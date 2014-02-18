Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaBRFS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 00:18:27 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:41402 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaBRFSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 00:18:25 -0500
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
To: linux-bluetooth@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kay.sievers@vrfy.org,
        linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH v2] Bluetooth: allocate static minor for vhci
Date: Tue, 18 Feb 2014 02:19:26 -0300
Message-Id: <1392700766-4374-1-git-send-email-lucas.demarchi@intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucas De Marchi <lucas.demarchi@intel.com>

Commit bfacbb9 (Bluetooth: Use devname:vhci module alias for virtual HCI
driver) added the module alias to hci_vhci module so it's possible to
create the /dev/vhci node. However creating an alias without
specifying the minor doesn't allow us to create the node ahead,
triggerring module auto-load when it's first accessed.

Starting with depmod from kmod 16 we started to warn if there's a
devname alias without specifying the major and minor.

Let's do the same done for uhid, kvm, fuse and others, specifying a
fixed minor. In systems with systemd as the init the following will
happen: on early boot systemd will call "kmod static-nodes" to read
/lib/modules/$(uname -r)/modules.devname and then create the nodes. When
first accessed these "dead" nodes will trigger the module loading.

Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
---

Changes from v1:
 - use minor=137, since 240 is reserved for local use

We talked about using 197, but that's being used by pxa3xx-gcu, too.

 Documentation/devices.txt    | 1 +
 drivers/bluetooth/hci_vhci.c | 3 ++-
 include/linux/miscdevice.h   | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 10378cc..04356f5 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -353,6 +353,7 @@ Your cooperation is appreciated.
 		133 = /dev/exttrp	External device trap
 		134 = /dev/apm_bios	Advanced Power Management BIOS
 		135 = /dev/rtc		Real Time Clock
+		137 = /dev/vhci		Bluetooth virtual HCI driver
 		139 = /dev/openprom	SPARC OpenBoot PROM
 		140 = /dev/relay8	Berkshire Products Octal relay card
 		141 = /dev/relay16	Berkshire Products ISO-16 relay card
diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
index 1ef6990..add1c6a 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -359,7 +359,7 @@ static const struct file_operations vhci_fops = {
 static struct miscdevice vhci_miscdev= {
 	.name	= "vhci",
 	.fops	= &vhci_fops,
-	.minor	= MISC_DYNAMIC_MINOR,
+	.minor	= VHCI_MINOR,
 };
 
 static int __init vhci_init(void)
@@ -385,3 +385,4 @@ MODULE_DESCRIPTION("Bluetooth virtual HCI driver ver " VERSION);
 MODULE_VERSION(VERSION);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("devname:vhci");
+MODULE_ALIAS_MISCDEV(VHCI_MINOR);
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 3737f72..7bb6148 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -23,6 +23,7 @@
 #define TEMP_MINOR		131	/* Temperature Sensor */
 #define RTC_MINOR		135
 #define EFI_RTC_MINOR		136	/* EFI Time services */
+#define VHCI_MINOR		137
 #define SUN_OPENPROM_MINOR	139
 #define DMAPI_MINOR		140	/* DMAPI */
 #define NVRAM_MINOR		144
-- 
1.9.0

