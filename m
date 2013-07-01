Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab3GAJ0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:26:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:8547 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974Ab3GAJ0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:26:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,973,1363158000"; 
   d="scan'208";a="363192432"
Message-ID: <51D14CB6.206@intel.com>
Date: Mon, 01 Jul 2013 12:32:38 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 12/15] perf tools: allow non-matching sample types
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com> <1372319707-13892-13-git-send-email-adrian.hunter@intel.com> <51CC6AAF.4030404@gmail.com>
In-Reply-To: <51CC6AAF.4030404@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/06/13 19:39, David Ahern wrote:
> On 6/27/13 1:55 AM, Adrian Hunter wrote:
>> Sample types need not be identical to determine
>> the sample id from the event.  Only the position
>> of the sample id needs to be the same.
>>
>> Compatible sample types are ones in which the bits
>> defined by PERF_COMPAT_MASK are the same.
>> 'perf_evlist__config()' forces sample types to be
>> compatible on that basis.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>   tools/perf/builtin-report.c |   2 +-
>>   tools/perf/util/event.h     |  14 +++++
>>   tools/perf/util/evlist.c    | 135
>> ++++++++++++++++++++++++++++++++++++++++++--
>>   tools/perf/util/evlist.h    |   8 ++-
>>   tools/perf/util/evsel.c     |  64 ++++++++++++++++++++-
>>   tools/perf/util/evsel.h     |  10 ++++
>>   tools/perf/util/session.c   |   8 ++-
>>   7 files changed, 230 insertions(+), 11 deletions(-)
>>

Snip

> 
> While this works for a combined S/W and tracepoint events session, I do not
> like promoting sample types to the minimum compatible level for all events
> in the session. perf needs to allow each event to have its own sample_type
> and not force a minimal compatibility.

Why?  The impact is small. The kernel API is completely unchanged.

Consider the affected sample members:

	PERF_SAMPLE_IP
	PERF_SAMPLE_TID
	PERF_SAMPLE_TIME
	PERF_SAMPLE_ADDR
	PERF_SAMPLE_ID
	PERF_SAMPLE_CPU
	PERF_SAMPLE_STREAM_ID

Of those, perf_evlist__config() always selects PERF_SAMPLE_IP,
PERF_SAMPLE_TID and PERF_SAMPLE_ID, and never selects PERF_SAMPLE_STREAM_ID.
 That leaves just:

	PERF_SAMPLE_TIME
	PERF_SAMPLE_ADDR
	PERF_SAMPLE_CPU

PERF_SAMPLE_TIME is always selected when inheriting.

PERF_SAMPLE_TIME and PERF_SAMPLE_CPU are always selected for per-cpu recording.

Under what circumstances would you want 'time' and/or 'cpu' on some events
but not all of them?

Under what circumstances would you want 'addr' but those events are not the
vast majority of the events you record?

