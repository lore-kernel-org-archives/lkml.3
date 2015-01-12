Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbbALMJC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:09:02 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48508 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbbALMJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:09:00 -0500
Message-ID: <54B3B955.80105@hitachi.com>
Date: Mon, 12 Jan 2015 21:08:53 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: Re: [PATCH 3/4] perf probe: Fix probing kretprobes
References: <1420886028-15135-1-git-send-email-namhyung@kernel.org> <1420886028-15135-3-git-send-email-namhyung@kernel.org> <20150112112604.GA4811@krava.brq.redhat.com>
In-Reply-To: <20150112112604.GA4811@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/12 20:26), Jiri Olsa wrote:
> On Sat, Jan 10, 2015 at 07:33:47PM +0900, Namhyung Kim wrote:
>> The commit dfef99cd0b2c ("perf probe: Use ref_reloc_sym based address
>> instead of the symbol name") converts kprobes to use ref_reloc_sym
>> (i.e. _stext) and offset instead of using symbol's name directly.  So
>> on my system, adding do_fork ends up with like below:
>>
>>   $ sudo perf probe -v --add do_fork%return
>>   probe-definition(0): do_fork%return
>>   symbol:do_fork file:(null) line:0 offset:0 return:1 lazy:(null)
>>   0 arguments
>>   Looking at the vmlinux_path (7 entries long)
>>   Using /lib/modules/3.17.6-1-ARCH/build/vmlinux for symbols
>>   Could not open debuginfo. Try to use symbols.
>>   Opening /sys/kernel/debug/tracing/kprobe_events write=1
>>   Added new event:
>>   Writing event: r:probe/do_fork _stext+456136
>>   Failed to write event: Invalid argument
>>   Error: Failed to add events. Reason: Operation not permitted (Code: -1)
>>
>> As you can see, the do_fork was translated to _stext+456136.  This was
>> because to support (local) symbols that have same name.  But the
>> problem is that kretprobe requires to be inserted at function start
>> point so it simply checks whether it's called with offset 0.  And if
>> not, it'll return with -EINVAL.  You can see it with dmesg.
>>
>>   $ dmesg | tail -1
>>     [125621.764103] Return probe must be used without offset.
>>
>> So we need to use the symbol name instead of ref_reloc_sym in case of
>> return probes.
> 
> with your patchset on top of current Arnaldo's perf/core,
> I'm still getting the same error:
> 
> 
> [root@krava perf]# ./perf probe -a fork_exit=do_fork%return
> Added new event:
> Failed to write event: Invalid argument
>   Error: Failed to add events.
> [root@krava perf]# ./perf probe -v --add do_fork%return
> probe-definition(0): do_fork%return
> symbol:do_fork file:(null) line:0 offset:0 return:1 lazy:(null)
> 0 arguments
> Using /root/.debug/.build-id/60/4c5fd8a6c9202acac3a9e82ecd34b22b8caef6 for symbols
> Open Debuginfo file: /root/.debug/.build-id/60/4c5fd8a6c9202acac3a9e82ecd34b22b8caef6
> Try to find probe point from debuginfo.
> Probe point found: do_fork+0
> Found 1 probe_trace_events.
> Opening /sys/kernel/debug/tracing/kprobe_events write=1
> Added new event:
> Writing event: r:probe/do_fork _text+597840
> Failed to write event: Invalid argument
>   Error: Failed to add events. Reason: Invalid argument (Code: -22)
> [root@krava perf]# dmesg | tail -1
> [113205.738833] Return probe must be used without offset.

Yes, it seems that Namhyung's patch fixes a half of the code path.
We should fix post_process_probe_trace_events() to skip symbol
conversion or we shouldn't use debuginfo when %return is given.
Even if we find inlined function for retprobe, we can't use it
for retprobe...

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


