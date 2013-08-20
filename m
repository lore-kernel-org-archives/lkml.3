Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200Ab3HTKOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:14:45 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:55794 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3HTKOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:14:42 -0400
From: Peter Wu <lekensteyn@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] writeback: fix NULL dereference when device is gone
Date: Tue, 20 Aug 2013 12:13:58 +0200
Message-ID: <1755678.6GItDDY0bW@al>
User-Agent: KMail/4.11 (Linux/3.11.0-1-custom; KDE/4.11.0; x86_64; ; )
In-Reply-To: <20130819230240.GA6869@mtj.dyndns.org>
References: <Pine.LNX.4.44L0.1308172104070.7744-100000@netrider.rowland.org> <5177367.3UXkd1Z6lS@al> <20130819230240.GA6869@mtj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 August 2013 19:02:40 Tejun Heo wrote:
> On Tue, Aug 20, 2013 at 12:45:53AM +0200, Peter Wu wrote:
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 68851ff..6e38a8b 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -1007,7 +1007,8 @@ void bdi_writeback_workfn(struct work_struct *work)
> > 
> >  	struct backing_dev_info *bdi = wb->bdi;
> >  	long pages_written;
> > 
> > -	set_worker_desc("flush-%s", dev_name(bdi->dev));
> > +	if (bdi->dev)
> > +		set_worker_desc("flush-%s", dev_name(bdi->dev));
> 
> Hmmm... bdi->dev is cleared after bdi_wb_shutdown() so the work item
> should no longer be running.  It seems like something is queueing the
> work item after shutdown and the proper fix would be finding out which
> and fixing it.  Can you please verify whether adding
> WARN_ON(!bdi->dev) in bdi_wakeup_thread_delayed() trigger anything?

Initially I did not get any warnings, so I added more. The patch (on top of
v3.11-rc6-27-g94fc5d9 plus some unrelated r8169 patches):

---8<---
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 68851ff..64a4cf9 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1007,7 +1007,9 @@ void bdi_writeback_workfn(struct work_struct *work)
 	struct backing_dev_info *bdi = wb->bdi;
 	long pages_written;
 
-	set_worker_desc("flush-%s", dev_name(bdi->dev));
+	WARN_ON(!bdi->dev);
+	if (bdi->dev)
+		set_worker_desc("flush-%s", dev_name(bdi->dev));
 	current->flags |= PF_SWAPWRITE;
 
 	if (likely(!current_is_workqueue_rescuer() ||
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index e04454c..6f754ed 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -290,6 +290,7 @@ void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
 {
 	unsigned long timeout;
 
+	WARN_ON(!bdi->dev);
 	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
 	mod_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
 }
@@ -362,6 +363,7 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	 * @bdi->bdi_list is empty telling bdi_Writeback_workfn() that @bdi
 	 * is dying and its work_list needs to be drained no matter what.
 	 */
+	WARN_ON(!bdi->dev);
 	mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
 	flush_delayed_work(&bdi->wb.dwork);
 	WARN_ON(!list_empty(&bdi->work_list));
@@ -406,6 +408,10 @@ void bdi_unregister(struct backing_dev_info *bdi)
 		spin_unlock_bh(&bdi->wb_lock);
 
 		device_unregister(dev);
+		if (delayed_work_pending(&bdi->wb.dwork))
+			WARN(1, "bdi->dwork is pending!");
+		else
+			WARN(1, "in bdi_unregister");
 	}
 }
 EXPORT_SYMBOL(bdi_unregister);
--->8---

In order to reproduce, I used the command:

    sudo dd if=/dev/zero of=/dev/sdc bs=1M count=300 &
    sleep .1 && sudo tee /sys/bus/usb/devices/6-2/remove <<<1

