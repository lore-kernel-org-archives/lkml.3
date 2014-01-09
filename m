Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbaAIIRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 03:17:36 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63544 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbaAIIR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 03:17:29 -0500
X-AuditID: 9c930179-b7b3eae0000044f1-97-52ce5b18f208
From: Namhyung Kim <namhyung@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Chad Paradis <chad.paradis@umit.maine.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch] perf tools: perf list broken on ARM
References: <alpine.DEB.2.10.1312301536150.28814@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1401081629200.4410@vincent-weaver-1.um.maine.edu>
Date: Thu, 09 Jan 2014 17:17:27 +0900
In-Reply-To: <alpine.DEB.2.10.1401081629200.4410@vincent-weaver-1.um.maine.edu>
	(Vince Weaver's message of "Wed, 8 Jan 2014 16:30:17 -0500 (EST)")
Message-ID: <871u0hd0x4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vince,

On Wed, 8 Jan 2014 16:30:17 -0500 (EST), Vince Weaver wrote:
> just checking on the status of this patch.  Am I sending it to the wrong 
> place?  Did it get lost in the post-holiday e-mail purges?  
>
> The bug is annoying if you're trying to use perf on ARM systems.

Right, acme, would you please merge this?

Thanks,
Namhyung

>
> On Mon, 30 Dec 2013, Vince Weaver wrote:
>
>> 
>> "perf list" listing of hardware events doesn't work on older ARM devices.
>> The change enabling event detection:
>> 
>>  commit b41f1cec91c37eeea6fdb15effbfa24ea0a5536b
>>  Author: Namhyung Kim <namhyung.kim@lge.com>
>>  Date:   Tue Aug 27 11:41:53 2013 +0900
>> 
>>      perf list: Skip unsupported events
>> 
>> 
>> uses the following code in tools/perf/util/parse-events.c:
>> 
>>         struct perf_event_attr attr = {
>>                 .type = type,
>>                 .config = config,
>>                 .disabled = 1,
>>                 .exclude_kernel = 1,
>>         };
>> 
>> On ARM machines pre-dating the Cortex-A15 this doesn't work, as
>> these machines don't support .exclude_kernel.  So starting with 3.12
>> "perf list" does not report any hardware events at all on older
>> machines (seen on Rasp-Pi, Pandaboard, Beagleboard, etc).
>> 
>> This version of the patch makes changes suggested by Namhyung Kim
>> to check for EACCESS and retry (instead of just dropping
>> the exclude_kernel) so we can properly handle machines where 
>> /proc/sys/kernel/perf_event_paranoid is set to 2.
>> 
>> Reported-by: Chad Paradis <chad.paradis@umit.maine.edu>
>> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
>> Acked-by: Namhyung Kim <namhyung@kernel.org>
>> 
>> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
>> index 6de6f89..1fa98b9 100644
>> --- a/tools/perf/util/parse-events.c
>> +++ b/tools/perf/util/parse-events.c
>> @@ -1082,12 +1082,12 @@ int is_valid_tracepoint(const char *event_string)
>>  static bool is_event_supported(u8 type, unsigned config)
>>  {
>>  	bool ret = true;
>> +	int open_return;
>>  	struct perf_evsel *evsel;
>>  	struct perf_event_attr attr = {
>>  		.type = type,
>>  		.config = config,
>>  		.disabled = 1,
>> -		.exclude_kernel = 1,
>>  	};
>>  	struct {
>>  		struct thread_map map;
>> @@ -1099,7 +1099,20 @@ static bool is_event_supported(u8 type, unsigned config)
>>  
>>  	evsel = perf_evsel__new(&attr);
>>  	if (evsel) {
>> -		ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
>> +		open_return = perf_evsel__open(evsel, NULL, &tmap.map);
>> +		ret = open_return >= 0;
>> +
>> +		if (open_return == -EACCES) {
>> +			/*
>> +			 * This happens if the paranoid value
>> +			 * /proc/sys/kernel/perf_event_paranoid is set to 2
>> +			 * Re-run with exclude_kernel set; we don't do that
>> +			 * by default as some ARM machines do not support it.
>> +			 *
>> +			 */
>> +			evsel->attr.exclude_kernel = 1;
>> +			ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
>> +		}
>>  		perf_evsel__delete(evsel);
>>  	}
>>  
>> 
>
> Vince Weaver
> vincent.weaver@maine.edu
> http://www.eece.maine.edu/~vweaver/
