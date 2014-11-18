Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaKRMrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:47:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595AbaKRMrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:47:40 -0500
Date: Tue, 18 Nov 2014 13:47:46 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141118124746.GB23958@pathway.suse.cz>
References: <20141107131153.GD4071@treble.redhat.com>
 <20141107140458.GA21774@suse.cz>
 <20141107154500.GF4071@treble.redhat.com>
 <20141107212735.GA21409@suse.cz>
 <54616533.1070301@hitachi.com>
 <20141111102655.GB20424@suse.cz>
 <546399E4.6050605@hitachi.com>
 <20141112214719.GA26809@suse.cz>
 <5464D4B6.5010808@hitachi.com>
 <20141113163804.GA10388@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113163804.GA10388@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-11-13 17:38:04, Vojtech Pavlik wrote:
> On Fri, Nov 14, 2014 at 12:56:38AM +0900, Masami Hiramatsu wrote:
> > > It'd be mostly based on your refcounting code, including stack
> > > checking (when a process sleeps, counter gets set based on number of
> > > patched functions on the stack), possibly including setting the counter
> > > to 0 on syscall entry/exit, but it'd make the switch per-thread like
> > > kGraft does, not for the whole system, when the respective counters
> > > reach zero.
> > 
> > I'm not sure what happens if a process sleeps on the patched-set?
> 
> Then the patching process will be stuck until it is woken up somehow.
> But it's still much better to only have to care about processes sleeping
> on the patched-set than about processes sleeping anywhere (kGraft).
> 
> > If we switch the other threads, when this sleeping thread wakes up
> > that will see the old functions (and old data).
> 
> Yes, until the patching process is complete, data must be kept in the
> old format, even by new functions.

I am not sure if I am able to follow all the ideas. Anyway,
the above sentence triggered some warning bells in my head ;-)

Would it mean waiting for two safe switch points, please? One to switch
functions and the second to switch the data structures?

The later condition looks pretty complicated to me. It would mean to
make sure that the old structures won't be stored anywhere and nobody
would want to use them later. It won't be enough to check the stack
because some function might be called later that would access a saved
pointer pointing to the old structure.


> > So I think we need both SWITCH_THREAD and SWITCH_KERNEL options in
> > that case.
> 
> With data shadowing that's not required. It still may be worth having
> it.

I am not 100% sure what the shadowing means. If it means that the new
function will be able to read and write both versions of the
structure, it looks more easily doable to me.


Best Regards,
Petr
