Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab3FDOOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:14:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46908 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab3FDOIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:08:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 51/70] cifs: fix potential buffer overrun when composing a new options string
Date: Tue,  4 Jun 2013 15:07:07 +0100
Message-Id: <1370354846-14213-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 166faf21bd14bc5c5295a44874bf7f3930c30b20 upstream.

Consider the case where we have a very short ip= string in the original
mount options, and when we chase a referral we end up with a very long
IPv6 address. Be sure to allow for that possibility when estimating the
size of the string to allocate.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/cifs/cifs_dfs_ref.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 2263144..d0e5fc5 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/vfs.h>
 #include <linux/fs.h>
+#include <linux/inet.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifsfs.h"
@@ -150,7 +151,8 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	 * assuming that we have 'unc=' and 'ip=' in
 	 * the original sb_mountdata
 	 */
-	md_len = strlen(sb_mountdata) + rc + strlen(ref->node_name) + 12;
+	md_len = strlen(sb_mountdata) + rc + strlen(ref->node_name) + 12 +
+			INET6_ADDRSTRLEN;
 	mountdata = kzalloc(md_len+1, GFP_KERNEL);
 	if (mountdata == NULL) {
 		rc = -ENOMEM;
-- 
1.8.1.2

