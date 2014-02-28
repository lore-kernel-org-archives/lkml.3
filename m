Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaB1U4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 15:56:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42435 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaB1U4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 15:56:44 -0500
Date: Fri, 28 Feb 2014 21:56:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Vince Weaver <vincent.weaver@maine.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140228205638.GD14089@laptop.programming.kicks-ass.net>
References: <530FC1C6.5040209@zytor.com>
 <alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
 <20140227215726.7018c861@gandalf.local.home>
 <alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu>
 <20140228092341.12a40f7c@gandalf.local.home>
 <alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
 <1c583986-74f8-4829-883b-390dc49ddabb@email.android.com>
 <20140228154026.GH9987@twins.programming.kicks-ass.net>
 <5310B60F.30806@zytor.com>
 <20140228112946.1f194397@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228112946.1f194397@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 11:29:46AM -0500, Steven Rostedt wrote:
> On Fri, 28 Feb 2014 08:15:11 -0800
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > Well, I was talking about the assumption spelled out in the comment
> > above copy_from_user_nmi() which pretty much states "cr2 is safe because
> > cr2 is saved/restored in the NMI wrappers."
> 
> Yeah, it seems that the name "copy_from_user_nmi()" is a misnomer. As
> it can be called outside of nmi context. Perhaps we should have a
> copy_from_user_trace() that does the save and restore of the cr2.
> 
> As that's the only place that faults, it may be the best answer.
> 
> Arnaldo,
> 
> Can you test this patch and see if it fixes the bug for you too. Vince
> already said it fixes it for him.
> 
> I'm attaching it below (it's from H. Peter).
> 
> Peter Z., as both Jiri's and my patch fixed the callers of the problem
> area, and as we have been discussing, there may be more problem areas,
> I'm thinking the best solution is to just use H. Peter's patch instead.
> And then we should rename it to copy_from_user_trace().

Like already said; _trace is an absolutely abysmal name. Also you
_really_ don't want an unconditional CR2 write in there, that's just
stupidly expensive.

Also, this function is called a _LOT_ under certain workloads, I don't
know how cheap a CR2 read is, but it had better be really cheap.
