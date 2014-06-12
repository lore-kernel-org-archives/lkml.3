Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110AbaFLLu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:50:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933018AbaFLLu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:50:26 -0400
Date: Thu, 12 Jun 2014 13:50:23 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
Message-ID: <20140612115022.GM7772@pathway.suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
 <alpine.LNX.2.00.1405290000350.17241@pobox.suse.cz>
 <20140529000909.GC6507@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529000909.GC6507@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 29-05-14 02:09:11, Frederic Weisbecker wrote:
> On Thu, May 29, 2014 at 12:02:30AM +0200, Jiri Kosina wrote:
> > On Fri, 9 May 2014, Petr Mladek wrote:
> > 
> > > printk() cannot be used safely in NMI context because it uses internal locks
> > > and thus could cause a deadlock. Unfortunately there are circumstances when
> > > calling printk from NMI is very useful. For example, all WARN.*(in_nmi())
> > > would be much more helpful if they didn't lockup the machine.
> > > 
> > > Another example would be arch_trigger_all_cpu_backtrace for x86 which uses NMI
> > > to dump traces on all CPU (either triggered by sysrq+l or from RCU stall
> > > detector).
> > 
> > I am rather surprised that this patchset hasn't received a single review 
> > comment for 3 weeks.
> > 
> > Let me point out that the issues Petr is talking about in the cover letter 
> > are real -- we've actually seen the lockups triggered by RCU stall 
> > detector trying to dump stacks on all CPUs, and hard-locking machine up 
> > while doing so.
> > 
> > So this really needs to be solved.
> 
> The lack of review may be partly due to a not very appealing changestat on an
> old codebase that is already unpopular:
> 
>  Documentation/kernel-parameters.txt |   19 +-
>  kernel/printk/printk.c              | 1218 +++++++++++++++++++++++++----------
>  2 files changed, 878 insertions(+), 359 deletions(-)
> 
> 
> Your patches look clean and pretty nice actually. They must be seriously considered if
> we want to keep the current locked ring buffer design and extend it to multiple per context
> buffers. But I wonder if it's worth to continue that way with the printk ancient design.
> 
> If it takes more than 1000 line changes (including 500 added) to make it finally work
> correctly with NMIs by working around its fundamental flaws, shouldn't we rather redesign
> it to use a lockless ring buffer like ftrace or perf ones?


I like the idea of the lock less buffer. So I have spent some time
to understand kernel/trace/ring_buffer.c and there are some challenges
that would need to be solved. Some of them might be pretty hard :-(

Here are the hardest missing features from my point of view:

    + storing the last message in all situations
    + reading from more locations in parallel
    + "aggressive" printing to console

, see below for more details.

Also note that the current code is already quite complex. There are
many tricks to solve conflicts a lockless way and it might get worse if
we want to solve the above stuff.

--------

Bellow are more details that explain the above statements. But first,
let me show how I understand the lock less ringbuffer:

    + there are separate buffers for each CPU
    + writers use a circular list of pages that are linked in both
      directions
    + writers reserve space before they copy the data
    + reader has an extra page that is not in the main ring and thus
      not accessible by writers
    + reader swap its page with another one from the main ring buffer
      when it wants to read some newer data

    + pages might have special flag/function:

	+ reader: the separate page accessed by reader
	+ head: page with the oldest data; the next one to be read
	+ tail: page with the newest data; the next write will try to
	    reserve the space here
	+ commit: the newest page where we have already copied the
	    data; it is usually the same as tail; the difference
	    happens when the write is interrupted and followup pages
	    are reserved and written; we must newer move tail over
	    this page, otherwise we would reserve the same location
	    twice, overwrite the data, and create mess

I hope that I have got the above correctly. It is why I think that the
missing features are hard to solve.

Here are the details about the above mentioned problems:

1. storing the last message in all situations
---------------------------------------------

  The problem is if we reserve space in a normal context, get
  interrupted, and the interrupt wants to write more data than the size
  of the ring buffer. We must stop rotating when we hit the first
  reserved but not committed page. Here are the code pointers:

  ring_buffer_write()
    rb_reserve_next_event()
      rb_reserve_next()
	rb_move_tail()
	  if (unlikely(next_page == commit_page)) {
		goto out_reset;

  This is must to have because the data are simply copied when
  the space is reserved, see memcpy(body, data, length) in
  ring_buffer_write()

  I think that we do not want this for printk(). The last messages are
  usually more important, especially in case of a fatal error.

  Possible solutions:

  + use different ring buffer for each context; it would need even
    more space

  + lock the page for the given context when a space is reserved; such
    locked page will be skipped when the buffer is rotated in a nested
    interrupt context; this will make the algorithm even more
    complicated; I am not sure if this would work at all

  + ignore this problem; each nested context should make sure that
    it does not use the whole buffer; it might even be realistic; we have
    separate buffer for each CPU; for example, one backtrace should
    should fit into one page; two pages are minimum...; but this
    is the type of assumption that might hit us in the future


2. reading from more locations in parallel
------------------------------------------

  The printk() ring buffer is asynchronously accessed by different
  readers, e.g. console, syslog, /dev/kmsg. Each one might read from
  a different location.

  Possible solutions:

  + have more reader and header pages; it would create the algorithm
    even more complicated; I am not sure if it is possible at all

  + have another printk() ring buffer and a single reader that would
    copy the messages here; it is ugly; also I am not sure if we would
    save much from the current printk() code


3. "aggressive" printing to console
-----------------------------------

  printk() currently triggers console immediately when new data
  appears in the ring buffer.

  This might cause swapping the reader page even when there is only
  one entry. The result might be that each page would include only
  one line. Few lines might occupy a large ring buffer.

  Possible solution:

  Do some lazy reading but how?


Best Regards,
Petr
