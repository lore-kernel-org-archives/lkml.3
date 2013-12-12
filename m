Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab3LLMWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:22:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:12924 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab3LLMWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:22:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,877,1378882800"; 
   d="scan'208";a="451143936"
Message-ID: <52A9AA72.1010601@intel.com>
Date: Thu, 12 Dec 2013 14:22:10 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 27/71] perf evlist: Add 'system_wide' option
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-28-git-send-email-alexander.shishkin@linux.intel.com> <52A8BEEB.1040203@gmail.com>
In-Reply-To: <52A8BEEB.1040203@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13 21:37, David Ahern wrote:
> On 12/11/13, 5:36 AM, Alexander Shishkin wrote:
>> From: Adrian Hunter <adrian.hunter@intel.com>
>>
>> Add an option to cause a selected event
>> to be opened always without a pid when
>> configured by perf_evsel__config().
>>
>> This is needed when using the sched_switch
>> tracepoint to follow object code execution.
>> sched_switch occurs before the task
>> switch and so it cannot record it in a
>> context limited to that task.  Note
>> that also means that sched_switch is
>> useless when capturing data per-thread,
>> as is the 'context-switches' software
>> event for the same reason.
> 
> This seems like a tailored solution for what is really a generic problem:
> you need events to have different attributes -- a mix of system wide, task
> based, with or without callchains and other sample options.

Actually in this case it is not the attribute but another parameter of the
perf_event_open syscall, namely the pid.  The effect of that is that there
are potentially fewer file descriptors needed for that event i.e. just 1 per
cpu compared with 1 per cpu per thread.

This is a generic solution for the case where you want to mix an event that
is not tied to a process, with other events that are.

If it were the attribute it would be easy because 'attr' is a member of
'struct evsel' so it can simply be changed directly.

