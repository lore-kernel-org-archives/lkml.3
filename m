Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab3GCSya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:54:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14694 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933211Ab3GCSk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:56 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=tkfT8ymuup8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=qSflzuEokKgA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=Atlr7haOKuAv7bOL3ZYA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184050.906563887@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [038/141] cifs: fix potential buffer overrun when composing a new options
 string
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0038-cifs-fix-potential-buffer-overrun-when-composing-a-n.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

[ Upstream commit 166faf21bd14bc5c5295a44874bf7f3930c30b20 ]

Consider the case where we have a very short ip= string in the original
mount options, and when we chase a referral we end up with a very long
IPv6 address. Be sure to allow for that possibility when estimating the
size of the string to allocate.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/cifs/cifs_dfs_ref.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index ce5cbd7..52527dd 100644
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
1.7.10.4


