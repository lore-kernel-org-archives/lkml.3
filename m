Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814Ab3K0Bbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:31:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571Ab3K0A6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3.12 034/116] Bluetooth: revert: "Bluetooth: Add missing reset_resume dev_pm_ops"
Date: Tue, 26 Nov 2013 16:56:47 -0800
Message-Id: <20131127005739.317843009@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit b1a8014471b01dd862de9f91bbbff1296afac42d upstream.

Many btusb devices have 2 modes, a hid mode and a bluetooth hci mode. These
devices default to hid mode for BIOS use. This means that after having been
reset they will revert to HID mode, and are no longer usable as a HCI.

Therefor it is a very bad idea to just blindly make reset_resume point to
the regular resume handler. Note that the btusb driver has no clue how to
switch these devices from hid to hci mode, this is done in userspace through
udev rules, so the proper way to deal with this is to not have a reset-resume
handler and instead let the usb-system re-enumerate the device, and re-run
the udev rules.

I must also note, that the commit message for the commit causing this
problem has a very weak motivation for the change:

"Add missing reset_resume dev_pm_ops. Missing reset_resume results in the
following message after power management device test. This change sets
reset_resume to btusb_resume().

[ 2506.936134] btusb 1-1.5:1.0: no reset_resume for driver btusb?
[ 2506.936137] btusb 1-1.5:1.1: no reset_resume for driver btusb?"

Making a change solely to silence a warning while also changing important
behavior (normal resume handling versus re-enumeration) requires a commit
message with a proper explanation why it is safe to do so, which clearly lacks
here, and unsurprisingly it turns out to not be safe to make this change.

Reverting the commit in question fixes bt no longer working on my Dell
E6430 after a suspend/resume, and I believe it likely also fixes the
following bugs:
https://bugzilla.redhat.com/show_bug.cgi?id=988481
https://bugzilla.redhat.com/show_bug.cgi?id=1010649
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1213239

This reverts commit 502f769662978a2fe99d0caed5e53e3006107381.

Cc: Shuah Khan <shuah.kh@samsung.com>
Cc: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btusb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1628,7 +1628,6 @@ static struct usb_driver btusb_driver =
 #ifdef CONFIG_PM
 	.suspend	= btusb_suspend,
 	.resume		= btusb_resume,
-	.reset_resume	= btusb_resume,
 #endif
 	.id_table	= btusb_table,
 	.supports_autosuspend = 1,


