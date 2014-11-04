Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaKDFoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 00:44:44 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39361 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaKDFom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 00:44:42 -0500
Message-ID: <545867BC.9070000@hitachi.com>
Date: Tue, 04 Nov 2014 14:44:28 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, srikar@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Gregg <brendan.gregg@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Re: [PATCH perf/core 0/6] perf-probe: Bugfix and add new options
 for cache
References: <20141031185128.27889.32747.stgit@localhost.localdomain> <87389z7j3x.fsf@sejong.aot.lge.com>
In-Reply-To: <87389z7j3x.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/04 12:14), Namhyung Kim wrote:
> Hi Masami,
> 
> On Fri, 31 Oct 2014 14:51:29 -0400, Masami Hiramatsu wrote:
>> Hi,
>>
>> Here is a sereis of patches for enabling "event cache" feature
>> to perf probe. Brendan gives me this cool idea, thanks! :)
>>
>> In this series, I added following options/features;
>>  - --output option
>>    We can save the probe definition command for given probe-event
>>    instead of setting up the local tracing/kprobe_events.
>>
>>  - --no-inlines option
>>    We can avoid searching the inline functions in debuginfo. Usually
>>    useful with wildcards since the wildcards will hit a huge amount
>>    of probe-points.
>>
>>  - $params special probe argument
>>    $params is expanded to function parameters only, no locally defined
>>    variables. This is useful for function-call tracing.
>>
>>  - wildcard support for function name
>>    Wildcard support is the key feature for this idea. Now we can use
>>    '*foo*' for function name to define the probe-point.
>>
>> So by using all of them, we can make an "event cache" file on all
>> functions (except for inlined functions) as below.
>>
>>   # perf probe --max-probes=100000 --no-inlines -a '* $params' -o event.cache
>>
>> builds "event.cache" file in which event settings for
>> all function entries, like below;
>>
>>   p:probe/reset_early_page_tables _text+12980741
>>   p:probe/copy_bootdata _text+12980830 real_mode_data=%di:u64
>>   p:probe/exit_amd_microcode _text+14692680
>>   p:probe/early_make_pgtable _text+12981274 address=%di:u64
>>   p:probe/x86_64_start_reservations _text+12981700 real_mode_data=%di:u64
>>   p:probe/x86_64_start_kernel _text+12981744 real_mode_data=%di:u64
>>   p:probe/reserve_ebda_region _text+12982117
> 
> Does this event cache support kernel modules too?  AFAIK it can have a
> different address whenever loaded even on a same kernel.

Yes, for the modules perf probe uses target function symbol directly instead
of _text.

 ----
 perf probe -m xfs -o - -q -a xfs_acl_exists
 p:probe/xfs_acl_exists xfs:xfs_acl_exists+0
 ----

>> This event.cache file will be big (but much smaller than native
>> debuginfo :) ) if your kernel have many option embedded.
>> Anyway, you can compress it too.
>>
>>   # wc -l event.cache
>>   33813 event.cache
>>   # ls -sh event.cache
>>   2.3M event.cache
>>   # ls -sh event.cache.gz
>>   464K event.cache.gz
>>
>> For setting up a probe event, you can grep the function name
>> and write it to tracing/kprobe_events, as below;
>>
>>   # zcat event.cache.gz | \
>>     grep probe/vfs_symlink > /sys/kernel/debug/tracing/kprobe_events
>>
>> This can be applied for the remote machine only if the machine
>> runs on completely same kernel binary. Perhaps, we need some
>> helper tool to check it.
> 
> While it's useful for "agent-less" systems, I think we also need to have
> a simple way to apply it with perf tools.

Yeah, I see. As I've sent a reply to Arnaldo, I'd like to add --query for
cached event definition by checking a build id.
In that case, you just need to run perf-archive and send it to remote,
then you can run perf-probe --query-set "event" on the machine.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


