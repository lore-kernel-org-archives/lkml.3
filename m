Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202Ab3BWQmn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 11:42:43 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:62188 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000Ab3BWQml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 11:42:41 -0500
Message-ID: <5128F16E.30804@gmail.com>
Date: Sat, 23 Feb 2013 11:42:22 -0500
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v4 00/32] ldisc patchset
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>  <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>  <51261E30.9040907@gmail.com> <1361453910.10685.7.camel@thor.lan> <1361558250.14402.6.camel@thor.lan> <5128DF40.7030003@gmail.com>
In-Reply-To: <5128DF40.7030003@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2013 10:24 AM, Sasha Levin wrote:
> On 02/22/2013 01:37 PM, Peter Hurley wrote:
>> On Thu, 2013-02-21 at 08:38 -0500, Peter Hurley wrote:
>>> On Thu, 2013-02-21 at 08:16 -0500, Sasha Levin wrote:
>>>> On 02/20/2013 03:02 PM, Peter Hurley wrote:
>>>>> Sasha and Dave, my trinity testbeds die in other areas right now;
>>>>> I would really appreciate if you would please re-test this series.
>>>>
>>>> Hi Peter,
>>>>
>>>> I saw this twice in overnight fuzzing:
>>>>
>>>> [ 1473.912280] =================================
>>>> [ 1473.913180] [ BUG: bad contention detected! ]
>>>> [ 1473.914071] 3.8.0-next-20130220-sasha-00038-g1ad55df-dirty #8 Tainted: G        W
>>>> [ 1473.915684] ---------------------------------
>>>> [ 1473.916549] kworker/1:1/361 is trying to contend lock (&tty->ldisc_sem) at:
>>>> [ 1473.918031] [<ffffffff81c493df>] tty_ldisc_ref+0x1f/0x60
>>>> [ 1473.919060] but there are no locks held!
>>>
>>> Ahh, of course. That explains why the rwsem trylock doesn't track lock
>>> stats -- because by the time lock_contended() is called, up_write()
>>> could have just called lockdep_release(), so that it appears as if the
>>> lock has been released when in fact it has not but is about to.
>>>
>>> I'll just remove the lock contention test from the trylocks.
>>
>> Hi Sasha,
>>
>> Sorry for the delay. I was actually looking into if I could tickle
>> lockdep into just recording the lock contention without testing, but
>> unfortunately, changes to where lockdep stores the contention now
>> requires the lockdep state to have an existing owner.
>>
>> So here's the trivial patch:
> 
> Hi Peter,
> 
> After more fuzzing, I'm seeing this sort of hangs (which are new):
> 
> [ 2644.723879] INFO: task trinity:17893 blocked for more than 120 seconds.
> [ 2644.727112] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2644.731916] trinity         D ffff8800a9c904a8  5192 17893   8043 0x00000000
> [ 2644.733517]  ffff88006efb3a78 0000000000000002 ffff8800aa0c3b10 ffff8800bb3d7180
> [ 2644.739350]  ffff880019103000 ffff880097a78000 ffff88006efb3a78 00000000001d7180
> [ 2644.741459]  ffff880097a78000 ffff88006efb3fd8 00000000001d7180 00000000001d7180
> [ 2644.746590] Call Trace:
> [ 2644.747177]  [<ffffffff83db9909>] __schedule+0x2e9/0x3b0
> [ 2644.748294]  [<ffffffff83db9b35>] schedule+0x55/0x60
> [ 2644.752382]  [<ffffffff83db9e83>] schedule_preempt_disabled+0x13/0x20
> [ 2644.753737]  [<ffffffff83db7fdd>] __mutex_lock_common+0x34d/0x560
> [ 2644.759037]  [<ffffffff81c40893>] ? ptmx_open+0x83/0x190
> [ 2644.760590]  [<ffffffff83db84b5>] ? __mutex_unlock_slowpath+0x185/0x1e0
> [ 2644.762064]  [<ffffffff81c40893>] ? ptmx_open+0x83/0x190
> [ 2644.768967]  [<ffffffff83db831f>] mutex_lock_nested+0x3f/0x50
> [ 2644.770314]  [<ffffffff81c40893>] ptmx_open+0x83/0x190
> [ 2644.771413]  [<ffffffff812917ae>] chrdev_open+0x11e/0x190
> [ 2644.780456]  [<ffffffff81291690>] ? cdev_put+0x30/0x30
> [ 2644.781421]  [<ffffffff8128af59>] do_dentry_open+0x1f9/0x310
> [ 2644.785550]  [<ffffffff8128b0bc>] finish_open+0x4c/0x70
> [ 2644.786724]  [<ffffffff8129c3eb>] do_last+0x61b/0x810
> [ 2644.787676]  [<ffffffff8129c699>] path_openat+0xb9/0x4d0
> [ 2644.791868]  [<ffffffff812ac278>] ? __alloc_fd+0x1e8/0x200
> [ 2644.792817]  [<ffffffff81185214>] ? lock_release_nested+0xb4/0xf0
> [ 2644.794010]  [<ffffffff81185331>] ? __lock_release+0xe1/0x100
> [ 2644.797401]  [<ffffffff8129cebd>] do_filp_open+0x3d/0xa0
> [ 2644.798467]  [<ffffffff812ac278>] ? __alloc_fd+0x1e8/0x200
> [ 2644.799577]  [<ffffffff8128c51b>] do_sys_open+0x12b/0x1d0
> [ 2644.804667]  [<ffffffff8128c5dc>] sys_open+0x1c/0x20
> [ 2644.805542]  [<ffffffff83dc49d8>] tracesys+0xe1/0xe6
> [ 2644.822807] 1 lock held by trinity/17893:
> [ 2644.823685]  #0:  (tty_mutex){+.+.+.}, at: [<ffffffff81c40893>] ptmx_open+0x83/0x190
> 
> The mutex is 'tty_mutex' at drivers/tty/pty.c:701 .
> 
> I didn't grab sysrq-t this time since it was an overnight run, but I'll
> try to grab one when it happens again.

