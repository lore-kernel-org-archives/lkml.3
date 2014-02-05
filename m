Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbaBEB1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 20:27:33 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46249 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaBEB1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 20:27:32 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-5f-52f19382eca8
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 1/3] perf tools: Put proper period for for samples without PERIOD sample_type
In-Reply-To: <1391427883-13443-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Mon, 3 Feb 2014 12:44:41 +0100")
References: <1391427883-13443-1-git-send-email-jolsa@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Wed, 05 Feb 2014 10:27:30 +0900
Message-ID: <87vbwu1h8d.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon,  3 Feb 2014 12:44:41 +0100, Jiri Olsa wrote:
> We use PERF_SAMPLE_PERIOD sample type only for frequency
> setup -F (default) option. The -c does not need store period,
> because it's always the same.
>
> In -c case the report code uses '1' as  period. Fixing
> it to perf_event_attr::sample_period.

All 3 patches look good.  But I found something strange.  When we
setup/config evsel attrs following code is used:

 util/evsel.c::perf_evsel__config()

	/*
	 * We default some events to a 1 default interval. But keep
	 * it a weak assumption overridable by the user.
	 */
	if (!attr->sample_period || (opts->user_freq != UINT_MAX &&
				     opts->user_interval != ULLONG_MAX)) {
		if (opts->freq) {
			perf_evsel__set_sample_bit(evsel, PERIOD);
			attr->freq		= 1;
			attr->sample_freq	= opts->freq;
		} else {
			attr->sample_period = opts->default_interval;
		}
	}


But shouldn't it be "||" instead of "&&" for checking
user_freq/interval?  The opts->freq was setup by code below

  util/record.c::record_opts__config_freq()

	bool user_freq = opts->user_freq != UINT_MAX;
	unsigned int max_rate;

	if (opts->user_interval != ULLONG_MAX)
		opts->default_interval = opts->user_interval;
	if (user_freq)
		opts->freq = opts->user_freq;

	/*
	 * User specified count overrides default frequency.
	 */
	if (opts->default_interval)
		opts->freq = 0;
	else if (opts->freq) {
		opts->default_interval = opts->freq;
	} else {
		pr_err("frequency and count are zero, aborting\n");
		return -1;
	}


Thanks,
Namhyung
