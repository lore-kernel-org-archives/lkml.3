Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbaHYVNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 17:13:54 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:30169 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006AbaHYVNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 17:13:52 -0400
Date: Mon, 25 Aug 2014 23:13:40 +0200
From: Sabrina Dubroca <sd@queasysnail.net>
To: Valdis.Kletnieks@vt.edu
Cc: Hugh Dickins <hughd@google.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Vincent Donnefort <vdonnefort@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: 3.17-rc1: leds blink workqueue causes sleeping BUGs
Message-ID: <20140825211340.GA22168@kria>
References: <alpine.LSU.2.11.1408161946450.1064@eggly.anvils>
 <10857.1408467967@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <10857.1408467967@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-19, 13:06:07 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Sat, 16 Aug 2014 20:27:01 -0700, Hugh Dickins said:
> > Can we safely revert your 8b37e1bef5a6 ("leds: convert blink timer to
> > workqueue"), or have there been other changes which now depend upon it?
> 
> I suspect there's something else busted.  I hand-reverted that patch, and I *still*
> see the following lockdep whine that looks related (as it talks about
> leddev_list_lock).  next-0811 was OK, looks like next-0815 and -0818 had this....

I've seen this one in linux-next too. It seems to be caused by
946a4abbcfac ("input: route kbd LEDs through the generic LEDs layer")

I had a look at the code, led_trigger_event calls vt_led_set, which
calls led_trigger_event again.

CC'ing Samuel Thibault, the author of the commit.


> 
> [    2.473044] iTCO_vendor_support: vendor-support=0
> [    2.473122] device-mapper: uevent: version 1.0.3
> 
> [    2.473145] =============================================
> [    2.473177] [ INFO: possible recursive locking detected ]
> [    2.473204] 3.17.0-rc1-next-20140818-dirty #274 Not tainted
> [    2.473231] ---------------------------------------------
> [    2.473258] kworker/3:0/25 is trying to acquire lock:
> [    2.473283]  (&trig->leddev_list_lock){.+.?..}, at: [<ffffffff9344da1b>] led_trigger_event+0x26/0x69
> [    2.473341]
> but task is already holding lock:
> [    2.473370]  (&trig->leddev_list_lock){.+.?..}, at: [<ffffffff9344da1b>] led_trigger_event+0x26/0x69
> [    2.473425]
> other info that might help us debug this:
> [    2.473456]  Possible unsafe locking scenario:
> 
> [    2.473485]        CPU0
> [    2.473498]        ----
> [    2.473511]   lock(&trig->leddev_list_lock);
> [    2.473538]   lock(&trig->leddev_list_lock);
> [    2.473565]
>  *** DEADLOCK ***
> 
> [    2.473594]  May be due to missing lock nesting notation
> 
> [    2.473626] 11 locks held by kworker/3:0/25:
> [    2.473648]  #0:  ("events_long"){.+.+.+}, at: [<ffffffff93054594>] process_one_work+0x1e9/0x4ad
> [    2.473704]  #1:  (serio_event_work){+.+.+.}, at: [<ffffffff93054594>] process_one_work+0x1e9/0x4ad
> [    2.473760]  #2:  (serio_mutex){+.+.+.}, at: [<ffffffff933dd7f0>] serio_handle_event+0x19/0x19c
> [    2.473816]  #3:  (&dev->mutex){......}, at: [<ffffffff9332cec3>] __driver_attach+0x2f/0x7e
> [    2.473869]  #4:  (&dev->mutex){......}, at: [<ffffffff9332cedb>] __driver_attach+0x47/0x7e
> [    2.473922]  #5:  (&serio->drv_mutex){+.+.+.}, at: [<ffffffff933dca77>] serio_connect_driver+0x21/0x42
> [    2.473980]  #6:  (input_mutex){+.+.+.}, at: [<ffffffff933e183a>] input_register_device+0x2a9/0x381
> [    2.474036]  #7:  (vt_led_registered_lock){+.+.+.}, at: [<ffffffff933e3846>] input_led_connect+0x49/0x1cd
> [    2.474095]  #8:  (triggers_list_lock){++++.+}, at: [<ffffffff9344dd91>] led_trigger_set_default+0x27/0x87
> [    2.474154]  #9:  (&led_cdev->trigger_lock){+.+.+.}, at: [<ffffffff9344dd99>] led_trigger_set_default+0x2f/0x87
> [    2.474214]  #10:  (&trig->leddev_list_lock){.+.?..}, at: [<ffffffff9344da1b>] led_trigger_event+0x26/0x69
> [    2.474274]
> stack backtrace:
> [    2.474297] CPU: 3 PID: 25 Comm: kworker/3:0 Not tainted 3.17.0-rc1-next-20140818-dirty #274
> [    2.474338] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A15 06/20/2014
> [    2.474374] Workqueue: events_long serio_handle_event
> [    2.474401]  0000000000000000 ffff880224ceb960 ffffffff9368ba02 ffffffff945ff130
> [    2.474447]  ffffffff945ff130 ffff880224ceba20 ffffffff9307b730 0000000a00000246
> [    2.474492]  0000000000000000 ffffffff945ff130 ffffffff00000003 23605381dcae248d
> [    2.474538] Call Trace:
> [    2.474554]  [<ffffffff9368ba02>] dump_stack+0x51/0xaa
> [    2.474581]  [<ffffffff9307b730>] __lock_acquire+0xd22/0xed1
> [    2.474611]  [<ffffffff9307b09a>] ? __lock_acquire+0x68c/0xed1
> [    2.474641]  [<ffffffff9344da1b>] ? led_trigger_event+0x26/0x69
> [    2.474671]  [<ffffffff9307bc64>] lock_acquire+0xdd/0x16a
> [    2.474699]  [<ffffffff9307bc64>] ? lock_acquire+0xdd/0x16a
> [    2.474727]  [<ffffffff9344da1b>] ? led_trigger_event+0x26/0x69
> [    2.474758]  [<ffffffff93696391>] _raw_read_lock+0x30/0x3f
> [    2.474786]  [<ffffffff9344da1b>] ? led_trigger_event+0x26/0x69
> [    2.474816]  [<ffffffff9344da1b>] led_trigger_event+0x26/0x69
> [    2.474846]  [<ffffffff933e3751>] vt_led_set+0x32/0x34
> [    2.474873]  [<ffffffff9344d312>] __led_set_brightness+0x1b/0x1d
> [    2.474904]  [<ffffffff9344d4a8>] led_set_brightness+0x37/0x39
> [    2.474934]  [<ffffffff9344da3d>] led_trigger_event+0x48/0x69
> [    2.474965]  [<ffffffff9330b7fb>] kbd_ledstate_trigger_activate+0x47/0x4f
> [    2.474999]  [<ffffffff9344dbda>] led_trigger_set+0xfd/0x139
> [    2.475028]  [<ffffffff9344ddcc>] led_trigger_set_default+0x62/0x87
> [    2.475061]  [<ffffffff9344d87e>] led_classdev_register+0x139/0x144
> [    2.475093]  [<ffffffff933e3887>] input_led_connect+0x8a/0x1cd
> [    2.475123]  [<ffffffff933e1901>] input_register_device+0x370/0x381
> [    2.475154]  [<ffffffff933e848f>] atkbd_connect+0x216/0x269
> [    2.475182]  [<ffffffff933dca82>] serio_connect_driver+0x2c/0x42
> [    2.475213]  [<ffffffff933dcab3>] serio_driver_probe+0x1b/0x1d
> [    2.476508]  [<ffffffff9332cd33>] driver_probe_device+0xda/0x203
> [    2.477797]  [<ffffffff9332cef0>] __driver_attach+0x5c/0x7e
> [    2.479081]  [<ffffffff9332ce94>] ? __device_attach+0x38/0x38
> [    2.480328]  [<ffffffff9332b3bb>] bus_for_each_dev+0x6a/0x82
> [    2.481604]  [<ffffffff9332c87d>] driver_attach+0x19/0x1b
> [    2.482874]  [<ffffffff933dd92d>] serio_handle_event+0x156/0x19c
> [    2.483387] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    2.485373]  [<ffffffff93054636>] process_one_work+0x28b/0x4ad
> [    2.485976] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
> [    2.485979] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
> [    2.485982] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
> [    2.486523] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
> [    2.489121] ata1.00: ATA-8: ST500LX003-1AC15G, DEM4, max UDMA/133
> [    2.489123] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [    2.492676] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
> [    2.492678] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
> [    2.492681] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
> [    2.493213] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
> [    2.495797] ata1.00: configured for UDMA/133
> [    2.497541] scsi 0:0:0:0: Direct-Access     ATA      ST500LX003-1AC15 DEM4 PQ: 0 ANSI: 5
> [    2.498023] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> [    2.498026] sd 0:0:0:0: [sda] 4096-byte physical blocks
> [    2.498169] sd 0:0:0:0: [sda] Write Protect is off
> [    2.498172] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    2.498231] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    2.505326]  sda: sda1 sda2 sda3
> [    2.506172] sd 0:0:0:0: [sda] Attached SCSI disk
> [    2.511495]  [<ffffffff93054bd3>] worker_thread+0x351/0x46a
> [    2.512855]  [<ffffffff93054882>] ? process_scheduled_works+0x2a/0x2a
> [    2.514195]  [<ffffffff9305967e>] kthread+0xd6/0xde
> [    2.515521]  [<ffffffff930595a8>] ? __kthread_parkme+0x62/0x62
> [    2.516814]  [<ffffffff93696dac>] ret_from_fork+0x7c/0xb0
> [    2.518095]  [<ffffffff930595a8>] ? __kthread_parkme+0x62/0x62
> [    2.519527] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
> [    2.520836] Intel P-state driver initializing.
> 
> (Looks like the lockdep output got intermixed with ata spinning up my disk)


-- 
Sabrina
