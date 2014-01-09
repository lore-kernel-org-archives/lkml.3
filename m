Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaAIPUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 10:20:08 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:64988 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaAIPUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 10:20:00 -0500
Date: Thu, 9 Jan 2014 16:19:57 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        thomas.ilsche@tu-dresden.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Perf: Correct Assumptions about Sample Timestamps in
 Passes
Message-ID: <20140109151955.GA9866@localhost.localdomain>
References: <20131223131051.GB585@localhost.localdomain>
 <52B84C49.70001@gmail.com>
 <20131226151429.GA15303@localhost.localdomain>
 <52BC4A13.1090508@gmail.com>
 <20131226153033.GC15303@localhost.localdomain>
 <52C46083.9070605@gmail.com>
 <20140103220745.GB11061@localhost.localdomain>
 <52C73D90.3020904@gmail.com>
 <20140104150539.GA17617@localhost.localdomain>
 <52CDC7B5.6060704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CDC7B5.6060704@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 02:48:37PM -0700, David Ahern wrote:
> The existing code does not work. Your unstable tsc patch did not
> work. I have not tried Joseph's patch. Are you proposing that one or
> do you have something else in mind?

I think we should integrate Joseph's patch (or mine, or some mixup, I mean
they do about the same IIRC) as it solves known and understood bugs in any case.

Then we need to check what is the real issue in your case.

> 
> >Now there is still the problem of:
> >
> >1) local timestamps not moving forward (could it happen when events happen in storm,
> >when they overflow multiple times in once for example, and clock is not granular
> >enough?)
> 
> Even at 650k events/sec I am not seeing this problem.

Yeah it happens mostly when a single event, supposed to overflow on period of 1, trigger
with a higher period. This is the case of sched stat runtime tracepoints for example
because it is a weighted tracepoint (see perf_count). So it demux into gazillions of
events all having very close timestamps. But normal tracepoints shouldn't have this problem.

> 
> >Anyway this should be solved with the patch that takes the earliest last event on all
> >CPU buffer instead of the maximum of a round as a barrier.
> >
> >2) local timestamps not monotonic due to interrupting events. This could be fixed
> >in the kernel with moving perf_clock() snapshot in perf_output_sample().
> >
> 
> For perf-kvm the events are all tracepoints, so there should not be
> a problem of overlap due to interruption.

Nope, I'm curious what kind of issue happens with kvm events. Could you send me a perf.data
that has this ordering problem?

Thanks.
