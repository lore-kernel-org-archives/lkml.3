Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbbAOJHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:07:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:37075 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbbAOJHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 04:07:05 -0500
Date: Thu, 15 Jan 2015 10:06:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        Kaixu Xia <kaixu.xia@linaro.org>, acme@infradead.org
Subject: Re: [PATCH v9 12/14] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20150115090659.GQ23965@worktop.programming.kicks-ass.net>
References: <1421237903-181015-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1421237903-181015-13-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421237903-181015-13-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 02:18:21PM +0200, Alexander Shishkin wrote:
> +static __init int pt_init(void)
> +{

> +	pt_pmu.pmu.attr_groups	= pt_attr_groups;
> +	pt_pmu.pmu.task_ctx_nr	= perf_hw_context;

I just noticed this one, how can this ever work? We want the PT thing to
always get programmed, right? -- because we disallow creating more than
1?

Which reminds me; does that exclusive thing you did not allow you to
create one cpu wide and one per task (they're separate contexts) events?
At which point we're not schedulable at all.

By sticking it on the HW context list it can end up not being programed
because its stuck after a bunch of hardware events that don't all fit on
the PMU.

Would not the SW list be more appropriate; the SW list is a list of
events that's guaranteed to be schedulable.

> +	pt_pmu.pmu.event_init	= pt_event_init;
> +	pt_pmu.pmu.add		= pt_event_add;
> +	pt_pmu.pmu.del		= pt_event_del;
> +	pt_pmu.pmu.start	= pt_event_start;
> +	pt_pmu.pmu.stop		= pt_event_stop;
> +	pt_pmu.pmu.read		= pt_event_read;
> +	pt_pmu.pmu.setup_aux	= pt_buffer_setup_aux;
> +	pt_pmu.pmu.free_aux	= pt_buffer_free_aux;
> +	ret = perf_pmu_register(&pt_pmu.pmu, "intel_pt", -1);
> +
> +	return ret;
> +}
