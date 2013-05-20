Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab3ETK6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:58:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56407 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab3ETKyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:54:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Shlomo Pongratz <shlomop@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 100/115] iscsi-target: Fix processing of OOO commands
Date: Mon, 20 May 2013 11:51:40 +0100
Message-Id: <1369047116-9378-101-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shlomo Pongratz <shlomop@mellanox.com>

commit 3eccfdb01da58fbd0f789ae6ca61cee3769e26de upstream.

Fix two issues in OOO commands processing done at iscsit_attach_ooo_cmdsn.

Handle command serial numbers wrap around by using iscsi_sna_lt and not regular comparisson.

The routine iterates until it finds an entry whose serial number is greater than the serial number of
the new one, thus the new entry should be inserted before that entry and not after.

Signed-off-by: Shlomo Pongratz <shlomop@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/iscsi/iscsi_target_erl1.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index ecdd46d..0f49a97 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -819,7 +819,7 @@ static int iscsit_attach_ooo_cmdsn(
 		/*
 		 * CmdSN is greater than the tail of the list.
 		 */
-		if (ooo_tail->cmdsn < ooo_cmdsn->cmdsn)
+		if (iscsi_sna_lt(ooo_tail->cmdsn, ooo_cmdsn->cmdsn))
 			list_add_tail(&ooo_cmdsn->ooo_list,
 					&sess->sess_ooo_cmdsn_list);
 		else {
@@ -829,11 +829,12 @@ static int iscsit_attach_ooo_cmdsn(
 			 */
 			list_for_each_entry(ooo_tmp, &sess->sess_ooo_cmdsn_list,
 						ooo_list) {
-				if (ooo_tmp->cmdsn < ooo_cmdsn->cmdsn)
+				if (iscsi_sna_lt(ooo_tmp->cmdsn, ooo_cmdsn->cmdsn))
 					continue;
 
+				/* Insert before this entry */
 				list_add(&ooo_cmdsn->ooo_list,
-					&ooo_tmp->ooo_list);
+					ooo_tmp->ooo_list.prev);
 				break;
 			}
 		}
-- 
1.8.1.2

