Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab3CDLoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 06:44:04 -0500
Received: from canardo.mork.no ([148.122.252.1]:44510 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488Ab3CDLoC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 06:44:02 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zihan@huawei.com>, <Lin.Lei@huawei.com>, <greg@kroah.com>,
        <neil.yi@huawei.com>, <wangyuhua@huawei.com>, <huqiao36@huawei.com>,
        <balbi@ti.com>, <mdharm-usb@one-eyed-alien.net>,
        <sebastian@breakpoint.cc>
Subject: v3.8 regression: Huawei mode switching fails (was Re: [PATCH 2/2]linux-usb:optimize to match the Huawei USB storage devices and support new switch command)
Organization: m
References: <fe8c966212fb.12fbfe8c9662@huawei.com>
Date: Mon, 04 Mar 2013 12:41:11 +0100
In-Reply-To: <fe8c966212fb.12fbfe8c9662@huawei.com> (fangxiaozhi@huawei.com's
	message of "Mon, 4 Feb 2013 15:16:34 +0800")
Message-ID: <87obezs888.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Franko,

This patch causes a number of regressions for both the Huawei devices I
have available for testing. One of them is completely unusable in v3.8
(unable to switch to modem mode) unless the usb-storage driver is
disabled.

I realize that some devices are historically handled by the usb-storage
driver, but userspace modeswitching is the rule for new devices AFAIK.
I see absolutely no valid argument for adding new devices.  And there is
absolutely no excuse for adding devices which have been handled by
userspace switching for years!  The patch does not just "optimize"
matching.  It adds a large number of devices which were previously
handled just fine by usb_modeswitch. This is guaranteed to confuse users
with existing configurations, and users looking up any of the existing
documentation pointing to usb_modeswitch.

There is no need to repeat the discussion of kernel vs userspace
switching.  I will only note that userspace switching:
 - has been selected as the rule for new devices,
 - allow the user to temporarily disable switching e.g. for mounting and
   inspecting the usb-storage exported data,
 - allow the user/system to apply device specific switching quirks


The v3.7->v3.8 regressions I observe are:

1) Temporarily disabling mode switching and mounting the CD image is now
  impossible. Mode switching can only be disabled by blacklisting
  usb-storage, which of course prevents usb-storage from working

  Prior to v3.8, modeswitching could easily be disabled by userspace
  configuration. The change breaks existing configurations.

2) Switching to non-default modes is now impossible.  The E392
 (initially appearing as 12d1:1505) Windows drivers will use a different
 command than the one used by Linux, causing the device to select a
 different configuration in Linux and Windows. This forces Linux and
 Windows to see the device differently.

 Prior to v3.8, different modeswitching commands could be configured 
 per device. The change breaks existing configurations.

3) Switching fails for some devices. The E367 (initially appearing as
 12d1:1446) does not switch when it receives the command sent by
 usb-storage.  But the command disable further switching, preventing
 userspace switching from working as well.

 Prior to v3.8, the device would switch fine using a default
 usb_modeswitch configuration. The change breaks existing
 configurations.

 I do note that there is a slight difference between the known working
 usb_modeswitch command:

   55534243123456780000000000000011062000000100000000000000000000

 and the command sent by usb-storage:

	char rewind_cmd[] = {0x11, 0x06, 0x20, 0x00, 0x00, 0x01, 0x01, 0x00,
			0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

 I assume the cause of the failure is either this difference or some
 timing issue.

Anyway, I believe this patch must be reverted.  It disables currently
used, well documented, and extremely useful, userspace funtionaliy for
all devices implicitly added by the conversion from device matching to
vendor matching.



Bjørn
