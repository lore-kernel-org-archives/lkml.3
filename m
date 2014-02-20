Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400AbaBUAz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:55:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbaBTXvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jim Strouth <james.strouth@ge.com>, Martyn Welch <martyn.welch@ge.com>
Subject: [PATCH 3.10 40/66] VME: Correct read/write alignment algorithm
Date: Thu, 20 Feb 2014 15:51:39 -0800
Message-Id: <20140220234910.643532806@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
References: <20140220234909.482516304@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/vme/bridges/vme_ca91cx42.c |    4 ++--
 drivers/vme/bridges/vme_tsi148.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/vme/bridges/vme_ca91cx42.c
+++ b/drivers/vme/bridges/vme_ca91cx42.c
@@ -880,7 +880,7 @@ static ssize_t ca91cx42_master_read(stru
 		if (done == count)
 			goto out;
 	}
-	if ((uintptr_t)addr & 0x2) {
+	if ((uintptr_t)(addr + done) & 0x2) {
 		if ((count - done) < 2) {
 			*(u8 *)(buf + done) = ioread8(addr + done);
 			done += 1;
@@ -934,7 +934,7 @@ static ssize_t ca91cx42_master_write(str
 		if (done == count)
 			goto out;
 	}
-	if ((uintptr_t)addr & 0x2) {
+	if ((uintptr_t)(addr + done) & 0x2) {
 		if ((count - done) < 2) {
 			iowrite8(*(u8 *)(buf + done), addr + done);
 			done += 1;
--- a/drivers/vme/bridges/vme_tsi148.c
+++ b/drivers/vme/bridges/vme_tsi148.c
@@ -1283,7 +1283,7 @@ static ssize_t tsi148_master_read(struct
 		if (done == count)
 			goto out;
 	}
-	if ((uintptr_t)addr & 0x2) {
+	if ((uintptr_t)(addr + done) & 0x2) {
 		if ((count - done) < 2) {
 			*(u8 *)(buf + done) = ioread8(addr + done);
 			done += 1;
@@ -1365,7 +1365,7 @@ static ssize_t tsi148_master_write(struc
 		if (done == count)
 			goto out;
 	}
-	if ((uintptr_t)addr & 0x2) {
+	if ((uintptr_t)(addr + done) & 0x2) {
 		if ((count - done) < 2) {
 			iowrite8(*(u8 *)(buf + done), addr + done);
 			done += 1;


