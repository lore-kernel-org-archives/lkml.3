Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936002Ab3DRL3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:29:20 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46201
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935355Ab3DRL3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:29:19 -0400
Message-ID: <1366284534.19383.13.camel@laptop>
Subject: Re: [PATCH 2/2] perf, amd: support for AMD NB and L2I "uncore"
 counters.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Date: Thu, 18 Apr 2013 13:28:54 +0200
In-Reply-To: <1366046483-1765-3-git-send-email-jacob.shin@amd.com>
References: <1366046483-1765-1-git-send-email-jacob.shin@amd.com>
	 <1366046483-1765-3-git-send-email-jacob.shin@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 12:21 -0500, Jacob Shin wrote:
> Add support for AMD Family 15h [and above] northbridge performance
> counters. MSRs 0xc0010240 ~ 0xc0010247 are shared across all cores
> that share a common northbridge.
> 
> Add support for AMD Family 16h L2 performance counters. MSRs
> 0xc0010230 ~ 0xc0010237 are shared across all cores that share a
> common L2 cache.
> 
> We do not enable counter overflow interrupts. Sampling mode and
> per-thread events are not supported.


Nice!

There's one crucial thing missing though.. The Intel uncore driver
explicitly maps all events of cpus that are of the same uncore to a
single cpu and migrates the events to another cpu (if any is available)
when that cpu goes down.

The advantage of keeping all the events on the same cpu is that we
don't need to consider shared resources between cpus of an uncore
group.

That way things like event rotation on overcommit also trivially works
right.

I appreciate the intel uncore driver might be a tad hard to read -- its
somewhat unwieldy. But it basically sets event->cpu on
pmu::event_init() to whatever cpu is selected to represent the group,
and then calls perf_pmu_migrate_context() from a hotplug notifier.



