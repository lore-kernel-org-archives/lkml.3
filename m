Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbaKRS7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:59:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbaKRS7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:59:08 -0500
Date: Tue, 18 Nov 2014 12:58:36 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: Vojtech Pavlik <vojtech@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141118185836.GA3844@treble.redhat.com>
References: <20141107140458.GA21774@suse.cz>
 <20141107154500.GF4071@treble.redhat.com>
 <20141107212735.GA21409@suse.cz>
 <54616533.1070301@hitachi.com>
 <20141111102655.GB20424@suse.cz>
 <546399E4.6050605@hitachi.com>
 <20141112214719.GA26809@suse.cz>
 <5464D4B6.5010808@hitachi.com>
 <20141113163804.GA10388@suse.cz>
 <20141118124746.GB23958@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141118124746.GB23958@pathway.suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 01:47:46PM +0100, Petr Mladek wrote:
> On Thu 2014-11-13 17:38:04, Vojtech Pavlik wrote:
> > On Fri, Nov 14, 2014 at 12:56:38AM +0900, Masami Hiramatsu wrote:
> > > > It'd be mostly based on your refcounting code, including stack
> > > > checking (when a process sleeps, counter gets set based on number of
> > > > patched functions on the stack), possibly including setting the counter
> > > > to 0 on syscall entry/exit, but it'd make the switch per-thread like
> > > > kGraft does, not for the whole system, when the respective counters
> > > > reach zero.
> > > 
> > > I'm not sure what happens if a process sleeps on the patched-set?
> > 
> > Then the patching process will be stuck until it is woken up somehow.
> > But it's still much better to only have to care about processes sleeping
> > on the patched-set than about processes sleeping anywhere (kGraft).
> > 
> > > If we switch the other threads, when this sleeping thread wakes up
> > > that will see the old functions (and old data).
> > 
> > Yes, until the patching process is complete, data must be kept in the
> > old format, even by new functions.
> 
> I am not sure if I am able to follow all the ideas. Anyway,
> the above sentence triggered some warning bells in my head ;-)
> 
> Would it mean waiting for two safe switch points, please? One to switch
> functions and the second to switch the data structures?

Yes, though the first switch "point" doesn't have to be instantaneous.
When changing data, new functions must be able to understand both old
and new data.  The transition to the new functions can happen gradually,
as long as you don't start creating new data (or migrating existing
data) until after the patching is complete.  That way you'll never have
an old function trying to access new data.

> The later condition looks pretty complicated to me. It would mean to
> make sure that the old structures won't be stored anywhere and nobody
> would want to use them later. It won't be enough to check the stack
> because some function might be called later that would access a saved
> pointer pointing to the old structure.

We don't need to necessarily get rid of all old data, because new
functions can handle both old and new data.

> 
> 
> > > So I think we need both SWITCH_THREAD and SWITCH_KERNEL options in
> > > that case.
> > 
> > With data shadowing that's not required. It still may be worth having
> > it.
> 
> I am not 100% sure what the shadowing means. If it means that the new
> function will be able to read and write both versions of the
> structure, it looks more easily doable to me.

Shadowing is a way of adding virtual fields to existing data structures
at runtime.  That enables the new functions to easily determine whether
they're dealing with v1 or v2 of a given data structure, as well as
access any new fields in v2.


-- 
Josh
