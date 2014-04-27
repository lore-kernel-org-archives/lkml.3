Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaD0RIP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:08:15 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48018 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbaD0RIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:00 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: James Nunez <james.a.nunez@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 18/47] staging/lustre/hsm: HSM requests not delivered
Date: Sun, 27 Apr 2014 13:06:42 -0400
Message-Id: <1398618431-29757-19-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Nunez <james.a.nunez@intel.com>

The total size of an HSM archive request may exceed the
desired (LNET) message. When this happens, it can hang
the client and not allow the archive request to succeed.

Before we know the total size of the hsm_action_items, we
need to limit the size of the reguest. Doing this limits
the number of items that can be sent in one archive request.
We'e reduced the size allowed for the user archive request
to MDS_MAXREQSIZE/3.

Signed-off-by: James Nunez <james.a.nunez@intel.com>
Reviewed-on: http://review.whamcloud.com/9393
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4639
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_net.h | 2 ++
 drivers/staging/lustre/lustre/llite/dir.c          | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index 745adbb..7640e17 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -264,6 +264,8 @@
 #define LDLM_MAXREQSIZE   (5 * 1024)
 #define LDLM_MAXREPSIZE   (1024)
 
+#define MDS_MAXREQSIZE		(5 * 1024)	/* >= 4736 */
+
 #define OST_MAXREQSIZE		(5 * 1024)
 
 /* Macro to hide a typecast. */
diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index 7fbc18e..c391b60 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -1804,6 +1804,11 @@ out_rmdir:
 		/* Compute the whole struct size */
 		totalsize = hur_len(hur);
 		OBD_FREE_PTR(hur);
+
+		/* Final size will be more than double totalsize */
+		if (totalsize >= MDS_MAXREQSIZE / 3)
+			return -E2BIG;
+
 		OBD_ALLOC_LARGE(hur, totalsize);
 		if (hur == NULL)
 			return -ENOMEM;
-- 
1.8.5.3

