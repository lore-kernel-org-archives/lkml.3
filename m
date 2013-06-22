Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750958Ab3FVFZv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 01:25:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:4244 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab3FVFZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 01:25:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,917,1363158000"; 
   d="scan'208";a="353900044"
Message-ID: <1371878748.6453.82.camel@empanada>
Subject: Re: [PATCH 04/11] tracing: fix disabling of soft disable
From: Tom Zanussi <tom.zanussi@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 22 Jun 2013 00:25:48 -0500
In-Reply-To: <1371849279.6453.44.camel@empanada>
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>
	 <f369f565dc440f40f027de0387c99dda4d36154e.1371751701.git.tom.zanussi@linux.intel.com>
	 <51C43537.8070300@hitachi.com>
	 <1371847171.18733.128.camel@gandalf.local.home>
	 <1371849279.6453.44.camel@empanada>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-21 at 16:14 -0500, Tom Zanussi wrote:
> On Fri, 2013-06-21 at 16:39 -0400, Steven Rostedt wrote:
> > On Fri, 2013-06-21 at 20:12 +0900, Masami Hiramatsu wrote:
> > > (2013/06/21 3:31), Tom Zanussi wrote:
> > > > The comment on the soft disable 'disable' case of
> > > > __ftrace_event_enable_disable() states that the soft disable bit
> > > > should be cleared in that case, but currently only the soft mode bit
> > > > is actually cleared.
> > > > 
> > > > This essentially leaves the standard non-soft-enable enable/disable
> > > > paths as the only way to clear the soft disable flag, but the soft
> > > > disable bit should also be cleared when removing a trigger with '!'.
> > > 
> > > Indeed, the soft-disabled flag may remain after the event itself
> > > disabled. However that soft-disabled flag will be cleared when
> > > the event is re-enabled. it seems no bad side-effect.
> > > 
> > > Thus I doubt this patch is separately required. I guess this is
> > > required for adding new trigger flag, isn't it? :)
> > 
> > Tom, I'm guessing Masami is correct here. It's needed for the trigger
> > work to work, correct?
> > 
> 
> Well, the trigger should really work without this - this is basically
> just a cleanup I added because it bothered me that I couldn't completely
> revert the enable state back to the original state that existed before I
> added the trigger (by reverting the trigger using '!').  It also just
> seemed obviously correct from looking at the code as well (though I
> agree, it's hard to keep the state machine of that function in your head
> in order to prove it correct, and the straggling soft-disable state
> hasn't bothered anyone until now, so maybe it's not worth it..)
> 

Looking into this a bit more, I think the reason it hasn't bothered
anyone until now is that it's been hidden by the existing
event_enable_read() implementation, which doesn't show any soft disable
state when the event is actually disabled, only when it's enabled.  So
the case where SOFT_DISABLED is still set but the event is actually
disabled gets hidden by the catch-all "0" case.

My new version of event_enable_read() does show the soft disabled state
when the event is actually disabled, which is why I noticed it wasn't
getting turned off, and led to the current patch.

Ironically, the reason I refactored the function in the first place was
to add the '+' flag for triggers - redundant, yes, but useful for
debugging, not quite in the way I planned though.  ;-)  (It might be
that leaving the current function in place and remaining oblivious would
be ok, too, since it doesn't seem to really cause much of a problem in
any case...)

Tom

> In any case, if the SOFT_DISABLED bit is erroneously set but there are
> no triggers, it shouldn't be a problem, since the trigger calls would
> just return immediately, so not having this patch wouldn't break
> anything... 
> 
> Tom
> 
> 
> > Either way, I probably could add it as a clean up patch regardless. I'll
> > just have to test the hell out of it some more, as the accounting for
> > soft-disable vs real disable was a PITA.
> > 
> 
> 
> > -- Steve
> > 
> 


