Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278Ab3HTNdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 09:33:13 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:55284 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab3HTNdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 09:33:12 -0400
Date: Tue, 20 Aug 2013 09:33:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Peter Wu <lekensteyn@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] writeback: fix NULL dereference when device is gone
Message-ID: <20130820133308.GE3926@htj.dyndns.org>
References: <Pine.LNX.4.44L0.1308172104070.7744-100000@netrider.rowland.org>
 <5177367.3UXkd1Z6lS@al>
 <20130819230240.GA6869@mtj.dyndns.org>
 <1755678.6GItDDY0bW@al>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1755678.6GItDDY0bW@al>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 20, 2013 at 12:13:58PM +0200, Peter Wu wrote:
...
> > Hmmm... bdi->dev is cleared after bdi_wb_shutdown() so the work item
> > should no longer be running.  It seems like something is queueing the
> > work item after shutdown and the proper fix would be finding out which
> > and fixing it.  Can you please verify whether adding
> > WARN_ON(!bdi->dev) in bdi_wakeup_thread_delayed() trigger anything?
> 
> Initially I did not get any warnings, so I added more. The patch (on top of
> v3.11-rc6-27-g94fc5d9 plus some unrelated r8169 patches):
...
> [  245.978170] WARNING: CPU: 1 PID: 2608 at /home/pc/Linux-src/linux/mm/backing-dev.c:293 bdi_wakeup_thread_delayed+0x5e/0x60()
> [  245.978189] Modules linked in: kvm_intel kvm dm_crypt binfmt_misc joydev snd_hda_codec_hdmi snd_hda_codec_realtek hid_logitech_dj hid_generic mxm_wmi nls_iso8859_1 snd_hda_intel snd_hda_codec usbhid hid snd_hwdep psmouse usb_storage snd_pcm serio_raw lpc_ich snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd wmi it87 mac_hid hwmon_vid coretemp soundcore snd_page_alloc r8169 eeprom_93cx6 mii pci_stub ahci libahci i915 drm_kms_helper drm video i2c_algo_bit
> [  245.978191] CPU: 1 PID: 2608 Comm: ata_id Tainted: G        W    3.11.0-rc6-usbdbg-00030-g693d742-dirty #1
> [  245.978192] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
> [  245.978194]  0000000000000125 ffff8805d3a4fa98 ffffffff8165986e 00000000000060d0
> [  245.978196]  0000000000000000 ffff8805d3a4fad8 ffffffff81047acc ffff880602f6beb8
> [  245.978197]  ffff8805fc024618 ffff880602f6be30 ffffffff81c58f80 ffff880602f6beb8
> [  245.978198] Call Trace:
> [  245.978202]  [<ffffffff8165986e>] dump_stack+0x55/0x76
> [  245.978204]  [<ffffffff81047acc>] warn_slowpath_common+0x8c/0xc0
> [  245.978206]  [<ffffffff81047b1a>] warn_slowpath_null+0x1a/0x20
> [  245.978207]  [<ffffffff811424fe>] bdi_wakeup_thread_delayed+0x5e/0x60
> [  245.978211]  [<ffffffff811bdc71>] bdev_inode_switch_bdi+0xf1/0x160
> [  245.978212]  [<ffffffff811bedd2>] __blkdev_get+0x372/0x4d0
> [  245.978216]  [<ffffffff811bf115>] blkdev_get+0x1e5/0x380
> [  245.978221]  [<ffffffff811bf36f>] blkdev_open+0x5f/0x90
> [  245.978223]  [<ffffffff81180cd6>] do_dentry_open+0x226/0x2a0
> [  245.978225]  [<ffffffff81180fa5>] finish_open+0x35/0x50
> [  245.978227]  [<ffffffff81192d9e>] do_last+0x48e/0x7a0
> [  245.978229]  [<ffffffff81193174>] path_openat+0xc4/0x4e0
> [  245.978230]  [<ffffffff81193d83>] do_filp_open+0x43/0xa0
> [  245.978234]  [<ffffffff81182422>] do_sys_open+0x132/0x220
> [  245.978236]  [<ffffffff8118252e>] SyS_open+0x1e/0x20
> [  245.978238]  [<ffffffff8166e802>] system_call_fastpath+0x16/0x1b

Hmmm... looks like the udev event handling from hotunplugging ends up
opening up the device which in turn schedules an already shutdown bdi.
The root problem here seems that there is no proper synchronization
around bdi shutdown.  Ideally, a bdi should be marked offline
preventing further activities and then shut down but we instead shut
it down first and then clear bdi->dev.  As bdi's lifetime is tied to
the backing request_queue, it might be okay as unsynchronized access
to bdi->dev should be safe as long as the bdi struct itself is
accessible.  Still nasty tho.

Not sure what to do.  The quick fix would be doing the following from
workfn().

	dev = bdi->dev;
	if (!dev)		// bdi already shutdown
		return;

	use @dev;		// can't use bdi->dev, as it can be cleared anytime

But it's nasty.  A better way to do it would be, from
bdi_wb_shutdown(), marking the bdi as offline and ensure that
bdi_wakeup_thread_delayed() sees that, flush the work item and then
clear bdi->dev.

Thanks.

-- 
tejun
