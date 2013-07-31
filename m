Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716Ab3GaVfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 17:35:17 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:49379 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757570Ab3GaVfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 17:35:15 -0400
Message-ID: <1375306513.8170.33.camel@x61.thuisdomein>
Subject: Can we drop __must_check from driver_for_each_device()?
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 31 Jul 2013 23:35:13 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jul 2013 21:35:13.0353 (UTC) FILETIME=[D719DB90:01CE8E35]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

0) Summary: I think __must_check can be dropped from
driver_for_each_device(). Do you agree?

1) Commit 4a7fb6363f ("add __must_check to device management code")
added __must_check to driver_for_each_device(), seven years ago. But of
the seventeen current users of that function just one actually seems to
care about its return value:

- dead code:
  drivers/mtd/onenand/omap2.c:omap2_onenand_rephase()

- callback always returns zero:
  drivers/infiniband/hw/qib/qib_init.c:qib_notify_dca()
    (see all three possible values of f_notify_dca())
  drivers/media/pci/cx25821/cx25821-alsa.c:cx25821_audio_fini()
  drivers/media/pci/cx25821/cx25821-alsa.c:cx25821_alsa_init()
  drivers/net/can/usb/peak_usb/pcan_usb_core.c:peak_usb_exit()
  drivers/net/ethernet/intel/igb/igb_main.c:igb_notify_dca()
  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:ixgbe_notify_dca()
  drivers/net/ethernet/myricom/myri10ge/myri10ge.c:myri10ge_notify_dca()

- return value of callback ignored:
  drivers/iommu/omap-iommu.c:omap_foreach_iommu_device()
    (when called by iommu_debugfs_exit())
  drivers/isdn/hardware/mISDN/hfcpci.c:hfcpci_softirq()
  drivers/media/pci/cx18/cx18-alsa-main.c:cx18_alsa_exit()
  drivers/media/pci/ivtv/ivtv-alsa-main.c:ivtv_alsa_exit()
  drivers/media/pci/ivtv/ivtvfb.c:ivtvfb_init()
  drivers/media/pci/ivtv/ivtvfb.c:ivtvfb_cleanup()
  drivers/media/platform/s5p-tv/mixer_video.c:find_and_register_subdev()
  drivers/net/wireless/brcm80211/brcmfmac/usb.c:brcmf_usb_exit()

- return value actually used:
  drivers/iommu/omap-iommu.c:omap_foreach_iommu_device()
    (when called by iommu_debug_init())

2) Please note that if the callback always returns zero,
driver_for_each_device() can still return -EINVAL, but only if it was
provided a NULL "drv" (a struct device_driver). It sure seems odd to do
so. Can that actually happen?

3) So to me it looks the __must_check attribute of
driver_for_each_device() can be dropped. Do you agree?


Paul Bolle

