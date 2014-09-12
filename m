Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbaILMnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:43:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33847 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaILMnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:43:41 -0400
Message-ID: <5412EA7A.9020807@codeaurora.org>
Date: Fri, 12 Sep 2014 08:43:38 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>
CC: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [RFC 2/2] perf: Marker software event and ioctl
References: <1410522513-1045-1-git-send-email-pawel.moll@arm.com> <1410522513-1045-3-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1410522513-1045-3-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pawel,

On 09/12/2014 07:48 AM, Pawel Moll wrote:
> This patch adds a PERF_COUNT_SW_MARKER event type, which
> can be requested by user and a PERF_EVENT_IOC_MARKER
> ioctl command which will inject an event of said type into
> the perf buffer. The ioctl can take a zero-terminated
> string argument, similar to tracing_marker in ftrace,
> which will be kept in the "raw" field of the sample.
> 
> The main use case for this is synchronisation of
> performance data generated in user space with the perf
> stream coming from the kernel. For example, the marker
> can be inserted by a JIT engine after it generated
> portion of the code, but before the code is executed
> for the first time, allowing the post-processor to
> pick the correct debugging information. Other example
> is a system profiling tool taking data from other
> sources than just perf, which generates a marker
> at the beginning at at the end of the session
> (also possibly periodically during the session) to
> synchronise kernel timestamps with clock values
> obtained in userspace (gtod or raw_monotonic).

> @@ -5960,6 +5965,44 @@ static struct pmu perf_swevent = {
>  	.event_idx	= perf_swevent_event_idx,
>  };
>  
> +static int perf_sw_event_marker(struct perf_event *event, char __user *arg)
> +{
> +	struct perf_sample_data data;
> +	struct pt_regs *regs = current_pt_regs();
> +	struct perf_raw_record raw = { 0, };
> +
> +	if (!static_key_false(&perf_swevent_enabled[PERF_COUNT_SW_MARKER]))
> +		return 0;
> +
> +	perf_sample_data_init(&data, 0, 0);
> +
> +	if (arg) {
> +		long len = strnlen_user(arg, PAGE_SIZE);

Just to ask the dumb questions in case the answers I've come up with are
wrong: What is PAGE_SIZE on an arm64 kernel? How does userspace know?

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
