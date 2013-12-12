Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab3LLSrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:47:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab3LLSrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:47:19 -0500
Subject: [PATCH 1/2] misc: Reserve minor for VFIO
To: alex.williamson@redhat.com, kvm@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 12 Dec 2013 11:47:17 -0700
Message-ID: <20131212184717.966.76895.stgit@bling.home>
In-Reply-To: <20131212184402.966.34502.stgit@bling.home>
References: <20131212184402.966.34502.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFIO currently allocates it's own dynamic chardev range, reserving the
first minor for the control part of the interface (/dev/vfio/vfio) and
the remainder for VFIO groups (/dev/vfio/$GROUP).  This works, but it
doesn't support auto loading.  For instance when libvirt checks for
VFIO support it looks for /dev/vfio/vfio, which currently doesn't
exist unless the vfio module is loaded.  By converting the control
device to a misc driver and reserving a static minor, we can enable
auto loading.

Reserving the minor is a prerequist to that conversion.  Minor 196
appears to be unused by anything currently in the kernel.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 Documentation/devices.txt  |    1 +
 include/linux/miscdevice.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 80b7241..10378cc 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -409,6 +409,7 @@ Your cooperation is appreciated.
 		193 = /dev/d7s		SPARC 7-segment display
 		194 = /dev/zkshim	Zero-Knowledge network shim control
 		195 = /dev/elographics/e2201	Elographics touchscreen E271-2201
+		196 = /dev/vfio/vfio	VFIO userspace driver interface
 		198 = /dev/sexec	Signed executable interface
 		199 = /dev/scanners/cuecat :CueCat barcode scanner
 		200 = /dev/net/tun	TAP/TUN network device
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index f7eaf2d..3737f72 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -30,6 +30,7 @@
 #define STORE_QUEUE_MINOR	155
 #define I2O_MINOR		166
 #define MICROCODE_MINOR		184
+#define VFIO_MINOR		196
 #define TUN_MINOR		200
 #define CUSE_MINOR		203
 #define MWAVE_MINOR		219	/* ACP/Mwave Modem */

