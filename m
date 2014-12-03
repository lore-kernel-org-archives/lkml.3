Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaLCLkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:40:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbaLCL1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:40 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Martyn Welch <martyn.welch@ge.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 083/101] VME: Stop using memcpy_[to|from]io() due to unwanted behaviour
Date: Wed,  3 Dec 2014 12:26:45 +0100
Message-Id: <181bbf73ff2088b53b1c9978f372225689c8b6e2.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martyn Welch <martyn.welch@ge.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a2a720e15f59be60c7ae1c58b5b4ac1003dd5078 upstream.

The ca91cx42 and tsi148 VME bridges use the width of reads and writes on the
PCI bus in part to control the width of the cycles on the VME bus. It is
important that we can control the width of cycles on the VME bus as some VME
hardware requires cycles of a specific width. The memcpy_toio() and
memcpy_fromio() functions do not provide sufficient control, so instead loop
using ioread functions.

Reported-by: Michael Kenney <mfkenney@gmail.com>
Signed-off-by: Martyn Welch <martyn.welch@ge.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/vme/bridges/vme_ca91cx42.c | 29 ++++++++++++++---------------
 drivers/vme/bridges/vme_tsi148.c   | 18 +++++++++---------
 2 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/vme/bridges/vme_ca91cx42.c b/drivers/vme/bridges/vme_ca91cx42.c
index 0b2fefbfcd10..1abbf80ffb19 100644
--- a/drivers/vme/bridges/vme_ca91cx42.c
+++ b/drivers/vme/bridges/vme_ca91cx42.c
@@ -869,14 +869,13 @@ static ssize_t ca91cx42_master_read(struct vme_master_resource *image,
 
 	spin_lock(&image->lock);
 
-	/* The following code handles VME address alignment problem
-	 * in order to assure the maximal data width cycle.
-	 * We cannot use memcpy_xxx directly here because it
-	 * may cut data transfer in 8-bits cycles, thus making
-	 * D16 cycle impossible.
-	 * From the other hand, the bridge itself assures that
-	 * maximal configured data cycle is used and splits it
-	 * automatically for non-aligned addresses.
+	/* The following code handles VME address alignment. We cannot use
+	 * memcpy_xxx here because it may cut data transfers in to 8-bit
+	 * cycles when D16 or D32 cycles are required on the VME bus.
+	 * On the other hand, the bridge itself assures that the maximum data
+	 * cycle configured for the transfer is used and splits it
+	 * automatically for non-aligned addresses, so we don't want the
+	 * overhead of needlessly forcing small transfers for the entire cycle.
 	 */
 	if ((uintptr_t)addr & 0x1) {
 		*(u8 *)buf = ioread8(addr);
@@ -896,9 +895,9 @@ static ssize_t ca91cx42_master_read(struct vme_master_resource *image,
 	}
 
 	count32 = (count - done) & ~0x3;
-	if (count32 > 0) {
-		memcpy_fromio(buf + done, addr + done, (unsigned int)count);
-		done += count32;
+	while (done < count32) {
+		*(u32 *)(buf + done) = ioread32(addr + done);
+		done += 4;
 	}
 
 	if ((count - done) & 0x2) {
@@ -930,7 +929,7 @@ static ssize_t ca91cx42_master_write(struct vme_master_resource *image,
 	spin_lock(&image->lock);
 
 	/* Here we apply for the same strategy we do in master_read
-	 * function in order to assure D16 cycle when required.
+	 * function in order to assure the correct cycles.
 	 */
 	if ((uintptr_t)addr & 0x1) {
 		iowrite8(*(u8 *)buf, addr);
@@ -950,9 +949,9 @@ static ssize_t ca91cx42_master_write(struct vme_master_resource *image,
 	}
 
 	count32 = (count - done) & ~0x3;
-	if (count32 > 0) {
-		memcpy_toio(addr + done, buf + done, count32);
-		done += count32;
+	while (done < count32) {
+		iowrite32(*(u32 *)(buf + done), addr + done);
+		done += 4;
 	}
 
 	if ((count - done) & 0x2) {
diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
index b92eb181dcda..ef9028f87da3 100644
--- a/drivers/vme/bridges/vme_tsi148.c
+++ b/drivers/vme/bridges/vme_tsi148.c
@@ -1282,8 +1282,8 @@ static ssize_t tsi148_master_read(struct vme_master_resource *image, void *buf,
 	spin_lock(&image->lock);
 
 	/* The following code handles VME address alignment. We cannot use
-	 * memcpy_xxx directly here because it may cut small data transfers in
-	 * to 8-bit cycles, thus making D16 cycle impossible.
+	 * memcpy_xxx here because it may cut data transfers in to 8-bit
+	 * cycles when D16 or D32 cycles are required on the VME bus.
 	 * On the other hand, the bridge itself assures that the maximum data
 	 * cycle configured for the transfer is used and splits it
 	 * automatically for non-aligned addresses, so we don't want the
@@ -1307,9 +1307,9 @@ static ssize_t tsi148_master_read(struct vme_master_resource *image, void *buf,
 	}
 
 	count32 = (count - done) & ~0x3;
-	if (count32 > 0) {
-		memcpy_fromio(buf + done, addr + done, count32);
-		done += count32;
+	while (done < count32) {
+		*(u32 *)(buf + done) = ioread32(addr + done);
+		done += 4;
 	}
 
 	if ((count - done) & 0x2) {
@@ -1369,7 +1369,7 @@ static ssize_t tsi148_master_write(struct vme_master_resource *image, void *buf,
 	spin_lock(&image->lock);
 
 	/* Here we apply for the same strategy we do in master_read
-	 * function in order to assure D16 cycle when required.
+	 * function in order to assure the correct cycles.
 	 */
 	if ((uintptr_t)addr & 0x1) {
 		iowrite8(*(u8 *)buf, addr);
@@ -1389,9 +1389,9 @@ static ssize_t tsi148_master_write(struct vme_master_resource *image, void *buf,
 	}
 
 	count32 = (count - done) & ~0x3;
-	if (count32 > 0) {
-		memcpy_toio(addr + done, buf + done, count32);
-		done += count32;
+	while (done < count32) {
+		iowrite32(*(u32 *)(buf + done), addr + done);
+		done += 4;
 	}
 
 	if ((count - done) & 0x2) {
-- 
2.1.3

