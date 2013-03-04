Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab3CDDBF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:01:05 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:50753 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3CDDBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:01:03 -0500
Message-ID: <51340E2E.4070805@huawei.com>
Date: Mon, 4 Mar 2013 10:59:58 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tommi Rantala <tt.rantala@gmail.com>
CC: Tejun Heo <tj@kernel.org>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: cgroup_release_agent() hung task warnings
References: <CA+ydwtrRAf5VW_iZYOjzmTv6Y0ebprXw_RfWVmR1okQOxQx=CA@mail.gmail.com>
In-Reply-To: <CA+ydwtrRAf5VW_iZYOjzmTv6Y0ebprXw_RfWVmR1okQOxQx=CA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/3 3:23, Tommi Rantala wrote:
> Hello,
> 
> I'm seeing the following hung task warnings when fuzzing the kernel
> with trinity (in a qemu virtual machine, as the root user), that I
> have not seen before with 3.8 or earlier. The kernel is
> b0af9cd9aab60ceb17d3ebabb9fdf4ff0a99cf50 (Merge tag
> 'lzo-update-signature-20130226' of
> git://github.com/markus-oberhumer/linux).
> 

This doesn't look like a cgroup bug.

...
> [  120.594088] INFO: task kworker/0:2:1079 blocked for more than 60 seconds.
> [  120.595877] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  120.598100] kworker/0:2     D ffff88007c518618     0  1079      2 0x00000000
> [  120.599958]  ffff88007adc9a38 0000000000000046 ffff88007b0b0000
> ffff88007adc9fd8
> [  120.601982]  ffff88007adc9fd8 ffff88007adc9fd8 ffff88007c518000
> ffff88007b0b0000
> [  120.603994]  ffff88007adc9a18 ffff88007adc9b88 ffff88007adc9b90
> 7fffffffffffffff
> [  120.606003] Call Trace:
> [  120.606684]  [<ffffffff81cd9d95>] schedule+0x55/0x60
> [  120.607973]  [<ffffffff81cd7786>] schedule_timeout+0x36/0x240
> [  120.609460]  [<ffffffff810f3303>] ? mark_held_locks+0x123/0x140
> [  120.610932]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
> [  120.612521]  [<ffffffff810f3475>] ? trace_hardirqs_on_caller+0x155/0x1f0
> [  120.614471]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
> [  120.615957]  [<ffffffff81cda037>] wait_for_completion+0x97/0x100
> [  120.617495]  [<ffffffff810d2310>] ? try_to_wake_up+0x340/0x340
> [  120.619013]  [<ffffffff810b615c>] call_usermodehelper_exec+0x14c/0x210
> [  120.620613]  [<ffffffff81cd9fcc>] ? wait_for_completion+0x2c/0x100
> [  120.622187]  [<ffffffff810b6948>] call_usermodehelper_fns+0xe8/0x100
> [  120.623821]  [<ffffffff8110921a>] cgroup_release_agent+0x15a/0x180
> [  120.625374]  [<ffffffff810b85cb>] process_one_work+0x29b/0x4c0
> [  120.626861]  [<ffffffff810b8560>] ? process_one_work+0x230/0x4c0
> [  120.628407]  [<ffffffff810b8da8>] worker_thread+0x248/0x380
> [  120.630183]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
> [  120.631761]  [<ffffffff810bfd71>] kthread+0xd1/0xe0
> [  120.633019]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
> [  120.634479]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
> [  120.635898]  [<ffffffff81cdcdfc>] ret_from_fork+0x7c/0xb0
> [  120.637254]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40

The completion was never done:

static
int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
{
        DECLARE_COMPLETION_ONSTACK(done);

	...
        sub_info->complete = &done;
        sub_info->wait = wait;

        queue_work(khelper_wq, &sub_info->work);
	...
        wait_for_completion(&done);
	...
        return retval;
}

It should be done here:

static void __call_usermodehelper(struct work_struct *work)
{
	...
                pid = kernel_thread(call_helper, sub_info,
                                    CLONE_VFORK | SIGCHLD);
	...

        switch (wait) {
	...
        case UMH_WAIT_EXEC:
                if (pid < 0)
                        sub_info->retval = pid;
                umh_complete(sub_info);
        }
}

You may need to add some printks to see why completion can't be done.
Maybe khelper_wq was blocked and couldn't schedule any work?

