Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab3GIIsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:48:19 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55365 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3GIIsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:48:17 -0400
Date: Tue, 9 Jul 2013 16:48:09 +0800
From: Adam Lee <adam.lee@canonical.com>
To: linux-bluetooth@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Wen-chien Jesse Sung <jesse.sung@canonical.com>,
        AceLan Kao <acelan.kao@canonical.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        Anthony Wong <anthony.wong@canonical.com>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] btusb: fix wrong use of PTR_ERR()
Message-ID: <20130709084809.GA23395@adam-laptop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <20130709074039.GA25268@adam-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

PTR_ERR() returns a signed long type value which is limited by IS_ERR(),
it must be a negative number and bigger than -MAX_ERRNO(-4095).

The bug here, btusb_setup_intel_patching()'s return value might come
from -PTR_ERR() which must be a positive number, we can't judge if it's
an error by "if (ret < 0)", the wrong use here leads to failure as
below, even panic.

Error log:

[   12.958920] Bluetooth: hci0 command 0xfc8e tx timeout
[   14.961765] Bluetooth: hci0 command 0xfc8e tx timeout
[   16.964688] Bluetooth: hci0 command 0xfc8e tx timeout
[   20.954501] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
[   22.957358] Bluetooth: hci0 command 0xfc8e tx timeout
[   30.948922] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
[   32.951780] Bluetooth: hci0 command 0xfc8e tx timeout
[   40.943359] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
[   42.946219] Bluetooth: hci0 command 0xfc8e tx timeout
[   50.937812] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
[   52.940670] Bluetooth: hci0 command 0xfc8e tx timeout
[   60.932236] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
[   62.935092] Bluetooth: hci0 command 0xfc8e tx timeout
[   70.926688] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
[   72.929545] Bluetooth: hci0 command 0xfc8e tx timeout
[   80.921111] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
[   82.923969] Bluetooth: hci0 command 0xfc2f tx timeout
[   90.915542] Bluetooth: hci0 sending Intel patch command (0xfc2f) failed (-110)
[   92.918406] Bluetooth: hci0 command 0xfc11 tx timeout
[  100.909955] Bluetooth: hci0 sending Intel patch command (0xfc11) failed (-110)
[  102.912858] Bluetooth: hci0 command 0xfc60 tx timeout
[  110.904394] Bluetooth: hci0 sending Intel patch command (0xfc60) failed (-110)
[  112.907293] Bluetooth: hci0 command 0xfc11 tx timeout
[  120.898831] Bluetooth: hci0 exiting Intel manufacturer mode failed (-110)
[  120.904757] bluetoothd[1030]: segfault at 4 ip 00007f8b2eb55236 sp 00007fff53ff6920 error 4 in bluetoothd[7f8b2eaff000+cb000]

Signed-off-by: Adam Lee <adam.lee@canonical.com>
---
 drivers/bluetooth/btusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 7a7e5f8..05a38a2 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1256,7 +1256,7 @@ static int btusb_setup_intel(struct hci_dev *hdev)
 
 		ret = btusb_setup_intel_patching(hdev, fw, &fw_ptr,
 						 &disable_patch);
-		if (ret < 0)
+		if (!ret)
 			goto exit_mfg_deactivate;
 	}
 
-- 
1.8.3.2

--EVF5PPMfhYS0aIcm
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="ptr_err.c"

#include <stdio.h>

#define MAX_ERRNO       4095

#define IS_ERR_VALUE(x) ((x) >= (unsigned long)-MAX_ERRNO)

static inline long IS_ERR(const void *ptr)
{
        return IS_ERR_VALUE((unsigned long)ptr);
}

static inline long PTR_ERR(const void *ptr)
{
	return (long) ptr;
}

int main(int argc, const char *argv[])
{
	void *ptr = (void *)-1;

	printf("ptr = %p, -PTR_ERR(ptr) = %ld\n\n", ptr, -PTR_ERR(ptr));

	if(IS_ERR(ptr)) {
		if (-PTR_ERR(ptr) < 0)
			printf("That's what the codes want.\n");
		else
			printf("Bug happens!\n");
	}

	return 0;
}

--EVF5PPMfhYS0aIcm--
