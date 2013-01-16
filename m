Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab3APAup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:50:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab3APAun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:50:43 -0500
Date: Tue, 15 Jan 2013 16:50:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sonny Rao <sonnyrao@google.com>
Cc: Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Bryan Freed <bfreed@google.com>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH 2/2] mm: forcely swapout when we are out of page cache
Message-Id: <20130115165042.1daadec2.akpm@linux-foundation.org>
In-Reply-To: <CAPz6YkWC+y+jqD+0UNe+cD6OyveursZaahxc26mH81DOGD7sNw@mail.gmail.com>
References: <1357712474-27595-1-git-send-email-minchan@kernel.org>
	<1357712474-27595-3-git-send-email-minchan@kernel.org>
	<20130109162602.53a60e77.akpm@linux-foundation.org>
	<20130110022306.GB14685@blaptop>
	<20130110135828.c88bcaf1.akpm@linux-foundation.org>
	<20130111044327.GB6183@blaptop>
	<20130115160957.9ef860d7.akpm@linux-foundation.org>
	<CAPz6YkWC+y+jqD+0UNe+cD6OyveursZaahxc26mH81DOGD7sNw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 16:32:38 -0800
Sonny Rao <sonnyrao@google.com> wrote:

> >> It's for saving the power to increase batter life.
> >
> > It might well have that effect, dunno.  That wasn't my intent.  Testing
> > needed!
> >
> 
> Power saving is certainly why we had it on originally for ChromeOS,
> but we turned it off due to misbehavior.
> 
> Specifically, we saw a pathological behavior where we'd end up writing
> to the disk every few seconds when laptop mode was turned on.  This
> turned out to be because laptop-mode sets a timer which is used to
> check for new dirty data after the initial flush and writes that out
> before spinning the disk down, and on ChromeOS various chatty daemons
> on the system were logging and dirtying data more or less constantly
> so there was almost always something there to be written out.  So what
> ended up happening was that we'd need to do a read, then wake up the
> disk, and then keep writing every few seconds for a long period of
> time, which had the opposite effect from what we wanted.

So after the read, the disk would chatter away doing a dribble of
writes?  That sounds like plain brokenness (and why did the chrome guys
not tell anyone about it?!?!?).  The idea is that when the physical
read occurs, we should opportunistically flush out all pending writes,
while the disk is running.  Then go back into
buffer-writes-for-a-long-time mode.

I forget what we did with fsync() and friends.  Quite a lot of
pestiferous applications like to do fsync quite frequently.  I had a
special kernel in which fsync() consisted of "return 0;", but ISTR
there being some resistance to productizing that idea.

>  The issues
> with zram swap just confirmed that we didn't want laptop mode.
>
> Most of our devices have had SSDs rather than spinning disks, so noise
> wasn't an issue, although when we finally did support an official
> device with a spinning disk people certainly complained when the disk
> started clicking all the time

hm, it's interesting that the general idea still has vailidity.  It
would be a fun project for someone to sniff out all the requirements,
fixup/enhance/rewrite the current implementation and generally make it
all spiffy and nice.

> (due to the underflow in the writeback code).

To what underflow do you refer?

> We do know that current SSDs save a significant amount of
> power when they go into standby, so minimizing disk writes is still
> useful on these devices.
> 
> A very simple laptop mode which only does a single sync when we spin
> up the disk, and didn't bother with the timer behavior or muck with
> swap behavior might be something that is more useful for us, and I
> suspect it might simplify the writeback code somewhat as well.

I don't think I understand the problem with the timer.  My original RFC
said

: laptop_writeback_centisecs
: --------------------------
: 
: This tunable determines the maximum age of dirty data when the machine
: is operating in Laptop mode.  The default value is 30000 - five
: minutes.  This means that if applications are generating a small amount
: of write traffic, the disk will spin up once per five minutes.
: 
: If the disk is spun up for any other reason (such as for a read) then
: all dirty data will be flushed anyway, and this timer is reset to zero.

which all sounds very sensible and shouldn't exhibit the behavior you
observed.



