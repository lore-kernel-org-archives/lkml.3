Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab3BWPZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 10:25:13 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:34208 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759038Ab3BWPZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 10:25:08 -0500
Message-ID: <5128DF40.7030003@gmail.com>
Date: Sat, 23 Feb 2013 10:24:48 -0500
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
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>  <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>  <51261E30.9040907@gmail.com> <1361453910.10685.7.camel@thor.lan> <1361558250.14402.6.camel@thor.lan>
In-Reply-To: <1361558250.14402.6.camel@thor.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 01:37 PM, Peter Hurley wrote:
> On Thu, 2013-02-21 at 08:38 -0500, Peter Hurley wrote:
>> On Thu, 2013-02-21 at 08:16 -0500, Sasha Levin wrote:
>>> On 02/20/2013 03:02 PM, Peter Hurley wrote:
>>>> Sasha and Dave, my trinity testbeds die in other areas right now;
>>>> I would really appreciate if you would please re-test this series.
>>>
>>> Hi Peter,
>>>
>>> I saw this twice in overnight fuzzing:
>>>
>>> [ 1473.912280] =================================
>>> [ 1473.913180] [ BUG: bad contention detected! ]
>>> [ 1473.914071] 3.8.0-next-20130220-sasha-00038-g1ad55df-dirty #8 Tainted: G        W
>>> [ 1473.915684] ---------------------------------
>>> [ 1473.916549] kworker/1:1/361 is trying to contend lock (&tty->ldisc_sem) at:
>>> [ 1473.918031] [<ffffffff81c493df>] tty_ldisc_ref+0x1f/0x60
>>> [ 1473.919060] but there are no locks held!
>>
>> Ahh, of course. That explains why the rwsem trylock doesn't track lock
>> stats -- because by the time lock_contended() is called, up_write()
>> could have just called lockdep_release(), so that it appears as if the
>> lock has been released when in fact it has not but is about to.
>>
>> I'll just remove the lock contention test from the trylocks.
> 
> Hi Sasha,
> 
> Sorry for the delay. I was actually looking into if I could tickle
> lockdep into just recording the lock contention without testing, but
> unfortunately, changes to where lockdep stores the contention now
> requires the lockdep state to have an existing owner.
> 
> So here's the trivial patch:

Hi Peter,

After more fuzzing, I'm seeing this sort of hangs (which are new):

[ 2644.723879] INFO: task trinity:17893 blocked for more than 120 seconds.
[ 2644.727112] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2644.731916] trinity         D ffff8800a9c904a8  5192 17893   8043 0x00000000
[ 2644.733517]  ffff88006efb3a78 0000000000000002 ffff8800aa0c3b10 ffff8800bb3d7180
[ 2644.739350]  ffff880019103000 ffff880097a78000 ffff88006efb3a78 00000000001d7180
[ 2644.741459]  ffff880097a78000 ffff88006efb3fd8 00000000001d7180 00000000001d7180
[ 2644.746590] Call Trace:
[ 2644.747177]  [<ffffffff83db9909>] __schedule+0x2e9/0x3b0
[ 2644.748294]  [<ffffffff83db9b35>] schedule+0x55/0x60
[ 2644.752382]  [<ffffffff83db9e83>] schedule_preempt_disabled+0x13/0x20
[ 2644.753737]  [<ffffffff83db7fdd>] __mutex_lock_common+0x34d/0x560
[ 2644.759037]  [<ffffffff81c40893>] ? ptmx_open+0x83/0x190
[ 2644.760590]  [<ffffffff83db84b5>] ? __mutex_unlock_slowpath+0x185/0x1e0
[ 2644.762064]  [<ffffffff81c40893>] ? ptmx_open+0x83/0x190
[ 2644.768967]  [<ffffffff83db831f>] mutex_lock_nested+0x3f/0x50
[ 2644.770314]  [<ffffffff81c40893>] ptmx_open+0x83/0x190
[ 2644.771413]  [<ffffffff812917ae>] chrdev_open+0x11e/0x190
[ 2644.780456]  [<ffffffff81291690>] ? cdev_put+0x30/0x30
[ 2644.781421]  [<ffffffff8128af59>] do_dentry_open+0x1f9/0x310
[ 2644.785550]  [<ffffffff8128b0bc>] finish_open+0x4c/0x70
[ 2644.786724]  [<ffffffff8129c3eb>] do_last+0x61b/0x810
[ 2644.787676]  [<ffffffff8129c699>] path_openat+0xb9/0x4d0
[ 2644.791868]  [<ffffffff812ac278>] ? __alloc_fd+0x1e8/0x200
[ 2644.792817]  [<ffffffff81185214>] ? lock_release_nested+0xb4/0xf0
[ 2644.794010]  [<ffffffff81185331>] ? __lock_release+0xe1/0x100
[ 2644.797401]  [<ffffffff8129cebd>] do_filp_open+0x3d/0xa0
[ 2644.798467]  [<ffffffff812ac278>] ? __alloc_fd+0x1e8/0x200
[ 2644.799577]  [<ffffffff8128c51b>] do_sys_open+0x12b/0x1d0
[ 2644.804667]  [<ffffffff8128c5dc>] sys_open+0x1c/0x20
[ 2644.805542]  [<ffffffff83dc49d8>] tracesys+0xe1/0xe6
[ 2644.822807] 1 lock held by trinity/17893:
[ 2644.823685]  #0:  (tty_mutex){+.+.+.}, at: [<ffffffff81c40893>] ptmx_open+0x83/0x190

The mutex is 'tty_mutex' at drivers/tty/pty.c:701 .

I didn't grab sysrq-t this time since it was an overnight run, but I'll
try to grab one when it happens again.


Thanks,
Sasha
