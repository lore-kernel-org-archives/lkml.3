Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbaCCTBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:01:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56214 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbaCCTAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:00:53 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martyn Welch <martyn.welch@ge.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 45/67] VME: Correct read/write alignment algorithm
Date: Mon,  3 Mar 2014 10:55:33 -0800
Message-Id: <1393872955-28810-46-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
index 9c1aa4d..6342406 100644
--- a/drivers/vme/bridges/vme_tsi148.c
+++ b/drivers/vme/bridges/vme_tsi148.c
@@ -1283,7 +1283,7 @@ static ssize_t tsi148_master_read(struct vme_master_resource *image, void *buf,
 		if (done == count)
 			goto out;
 	}
-	if ((uintptr_t)addr & 0x2) {
+	if ((uintptr_t)(addr + done) & 0x2) {
 		if ((count - done) < 2) {
 			*(u8 *)(buf + done) = ioread8(addr + done);
 			done += 1;
@@ -1365,7 +1365,7 @@ static ssize_t tsi148_master_write(struct vme_master_resource *image, void *buf,
 		if (done == count)
 			goto out;
 	}
-	if ((uintptr_t)addr & 0x2) {
+	if ((uintptr_t)(addr + done) & 0x2) {
 		if ((count - done) < 2) {
 			iowrite8(*(u8 *)(buf + done), addr + done);
 			done += 1;
-- 
1.8.3.2

