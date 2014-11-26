Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaKZFPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 00:15:40 -0500
Received: from senator.holtmann.net ([87.106.208.187]:53695 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaKZFPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 00:15:38 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: bluetooth related firmware loader spew on resume.
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <s5hsih7xmgg.wl-tiwai@suse.de>
Date: Wed, 26 Nov 2014 14:15:27 +0900
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        pgynther@google.com, linux-bluetooth@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D19A9DA1-3706-4351-B2E9-25D5ABA662E7@holtmann.org>
References: <20141111181228.GA27815@redhat.com> <s5hsih7xmgg.wl-tiwai@suse.de>
To: Takashi Iwai <tiwai@suse.de>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

>> Since the addition of 10d4c6736ea "Bluetooth: btusb: Add Broadcom patch
>> RAM support", I (and a number of other people[*]) have been seeing
>> this trace on resume from suspend.
>> 
>> WARNING: CPU: 1 PID: 8565 at drivers/base/firmware_class.c:1127 _request_firmware+0x4c1/0x7c0()
>> CPU: 1 PID: 8565 Comm: kworker/u17:0 Not tainted 3.17.2-200.fc20.x86_64 #1
>> Hardware name: LENOVO 2356JK8/2356JK8, BIOS G7ET94WW (2.54 ) 04/30/2013
>> Workqueue: hci0 hci_power_on [bluetooth]
>> 0000000000000000 00000000f52a564b ffff8800a8c63be8 ffffffff817271cc
>> 0000000000000000 ffff8800a8c63c20 ffffffff81094ced ffff8800a8c63d10
>> ffff8801365ddf00 ffff8801387b4b00 ffff8800a8c63d08 00000000fffffff5
>> Call Trace:
>> [<ffffffff817271cc>] dump_stack+0x45/0x56
>> [<ffffffff81094ced>] warn_slowpath_common+0x7d/0xa0
>> [<ffffffff81094e1a>] warn_slowpath_null+0x1a/0x20
>> [<ffffffff814965c1>] _request_firmware+0x4c1/0x7c0
>> [<ffffffff8137b9b9>] ? snprintf+0x49/0x70
>> [<ffffffff814968f1>] request_firmware+0x31/0x50
>> [<ffffffffa0943bf3>] btusb_setup_bcm_patchram+0x83/0x550 [btusb]
>> [<ffffffff8148ecf6>] ? rpm_idle+0xd6/0x2b0
>> [<ffffffffa0649051>] hci_dev_do_open+0xe1/0xa60 [bluetooth]
>> ACPI: \_SB_.PCI0.LPC_.EC__.BAT1: docking
>> Restarting tasks ... 
>> [<ffffffff810bcb3d>] ? ttwu_do_activate.constprop.90+0x5d/0x70
>> [<ffffffffa064a1c0>] hci_power_on+0x40/0x1e0 [bluetooth]
>> [<ffffffff810f53fb>] ? lock_timer_base.isra.34+0x2b/0x50
>> [<ffffffff810acc39>] process_one_work+0x149/0x3d0
>> [<ffffffff810ad2bb>] worker_thread+0x11b/0x490
>> [<ffffffff810ad1a0>] ? rescuer_thread+0x2e0/0x2e0
>> [<ffffffff810b2318>] kthread+0xd8/0xf0
>> [<ffffffff810b2240>] ? kthread_create_on_node+0x190/0x190
>> [<ffffffff8172e7bc>] ret_from_fork+0x7c/0xb0
>> [<ffffffff810b2240>] ? kthread_create_on_node+0x190/0x190
>> ---[ end trace 75a0e9c7f33ebb4c ]---
>> bluetooth hci0: firmware: brcm/BCM20702A0-0a5c-21e6.hcd will not be loaded
>> Bluetooth: hci0: BCM: patch brcm/BCM20702A0-0a5c-21e6.hcd not found
>> 
>> 
>> At first I thought it was just over-reaction to the file being missing, but
>> looking at the WARN_ON, it appears that we're trying to invoke the firmware
>> loader before userspace is back up ?
>> 
>> In this (and probably other related) kernel, CONFIG_FW_LOADER_USER_HELPER is unset,
>> in case that matters at all.
> 
> If it's the case where no matching firmware file is present, the patch
> below might help.  It's only compile-tested.
> 
> 
> Takashi
> 
> -- 8< --
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] btusb: Give up firmware loading once when failed
> 
> Otherwise it may trigger request_firmware() for the non-existing file
> in the resume path, resulting in a warning.  For the success paths,
> calling request_firmware() is fine, as it's cached properly at
> suspend.  The problem is only for the error paths.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
> drivers/bluetooth/btusb.c | 2 ++
> 1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index edfc17bfcd44..62d8e23fd3cb 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -1569,6 +1569,7 @@ static int btusb_setup_intel(struct hci_dev *hdev)
> 	if (!fw) {
> 		kfree_skb(skb);
> 		btusb_check_bdaddr_intel(hdev);
> +		hdev->setup = NULL;
> 		return 0;
> 	}
> 	fw_ptr = fw->data;
> @@ -1756,6 +1757,7 @@ static int btusb_setup_bcm_patchram(struct hci_dev *hdev)
> 	ret = request_firmware(&fw, fw_name, &hdev->dev);
> 	if (ret < 0) {
> 		BT_INFO("%s: BCM: patch %s not found", hdev->name, fw_name);
> +		hdev->setup = NULL;
> 		return 0;
> 	}

the hdev->setup callback is only called once for each new device found. This means that setting it back to NULL from the its own handler is not making any difference.

Also the problem is that hdev->setup is really there to load firmware. Devices might work without the firmware, but then they run off an old ROM firmware which is not a good idea in most cases. So we can not just close our eyes and hope for the best. The firmware should really be loaded.

I think the problem is that the devices physically disappear from the USB bus during suspend and will show up as a newly attached device after resume. So we have the cold plug case here. And there we need to firmware. Plain and simple. As stated above hdev->setup is only after run once. The only way to run it a second time is by unplugging and replugging the device. A BIOS that takes the power of the Bluetooth USB device is essentially simulating this behavior.

We are seeing a hci_power_on call since that is triggered exactly once when the device is plugged in. If we wanted to be super smart, then we could delay that initial call until the first userspace opens any Bluetooth socket. In theory that would work, but could be also way to complicated to realized. However it would mean the initial firmware loading and setup of the device is delayed until bluetoothd has been started. For bluetoothd this will be not a problem since it can handle hotplug of Bluetooth controllers, but for all other command line tools it might be a real problem. 

Regards

Marcel

