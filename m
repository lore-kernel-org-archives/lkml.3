Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbaEBNLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:11:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbaEBNLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:11:00 -0400
Date: Fri, 2 May 2014 15:10:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
In-Reply-To: <cover.1398958771.git.jpoimboe@redhat.com>
Message-ID: <alpine.LRH.2.00.1405021504320.22053@twin.jikos.cz>
References: <cover.1398958771.git.jpoimboe@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2014, Josh Poimboeuf wrote:

> kpatch vs kGraft
> ----------------
> 
> I think the biggest difference between kpatch and kGraft is how they
> ensure that the patch is applied atomically and safely.
> 
> kpatch checks the backtraces of all tasks in stop_machine() to ensure
> that no instances of the old function are running when the new function
> is applied.  I think the biggest downside of this approach is that
> stop_machine() has to idle all other CPUs during the patching process,
> so it inserts a small amount of latency (a few ms on an idle system).
> 
> Instead, kGraft uses per-task consistency: each task either sees the old
> version or the new version of the function.  This gives a consistent
> view with respect to functions, but _not_ data, because the old and new
> functions are allowed to run simultaneously and share data.  This could
> be dangerous if a patch changes how a function uses a data structure.
> The new function could make a data change that the old function wasn't
> expecting.

Please correct me if I am wrong, but with kPatch, you are also unable to 
do a "flip and forget" switch between functions that expect different 
format of in-memory data without performing a non-trivial all-memory 
lookup to find structures in question and perfoming corresponding 
transformations.

What we can do with kGraft si to perform the patching in two steps

(1) redirect to a temporary band-aid function that can handle both 
    semantics of the data (persumably in highly sub-optimal way)
(2) patching in (1) succeeds completely (kGraft claims victory), start a 
    new round of patching with redirect to the final function which 
    expects only the new semantics

This basically implies that both aproaches need "human inspection" in this 
respect anyway.

-- 
Jiri Kosina
SUSE Labs

