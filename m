Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab3EQVsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:48:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932385Ab3EQVr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:47:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shlomo Pongratz <shlomop@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 45/50] iscsi-target: Fix processing of OOO commands
Date: Fri, 17 May 2013 14:47:20 -0700
Message-Id: <20130517213847.403881854@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213842.447809965@linuxfoundation.org>
References: <20130517213842.447809965@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shlomo Pongratz <shlomop@mellanox.com>

commit 3eccfdb01da58fbd0f789ae6ca61cee3769e26de upstream.

Fix two issues in OOO commands processing done at iscsit_attach_ooo_cmdsn.

Handle command serial numbers wrap around by using iscsi_sna_lt and not regular comparisson.

The routine iterates until it finds an entry whose serial number is greater than the serial number of
the new one, thus the new entry should be inserted before that entry and not after.

Signed-off-by: Shlomo Pongratz <shlomop@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


