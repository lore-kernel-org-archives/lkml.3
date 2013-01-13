Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab3AMRnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:43:12 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38229 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab3AMRnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:43:10 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
References: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
From: Alex Riesen <raa.lkml@gmail.com>
Date: Sun, 13 Jan 2013 18:42:49 +0100
Message-ID: <CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than
 120 seconds"
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 5:56 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sun, 13 Jan 2013, Alex Riesen wrote:
>>
>> Yes, almost. What about khubd hanging when machine is shutdown?
>
> What about it?  I have trouble understanding all the descriptions you
> have provided so far, because you talk about several different things
> and change your mind a lot.  Can you provide a single, simple scenario
> that illustrates this problem?

1. Compile a kernel with deadline elevator as module
2. Boot into it, make sure the elevator is selected
  (I used "elevator=deadline" in the kernel command line)
3. Insert a FAT formatted mass storage device in an USB2 port
   Observe "io scheduler deadline registered"
4. Pull the stick out, wait a moment, and either shutdown or just
   and press alt-sysrq-W:

[  158.170585] usb 1-1.2: USB disconnect, device number 3
[  158.170590] usb 1-1.2: unregistering device
[  158.170595] usb 1-1.2: unregistering interface 1-1.2:1.0
[  166.959398] SysRq : Show Blocked State
[  166.959410]   task                        PC stack   pid father
[  166.959432] khubd           D ffff880213a68000     0   513      2 0x00000000
[  166.959440]  ffff880213affa18 0000000000000046 ffff88020000006b 0000000000000
[  166.959448]  ffff880213a68000 ffff880213afffd8 ffff880213afffd8 0000000000013
[  166.959454]  ffffffff81a14400 ffff880213a68000 ffff880213aff9a8 0000000000000
[  166.959461] Call Trace:
[  166.959475]  [<ffffffff8104d763>] ? flush_work+0x6d/0x1fe
[  166.959485]  [<ffffffff8133defb>] ? scsi_remove_host+0x24/0x10e
[  166.959490]  [<ffffffff8104d6fb>] ? flush_work+0x5/0x1fe
[  166.959499]  [<ffffffff815e1dd6>] schedule+0x65/0x67
[  166.959506]  [<ffffffff815e201e>] schedule_preempt_disabled+0x18/0x24
[  166.959513]  [<ffffffff815e07e4>] mutex_lock_nested+0x181/0x2c1
[  166.959518]  [<ffffffff8133defb>] ? scsi_remove_host+0x24/0x10e
[  166.959524]  [<ffffffff8133defb>] scsi_remove_host+0x24/0x10e
[  166.959531]  [<ffffffff813910d5>] usb_stor_disconnect+0x77/0xbc
[  166.959539]  [<ffffffff81377ca3>] usb_unbind_interface+0x6c/0x14d
[  166.959548]  [<ffffffff813266fc>] __device_release_driver+0x88/0xdb
[  166.959554]  [<ffffffff81326774>] device_release_driver+0x25/0x32
[  166.959561]  [<ffffffff8132616f>] bus_remove_device+0xf5/0x10a
[  166.959567]  [<ffffffff8132413f>] device_del+0x12e/0x189
[  166.959574]  [<ffffffff81375d3a>] usb_disable_device+0xb1/0x20e
[  166.959582]  [<ffffffff8136ed8b>] usb_disconnect+0xab/0x113
[  166.959589]  [<ffffffff81370218>] hub_port_connect_change+0x1b0/0x879
[  166.959597]  [<ffffffff81370e3a>] hub_events+0x559/0x69d
[  166.959604]  [<ffffffff81370fb6>] hub_thread+0x38/0x19b
[  166.959612]  [<ffffffff81052587>] ? wake_up_bit+0x2a/0x2a
[  166.959618]  [<ffffffff81370f7e>] ? hub_events+0x69d/0x69d
[  166.959625]  [<ffffffff81051f2a>] kthread+0xd5/0xdd
[  166.959632]  [<ffffffff8105d5f6>] ? finish_task_switch+0x3f/0xf7
[  166.959641]  [<ffffffff81051e55>] ? __init_kthread_worker+0x5a/0x5a
[  166.959648]  [<ffffffff815e965c>] ret_from_fork+0x7c/0xb0
[  166.959655]  [<ffffffff81051e55>] ? __init_kthread_worker+0x5a/0x5a

This trace if from alt-sysrq-W. I can attach an image from the shutdown case,
the traces from that case are hard to save: the main storage is usually already
stopped. I believe it was the same, though.
