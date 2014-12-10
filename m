Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbaLJQNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:13:44 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42845 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaLJQNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:13:43 -0500
Message-ID: <54887134.7090306@kernel.dk>
Date: Wed, 10 Dec 2014 09:13:40 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: Fix uninitialized kobject at CPU hotplugging
References: <1418225910-22108-1-git-send-email-tiwai@suse.de>	<54886E41.4000407@kernel.dk> <s5h1to7o5ki.wl-tiwai@suse.de>
In-Reply-To: <s5h1to7o5ki.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 09:03 AM, Takashi Iwai wrote:
> At Wed, 10 Dec 2014 09:01:05 -0700,
> Jens Axboe wrote:
>>
>> On 12/10/2014 08:38 AM, Takashi Iwai wrote:
>>> When a CPU is hotplugged, the current blk-mq spews a warning like:
>>>
>>>     kobject '(null)' (ffffe8ffffc8b5d8): tried to add an uninitialized object, something is seriously wrong.
>>>     CPU: 1 PID: 1386 Comm: systemd-udevd Not tainted 3.18.0-rc7-2.g088d59b-default #1
>>>     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_171129-lamiak 04/01/2014
>>>      0000000000000000 0000000000000002 ffffffff81605f07 ffffe8ffffc8b5d8
>>>      ffffffff8132c7a0 ffff88023341d370 0000000000000020 ffff8800bb05bd58
>>>      ffff8800bb05bd08 000000000000a0a0 000000003f441940 0000000000000007
>>>     Call Trace:
>>>      [<ffffffff81005306>] dump_trace+0x86/0x330
>>>      [<ffffffff81005644>] show_stack_log_lvl+0x94/0x170
>>>      [<ffffffff81006d21>] show_stack+0x21/0x50
>>>      [<ffffffff81605f07>] dump_stack+0x41/0x51
>>>      [<ffffffff8132c7a0>] kobject_add+0xa0/0xb0
>>>      [<ffffffff8130aee1>] blk_mq_register_hctx+0x91/0xb0
>>>      [<ffffffff8130b82e>] blk_mq_sysfs_register+0x3e/0x60
>>>      [<ffffffff81309298>] blk_mq_queue_reinit_notify+0xf8/0x190
>>>      [<ffffffff8107cfdc>] notifier_call_chain+0x4c/0x70
>>>      [<ffffffff8105fd23>] cpu_notify+0x23/0x50
>>>      [<ffffffff81060037>] _cpu_up+0x157/0x170
>>>      [<ffffffff810600d9>] cpu_up+0x89/0xb0
>>>      [<ffffffff815fa5b5>] cpu_subsys_online+0x35/0x80
>>>      [<ffffffff814323cd>] device_online+0x5d/0xa0
>>>      [<ffffffff81432485>] online_store+0x75/0x80
>>>      [<ffffffff81236a5a>] kernfs_fop_write+0xda/0x150
>>>      [<ffffffff811c5532>] vfs_write+0xb2/0x1f0
>>>      [<ffffffff811c5f42>] SyS_write+0x42/0xb0
>>>      [<ffffffff8160c4ed>] system_call_fastpath+0x16/0x1b
>>>      [<00007f0132fb24e0>] 0x7f0132fb24e0
>>>
>>> This is indeed because of an uninitialized kobject for blk_mq_ctx.
>>> The blk_mq_ctx kobjects are initialized in blk_mq_sysfs_init(), but it
>>> goes loop over hctx_for_each_ctx(), i.e. it initializes only for
>>> online CPUs.  Thus, when a CPU is hotplugged, the ctx for the newly
>>> onlined CPU is registered without initialization.
>>>
>>> This patch fixes the issue by initializing the all ctx kobjects
>>> belonging to each queue.
>>
>> Thanks, this looks good. I wonder why I haven't hit this yet.
>
> Maybe you did test CPU hot removal before adding?

I've definitely tested all cases, but changes in this area may have 
happened on the side since that testing was done. In any case, the patch 
makes it saner, just initializing hw and sw ctx's separately.

-- 
Jens Axboe

