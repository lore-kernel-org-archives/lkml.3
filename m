Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaGNKjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:39:03 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33267 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaGNKix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:38:53 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Steve French <sfrench@samba.org>
Cc: Sachin Prabhu <sprabhu@redhat.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs/cifs: Fix build warnings
Date: Mon, 14 Jul 2014 12:38:49 +0200
Message-Id: <1405334329-25271-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The sess_alloc_buffer(), sess_free_buffer(), sess_establish_session()
and sess_sendreceive() functions are only used by sess_auth_lanman(),
therefore should be guarded by the same #ifdef to prevent the following
compiler warnings:

	fs/cifs/sess.c:542:1: warning: 'sess_alloc_buffer' defined but not used [-Wunused-function]
	 sess_alloc_buffer(struct sess_data *sess_data, int wct)
	 ^
	fs/cifs/sess.c:580:1: warning: 'sess_free_buffer' defined but not used [-Wunused-function]
	 sess_free_buffer(struct sess_data *sess_data)
	 ^
	fs/cifs/sess.c:589:1: warning: 'sess_establish_session' defined but not used [-Wunused-function]
	 sess_establish_session(struct sess_data *sess_data)
	 ^
	fs/cifs/sess.c:621:1: warning: 'sess_sendreceive' defined but not used [-Wunused-function]
	 sess_sendreceive(struct sess_data *sess_data)
	 ^

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 fs/cifs/sess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index db6ecdf0974c..5fb7606b81ef 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -538,6 +538,7 @@ struct sess_data {
 	struct kvec iov[3];
 };
 
+#ifdef CONFIG_CIFS_WEAK_PW_HASH
 static int
 sess_alloc_buffer(struct sess_data *sess_data, int wct)
 {
@@ -644,7 +645,6 @@ sess_sendreceive(struct sess_data *sess_data)
  * in proc/fs/cifs or via mount parm.  Unfortunately this is
  * needed for old Win (e.g. Win95), some obscure NAS and OS/2
  */
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 static void
 sess_auth_lanman(struct sess_data *sess_data)
 {
-- 
2.0.1

