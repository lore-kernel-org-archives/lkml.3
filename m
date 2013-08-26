Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab3HZBqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 21:46:44 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:55786 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab3HZBqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 21:46:42 -0400
X-AuditID: 85900ec0-cff26b9000001514-f3-521ab37f071f
Message-ID: <521AB37E.4050800@hitachi.com>
Date: Mon, 26 Aug 2013 10:46:38 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [RFC PATCH 00/11] trace-cmd: Support the feature recording
 trace data of guests on the host
References: <20130819094620.26597.79499.stgit@yunodevel> <20130820120006.1a4118c5@gandalf.local.home>
In-Reply-To: <20130820120006.1a4118c5@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Thank you for reviewing my patches.
Sorry for the late reply.

(2013/08/21 1:00), Steven Rostedt wrote:
> On Mon, 19 Aug 2013 18:46:20 +0900
> Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
>
>
>> d) merge feature of trace data of multiple guests and a host in chronological
>>     order
>>   Current trace-cmd cannot merge trace data of multiple guests and a host in
>> chronological order. If an user wants to analyze an I/O delay problem of a
>> guest, the user will want to check trace data of all guests and the host in a
>> file. However, trace-cmd does not support a merge feature yet, the user must
>> make a merging script. So, trace-cmd had better support a merge feature for
>> multiple files for virtualization.
>>
>
> This is incorrect. trace-cmd already has a merge feature for multiple
> machines.
>
> If you have two boxes that are in sync by ntp, you can do the following:
>
> On box1:
>
>   trace-cmd record --date -o trace-box1.dat -e all ping box2
>
> On box2:
>
>   trace-cmd record --date -o trace-box2.dat -e all ping box1
>
>
> And then copy over trace-box2.dat to box1 and run
>
>   trace-cmd report -i trace-box1.dat -i trace-box2.dat
>
> And you will see a merge. I just did this on two of my boxes called ixf
> and bxtest and here's a partial output:
>
> trace-bxtest.dat:        trace-cmd-1348  [003] 1377013771.682807: sys_enter:            NR 2 (22e2b00, 241, 1a4, 1a, 4361ac, 3)
> trace-bxtest.dat:        trace-cmd-1348  [003] 1377013771.682808: sys_enter_open:       filename: 0x022e2b00, flags: 0x00000241, mode: 0x000001a4
>     trace-ixf.dat:           <idle>-0     [002] 1377013771.682808: hrtimer_cancel:       hrtimer=0xffff880002110820
>     trace-ixf.dat:           <idle>-0     [002] 1377013771.682808: hrtimer_expire_entry: hrtimer=0xffff880002110820 now=673528250850 function=tick_sched_timer/0x0
> trace-bxtest.dat:        trace-cmd-1348  [003] 1377013771.682809:
> kmem_cache_alloc:     (getname_flags+0x37) call_site=ffffffff8117b797 ptr=0xffff8800d38c0000 bytes_req=4096 bytes_alloc=4096 gfp_flags=GFP_KERNELGFP_NOTRACK
>
>
> The --date option is used because the two machines are not in sync with
> the trace time stamp. What the date option does, is to sync the
> timestamp up with the gettimeofday and the output reports that. This
> allows the two boxes to report information that is relatively close to
> how the two interacted.

Oh, I didn't know the --date option.
As you mentioned, we can merge trace data in chronological order by
using --date option if the times of those machines are synchronized by
NTP.

> If the guest and the host have the same clock, then the --date option
> is not needed and the two should be able to be merged normally.

No, we can not assure that the guest and the host have the same clock
even if it is running on the same physical machine, because both kernel
doesn't share it, there is some difference between them. So, we still
need time synchronizing guest-host by NTP and --date option.

However, there are cases that times of those machines cannot be
synchronized. For example, although multiple users can run guests on
virtualization environments (e.g. multi-tenant cloud hosting), there
are no guarantee that they use the same NTP server. Moreover, even if
the times are synchronized, trace data cannot exactly be merged because
the NTP-synchronized time granularity may not be enough fine for
sorting guest-host switching events.

> Also, I haven't released it yet (will soon), but trace-cmd handles
> multiple buffers too. That is, with the multiple buffers that ftrace
> has, it will create and read from them as well as report them.

Is it commit ID d56f30679f9811a91ed471c8e081cc7ffbed1e62?
We can download the feature from your git repository.

> I'll finish my testing on all the latest features of trace-cmd I have
> and push it out later today.
>
> I'll also take a look at the rest of your patches.

Thank you!

Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


