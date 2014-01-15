Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaAONLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:11:30 -0500
Received: from ns.iliad.fr ([212.27.33.1]:55253 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbaAONL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:11:28 -0500
Message-ID: <52D688FE.2030908@freebox.fr>
Date: Wed, 15 Jan 2014 14:11:26 +0100
From: Nicolas Schichan <nschichan@freebox.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
Subject: Re: livelock during MD device open
References: <52D57086.1000508@freebox.fr> <20140115125740.160e8998@notabene.brown>
In-Reply-To: <20140115125740.160e8998@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 02:57 AM, NeilBrown wrote:
[...]
> That's a very small race you are consistently losing - if I understand
> correctly.
>
> In __blkdev_get:
>
>   restart:
>
> 	ret = -ENXIO;
> 	disk = get_gendisk(bdev->bd_dev, &partno);
> 	if (!disk)
> 		goto out;
> 	owner = disk->fops->owner;
>
> 	disk_block_events(disk);
> 	mutex_lock_nested(&bdev->bd_mutex, for_part);
>
>
> The "get_gendisk" calls into md_alloc (via md_probe) and then add_disk(),
> which generates a uevent which is handled by udev.
> And before the above code gets to the mutex_lock_nexted(), the process run by
> udev must have opened the device (executing all that code above and more) and
> issued the ioctl.
>
> I guess it is possible, but happening every time to produce a live-lock
> suggests that the scheduler must be encouraging that behaviour.  Presumably
> this is a virtual machine with just one CPU ??

add_disk() will call schedule via call_usermode_helper() (for /sbin/hotplug), 
the scheduler will, I think, almost always choose to schedule the "udev" 
process instead of the process which did the first open to the md device, once 
the usermode helper has run.

SysRq + 'w' consistently showed a process that had called schedule() from 
md_alloc() -> add_disk() ... -> call_usermodehelper():


[   57.932671] test            D 805ac41c     0   748    745 0x00000000
[   57.939075] [<805ac41c>] (__schedule+0x33c/0x3b0) from [<805aa8f0>] 
(schedule_timeout+0x18/0x168)
[   57.947984] [<805aa8f0>] (schedule_timeout+0x18/0x168) from [<805abfa4>] 
(wait_for_common+0xf0/0x198)
[   57.957245] [<805abfa4>] (wait_for_common+0xf0/0x198) from [<80029e30>] 
(call_usermodehelper_exec+0xf8/0x15c)
[   57.967205] [<80029e30>] (call_usermodehelper_exec+0xf8/0x15c) from 
[<8028abd0>] (kobject_uevent_env+0x37c/0x3e8)
[   57.977515] [<8028abd0>] (kobject_uevent_env+0x37c/0x3e8) from [<8027cff8>] 
(add_disk+0x29c/0x400)
[   57.986520] [<8027cff8>] (add_disk+0x29c/0x400) from [<803bbcac>] 
(md_alloc+0x1cc/0x2cc)
[   57.994645] [<803bbcac>] (md_alloc+0x1cc/0x2cc) from [<803bbe38>] 
(md_probe+0xc/0x14)
[   58.002511] [<803bbe38>] (md_probe+0xc/0x14) from [<802ede10>] 
(kobj_lookup+0xd8/0x110)
[   58.010550] [<802ede10>] (kobj_lookup+0xd8/0x110) from [<8027cacc>] 
(get_gendisk+0x2c/0xe0)
[   58.018942] [<8027cacc>] (get_gendisk+0x2c/0xe0) from [<800c0598>] 
(__blkdev_get+0x28/0x364)
[   58.027416] [<800c0598>] (__blkdev_get+0x28/0x364) from [<800c0ab0>] 
(blkdev_get+0x1dc/0x318)
[   58.035983] [<800c0ab0>] (blkdev_get+0x1dc/0x318) from [<800918bc>] 
(do_dentry_open.isra.15+0x184/0x248)
[   58.045510] [<800918bc>] (do_dentry_open.isra.15+0x184/0x248) from 
[<800919a4>] (finish_open+0x24/0x38)
[   58.054945] [<800919a4>] (finish_open+0x24/0x38) from [<8009fb40>] 
(do_last+0x9a8/0xc08)
[   58.063071] [<8009fb40>] (do_last+0x9a8/0xc08) from [<8009ffdc>] 
(path_openat+0x23c/0x5c8)
[   58.071371] [<8009ffdc>] (path_openat+0x23c/0x5c8) from [<800a0620>] 
(do_filp_open+0x2c/0x78)
[   58.079935] [<800a0620>] (do_filp_open+0x2c/0x78) from [<800929b4>] 
(do_sys_open+0x124/0x1c4)
[   58.088498] [<800929b4>] (do_sys_open+0x124/0x1c4) from [<80009060>] 
(ret_fast_syscall+0x0/0x2c)

The system showing the livelock is a Marvell 88F6282 CPU (single core processor).

It took me some time start to suspect the problem was due to the md_ioctl() 
code :)

> I suppose the best fix is, as you suggest, to avoid clearing hold_active for
> invalid ioctls.  It feels a bit like papering over a bug, but I think the
> only way to really fix it is to add extra locking to the above code sequence
> and I don't want to do that.
>
> Of your two suggestions I much prefer the second.  It will be more code, but
> it is also more obviously correct.  The current code is rather messy with
> respect to invalid ioctl commands.
>
> I would be happy to accept a patch which aborted md_ioctl if the cmd wasn't
> one of those known to md.

I'll send a patch for that then.

Regards,


-- 
Nicolas Schichan
Freebox SAS