=== serial console ===
[  196.186205] usb 6-2: new SuperSpeed USB device number 2 using xhci_hcd
[  196.208702] usb 6-2: Parent hub missing LPM exit latency info.  Power management will be impacted.
[  196.221963] usb 6-2: New USB device found, idVendor=1058, idProduct=0748
[  196.228662] usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=5
[  196.235791] usb 6-2: Product: My Passport 0748
[  196.240234] usb 6-2: Manufacturer: Western Digital
[  196.245025] usb 6-2: SerialNumber: 575842314133334E35383439
[  196.252492] usb-storage 6-2:1.0: USB Mass Storage device detected
[  196.258827] scsi13 : usb-storage 6-2:1.0
[  197.263013] scsi 13:0:0:0: Direct-Access     WD       My Passport 0748 1022 PQ: 0 ANSI: 6
[  197.271459] scsi 13:0:0:1: Enclosure         WD       SES Device       1022 PQ: 0 ANSI: 6
[  197.279981] sd 13:0:0:0: Attached scsi generic sg3 type 0
[  197.280207] sd 13:0:0:0: [sdc] 1953458176 512-byte logical blocks: (1.00 TB/931 GiB)
[  197.280668] sd 13:0:0:0: [sdc] Write Protect is off
[  197.280670] sd 13:0:0:0: [sdc] Mode Sense: 47 00 10 08
[  197.281340] sd 13:0:0:0: [sdc] No Caching mode page present
[  197.281341] sd 13:0:0:0: [sdc] Assuming drive cache: write through
[  197.283092] sd 13:0:0:0: [sdc] No Caching mode page present
[  197.283093] sd 13:0:0:0: [sdc] Assuming drive cache: write through
[  197.283318]  sdc: unknown partition table
[  197.330898] scsi 13:0:0:1: Attached scsi generic sg4 type 13
[  197.338824] sd 13:0:0:0: [sdc] No Caching mode page present
[  197.344449] sd 13:0:0:0: [sdc] Assuming drive cache: write through
[  197.350647] sd 13:0:0:0: [sdc] Attached SCSI disk
[  245.972280] ------------[ cut here ]------------
[  245.976904] WARNING: CPU: 3 PID: 2605 at /home/pc/Linux-src/linux/mm/backing-dev.c:414 bdi_unregister+0x107/0x1c0()
[  245.978167] ------------[ cut here ]------------
[  245.978170] WARNING: CPU: 1 PID: 2608 at /home/pc/Linux-src/linux/mm/backing-dev.c:293 bdi_wakeup_thread_delayed+0x5e/0x60()
[  245.978189] Modules linked in: kvm_intel kvm dm_crypt binfmt_misc joydev snd_hda_codec_hdmi snd_hda_codec_realtek hid_logitech_dj hid_generic mxm_wmi nls_iso8859_1 snd_hda_intel snd_hda_codec usbhid hid snd_hwdep psmouse usb_storage snd_pcm serio_raw lpc_ich snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd wmi it87 mac_hid hwmon_vid coretemp soundcore snd_page_alloc r8169 eeprom_93cx6 mii pci_stub ahci libahci i915 drm_kms_helper drm video i2c_algo_bit
[  245.978191] CPU: 1 PID: 2608 Comm: ata_id Tainted: G        W    3.11.0-rc6-usbdbg-00030-g693d742-dirty #1
[  245.978192] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[  245.978194]  0000000000000125 ffff8805d3a4fa98 ffffffff8165986e 00000000000060d0
[  245.978196]  0000000000000000 ffff8805d3a4fad8 ffffffff81047acc ffff880602f6beb8
[  245.978197]  ffff8805fc024618 ffff880602f6be30 ffffffff81c58f80 ffff880602f6beb8
[  245.978198] Call Trace:
[  245.978202]  [<ffffffff8165986e>] dump_stack+0x55/0x76
[  245.978204]  [<ffffffff81047acc>] warn_slowpath_common+0x8c/0xc0
[  245.978206]  [<ffffffff81047b1a>] warn_slowpath_null+0x1a/0x20
[  245.978207]  [<ffffffff811424fe>] bdi_wakeup_thread_delayed+0x5e/0x60
[  245.978211]  [<ffffffff811bdc71>] bdev_inode_switch_bdi+0xf1/0x160
[  245.978212]  [<ffffffff811bedd2>] __blkdev_get+0x372/0x4d0
[  245.978214]  [<ffffffff811bf310>] ? blkdev_get_by_dev+0x60/0x60
[  245.978216]  [<ffffffff811bf115>] blkdev_get+0x1e5/0x380
[  245.978218]  [<ffffffff8166551b>] ? _raw_spin_unlock+0x2b/0x50
[  245.978219]  [<ffffffff811bf310>] ? blkdev_get_by_dev+0x60/0x60
[  245.978221]  [<ffffffff811bf36f>] blkdev_open+0x5f/0x90
[  245.978223]  [<ffffffff81180cd6>] do_dentry_open+0x226/0x2a0
[  245.978225]  [<ffffffff81180fa5>] finish_open+0x35/0x50
[  245.978227]  [<ffffffff81192d9e>] do_last+0x48e/0x7a0
[  245.978229]  [<ffffffff81193174>] path_openat+0xc4/0x4e0
[  245.978230]  [<ffffffff81193d83>] do_filp_open+0x43/0xa0
[  245.978232]  [<ffffffff811a14a7>] ? __alloc_fd+0xa7/0x130
[  245.978234]  [<ffffffff81182422>] do_sys_open+0x132/0x220
[  245.978236]  [<ffffffff8118252e>] SyS_open+0x1e/0x20
[  245.978238]  [<ffffffff8166e802>] system_call_fastpath+0x16/0x1b
[  245.978239] ---[ end trace 04d4f07eb5cc8c11 ]---
[  245.979484] ------------[ cut here ]------------
[  245.979487] WARNING: CPU: 1 PID: 2609 at /home/pc/Linux-src/linux/mm/backing-dev.c:293 bdi_wakeup_thread_delayed+0x5e/0x60()
[  245.979500] Modules linked in: kvm_intel kvm dm_crypt binfmt_misc joydev snd_hda_codec_hdmi snd_hda_codec_realtek hid_logitech_dj hid_generic mxm_wmi nls_iso8859_1 snd_hda_intel snd_hda_codec usbhid hid snd_hwdep psmouse usb_storage snd_pcm serio_raw lpc_ich snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd wmi it87 mac_hid hwmon_vid coretemp soundcore snd_page_alloc r8169 eeprom_93cx6 mii pci_stub ahci libahci i915 drm_kms_helper drm video i2c_algo_bit
[  245.979502] CPU: 1 PID: 2609 Comm: scsi_id Tainted: G        W    3.11.0-rc6-usbdbg-00030-g693d742-dirty #1
[  245.979502] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[  245.979504]  0000000000000125 ffff8805d391fa98 ffffffff8165986e 000000000000613d
[  245.979506]  0000000000000000 ffff8805d391fad8 ffffffff81047acc ffff880602f6beb8
[  245.979507]  ffff8805fc024618 ffff880602f6be30 ffffffff81c58f80 ffff880602f6beb8
[  245.979507] Call Trace:
[  245.979510]  [<ffffffff8165986e>] dump_stack+0x55/0x76
[  245.979512]  [<ffffffff81047acc>] warn_slowpath_common+0x8c/0xc0
[  245.979513]  [<ffffffff81047b1a>] warn_slowpath_null+0x1a/0x20
[  245.979515]  [<ffffffff811424fe>] bdi_wakeup_thread_delayed+0x5e/0x60
[  245.979516]  [<ffffffff811bdc71>] bdev_inode_switch_bdi+0xf1/0x160
[  245.979518]  [<ffffffff811bedd2>] __blkdev_get+0x372/0x4d0
[  245.979520]  [<ffffffff811bf310>] ? blkdev_get_by_dev+0x60/0x60
[  245.979522]  [<ffffffff811bf115>] blkdev_get+0x1e5/0x380
[  245.979523]  [<ffffffff8166551b>] ? _raw_spin_unlock+0x2b/0x50
[  245.979525]  [<ffffffff811bf310>] ? blkdev_get_by_dev+0x60/0x60
[  245.979527]  [<ffffffff811bf36f>] blkdev_open+0x5f/0x90
[  245.979528]  [<ffffffff81180cd6>] do_dentry_open+0x226/0x2a0
[  245.979530]  [<ffffffff81180fa5>] finish_open+0x35/0x50
[  245.979531]  [<ffffffff81192d9e>] do_last+0x48e/0x7a0
[  245.979533]  [<ffffffff81193174>] path_openat+0xc4/0x4e0
[  245.979534]  [<ffffffff81193d83>] do_filp_open+0x43/0xa0
[  245.979536]  [<ffffffff811a14a7>] ? __alloc_fd+0xa7/0x130
[  245.979537]  [<ffffffff81182422>] do_sys_open+0x132/0x220
[  245.979539]  [<ffffffff8118252e>] SyS_open+0x1e/0x20
[  245.979541]  [<ffffffff8166e802>] system_call_fastpath+0x16/0x1b
[  245.979542] ---[ end trace 04d4f07eb5cc8c12 ]---
[  245.980314] ------------[ cut here ]------------
[  245.980317] WARNING: CPU: 2 PID: 2610 at /home/pc/Linux-src/linux/mm/backing-dev.c:293 bdi_wakeup_thread_delayed+0x5e/0x60()
[  245.980330] Modules linked in: kvm_intel kvm dm_crypt binfmt_misc joydev snd_hda_codec_hdmi snd_hda_codec_realtek hid_logitech_dj hid_generic mxm_wmi nls_iso8859_1 snd_hda_intel snd_hda_codec usbhid hid snd_hwdep psmouse usb_storage snd_pcm serio_raw lpc_ich snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd wmi it87 mac_hid hwmon_vid coretemp soundcore snd_page_alloc r8169 eeprom_93cx6 mii pci_stub ahci libahci i915 drm_kms_helper drm video i2c_algo_bit
[  245.980331] CPU: 2 PID: 2610 Comm: blkid Tainted: G        W    3.11.0-rc6-usbdbg-00030-g693d742-dirty #1
[  245.980332] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[  245.980334]  0000000000000125 ffff8805d6e93a98 ffffffff8165986e 00000000000061aa
[  245.980335]  0000000000000000 ffff8805d6e93ad8 ffffffff81047acc ffff880602f6beb8
[  245.980337]  ffff8805fc024618 ffff880602f6be30 ffffffff81c58f80 ffff880602f6beb8
[  245.980337] Call Trace:
[  245.980339]  [<ffffffff8165986e>] dump_stack+0x55/0x76
[  245.980341]  [<ffffffff81047acc>] warn_slowpath_common+0x8c/0xc0
[  245.980343]  [<ffffffff81047b1a>] warn_slowpath_null+0x1a/0x20
[  245.980344]  [<ffffffff811424fe>] bdi_wakeup_thread_delayed+0x5e/0x60
[  245.980346]  [<ffffffff811bdc71>] bdev_inode_switch_bdi+0xf1/0x160
[  245.980348]  [<ffffffff811bedd2>] __blkdev_get+0x372/0x4d0
[  245.980349]  [<ffffffff811bf310>] ? blkdev_get_by_dev+0x60/0x60
[  245.980351]  [<ffffffff811bf115>] blkdev_get+0x1e5/0x380
[  245.980352]  [<ffffffff8166551b>] ? _raw_spin_unlock+0x2b/0x50
[  245.980354]  [<ffffffff811bf310>] ? blkdev_get_by_dev+0x60/0x60
[  245.980356]  [<ffffffff811bf36f>] blkdev_open+0x5f/0x90
[  245.980357]  [<ffffffff81180cd6>] do_dentry_open+0x226/0x2a0
[  245.980359]  [<ffffffff81180fa5>] finish_open+0x35/0x50
[  245.980360]  [<ffffffff81192d9e>] do_last+0x48e/0x7a0
[  245.980362]  [<ffffffff81193174>] path_openat+0xc4/0x4e0
[  245.980363]  [<ffffffff81193d83>] do_filp_open+0x43/0xa0
[  245.980365]  [<ffffffff811a14a7>] ? __alloc_fd+0xa7/0x130
[  245.980366]  [<ffffffff81182422>] do_sys_open+0x132/0x220
[  245.980368]  [<ffffffff8118252e>] SyS_open+0x1e/0x20
[  245.980369]  [<ffffffff8166e802>] system_call_fastpath+0x16/0x1b
[  245.980370] ---[ end trace 04d4f07eb5cc8c13 ]---
[  245.981935] ------------[ cut here ]------------
[  245.981938] WARNING: CPU: 2 PID: 2611 at /home/pc/Linux-src/linux/mm/backing-dev.c:293 bdi_wakeup_thread_delayed+0x5e/0x60()
[  245.981951] Modules linked in: kvm_intel kvm dm_crypt binfmt_misc joydev snd_hda_codec_hdmi snd_hda_codec_realtek hid_logitech_dj hid_generic mxm_wmi nls_iso8859_1 snd_hda_intel snd_hda_codec usbhid hid snd_hwdep psmouse usb_storage snd_pcm serio_raw lpc_ich snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd wmi it87 mac_hid hwmon_vid coretemp soundcore snd_page_alloc r8169 eeprom_93cx6 mii pci_stub ahci libahci i915 drm_kms_helper drm video i2c_algo_bit
[  245.981952] CPU: 2 PID: 2611 Comm: udisks-part-id Tainted: G        W    3.11.0-rc6-usbdbg-00030-g693d742-dirty #1
[  245.981953] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[  245.981955]  0000000000000125 ffff8805d6e97a98 ffffffff8165986e 0000000000006217
[  245.981956]  0000000000000000 ffff8805d6e97ad8 ffffffff81047acc ffff880602f6beb8
[  245.981957]  ffff8805fc024618 ffff880602f6be30 ffffffff81c58f80 ffff880602f6beb8
[  245.981958] Call Trace:
[  245.981960]  [<ffffffff8165986e>] dump_stack+0x55/0x76
[  245.981962]  [<ffffffff81047acc>] warn_slowpath_common+0x8c/0xc0
[  245.981964]  [<ffffffff81047b1a>] warn_slowpath_null+0x1a/0x20
[  245.981965]  [<ffffffff811424fe>] bdi_wakeup_thread_delayed+0x5e/0x60
[  245.981967]  [<ffffffff811bdc71>] bdev_inode_switch_bdi+0xf1/0x160
[  245.981968]  [<ffffffff811bedd2>] __blkdev_get+0x372/0x4d0
[  245.981970]  [<ffffffff811bf310>] ? blkdev_get_by_dev+0x60/0x60
[  245.981972]  [<ffffffff811bf115>] blkdev_get+0x1e5/0x380
[  245.981973]  [<ffffffff8166551b>] ? _raw_spin_unlock+0x2b/0x50
[  245.981975]  [<ffffffff811bf310>] ? blkdev_get_by_dev+0x60/0x60
[  245.981977]  [<ffffffff811bf36f>] blkdev_open+0x5f/0x90
[  245.981978]  [<ffffffff81180cd6>] do_dentry_open+0x226/0x2a0
[  245.981980]  [<ffffffff81180fa5>] finish_open+0x35/0x50
[  245.981981]  [<ffffffff81192d9e>] do_last+0x48e/0x7a0
[  245.981983]  [<ffffffff81193174>] path_openat+0xc4/0x4e0
[  245.981984]  [<ffffffff81193d83>] do_filp_open+0x43/0xa0
[  245.981986]  [<ffffffff811a14a7>] ? __alloc_fd+0xa7/0x130
[  245.981987]  [<ffffffff81182422>] do_sys_open+0x132/0x220
[  245.981989]  [<ffffffff8118252e>] SyS_open+0x1e/0x20
[  245.981990]  [<ffffffff8166e802>] system_call_fastpath+0x16/0x1b
[  245.981991] ---[ end trace 04d4f07eb5cc8c14 ]---
[  246.864116] in bdi_unregister
[  246.866911] Modules linked in: kvm_intel kvm dm_crypt binfmt_misc joydev snd_hda_codec_hdmi snd_hda_codec_realtek hid_logitech_dj hid_generic mxm_wmi nls_iso8859_1 snd_hda_intel snd_hda_codec usbhid hid snd_hwdep psmouse usb_storage snd_pcm serio_raw lpc_ich snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd wmi it87 mac_hid hwmon_vid coretemp soundcore snd_page_alloc r8169 eeprom_93cx6 mii pci_stub ahci libahci i915 drm_kms_helper drm video i2c_algo_bit
[  246.910673] CPU: 3 PID: 2605 Comm: tee Tainted: G        W    3.11.0-rc6-usbdbg-00030-g693d742-dirty #1
[  246.920049] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[  246.930300]  000000000000019e ffff8805d71c39b8 ffffffff8165986e ffff88061f38f418
[  246.937763]  ffff8805d71c3a08 ffff8805d71c39f8 ffffffff81047acc ffff8805fd7a0410
[  246.945223]  ffff8805fc024618 ffff8805fd7a0400 ffff8805fc0249d8 0000000000800020
[  246.952683] Call Trace:
[  246.955128]  [<ffffffff8165986e>] dump_stack+0x55/0x76
[  246.960261]  [<ffffffff81047acc>] warn_slowpath_common+0x8c/0xc0
[  246.966264]  [<ffffffff81047bb6>] warn_slowpath_fmt+0x46/0x50
[  246.972009]  [<ffffffff8140ad17>] ? put_device+0x17/0x20
[  246.977318]  [<ffffffff81141d17>] bdi_unregister+0x107/0x1c0
[  246.982977]  [<ffffffff812f86eb>] del_gendisk+0xfb/0x260
[  246.988287]  [<ffffffff81459bd9>] sd_remove+0x79/0xe0
[  246.993339]  [<ffffffff8140f54f>] __device_release_driver+0x7f/0xf0
[  246.999603]  [<ffffffff8140f5e5>] device_release_driver+0x25/0x40
[  247.005693]  [<ffffffff8140ee47>] bus_remove_device+0x107/0x150
[  247.011611]  [<ffffffff8140c033>] device_del+0x133/0x1c0
[  247.016922]  [<ffffffff81455355>] __scsi_remove_device+0xc5/0xd0
[  247.022925]  [<ffffffff81453c3f>] scsi_forget_host+0x6f/0x80
[  247.028584]  [<ffffffff81448baa>] scsi_remove_host+0x7a/0x130
[  247.034330]  [<ffffffffa01fc6e3>] quiesce_and_remove_host+0x63/0xd0 [usb_storage]
[  247.041805]  [<ffffffffa01fc822>] usb_stor_disconnect+0x22/0x40 [usb_storage]
[  247.048935]  [<ffffffff814a9c23>] usb_unbind_interface+0x63/0x1b0
[  247.055024]  [<ffffffff8140f54f>] __device_release_driver+0x7f/0xf0
[  247.061288]  [<ffffffff8140f5e5>] device_release_driver+0x25/0x40
[  247.067379]  [<ffffffff8140ee47>] bus_remove_device+0x107/0x150
[  247.073296]  [<ffffffff8140c033>] device_del+0x133/0x1c0
[  247.078609]  [<ffffffff814a764f>] usb_disable_device+0xaf/0x200
[  247.084526]  [<ffffffff814a7f9c>] usb_set_configuration+0x14c/0x800
[  247.090789]  [<ffffffff814ad8ad>] ? usb_remove_store+0x2d/0x80
[  247.096619]  [<ffffffff814ad8e4>] usb_remove_store+0x64/0x80
[  247.102278]  [<ffffffff8140a908>] dev_attr_store+0x18/0x30
[  247.107764]  [<ffffffff811f8c86>] sysfs_write_file+0xe6/0x170
[  247.113505]  [<ffffffff811836ae>] vfs_write+0xce/0x200
[  247.118646]  [<ffffffff816625ca>] ? __schedule+0x3ca/0x870
[  247.124129]  [<ffffffff81183bb5>] SyS_write+0x55/0xa0
[  247.129179]  [<ffffffff8166e802>] system_call_fastpath+0x16/0x1b
[  247.135181] ---[ end trace 04d4f07eb5cc8c15 ]---
[  247.141812] usb 6-2: USB disconnect, device number 2