Hi Peter,

I've also got this one for the first time:
[  484.450139] INFO: task init:1 blocked for more than 120 seconds.
[  484.451130] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  484.452013] init            D 00000000001d7180  2688     1      0 0x00000002
[  484.452883]  ffff8800b9acfba8 0000000000000002 00000000001d7180 ffff8800b9b10048
[  484.453816]  ffff8800b94cb000 ffff8800b9b10000 00000000001d7180 00000000001d7180
[  484.454529]  ffff8800b9b10000 ffff8800b9acffd8 00000000001d7180 00000000001d7180
[  484.455232] Call Trace:
[  484.455515]  [<ffffffff83db9909>] __schedule+0x2e9/0x3b0
[  484.456081]  [<ffffffff83db9b35>] schedule+0x55/0x60
[  484.456636]  [<ffffffff83db74ba>] schedule_timeout+0x3a/0x370
[  484.457263]  [<ffffffff81182349>] ? mark_held_locks+0xf9/0x130
[  484.457866]  [<ffffffff83dbab38>] ? down_failed+0x108/0x200
[  484.458539]  [<ffffffff83dbb7ab>] ? _raw_spin_unlock_irq+0x2b/0x80
[  484.459223]  [<ffffffff81182608>] ? trace_hardirqs_on_caller+0x128/0x160
[  484.459822]  [<ffffffff83dbab61>] down_failed+0x131/0x200
[  484.460512]  [<ffffffff83dbbfad>] ? tty_ldisc_lock_pair_timeout+0xcd/0x120
[  484.461376]  [<ffffffff83dbae03>] ldsem_down_write+0xd3/0x113
[  484.461895]  [<ffffffff83dbbfad>] ? tty_ldisc_lock_pair_timeout+0xcd/0x120
[  484.462824]  [<ffffffff8118264d>] ? trace_hardirqs_on+0xd/0x10
[  484.463504]  [<ffffffff83dbbfad>] tty_ldisc_lock_pair_timeout+0xcd/0x120
[  484.464258]  [<ffffffff81c3df60>] tty_ldisc_hangup+0xd0/0x220
[  484.464825]  [<ffffffff81c35bd7>] __tty_hangup+0x137/0x4f0
[  484.465684]  [<ffffffff81c37c7c>] disassociate_ctty+0x6c/0x230
[  484.466607]  [<ffffffff8111290c>] do_exit+0x41c/0x590
[  484.467419]  [<ffffffff8107ad34>] ? syscall_trace_enter+0x24/0x2e0
[  484.468413]  [<ffffffff81112b4a>] do_group_exit+0x8a/0xc0
[  484.469281]  [<ffffffff81112b92>] sys_exit_group+0x12/0x20
[  484.470159]  [<ffffffff83dc49d8>] tracesys+0xe1/0xe6
[  484.470951] 1 lock held by init/1:
[  484.471513]  #0:  (&tty->ldisc_sem){++++++}, at: [<ffffffff83dbbfad>] tty_ldisc_lock_pair_timeout+0xcd/0x120
[  484.473290] INFO: task trinity:9732 blocked for more than 120 seconds.
[  484.474324] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  484.475540] trinity         D 00000000001d7180  4992  9732      1 0x00000000
[  484.476691]  ffff8800915ddc28 0000000000000002 00000000001d7180 ffff8800aa09d208
[  484.477933]  ffff8800b94b3000 ffff880070188000 00000000001d7180 00000000001d7180
[  484.479180]  ffff880070188000 ffff8800915ddfd8 00000000001d7180 00000000001d7180
[  484.480387] Call Trace:
[  484.480744]  [<ffffffff83db9909>] __schedule+0x2e9/0x3b0
[  484.481487]  [<ffffffff83db9b35>] schedule+0x55/0x60
[  484.482258]  [<ffffffff83db74ba>] schedule_timeout+0x3a/0x370
[  484.483164]  [<ffffffff81182349>] ? mark_held_locks+0xf9/0x130
[  484.484059]  [<ffffffff83dbab38>] ? down_failed+0x108/0x200
[  484.484915]  [<ffffffff83dbb7ab>] ? _raw_spin_unlock_irq+0x2b/0x80
[  484.485866]  [<ffffffff81182608>] ? trace_hardirqs_on_caller+0x128/0x160
[  484.486890]  [<ffffffff83dbab61>] down_failed+0x131/0x200
[  484.487714]  [<ffffffff81c3d6bf>] ? tty_ldisc_ref_wait+0x1f/0x50
[  484.488628]  [<ffffffff83dbacbc>] ldsem_down_read+0x8c/0x100
[  484.489522]  [<ffffffff81c3d6bf>] ? tty_ldisc_ref_wait+0x1f/0x50
[  484.490463]  [<ffffffff81185331>] ? __lock_release+0xe1/0x100
[  484.491349]  [<ffffffff81c3d6bf>] tty_ldisc_ref_wait+0x1f/0x50
[  484.491967]  [<ffffffff81c36508>] tty_write+0x98/0xf0
[  484.492442]  [<ffffffff81a38938>] ? do_raw_spin_unlock+0xc8/0xe0
[  484.493000]  [<ffffffff81c365f5>] redirected_tty_write+0x95/0xc0
[  484.493826]  [<ffffffff8128ce38>] vfs_write+0xb8/0x180
[  484.494643]  [<ffffffff8128d170>] sys_write+0x50/0xa0
[  484.495460]  [<ffffffff83dc49d8>] tracesys+0xe1/0xe6
[  484.496398] 1 lock held by trinity/9732:
[  484.497032]  #0:  (&tty->ldisc_sem){++++++}, at: [<ffffffff81c3d6bf>] tty_ldisc_ref_wait+0x1f/0x50
[  484.498606] INFO: task trinity:10089 blocked for more than 120 seconds.
[  484.499640] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  484.500885] trinity         D 00000000001d7180  5224 10089      1 0x00000000
[  484.502053]  ffff88006bb2bc28 0000000000000002 00000000001d7180 ffff8800aa09d208
[  484.503256]  ffff8800b94b3000 ffff880094303000 00000000001d7180 00000000001d7180
[  484.504450]  ffff880094303000 ffff88006bb2bfd8 00000000001d7180 00000000001d7180
[  484.505657] Call Trace:
[  484.506052]  [<ffffffff83db9909>] __schedule+0x2e9/0x3b0
[  484.506871]  [<ffffffff83db9b35>] schedule+0x55/0x60
[  484.507650]  [<ffffffff83db74ba>] schedule_timeout+0x3a/0x370
[  484.508542]  [<ffffffff81182349>] ? mark_held_locks+0xf9/0x130
[  484.509446]  [<ffffffff83dbab38>] ? down_failed+0x108/0x200
[  484.510312]  [<ffffffff83dbb7ab>] ? _raw_spin_unlock_irq+0x2b/0x80
[  484.511285]  [<ffffffff81182608>] ? trace_hardirqs_on_caller+0x128/0x160
[  484.512276]  [<ffffffff83dbab61>] down_failed+0x131/0x200
[  484.512813]  [<ffffffff81c3d6bf>] ? tty_ldisc_ref_wait+0x1f/0x50
[  484.513459]  [<ffffffff83dbacbc>] ldsem_down_read+0x8c/0x100
[  484.514345]  [<ffffffff81c3d6bf>] ? tty_ldisc_ref_wait+0x1f/0x50
[  484.515263]  [<ffffffff81185331>] ? __lock_release+0xe1/0x100
[  484.516135]  [<ffffffff81c3d6bf>] tty_ldisc_ref_wait+0x1f/0x50
[  484.517049]  [<ffffffff81c36508>] tty_write+0x98/0xf0
[  484.517842]  [<ffffffff81a38938>] ? do_raw_spin_unlock+0xc8/0xe0
[  484.518780]  [<ffffffff81c365f5>] redirected_tty_write+0x95/0xc0
[  484.519730]  [<ffffffff8128ce38>] vfs_write+0xb8/0x180
[  484.520590]  [<ffffffff8128d170>] sys_write+0x50/0xa0
[  484.521108]  [<ffffffff83dc49d8>] tracesys+0xe1/0xe6
[  484.521976] 1 lock held by trinity/10089:
[  484.522619]  #0:  (&tty->ldisc_sem){++++++}, at: [<ffffffff81c3d6bf>] tty_ldisc_ref_wait+0x1f/0x50
[  484.524181] INFO: task trinity:10254 blocked for more than 120 seconds.
[  484.525200] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  484.526405] trinity         D 00000000001d7180  5240 10254      1 0x00000000
[  484.527559]  ffff880096219c28 0000000000000002 00000000001d7180 ffff8800aa09cb78
[  484.528799]  ffff8800b94c3000 ffff8800961a8000 00000000001d7180 00000000001d7180
[  484.530059]  ffff8800961a8000 ffff880096219fd8 00000000001d7180 00000000001d7180
[  484.531205] Call Trace:
[  484.531593]  [<ffffffff83db9909>] __schedule+0x2e9/0x3b0
[  484.532185]  [<ffffffff83db9b35>] schedule+0x55/0x60
[  484.532964]  [<ffffffff83db74ba>] schedule_timeout+0x3a/0x370
[  484.533865]  [<ffffffff81182349>] ? mark_held_locks+0xf9/0x130
[  484.534784]  [<ffffffff83dbab38>] ? down_failed+0x108/0x200
[  484.535669]  [<ffffffff83dbb7ab>] ? _raw_spin_unlock_irq+0x2b/0x80
[  484.536660]  [<ffffffff81182608>] ? trace_hardirqs_on_caller+0x128/0x160
[  484.537716]  [<ffffffff83dbab61>] down_failed+0x131/0x200
[  484.538568]  [<ffffffff81c3d6bf>] ? tty_ldisc_ref_wait+0x1f/0x50
[  484.539511]  [<ffffffff83dbacbc>] ldsem_down_read+0x8c/0x100
[  484.540426]  [<ffffffff81c3d6bf>] ? tty_ldisc_ref_wait+0x1f/0x50
[  484.541321]  [<ffffffff81185331>] ? __lock_release+0xe1/0x100
[  484.542097]  [<ffffffff81c3d6bf>] tty_ldisc_ref_wait+0x1f/0x50
[  484.542754]  [<ffffffff81c36508>] tty_write+0x98/0xf0
[  484.543299]  [<ffffffff81a38938>] ? do_raw_spin_unlock+0xc8/0xe0
[  484.543930]  [<ffffffff81c365f5>] redirected_tty_write+0x95/0xc0
[  484.544529]  [<ffffffff8128ce38>] vfs_write+0xb8/0x180
[  484.545109]  [<ffffffff8128d170>] sys_write+0x50/0xa0
[  484.545590]  [<ffffffff83dc49d8>] tracesys+0xe1/0xe6
[  484.546280] 1 lock held by trinity/10254:
[  484.546841]  #0:  (&tty->ldisc_sem){++++++}, at: [<ffffffff81c3d6bf>] tty_ldisc_ref_wait+0x1f/0x50
[  484.547890] INFO: task trinity:10643 blocked for more than 120 seconds.
[  484.548516] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  484.549320] trinity         D 00000000001d7180  5432 10643      1 0x00000000
[  484.550051]  ffff88006adafc28 0000000000000002 00000000001d7180 ffff8800aa09cec0
[  484.551316]  ffff8800b94c0000 ffff880090a6b000 00000000001d7180 00000000001d7180
[  484.552233]  ffff880090a6b000 ffff88006adaffd8 00000000001d7180 00000000001d7180
[  484.553283] Call Trace:
[  484.553564]  [<ffffffff83db9909>] __schedule+0x2e9/0x3b0
[  484.554125]  [<ffffffff83db9b35>] schedule+0x55/0x60
[  484.554746]  [<ffffffff83db74ba>] schedule_timeout+0x3a/0x370
[  484.555490]  [<ffffffff81182349>] ? mark_held_locks+0xf9/0x130
[  484.556289]  [<ffffffff83dbab38>] ? down_failed+0x108/0x200
[  484.556892]  [<ffffffff83dbb7ab>] ? _raw_spin_unlock_irq+0x2b/0x80
[  484.557576]  [<ffffffff81182608>] ? trace_hardirqs_on_caller+0x128/0x160
[  484.558452]  [<ffffffff83dbab61>] down_failed+0x131/0x200
[  484.559045]  [<ffffffff81c3d6bf>] ? tty_ldisc_ref_wait+0x1f/0x50
[  484.559786]  [<ffffffff83dbacbc>] ldsem_down_read+0x8c/0x100
[  484.560742]  [<ffffffff81c3d6bf>] ? tty_ldisc_ref_wait+0x1f/0x50
[  484.561913]  [<ffffffff81185331>] ? __lock_release+0xe1/0x100
[  484.562875]  [<ffffffff81c3d6bf>] tty_ldisc_ref_wait+0x1f/0x50
[  484.563587]  [<ffffffff81c36508>] tty_write+0x98/0xf0
[  484.564126]  [<ffffffff81a38938>] ? do_raw_spin_unlock+0xc8/0xe0
[  484.564938]  [<ffffffff81c365f5>] redirected_tty_write+0x95/0xc0
[  484.565569]  [<ffffffff8128ce38>] vfs_write+0xb8/0x180
[  484.566098]  [<ffffffff8128d170>] sys_write+0x50/0xa0
[  484.566740]  [<ffffffff83dc49d8>] tracesys+0xe1/0xe6
[  484.567436] 1 lock held by trinity/10643:
[  484.567932]  #0:  (&tty->ldisc_sem){++++++}, at: [<ffffffff81c3d6bf>] tty_ldisc_ref_wait+0x1f/0x50
[  484.569211] INFO: task trinity:11088 blocked for more than 120 seconds.
[  484.569980] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  484.571067] trinity         D 00000000001d7180  5608 11088      1 0x00000000
[  484.572132]  ffff88006b197c28 0000000000000002 00000000001d7180 ffff8800aa09cb78
[  484.573011]  ffff8800b94c3000 ffff88009a633000 00000000001d7180 00000000001d7180
[  484.573876]  ffff88009a633000 ffff88006b197fd8 00000000001d7180 00000000001d7180
[  484.574822] Call Trace:
[  484.575092]  [<ffffffff83db9909>] __schedule+0x2e9/0x3b0
[  484.575811]  [<ffffffff83db9b35>] schedule+0x55/0x60
[  484.576413]  [<ffffffff83db74ba>] schedule_timeout+0x3a/0x370
[  484.577003]  [<ffffffff81182349>] ? mark_held_locks+0xf9/0x130
[  484.577732]  [<ffffffff83dbab38>] ? down_failed+0x108/0x200
[  484.578381]  [<ffffffff83dbb7ab>] ? _raw_spin_unlock_irq+0x2b/0x80
[  484.579070]  [<ffffffff81182608>] ? trace_hardirqs_on_caller+0x128/0x160
[  484.579836]  [<ffffffff83dbab61>] down_failed+0x131/0x200
[  484.580600]  [<ffffffff81c3d6bf>] ? tty_ldisc_ref_wait+0x1f/0x50
[  484.581320]  [<ffffffff83dbacbc>] ldsem_down_read+0x8c/0x100
[  484.581947]  [<ffffffff81c3d6bf>] ? tty_ldisc_ref_wait+0x1f/0x50
[  484.582536]  [<ffffffff81185331>] ? __lock_release+0xe1/0x100
[  484.583061]  [<ffffffff81c3d6bf>] tty_ldisc_ref_wait+0x1f/0x50
[  484.583741]  [<ffffffff81c36508>] tty_write+0x98/0xf0
[  484.584215]  [<ffffffff81a38938>] ? do_raw_spin_unlock+0xc8/0xe0
[  484.584893]  [<ffffffff81c365f5>] redirected_tty_write+0x95/0xc0
[  484.585491]  [<ffffffff8128ce38>] vfs_write+0xb8/0x180
[  484.586000]  [<ffffffff8128d170>] sys_write+0x50/0xa0
[  484.586543]  [<ffffffff83dc49d8>] tracesys+0xe1/0xe6
[  484.587211] 1 lock held by trinity/11088:
[  484.587599]  #0:  (&tty->ldisc_sem){++++++}, at: [<ffffffff81c3d6bf>] tty_ldisc_ref_wait+0x1f/0x50
[  604.580385] INFO: task init:1 blocked for more than 120 seconds.
[  604.581345] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  604.582364] init            D 00000000001d7180  2688     1      0 0x00000002
[  604.583115]  ffff8800b9acfba8 0000000000000002 00000000001d7180 ffff8800b9b10048
[  604.583949]  ffff8800b94cb000 ffff8800b9b10000 00000000001d7180 00000000001d7180
[  604.584652]  ffff8800b9b10000 ffff8800b9acffd8 00000000001d7180 00000000001d7180
[  604.585375] Call Trace:
[  604.585680]  [<ffffffff83db9909>] __schedule+0x2e9/0x3b0
[  604.586213]  [<ffffffff83db9b35>] schedule+0x55/0x60
[  604.586744]  [<ffffffff83db74ba>] schedule_timeout+0x3a/0x370
[  604.587322]  [<ffffffff81182349>] ? mark_held_locks+0xf9/0x130
[  604.587850]  [<ffffffff83dbab38>] ? down_failed+0x108/0x200
[  604.588379]  [<ffffffff83dbb7ab>] ? _raw_spin_unlock_irq+0x2b/0x80
[  604.588991]  [<ffffffff81182608>] ? trace_hardirqs_on_caller+0x128/0x160
[  604.589743]  [<ffffffff83dbab61>] down_failed+0x131/0x200
[  604.590598]  [<ffffffff83dbbfad>] ? tty_ldisc_lock_pair_timeout+0xcd/0x120
[  604.591651]  [<ffffffff83dbae03>] ldsem_down_write+0xd3/0x113
[  604.592467]  [<ffffffff83dbbfad>] ? tty_ldisc_lock_pair_timeout+0xcd/0x120
[  604.593494]  [<ffffffff8118264d>] ? trace_hardirqs_on+0xd/0x10
[  604.594402]  [<ffffffff83dbbfad>] tty_ldisc_lock_pair_timeout+0xcd/0x120
[  604.595445]  [<ffffffff81c3df60>] tty_ldisc_hangup+0xd0/0x220
[  604.596324]  [<ffffffff81c35bd7>] __tty_hangup+0x137/0x4f0
[  604.597159]  [<ffffffff81c37c7c>] disassociate_ctty+0x6c/0x230
[  604.598047]  [<ffffffff8111290c>] do_exit+0x41c/0x590
[  604.598872]  [<ffffffff8107ad34>] ? syscall_trace_enter+0x24/0x2e0
[  604.599827]  [<ffffffff81112b4a>] do_group_exit+0x8a/0xc0
[  604.600686]  [<ffffffff81112b92>] sys_exit_group+0x12/0x20
[  604.601568]  [<ffffffff83dc49d8>] tracesys+0xe1/0xe6
[  604.608562] 1 lock held by init/1:
[  604.609053]  #0:  (&tty->ldisc_sem){++++++}, at: [<ffffffff83dbbfad>] tty_ldisc_lock_pair_timeout+0xcd/0x120
[  604.610836] INFO: task trinity:9732 blocked for more than 120 seconds.
[  604.611877] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  604.613063] trinity         D 00000000001d7180  4992  9732      1 0x00000000
[  604.614204]  ffff8800915ddc28 0000000000000002 00000000001d7180 ffff8800aa09d208
[  604.615410]  ffff8800b94b3000 ffff880070188000 00000000001d7180 00000000001d7180
[  604.616604]  ffff880070188000 ffff8800915ddfd8 00000000001d7180 00000000001d7180
[  604.617846] Call Trace:
[  604.618258]  [<ffffffff83db9909>] __schedule+0x2e9/0x3b0
[  604.619076]  [<ffffffff83db9b35>] schedule+0x55/0x60
[  604.619844]  [<ffffffff83db74ba>] schedule_timeout+0x3a/0x370
[  604.620754]  [<ffffffff81182349>] ? mark_held_locks+0xf9/0x130
[  604.621682]  [<ffffffff83dbab38>] ? down_failed+0x108/0x200
[  604.622533]  [<ffffffff83dbb7ab>] ? _raw_spin_unlock_irq+0x2b/0x80
[  604.623475]  [<ffffffff81182608>] ? trace_hardirqs_on_caller+0x128/0x160
[  604.624533]  [<ffffffff83dbab61>] down_failed+0x131/0x200
[  604.625372]  [<ffffffff81c3d6bf>] ? tty_ldisc_ref_wait+0x1f/0x50
[  604.626325]  [<ffffffff83dbacbc>] ldsem_down_read+0x8c/0x100
[  604.627239]  [<ffffffff81c3d6bf>] ? tty_ldisc_ref_wait+0x1f/0x50
[  604.628193]  [<ffffffff81185331>] ? __lock_release+0xe1/0x100
[  604.629107]  [<ffffffff81c3d6bf>] tty_ldisc_ref_wait+0x1f/0x50
[  604.630082]  [<ffffffff81c36508>] tty_write+0x98/0xf0
[  604.630856]  [<ffffffff81a38938>] ? do_raw_spin_unlock+0xc8/0xe0
[  604.631819]  [<ffffffff81c365f5>] redirected_tty_write+0x95/0xc0
[  604.632778]  [<ffffffff8128ce38>] vfs_write+0xb8/0x180
[  604.633595]  [<ffffffff8128d170>] sys_write+0x50/0xa0
[  604.634422]  [<ffffffff83dc49d8>] tracesys+0xe1/0xe6
[  604.635324] 1 lock held by trinity/9732:
[  604.635906]  #0:  (&tty->ldisc_sem){++++++}, at: [<ffffffff81c3d6bf>] tty_ldisc_ref_wait+0x1f/0x50
[  604.637466] INFO: task trinity:10089 blocked for more than 120 seconds.
[  604.638496] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  604.639675] trinity         D 00000000001d7180  5224 10089      1 0x00000000
[  604.640798]  ffff88006bb2bc28 0000000000000002 00000000001d7180 ffff8800aa09d208
[  604.641731]  ffff8800b94b3000 ffff880094303000 00000000001d7180 00000000001d7180
[  604.642769]  ffff880094303000 ffff88006bb2bfd8 00000000001d7180 00000000001d7180
[  604.643977] Call Trace:
[  604.644383]  [<ffffffff83db9909>] __schedule+0x2e9/0x3b0
[  604.645205]  [<ffffffff83db9b35>] schedule+0x55/0x60
[  604.645957]  [<ffffffff83db74ba>] schedule_timeout+0x3a/0x370
[  604.646843]  [<ffffffff81182349>] ? mark_held_locks+0xf9/0x130
[  604.647746]  [<ffffffff83dbab38>] ? down_failed+0x108/0x200
[  604.648624]  [<ffffffff83dbb7ab>] ? _raw_spin_unlock_irq+0x2b/0x80
[  604.649605]  [<ffffffff81182608>] ? trace_hardirqs_on_caller+0x128/0x160
[  604.650652]  [<ffffffff83dbab61>] down_failed+0x131/0x200
[  604.651445]  [<ffffffff81c3d6bf>] ? tty_ldisc_ref_wait+0x1f/0x50
[  604.652366]  [<ffffffff83dbacbc>] ldsem_down_read+0x8c/0x100
[  604.653267]  [<ffffffff81c3d6bf>] ? tty_ldisc_ref_wait+0x1f/0x50
[  604.654222]  [<ffffffff81185331>] ? __lock_release+0xe1/0x100
[  604.655118]  [<ffffffff81c3d6bf>] tty_ldisc_ref_wait+0x1f/0x50
[  604.656040]  [<ffffffff81c36508>] tty_write+0x98/0xf0
[  604.656848]  [<ffffffff81a38938>] ? do_raw_spin_unlock+0xc8/0xe0
[  604.657794]  [<ffffffff81c365f5>] redirected_tty_write+0x95/0xc0
[  604.658750]  [<ffffffff8128ce38>] vfs_write+0xb8/0x180
[  604.659597]  [<ffffffff8128d170>] sys_write+0x50/0xa0
[  604.660412]  [<ffffffff83dc49d8>] tracesys+0xe1/0xe6
[  604.661209] 1 lock held by trinity/10089:
[  604.661828]  #0:  (&tty->ldisc_sem){++++++}, at: [<ffffffff81c3d6bf>] tty_ldisc_ref_wait+0x1f/0x50
[  604.662732] INFO: task trinity:10254 blocked for more than 120 seconds.
[  604.663310] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  604.664504] trinity         D 00000000001d7180  5240 10254      1 0x00000000
[  604.665679]  ffff880096219c28 0000000000000002 00000000001d7180 ffff8800aa09cb78
[  604.666874]  ffff8800b94c3000 ffff8800961a8000 00000000001d7180 00000000001d7180
[  604.668060]  ffff8800961a8000 ffff880096219fd8 00000000001d7180 00000000001d7180
[  604.669320] Call Trace:
[  604.669713]  [<ffffffff83db9909>] __schedule+0x2e9/0x3b0
[  604.670542]  [<ffffffff83db9b35>] schedule+0x55/0x60
[  604.671360]  [<ffffffff83db74ba>] schedule_timeout+0x3a/0x370
[  604.672270]  [<ffffffff81182349>] ? mark_held_locks+0xf9/0x130
[  604.673161]  [<ffffffff83dbab38>] ? down_failed+0x108/0x200
[  604.674051]  [<ffffffff83dbb7ab>] ? _raw_spin_unlock_irq+0x2b/0x80
[  604.675022]  [<ffffffff81182608>] ? trace_hardirqs_on_caller+0x128/0x160
[  604.676068]  [<ffffffff83dbab61>] down_failed+0x131/0x200
[  604.676940]  [<ffffffff81c3d6bf>] ? tty_ldisc_ref_wait+0x1f/0x50
[  604.677896]  [<ffffffff83dbacbc>] ldsem_down_read+0x8c/0x100
[  604.678803]  [<ffffffff81c3d6bf>] ? tty_ldisc_ref_wait+0x1f/0x50
[  604.679760]  [<ffffffff81185331>] ? __lock_release+0xe1/0x100
[  604.680639]  [<ffffffff81c3d6bf>] tty_ldisc_ref_wait+0x1f/0x50
[  604.681485]  [<ffffffff81c36508>] tty_write+0x98/0xf0
[  604.682288]  [<ffffffff81a38938>] ? do_raw_spin_unlock+0xc8/0xe0
[  604.683246]  [<ffffffff81c365f5>] redirected_tty_write+0x95/0xc0
[  604.684206]  [<ffffffff8128ce38>] vfs_write+0xb8/0x180
[  604.685055]  [<ffffffff8128d170>] sys_write+0x50/0xa0
[  604.685858]  [<ffffffff83dc49d8>] tracesys+0xe1/0xe6
[  604.686738] 1 lock held by trinity/10254:
[  604.687366]  #0:  (&tty->ldisc_sem){++++++}, at: [<ffffffff81c3d6bf>] tty_ldisc_ref_wait+0x1f/0x50


Thanks,
Sasha


