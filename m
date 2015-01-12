Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbbALMpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:45:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:45166 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbbALMpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:45:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,743,1413270000"; 
   d="scan'208";a="649798022"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        acme@infradead.org
Subject: Re: [PATCH v8 12/14] x86: perf: intel_pt: Intel PT PMU driver
In-Reply-To: <20150109131045.GM3337@twins.programming.kicks-ass.net>
References: <1415972627-37514-1-git-send-email-alexander.shishkin@linux.intel.com> <1415972627-37514-13-git-send-email-alexander.shishkin@linux.intel.com> <20150109131045.GM3337@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 12 Jan 2015 14:45:25 +0200
Message-ID: <87iogcnp5m.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Fri, Nov 14, 2014 at 03:43:45PM +0200, Alexander Shishkin wrote:
>> +static void pt_handle_status(struct pt *pt)
>> +{
>> +	struct pt_buffer *buf = perf_get_aux(&pt->handle);
>> +	int advance = 0;
>> +	u64 status;
>> +
>> +	rdmsrl(MSR_IA32_RTIT_STATUS, status);
>> +
>> +	if (status & RTIT_STATUS_ERROR) {
>> +		pr_err_ratelimited("ToPA ERROR encountered, trying to recover\n");
>> +		pt_topa_dump(buf);
>> +		status &= ~RTIT_STATUS_ERROR;
>> +	}
>> +
>> +	if (status & RTIT_STATUS_STOPPED) {
>> +		status &= ~RTIT_STATUS_STOPPED;
>> +
>> +		/*
>> +		 * On systems that only do single-entry ToPA, hitting STOP
>> +		 * means we are already losing data; need to let the decoder
>> +		 * know.
>> +		 */
>> +		if (!pt_cap_get(PT_CAP_topa_multiple_entries) ||
>> +		    buf->output_off == sizes(TOPA_ENTRY(buf->cur, buf->cur_idx)->size)) {
>> +			local_inc(&buf->lost);
>> +			advance++;
>> +		}
>> +	}
>> +
>> +	/*
>> +	 * Also on single-entry ToPA implementations, interrupt will come
>> +	 * before the output reaches its output region's boundary.
>> +	 */
>
> My understanding was that, while yes it will attempt to generate the
> interrupt early, there is absolutely no guarantee it will in fact arrive
> in time or even it if does, guarantee that there is buffer left by the
> time you're ready to read it.

That's correct. If the PMI didn't arrive on time and the buffer got
filled up, the STOPPED bit will be set in the STATUS register, which is
what we're handling above.

>> +	if (!pt_cap_get(PT_CAP_topa_multiple_entries) && !buf->snapshot &&
>> +	    pt_buffer_region_size(buf) - buf->output_off <= TOPA_PMI_MARGIN) {
>
> Now this check appears to indeed cater for this scenario where the
> buffer is overran, right?

The check above is for the case when the PMI did make it before the end
of the physical buffer was reached.

>
>> +		void *head = pt_buffer_region(buf);
>> +
>> +		/* everything within this margin needs to be zeroed out */
>> +		memset(head + buf->output_off, 0,
>> +		       pt_buffer_region_size(buf) -
>> +		       buf->output_off);
>> +		advance++;
>> +	}
>> +
>> +	if (advance)
>> +		pt_buffer_advance(buf);
>> +
>> +	wrmsrl(MSR_IA32_RTIT_STATUS, status);
>> +}

Regards,
--
Alex
