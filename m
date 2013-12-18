Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3LRU4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 15:56:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab3LRU4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 15:56:47 -0500
Subject: [PATCH v2] misc: Reserve minor for VFIO
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, gnomes@lxorguk.ukuu.org.uk, arnd@arndb.de,
        hpa@zytor.com
Date: Wed, 18 Dec 2013 13:56:32 -0700
Message-ID: <20131218204024.30540.55302.stgit@bling.home>
User-Agent: StGit/0.17-dirty
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
is unused by anything currently in the kernel.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

v2: Plea for ack edition

As Alan suspected, there's been no response from device@lanana.org,
so there's probably nobody monitoring it anymore.  I've done due
diligence looking at all the callers of misc_register() in linux-next
and cannot find any conflicts with minor 196.  If anyone wants to toss
me an ack or sign-off I'll be happy to bring this in through my vfio
tree, otherwise I'd appreciate if someone wants to take it directly.
Thanks!

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

