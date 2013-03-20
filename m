Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab3CTX2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:28:47 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:50120 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab3CTX2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:28:44 -0400
MIME-Version: 1.0
In-Reply-To: <514988F9.2000005@linux.vnet.ibm.com>
References: <20130319224408.GB18152@redhat.com>
	<20130320031647.GA13311@gchen.bj.intel.com>
	<514988F9.2000005@linux.vnet.ibm.com>
Date: Wed, 20 Mar 2013 16:28:43 -0700
Message-ID: <CA+8MBbKC9PJnnZPc40ema3npVBV9i6vsp5gcF6=kdmsn3s=T-Q@mail.gmail.com>
Subject: Re: [PATCH] x86/mce: Rework cmci_rediscover() to play well with CPU hotplug
From: Tony Luck <tony.luck@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Chen Gong <gong.chen@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, andi@firstfloor.org,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks lots cleaner.  Applied on top of 3.9.rc3 and took it for a spin
offlining and onlining cpus at random intervals.  First time round I
saw a few splats like the one below.  But after a reboot I can no
longer reproduce.

-Tony

INFO: task devkit-power-da:19861 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
devkit-power-da D ffff8810114cd048     0 19861      1 0x00000080
 ffff88101063b828 0000000000000082 ffff8810114cca80 ffff88101063bfd8
 ffff88101063bfd8 ffff88101063bfd8 ffff88081fa18040 ffff8810114cca80
 ffff88101063b808 ffff88080c0cf800 0000000000000000 ffff88101063b8b0
Call Trace:
 [<ffffffff815dcd39>] schedule+0x29/0x70
 [<ffffffff81478865>] usb_kill_urb+0x85/0xc0
 [<ffffffff810771f0>] ? wake_up_bit+0x40/0x40
 [<ffffffff81479b08>] usb_start_wait_urb+0xd8/0x160
 [<ffffffff81479dec>] usb_control_msg+0xcc/0x110
 [<ffffffff81479ef3>] ? usb_get_status+0x43/0xc0
 [<ffffffff81479f33>] usb_get_status+0x83/0xc0
 [<ffffffff8146e707>] ? usb_set_device_state+0x127/0x160
 [<ffffffff81471fa6>] usb_port_resume+0x2c6/0x630
 [<ffffffff810135d1>] ? __switch_to+0x181/0x4a0
 [<ffffffff81485935>] generic_resume+0x15/0x30
 [<ffffffff8147c405>] usb_resume_both+0x105/0x150
 [<ffffffff8147d8aa>] usb_runtime_resume+0x1a/0x20
 [<ffffffff813b5bd1>] __rpm_callback+0x31/0x90
 [<ffffffff813b5c5f>] rpm_callback+0x2f/0x90
 [<ffffffff813b6d5c>] rpm_resume+0x40c/0x670
 [<ffffffff810771f0>] ? wake_up_bit+0x40/0x40
 [<ffffffff813b725c>] __pm_runtime_resume+0x5c/0x90
 [<ffffffff8147cee9>] usb_autoresume_device+0x29/0x60
 [<ffffffff81482b50>] usbdev_open+0x110/0x210
 [<ffffffff8116dc4c>] chrdev_open+0x9c/0x180
 [<ffffffff811677df>] do_dentry_open+0x20f/0x2c0
 [<ffffffff8116dbb0>] ? cdev_put+0x30/0x30
 [<ffffffff811678c5>] finish_open+0x35/0x50
 [<ffffffff81177e5e>] do_last+0x6de/0xde0
 [<ffffffff811749a8>] ? inode_permission+0x18/0x50
 [<ffffffff81174a58>] ? link_path_walk+0x78/0x880
 [<ffffffff81178617>] path_openat+0xb7/0x4a0
 [<ffffffff81178cc1>] do_filp_open+0x41/0xa0
 [<ffffffff81185382>] ? __alloc_fd+0x42/0x110
 [<ffffffff81168c24>] do_sys_open+0xf4/0x1e0
 [<ffffffff81014959>] ? do_notify_resume+0x59/0x80
 [<ffffffff81168d31>] sys_open+0x21/0x30
 [<ffffffff815e6159>] system_call_fastpath+0x16/0x1b
