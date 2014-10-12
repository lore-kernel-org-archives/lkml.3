Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaJLXoJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 19:44:09 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:51263 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaJLXoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 19:44:03 -0400
From: "S. Gilles" <sgilles@terpmail.umd.edu>
X-Google-Original-From: "S. Gilles" <sgilles@umd.edu>
Date: Sun, 12 Oct 2014 19:43:54 -0400
To: linux-kernel@vger.kernel.org
Subject: [Regression] rtlwifi boot failure with 3.17
Message-ID: <20141012234354.GA22088@number18>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a boot failure (consistent) since about 3.17-rc7, which I have
bisected to

38506ecefab911785d5e1aa5889f6eeb462e0954 is the first bad commit
commit 38506ecefab911785d5e1aa5889f6eeb462e0954
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Mon Sep 22 09:39:19 2014 -0500

    rtlwifi: rtl_pci: Start modification for new drivers
    
    Future patches will move the drivers for RTL8192EE and RTL8821AE
    from staging to the regular wireless tree. Here, the necessary features
    are added to the PCI driver. Other files are touched due to changes
    in the various data structs.
    
    Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

The trace (as much of it as I can capture by hand, though I think I've
checked it for typos):

R10: ffffffff825f2d80 R11: 0000000000000000 R12: ffff8800b4f107c0
R13: ffff8800b4f124b8 R14: 0000000000001000 R15: ffff8800b4c7a000
FS:  000007fc66c938700(0000) GS:ffff88013e200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000b5438000 CR4: 00000000000407f0
Stack:
 ffffffffa01e20d6 ffff8800b4f12420 ffff8800b4f107c0 ffff880137d7fcd0
 ffffffffa01c97b5 ffff8800b4f107c0 ffff8800b4c7a8d0 0000000000000000
 ffff880137d7fd30 ffffffff81577304 0000000000000000 ffff8800b4c7a8c0
Call Trace:
 [<ffffffffa01e20d6>] ? rtl_pci_start+0x2b/0x15f [rtl_pci]
 [<ffffffffa01c97b5>] rtl_op_start+0x45/0x64 [rtlwifi]
 [<ffffffff81577304>] ieee80211_do_open+0x152/0xb4b
 [<ffffffff815b52bc>] ? mutex_unlock+0x9/0xb
 [<ffffffff81577d4a>] ieee80211_open+0x4d/0x57
 [<ffffffff8147df7f>] __dev_open+0x8b/0xcb
 [<ffffffff8147e1e1>] __dev_change_flags+0xa4/0x13a
 [<ffffffff8147e297>] dev_change_flags+0x20/0x53
 [<ffffffff814d0204>] devinet_ioctl+0x269/0x568
 [<ffffffff814d19b4>] inet_ioctl+0x81/0x9e
 [<ffffffff814654e6>] sock_do_ioctl+0x20/0x3d
 [<ffffffff81465a56>] sock_ioctl+0x20e/0x21a
 [<ffffffff81136242>] do_vfs_ioctl+0x39e/0x467
 [<ffffffff815b7277>] ? sysret_check+0x1b/0x56
 [<ffffffff810965fe>] ? trace_hardirqs_on_caller+0x16e/0x18a
 [<ffffffff81136343>] SyS_ioctl+0x38/0x5f
 [<ffffffff815b7252>] system_call_fastpath+0x16/0x1b
Code:  Bad RIP value.
RIP  [<          (null)>]           (null)
 RSP <ffff880137d7fc90>
CR2: 0000000000000000
---[ end trace 7307d2524c1e640b ]---

My card is

$ lspci -nn | grep RTL
03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)

The portions of my config that I think are relevant follow, if the
entire .config is requested I can provide it.

CONFIG_WLAN=y
CONFIG_RTL_CARDS=y
CONFIG_RTL8192CE=m
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8723BE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192CU is not set
CONFIG_RTLWIFI=m
CONFIG_RTLWIFI_PCI=m
CONFIG_RTLWIFI_DEBUG=y
CONFIG_RTL8192C_COMMON=m

Please let me know if there's more information I can provide or tests
I can perform.

--
S. Gilles
