Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaKEIHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:07:03 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46582 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaKEIG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:06:59 -0500
Message-ID: <5459DA9C.6020704@hitachi.com>
Date: Wed, 05 Nov 2014 17:06:52 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: [PATCH v3 0/3] perf: User/kernel time correlation and
 event generation
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>  <54589B58.7080102@hitachi.com> <1415116269.24819.14.camel@arm.com>
In-Reply-To: <1415116269.24819.14.camel@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/05 0:51), Pawel Moll wrote:
> On Tue, 2014-11-04 at 09:24 +0000, Masami Hiramatsu wrote:
>> What I'd like to do is the binary version of ftrace-marker, the text
>> version is already supported by qemu (see below).
>> https://lists.gnu.org/archive/html/qemu-devel/2013-04/msg00505.html
>>
>> But since that is just a string data (not structured data), it is hard to
>> analyze via perf-script or some other useful filters/triggers in ftrace.
>>
>> In my idea, the new event will be defined via a special file in debugfs like
>> kprobe-events, like below.
>>
>>   # cd $debugfs/tracing
>>   # echo "newgrp/newevent signarg:s32 flag:u64" >> marker_events
>>   # cat events/newgrp/newevent/format
>>   name: newevent
>>   ID: 2048
>>   format:
>>         field:unsigned short common_type;       offset:0;       size:2; signed:0;
>>         field:unsigned char common_flags;       offset:2;       size:1; signed:0;
>>         field:unsigned char common_preempt_count;       offset:3;       size:1;signed:0;
>>         field:int common_pid;   offset:4;       size:4; signed:1;
>>
>>         field:s32 signarg;      offset:8;      size:4; signed:1;
>>         field:u64 flag; offset:12;      size:8; signed:0;
>>
>>   print fmt: "signarg=%d flag=0x%Lx", REC->signarg, REC->flag
>>
>> Then, users will write the data (excluded common fields) when the event happens
>> via trace_marker which start with '\0'ID(in u32). Kernel just checks the ID and
>> its data size, but doesn't parse, filter/trigger it and log it into the kernel buffer.
> 
> Very neat, I like it! Certainly useful with scripting. Any gut feeling
> regarding the kernel version it will be ready for? 3.19 or later than
> that?

Thanks, and not yet implemented, I'd like to ask people about the format etc.
before that :)

>> Of course, this has a downside that the user must have a privilege to access to debugfs.
>> Thus maybe we need both of prctl() IF for perf and this IF for ftrace.
> 
> I don't have any particularly strong feelings about the solution as long
> as I'm able to create this "synchronisation point" of mine in the perf
> data. In one of this patch's previous incarnations I was also doing a
> write() to the perf fd to achieve pretty much the same result.
> 
> In my personal use case root access to debugfs isn't a problem (I need
> it for other ftrace operations anyway). However Ingo and some other guys
> seemed interested in prctl() approach because: 1. it's much simpler to
> use even comparing with simple trace_marker's open(path)/write()/close()
> and 2. because any process can do it at any time and the results are
> quietly discarded if no one is listening. I also remember that when I
> proposed sort of "unification" between trace_marker and the uevents,
> Ingo straight away "suggested" keeping it separate.

Agreed, I think we can keep trace_marker opened (so application will just
need to write() the events), but for the second reason, prctl will be
better for per-application usage. Actually, ftrace is "system-wide" oriented,
but the perf is not.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


