Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418AbaBUNdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:33:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47118 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbaBUMvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martyn Welch <martyn.welch@ge.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 080/121] VME: Correct read/write alignment algorithm
Date: Fri, 21 Feb 2014 12:48:24 +0000
Message-Id: <1392986945-9693-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martyn Welch <martyn.welch@ge.com>

commit f0342e66b397947ed8c3eef8c37b5ca2d5b1bb50 upstream.

In order to ensure the correct width cycles on the VME bus, the VME bridge
drivers implement an algorithm to utilise the largest possible width reads and
writes whilst maintaining natural alignment constraints. The algorithm
currently looks at the start address rather than the current read/write address
when determining whether a 16-bit width cycle is required to get to 32-bit
alignment.  This results in incorrect alignment,

Reported-by: Jim Strouth <james.strouth@ge.com>
Tested-by: Jim Strouth <james.strouth@ge.com>
Signed-off-by: Martyn Welch <martyn.welch@ge.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/vme/bridges/vme_ca91cx42.c | 4 ++--
 drivers/vme/bridges/vme_tsi148.c   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vme/bridges/vme_ca91cx42.c b/drivers/vme/bridges/vme_ca91cx42.c
index 64bfea3..8ca1030 100644
--- a/drivers/vme/bridges/vme_ca91cx42.c
+++ b/drivers/vme/bridges/vme_ca91cx42.c
@@ -880,7 +880,7 @@ static ssize_t ca91cx42_master_read(struct vme_master_resource *image,
 		if (done == count)
 			goto out;
 	}
-	if ((uintptr_t)addr & 0x2) {
+	if ((uintptr_t)(addr + done) & 0x2) {
 		if ((count - done) < 2) {
 			*(u8 *)(buf + done) = ioread8(addr + done);
 			done += 1;
@@ -934,7 +934,7 @@ static ssize_t ca91cx42_master_write(struct vme_master_resource *image,
 		if (done == count)
 			goto out;
 	}
-	if ((uintptr_t)addr & 0x2) {
+	if ((uintptr_t)(addr + done) & 0x2) {
 		if ((count - done) < 2) {
 			iowrite8(*(u8 *)(buf + done), addr + done);
 			done += 1;
diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
index 94c892f..732983f 100644
--- a/drivers/vme/bridges/vme_tsi148.c
+++ b/drivers/vme/bridges/vme_tsi148.c
@@ -1289,7 +1289,7 @@ static ssize_t tsi148_master_read(struct vme_master_resource *image, void *buf,
 		if (done == count)
 			goto out;
 	}
-	if ((uintptr_t)addr & 0x2) {
+	if ((uintptr_t)(addr + done) & 0x2) {
 		if ((count - done) < 2) {
 			*(u8 *)(buf + done) = ioread8(addr + done);
 			done += 1;
@@ -1371,7 +1371,7 @@ static ssize_t tsi148_master_write(struct vme_master_resource *image, void *buf,
 		if (done == count)
 			goto out;
 	}
-	if ((uintptr_t)addr & 0x2) {
+	if ((uintptr_t)(addr + done) & 0x2) {
 		if ((count - done) < 2) {
 			iowrite8(*(u8 *)(buf + done), addr + done);
 			done += 1;
-- 
1.9.0

