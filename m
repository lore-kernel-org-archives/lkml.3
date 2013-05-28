Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111Ab3E1DzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52501 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758814Ab3E1DyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:13 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nicholas Bellinger" <nab@linux-iscsi.org>,
        "Shlomo Pongratz" <shlomop@mellanox.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.390710444@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [15/94] iscsi-target: Fix processing of OOO commands
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Shlomo Pongratz <shlomop@mellanox.com>

commit 3eccfdb01da58fbd0f789ae6ca61cee3769e26de upstream.

Fix two issues in OOO commands processing done at iscsit_attach_ooo_cmdsn.

Handle command serial numbers wrap around by using iscsi_sna_lt and not regular comparisson.

The routine iterates until it finds an entry whose serial number is greater than the serial number of
the new one, thus the new entry should be inserted before that entry and not after.

Signed-off-by: Shlomo Pongratz <shlomop@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/iscsi/iscsi_target_erl1.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -824,7 +824,7 @@ static int iscsit_attach_ooo_cmdsn(
 		/*
 		 * CmdSN is greater than the tail of the list.
 		 */
-		if (ooo_tail->cmdsn < ooo_cmdsn->cmdsn)
+		if (iscsi_sna_lt(ooo_tail->cmdsn, ooo_cmdsn->cmdsn))
 			list_add_tail(&ooo_cmdsn->ooo_list,
 					&sess->sess_ooo_cmdsn_list);
 		else {
@@ -834,11 +834,12 @@ static int iscsit_attach_ooo_cmdsn(
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

