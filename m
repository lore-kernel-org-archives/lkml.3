Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbbASMpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:45:44 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53614 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbbASMpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:45:42 -0500
Message-ID: <54BCFC6E.1080007@hitachi.com>
Date: Mon, 19 Jan 2015 21:45:34 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
Cc: tixy@linaro.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, lizefan@huawei.com
Subject: Re: [PATCH] kprobes: bugfix: checks kprobes_all_disarmed in unoptimized_kprobe().
References: <54B3B32E.7070709@hitachi.com> <1421064563-77831-1-git-send-email-wangnan0@huawei.com> <54B3C3A0.6010708@hitachi.com> <54BC742E.80006@huawei.com> <54BCC8C0.40706@hitachi.com> <54BCE8C3.4080903@huawei.com>
In-Reply-To: <54BCE8C3.4080903@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/19 20:21), Wang Nan wrote:
> On 2015/1/19 17:05, Masami Hiramatsu wrote:
>> Hi Wang,
>>
>> I've found a problem on this patch, since kprobes calls unoptioize_kprobe
>> with kprobes_all_disarmed=true when trying to disable all kprobes, this
>> cause a serious problem.
>>
>> Moreover, I couldn't reproduce your reported bug on my 3.19-rc4 kernel.
>> Could you test it again?
>>
> 
> I tested it again based on 3.19-rc5 and found that the problem still exists.
> My testing is based on QEMU.
> 
> First I tested my kprobeopt for ARM, then on x86_64. The test results are pasted
> at the bottom of this mail. Commands after 'gdb attaches to QEMU' is my actions
> on a gdb console attached to QEMU; commands after 'inside virtual machine' is
> what I do in Linux run under QEMU.

Thank you for the reporting.
So, now I know what happened, the problem is "debugfs/kprobes/enabled doesn't work
correctly on optimized kprobes". Please make update the patch description.

I also reproduced the bug without gdb.
Here is the log.

----
[root@localhost ~]# cd /sys/kernel/debug/tracing/
[root@localhost tracing]# echo p do_fork+5 > kprobe_events	# setup new event
[root@localhost tracing]# echo $$ > set_ftrace_pid		# trace only this process
[root@localhost tracing]# echo 1 > events/kprobes/p_do_fork_5/enable	# enable it
[root@localhost tracing]# cat trace				# check the trace data
# tracer: nop
#
# entries-in-buffer/entries-written: 1/1   #P:8
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
            bash-3883  [006] d...   279.799023: p_do_fork_5: (do_fork+0x5/0x360) # OK, now tracing
[root@localhost tracing]# cat ../kprobes/list
ffffffff810bc1c5  k  do_fork+0x5    [OPTIMIZED]			# and it is actually optimized
[root@localhost tracing]# echo 0 > ../kprobes/enabled		# disable *ALL* kprobes
[root@localhost tracing]# echo > trace				# clear events
[root@localhost tracing]# cat trace				# this should show empty buffer
# tracer: nop
#
# entries-in-buffer/entries-written: 1/1   #P:8
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
            bash-3883  [006] d...   337.770785: p_do_fork_5: (do_fork+0x5/0x360)  # But still tracing!
[root@localhost tracing]# cat trace				# Check again
# tracer: nop
#
# entries-in-buffer/entries-written: 2/2   #P:8
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
            bash-3883  [006] d...   337.770785: p_do_fork_5: (do_fork+0x5/0x360)
            bash-3883  [006] d...   345.592178: p_do_fork_5: (do_fork+0x5/0x360) # We are tracing!!

So, after global disabling kprobes, ALL kprobes event should be disabled, but not.

OK, I think your first patch is better than the second one, but not enough.
What we should do is use kprobes_all_disarmed for force option like below.

	unoptimize_kprobe(p, kprobes_all_disarmed);    /* Try to unoptimize */

We also would better to check the flag in unregistering path for skipping unneeded
disarming process when kprobes globally disarmed.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


