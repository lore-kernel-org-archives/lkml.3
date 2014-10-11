Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaJKTNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 15:13:55 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:39837 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaJKTNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 15:13:54 -0400
From: =?UTF-8?q?Filipe=20Gon=C3=A7alves?= <filipe@codinghighway.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Filipe=20Gon=C3=A7alves?= <filipe@codinghighway.com>
Subject: [PATCH 1/1] drivers/staging: Fixed sparse error "directive in argument list"
Date: Sat, 11 Oct 2014 20:13:42 +0100
Message-Id: <1413054822-7894-1-git-send-email-filipe@codinghighway.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a sparse warning on layout.c (ptlrpc) that was caused by having preprocessor directives in the arguments to a macro.

Signed-off-by: Filipe Gonçalves <filipe@codinghighway.com>
---
 drivers/staging/lustre/lustre/ptlrpc/layout.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/layout.c b/drivers/staging/lustre/lustre/ptlrpc/layout.c
index 5b83371..211df78 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/layout.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/layout.c
@@ -978,10 +978,11 @@ struct req_msg_field RMF_CONN =
 EXPORT_SYMBOL(RMF_CONN);
 
 struct req_msg_field RMF_CONNECT_DATA =
+#if LUSTRE_VERSION_CODE > OBD_OCD_VERSION(2, 7, 50, 0)
 	DEFINE_MSGF("cdata",
 		    RMF_F_NO_SIZE_CHECK /* we allow extra space for interop */,
-#if LUSTRE_VERSION_CODE > OBD_OCD_VERSION(2, 7, 50, 0)
 		    sizeof(struct obd_connect_data),
+		    lustre_swab_connect, NULL);
 #else
 /* For interoperability with 1.8 and 2.0 clients/servers.
  * The RPC verification code allows larger RPC buffers, but not
@@ -990,9 +991,11 @@ struct req_msg_field RMF_CONNECT_DATA =
  * size is at least as large as obd_connect_data_v1.  That is not
  * not in itself harmful, since the chance of just corrupting this
  * field is low.  See JIRA LU-16 for details. */
+	DEFINE_MSGF("cdata",
+		    RMF_F_NO_SIZE_CHECK /* we allow extra space for interop */,
 		    sizeof(struct obd_connect_data_v1),
-#endif
 		    lustre_swab_connect, NULL);
+#endif
 EXPORT_SYMBOL(RMF_CONNECT_DATA);
 
 struct req_msg_field RMF_DLM_REQ =
-- 
1.9.1

