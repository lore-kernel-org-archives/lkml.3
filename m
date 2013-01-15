Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab3AOQsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:48:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559Ab3AOQsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:48:52 -0500
Message-ID: <50F58867.6010507@redhat.com>
Date: Tue, 15 Jan 2013 11:48:39 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Clayton <andrew@digital-domain.net>
CC: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: qemu-kvm hangs at start up under 3.8.0-rc3-00074-gb719f43 (works
 with CONFIG_LOCKDEP)
References: <20130113222958.64840242@omega.digital-domain.net> <20130114132736.GA12489@redhat.com> <20130114182449.5a163101@omega.digital-domain.net>
In-Reply-To: <20130114182449.5a163101@omega.digital-domain.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 01:24 PM, Andrew Clayton wrote:
> On Mon, 14 Jan 2013 15:27:36 +0200, Gleb Natapov wrote:
>
>> On Sun, Jan 13, 2013 at 10:29:58PM +0000, Andrew Clayton wrote:
>>> When running qemu-kvm under 64but Fedora 16 under current 3.8, it
>>> just hangs at start up. Dong a ps -ef hangs the process at the
>>> point where it would display the qemu process (trying to list the
>>> qemu-kvm /proc pid directory contents just hangs ls).
>>>
>>> I also noticed some other weirdness at this point like Firefox
>>> hanging for many seconds at a time and increasing load average.
>>>
>>> The qemu command I was trying to run was
>>>
>>> $ qemu-kvm -m 512 -smp 2 -vga vmware -k en-gb -drive
>>> file=/home/andrew/machines/qemu/f16-i386.img,if=virtio
>>>
>>> Here's the last few lines of a strace on it at start up.
>>>
>>> open("/home/andrew/machines/qemu/f16-i386.img",
>>> O_RDWR|O_DSYNC|O_CLOEXEC) = 8 lseek(8, 0,
>>> SEEK_END)                   = 9100722176 pread(8,
>>> "QFI\373\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\20\0\0\0\2\200\0\0\0"...,
>>> 512, 0) = 512 pread(8,
>>> "\200\0\0\0\0\4\0\0\200\0\0\0\0\10\0\0\200\0\0\0\2\210\0\0\200\0\0\0\2\233\0\0"...,
>>> 512, 65536) = 512 brk(0)                                  =
>>> 0x7faf12db0000 brk(0x7faf12ddd000
>>>
>>> It's hanging in that brk syscall. The load average also then starts
>>> to increase.
>>>
>>>
>>> However. I can make it run fine, if I enable CONFIG_LOCKDEP. But
>>> the only thing in dmesg I get is the usual.
>>>
>>> kvm: SMP vm created on host with unstable TSC; guest TSC will not
>>> be reliable
>>>
>>> I've attached both working and non-working .configs. The only
>>> difference being the lock checking enabled in config.good.
>>>
>>> The most recent kernel I had it working in was 3.7.0
>>>
>>> System is a Quad Core Intel running 64bit Fedora 16.
>>>
>> Can you run "echo t > /proc/sysrq-trigger" and see where it hangs?
>
> Here you go, here's the bash process, qemu and a kvm bit. (From the
> above command)
>
> bash            S ffff88013b2b0d00     0  3203   3133 0x00000000
>   ffff880114dabe58 0000000000000082 8000000113558065 ffff880114dabfd8
>   ffff880114dabfd8 0000000000004000 ffff88013b0c5b00 ffff88013b2b0d00
>   ffff880114dabd88 ffffffff8109067d ffffea0004536670 ffffea0004536640
> Call Trace:
>   [<ffffffff8109067d>] ? default_wake_function+0xd/0x10
>   [<ffffffff8108a315>] ? atomic_notifier_call_chain+0x15/0x20
>   [<ffffffff8133d84f>] ? tty_get_pgrp+0x3f/0x50
>   [<ffffffff810819ac>] ? pid_vnr+0x2c/0x30
>   [<ffffffff8133fe54>] ? tty_ioctl+0x7b4/0xbd0
>   [<ffffffff8106bf62>] ? wait_consider_task+0x102/0xaf0
>   [<ffffffff815c00e4>] schedule+0x24/0x70
>   [<ffffffff8106cb24>] do_wait+0x1d4/0x200
>   [<ffffffff8106d9cb>] sys_wait4+0x9b/0xf0
>   [<ffffffff8106b9f0>] ? task_stopped_code+0x50/0x50
>   [<ffffffff815c1ad2>] system_call_fastpath+0x16/0x1b
>
> qemu-kvm        D ffff88011ab8c8b8     0  3345   3203 0x00000000
>   ffff880112129cd8 0000000000000082 ffff880112129c50 ffff880112129fd8
>   ffff880112129fd8 0000000000004000 ffff88013b04ce00 ffff880139da1a00
>   0000000000000000 00000000000280da ffff880112129d38 ffffffff810d3300
> Call Trace:
>   [<ffffffff810d3300>] ? __alloc_pages_nodemask+0xf0/0x7c0
>   [<ffffffff811273c6>] ? touch_atime+0x66/0x170
>   [<ffffffff810cdabf>] ? generic_file_aio_read+0x5bf/0x730
>   [<ffffffff815c00e4>] schedule+0x24/0x70
>   [<ffffffff815c0cdd>] rwsem_down_failed_common+0xbd/0x150
>   [<ffffffff815c0da3>] rwsem_down_write_failed+0x13/0x15
>   [<ffffffff812d1be3>] call_rwsem_down_write_failed+0x13/0x20
>   [<ffffffff815bf4dd>] ? down_write+0x2d/0x34
>   [<ffffffff810f0724>] vma_adjust+0xe4/0x610
>   [<ffffffff810f0fa4>] vma_merge+0x1b4/0x270
>   [<ffffffff810f1fa6>] do_brk+0x196/0x330
>   [<ffffffff810f2217>] sys_brk+0xd7/0x130
>   [<ffffffff815c1ad2>] system_call_fastpath+0x16/0x1b

This looks like qemu-kvm getting stuck trying to get the anon_vma lock.

That leads to the obvious question: what is holding the lock, and/or
failed to release it?

Do you have any other (qemu-kvm?) processes on your system that have
any code in the VM (or strace/ptrace/...) in the backtrace, that might
be holding this lock?

Do you have anything in your dmesg showing threads that had a BUG_ON
(and exited) while holding the lock?

-- 
All rights reversed
