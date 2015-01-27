Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbbA0PPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:15:47 -0500
Received: from smtprelay0122.hostedemail.com ([216.40.44.122]:56646 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751599AbbA0PPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:15:43 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2693:2897:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4385:5007:6261:7875:7903:9010:10004:10400:10450:10455:10848:10967:11026:11232:11658:11914:12296:12517:12519:12663:12740:13069:13311:13357:14096:14097:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: judge73_6bdec624a063b
X-Filterd-Recvd-Size: 2760
Date: Tue, 27 Jan 2015 10:15:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16 v3] tracing: Add new file system tracefs
Message-ID: <20150127101540.297004d0@gandalf.local.home>
In-Reply-To: <20150127043421.GV29656@ZenIV.linux.org.uk>
References: <20150126150913.653681560@goodmis.org>
	<20150126193049.GN29656@ZenIV.linux.org.uk>
	<20150126154259.5e650d32@gandalf.local.home>
	<20150126214658.GQ29656@ZenIV.linux.org.uk>
	<20150126184314.24f2583c@gandalf.local.home>
	<20150126184916.70d88963@gandalf.local.home>
	<20150126193909.19967bd0@grimm.local.home>
	<20150127043421.GV29656@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015 04:34:21 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:


> Frankly, the first impression is that you have trace_types_lock way too
> high in the hierarchy - you are taking it well outside of the level where
> you start walking through ftrace_trace_arrays...

Actually, it is originally used for modifying of tr->current_trace

This was before having multiple buffers. I just used the same lock to
protect the trace arrays. Note, I have patches to make a separate mutex
for that, but it just seems to make things a little more complex, so I
haven't pushed it too much. Yeah, that trace_types_lock is basically
tracing's BKL.

> 
> What else is it used for?  You seem to use it protect trace_array refcounts,
> but you use them in a very odd way...  What happens if lookup for a file
> in that tree loses CPU just as it enters trace_array_get() (e.g. on the
> same trace_types_lock), at which point rm .../instances/<whatever> comes,
> sees that tr->ref is still zero, kicks the sucker out of the list and
> frees it, immediately followed by mkdir creating a new instace?  If the
> allocation of the new trace_array happens to reuse the just-freed one,
> your trace_array_get() will actually succeed, won't it?
> 
> It's not fatal (after all, everything will work as if you opened the similar
> file in new instance in the first place), but it looks rather bogus...

I'm actually aware of this possibility. But as you said, it's not
fatal, and very unlikely to happen.

-- Steve
