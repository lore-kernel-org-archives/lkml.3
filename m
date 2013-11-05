Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab3KEHlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 02:41:45 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55782 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab3KEHlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 02:41:44 -0500
X-AuditID: 9c93017e-b7c22ae000005611-07-5278a1359d74
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH 07/14] perf tools: Update cpumode for each cumulative entry
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
	<1383202576-28141-8-git-send-email-namhyung@kernel.org>
	<20131101125551.GE10041@krava.brq.redhat.com>
Date: Tue, 05 Nov 2013 16:41:41 +0900
In-Reply-To: <20131101125551.GE10041@krava.brq.redhat.com> (Jiri Olsa's
	message of "Fri, 1 Nov 2013 13:55:51 +0100")
Message-ID: <8738nbz45m.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Nov 2013 13:55:51 +0100, Jiri Olsa wrote:
> On Thu, Oct 31, 2013 at 03:56:09PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> The cpumode and level in struct addr_localtion was set for a sample
>> and but updated as cumulative callchains were added.  This led to have
>> non-matching symbol and cpumode in the output.
>> 
>> Update it accordingly based on the fact whether the map is a part of
>> the kernel or not.

[SNIP]

>> @@ -468,6 +470,27 @@ iter_next_cumulative_entry(struct add_entry_iter *iter __maybe_unused,
>>  	if (al->sym == NULL)
>>  		return 0;
>>  
>> +	if (al->map->groups == &iter->machine->kmaps) {
>> +		if (machine__is_host(iter->machine)) {
>> +			al->cpumode = PERF_RECORD_MISC_KERNEL;
>> +			al->level = 'k';
>> +		} else {
>> +			al->cpumode = PERF_RECORD_MISC_GUEST_KERNEL;
>> +			al->level = 'g';
>> +		}
>> +	} else {
>> +		if (machine__is_host(iter->machine)) {
>> +			al->cpumode = PERF_RECORD_MISC_USER;
>> +			al->level = '.';
>> +		} else if (perf_guest) {
>> +			al->cpumode = PERF_RECORD_MISC_GUEST_USER;
>> +			al->level = 'u';
>> +		} else {
>> +			al->cpumode = PERF_RECORD_MISC_HYPERVISOR;
>> +			al->level = 'H';
>> +		}
>> +	}
>> +
>
> Looks like this is what thread__find_addr_map does as well.
> Could above code go into a function used by both places?

In fact, it does the reverse - the thread__find_addr_map() tries to find
a map group (and map) using cpumode, but it wants to know cpumode using
map (and map group).

Thanks,
Namhyung
