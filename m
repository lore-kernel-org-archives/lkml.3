Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaEBNiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:38:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbaEBNiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:38:02 -0400
Date: Fri, 2 May 2014 08:37:51 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140502133751.GB4556@treble.redhat.com>
References: <cover.1398958771.git.jpoimboe@redhat.com>
 <alpine.LRH.2.00.1405021504320.22053@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1405021504320.22053@twin.jikos.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 03:10:58PM +0200, Jiri Kosina wrote:
> On Thu, 1 May 2014, Josh Poimboeuf wrote:
> 
> > kpatch vs kGraft
> > ----------------
> > 
> > I think the biggest difference between kpatch and kGraft is how they
> > ensure that the patch is applied atomically and safely.
> > 
> > kpatch checks the backtraces of all tasks in stop_machine() to ensure
> > that no instances of the old function are running when the new function
> > is applied.  I think the biggest downside of this approach is that
> > stop_machine() has to idle all other CPUs during the patching process,
> > so it inserts a small amount of latency (a few ms on an idle system).
> > 
> > Instead, kGraft uses per-task consistency: each task either sees the old
> > version or the new version of the function.  This gives a consistent
> > view with respect to functions, but _not_ data, because the old and new
> > functions are allowed to run simultaneously and share data.  This could
> > be dangerous if a patch changes how a function uses a data structure.
> > The new function could make a data change that the old function wasn't
> > expecting.
> 
> Please correct me if I am wrong, but with kPatch, you are also unable to 
> do a "flip and forget" switch between functions that expect different 
> format of in-memory data without performing a non-trivial all-memory 
> lookup to find structures in question and perfoming corresponding 
> transformations.
> 
> What we can do with kGraft si to perform the patching in two steps
> 
> (1) redirect to a temporary band-aid function that can handle both 
>     semantics of the data (persumably in highly sub-optimal way)
> (2) patching in (1) succeeds completely (kGraft claims victory), start a 
>     new round of patching with redirect to the final function which 
>     expects only the new semantics
> 
> This basically implies that both aproaches need "human inspection" in this 
> respect anyway.

Ah, interesting.  The intermediate function which knows how to handle
both versions of the data could get pretty tricky though.

With kpatch we'd just need to allow the user to install a callback
function which runs in stop_machine() and manually updates all the data
structures.  I think we'll be implementing something like this soon.

-- 
Josh
