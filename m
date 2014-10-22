Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaJVP0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:26:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41266 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaJVP0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:26:52 -0400
Date: Wed, 22 Oct 2014 17:26:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20141022152644.GZ12706@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 04:45:40PM +0300, Alexander Shishkin wrote:
> +static void pt_event_start(struct perf_event *event, int mode)
> +{
> +	struct pt *pt = this_cpu_ptr(&pt_ctx);
> +	struct pt_buffer *buf = perf_get_aux(&pt->handle);
> +
> +	if (pt_is_running() || !buf || pt_buffer_is_full(buf, pt) ||
> +	    pt_config(event)) {
> +		event->hw.state = PERF_HES_STOPPED;
> +		return;
> +	}
> +
> +	ACCESS_ONCE(pt->handle_nmi) = 1;
> +	event->hw.state = 0;
> +
> +	pt_config_buffer(buf->cur->table, buf->cur_idx,
> +			 buf->output_off);
> +	wrmsrl(MSR_IA32_RTIT_STATUS, 0);
> +	pt_config_start(true);
> +}

That's two RTIT_CTL writes, should we not try and merge those?
