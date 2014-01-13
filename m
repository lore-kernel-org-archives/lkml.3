Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaAMO16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:27:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51312 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaAMOZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:25:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 33/96] iscsi-target: Fix-up all zero data-length CDBs with R/W_BIT set
Date: Mon, 13 Jan 2014 14:23:56 +0000
Message-Id: <1389623099-18783-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 4454b66cb67f14c33cd70ddcf0ff4985b26324b7 upstream.

This patch changes special case handling for ISCSI_OP_SCSI_CMD
where an initiator sends a zero length Expected Data Transfer
Length (EDTL), but still sets the WRITE and/or READ flag bits
when no payload transfer is requested.

Many, many moons ago two special cases where added for an ancient
version of ESX that has long since been fixed, so instead of adding
a new special case for the reported bug with a Broadcom 57800 NIC,
go ahead and always strip off the incorrect WRITE + READ flag bits.

Also, avoid sending a reject here, as RFC-3720 does mandate this
case be handled without protocol error.

Reported-by: Witold Bazakbal <865perl@wp.pl>
Tested-by: Witold Bazakbal <865perl@wp.pl>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/iscsi/iscsi_target.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 3e7ac0c..955392e 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -803,24 +803,22 @@ static int iscsit_handle_scsi_cmd(
 	if (((hdr->flags & ISCSI_FLAG_CMD_READ) ||
 	     (hdr->flags & ISCSI_FLAG_CMD_WRITE)) && !hdr->data_length) {
 		/*
-		 * Vmware ESX v3.0 uses a modified Cisco Initiator (v3.4.2)
-		 * that adds support for RESERVE/RELEASE.  There is a bug
-		 * add with this new functionality that sets R/W bits when
-		 * neither CDB carries any READ or WRITE datapayloads.
+		 * From RFC-3720 Section 10.3.1:
+		 *
+		 * "Either or both of R and W MAY be 1 when either the
+		 *  Expected Data Transfer Length and/or Bidirectional Read
+		 *  Expected Data Transfer Length are 0"
+		 *
+		 * For this case, go ahead and clear the unnecssary bits
+		 * to avoid any confusion with ->data_direction.
 		 */
-		if ((hdr->cdb[0] == 0x16) || (hdr->cdb[0] == 0x17)) {
-			hdr->flags &= ~ISCSI_FLAG_CMD_READ;
-			hdr->flags &= ~ISCSI_FLAG_CMD_WRITE;
-			goto done;
-		}
+		hdr->flags &= ~ISCSI_FLAG_CMD_READ;
+		hdr->flags &= ~ISCSI_FLAG_CMD_WRITE;
 
-		pr_err("ISCSI_FLAG_CMD_READ or ISCSI_FLAG_CMD_WRITE"
+		pr_warn("ISCSI_FLAG_CMD_READ or ISCSI_FLAG_CMD_WRITE"
 			" set when Expected Data Transfer Length is 0 for"
-			" CDB: 0x%02x. Bad iSCSI Initiator.\n", hdr->cdb[0]);
-		return iscsit_add_reject(ISCSI_REASON_BOOKMARK_INVALID, 1,
-				buf, conn);
+			" CDB: 0x%02x, Fixing up flags\n", hdr->cdb[0]);
 	}
-done:
 
 	if (!(hdr->flags & ISCSI_FLAG_CMD_READ) &&
 	    !(hdr->flags & ISCSI_FLAG_CMD_WRITE) && (hdr->data_length != 0)) {
-- 
1.8.3.2

