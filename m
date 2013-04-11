Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702Ab3DKUeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:34:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18255 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab3DKU0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:13 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Yn3arrLjY2EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=5dYAlnOqI5YA:10 a=yQdBAQUQAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=q6qRh1ou-MTl8AK-j0EA:9 a=IcxpeKGZWnEA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202552.540204016@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 039/171 ] rtlwifi: rtl8192cu: Fix schedule while atomic bug splat
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0039-rtlwifi-rtl8192cu-Fix-schedule-while-atomic-bug-spla.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

[ Upstream commit 664899786cb49cb52f620e06ac19c0be524a7cfa ]

When run at debug 3 or higher, rtl8192cu reports a BUG as follows:

BUG: scheduling while atomic: kworker/u:0/5281/0x00000002
INFO: lockdep is turned off.
Modules linked in: rtl8192cu rtl8192c_common rtlwifi fuse af_packet bnep bluetooth b43 mac80211 cfg80211 ipv6 snd_hda_codec_conexant kvm_amd k
vm snd_hda_intel snd_hda_codec bcma rng_core snd_pcm ssb mmc_core snd_seq snd_timer snd_seq_device snd i2c_nforce2 sr_mod pcmcia forcedeth i2c_core soundcore
 cdrom sg serio_raw k8temp hwmon joydev ac battery pcmcia_core snd_page_alloc video button wmi autofs4 ext4 mbcache jbd2 crc16 thermal processor scsi_dh_alua
 scsi_dh_hp_sw scsi_dh_rdac scsi_dh_emc scsi_dh ata_generic pata_acpi pata_amd [last unloaded: rtlwifi]
Pid: 5281, comm: kworker/u:0 Tainted: G        W    3.8.0-wl+ #119
Call Trace:
 [<ffffffff814531e7>] __schedule_bug+0x62/0x70
 [<ffffffff81459af0>] __schedule+0x730/0xa30
 [<ffffffff81326e49>] ? usb_hcd_link_urb_to_ep+0x19/0xa0
 [<ffffffff8145a0d4>] schedule+0x24/0x70
 [<ffffffff814575ec>] schedule_timeout+0x18c/0x2f0
 [<ffffffff81459ec0>] ? wait_for_common+0x40/0x180
 [<ffffffff8133f461>] ? ehci_urb_enqueue+0xf1/0xee0
 [<ffffffff810a579d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81459f65>] wait_for_common+0xe5/0x180
 [<ffffffff8107d1c0>] ? try_to_wake_up+0x2d0/0x2d0
 [<ffffffff8145a08e>] wait_for_completion_timeout+0xe/0x10
 [<ffffffff8132ab1c>] usb_start_wait_urb+0x8c/0x100
 [<ffffffff8132adf9>] usb_control_msg+0xd9/0x130
 [<ffffffffa057dd8d>] _usb_read_sync+0xcd/0x140 [rtlwifi]
 [<ffffffffa057de0e>] _usb_read32_sync+0xe/0x10 [rtlwifi]
 [<ffffffffa04b0555>] rtl92cu_update_hal_rate_table+0x1a5/0x1f0 [rtl8192cu]

The cause is a synchronous read from routine rtl92cu_update_hal_rate_table().
The resulting output is not critical, thus the debug statement is
deleted.

Reported-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 4bbb711..b4b2e43 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -2058,8 +2058,6 @@ void rtl92cu_update_hal_rate_table(struct ieee80211_hw *hw,
 			       (shortgi_rate << 4) | (shortgi_rate);
 	}
 	rtl_write_dword(rtlpriv, REG_ARFR0 + ratr_index * 4, ratr_value);
-	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG, "%x\n",
-		 rtl_read_dword(rtlpriv, REG_ARFR0));
 }
 
 void rtl92cu_update_hal_rate_mask(struct ieee80211_hw *hw, u8 rssi_level)
-- 
1.7.10.4


