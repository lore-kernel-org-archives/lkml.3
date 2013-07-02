Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3GBG5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:57:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:43944 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab3GBG5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:57:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,979,1363158000"; 
   d="scan'208";a="359136562"
Message-ID: <51D27A04.7040705@intel.com>
Date: Tue, 02 Jul 2013 09:58:12 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH V2 12/15] perf tools: allow non-matching sample types
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com> <1372319707-13892-13-git-send-email-adrian.hunter@intel.com> <51CC6AAF.4030404@gmail.com> <51D14CB6.206@intel.com> <51D1D043.5030509@gmail.com> <CABPqkBRJNcSi_qdmn9Bfw57MbX=RcaSC9RLt-u6FKfW+q5jM0A@mail.gmail.com>
In-Reply-To: <CABPqkBRJNcSi_qdmn9Bfw57MbX=RcaSC9RLt-u6FKfW+q5jM0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/13 22:10, Stephane Eranian wrote:
> On Mon, Jul 1, 2013 at 8:53 PM, David Ahern <dsahern@gmail.com> wrote:
>>
>> On 7/1/13 3:32 AM, Adrian Hunter wrote:
>>>
>>> Snip
>>>
>>>>
>>>> While this works for a combined S/W and tracepoint events session, I do not
>>>> like promoting sample types to the minimum compatible level for all events
>>>> in the session. perf needs to allow each event to have its own sample_type
>>>> and not force a minimal compatibility.
>>>
>>>
>>> Why?  The impact is small. The kernel API is completely unchanged.
>>
>>
>> I'd like to see libperf become a stable, usable library - usable by more than the perf binary and its builtin commands. I have already done this once for a daemon, and it was a PITA to get the specific use functional without memory leaks/growth in the libperf part.
>>
>> With respect to this specific patch it means appropriate flexibility in the data collected for events. ie., each event can have its own sample_type. For example if the tracepoint already contains task information TID is not needed - and IP may not be wanted either. The code processing the samples should not require all events to have some minimum data format - that just wastes buffer space.
>>
> I agree. This kernel needs to allow for any bit combination on
> sample_type and yet provide enough info
> to parse the buffer in the case of multi-event sampling. This is
> kernel bug. Tools should not have to handle
> this. Because it'd have to be repeated for each tool.
> 
> Later this week, I'll post a patch that address the kernel limitation.

But isn't it trivial.  Just add a new sample type that puts the ID first.
Anyone using the new PERF_SAMPLE_IDENTIFIER gets the new ABI.



diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 0b1df41..6bb217e 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -134,8 +134,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_STACK_USER			= 1U << 13,
 	PERF_SAMPLE_WEIGHT			= 1U << 14,
 	PERF_SAMPLE_DATA_SRC			= 1U << 15,
+	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
 
-	PERF_SAMPLE_MAX = 1U << 16,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 17,		/* non-ABI */
 };
 
 /*
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1db3af9..a3707af 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1203,6 +1203,9 @@ static void perf_event__id_header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_TIME)
 		size += sizeof(data->time);
 
+	if (sample_type & PERF_SAMPLE_IDENTIFIER)
+		size += sizeof(data->id);
+
 	if (sample_type & PERF_SAMPLE_ID)
 		size += sizeof(data->id);
 
@@ -4229,7 +4232,7 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
 	if (sample_type & PERF_SAMPLE_TIME)
 		data->time = perf_clock();
 
-	if (sample_type & PERF_SAMPLE_ID)
+	if (sample_type & (PERF_SAMPLE_ID | PERF_SAMPLE_IDENTIFIER))
 		data->id = primary_event_id(event);
 
 	if (sample_type & PERF_SAMPLE_STREAM_ID)
@@ -4268,6 +4271,9 @@ static void __perf_event__output_id_sample(struct perf_output_handle *handle,
 
 	if (sample_type & PERF_SAMPLE_CPU)
 		perf_output_put(handle, data->cpu_entry);
+
+	if (sample_type & PERF_SAMPLE_IDENTIFER)
+		perf_output_put(handle, data->id);
 }
 
 void perf_event__output_id_sample(struct perf_event *event,
@@ -4380,6 +4386,9 @@ void perf_output_sample(struct perf_output_handle *handle,
 
 	perf_output_put(handle, *header);
 
+	if (sample_type & PERF_SAMPLE_IDENTIFIER)
+		perf_output_put(handle, data->id);
+
 	if (sample_type & PERF_SAMPLE_IP)
 		perf_output_put(handle, data->ip);
 
