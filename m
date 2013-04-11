Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935810Ab3DKVJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:09:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5406 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935666Ab3DKUtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:10 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=F5vN_0FPRhQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=gicdbwnZX2AA:10 a=vpVRfoo1AAAA:8 a=VwQbUJbxAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=0yVQzcu7H6MA:10 a=jeBq3FmKZ4MA:10 a=OT08IXiO6bteR6n1:21 a=yGuIvYPAdrRTr9pX:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202604.987519891@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Josef Bacik <jbacik@fusionio.com>
Subject: [ 114/171 ] Btrfs: limit the global reserve to 512mb
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0114-Btrfs-limit-the-global-reserve-to-512mb.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

[ Upstream commit fdf30d1c1b386e1b73116cc7e0fb14e962b763b0 ]

A user reported a problem where he was getting early ENOSPC with hundreds of
gigs of free data space and 6 gigs of free metadata space.  This is because the
global block reserve was taking up the entire free metadata space.  This is
ridiculous, we have infrastructure in place to throttle if we start using too
much of the global reserve, so instead of letting it get this huge just limit it
to 512mb so that users can still get work done.  This allowed the user to
complete his rsync without issues.  Thanks

Cc: stable@vger.kernel.org
Reported-and-tested-by: Stefan Priebe <s.priebe@profihost.ag>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ba58024..f1bdfb5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4301,7 +4301,7 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 	spin_lock(&sinfo->lock);
 	spin_lock(&block_rsv->lock);
 
-	block_rsv->size = num_bytes;
+	block_rsv->size = min_t(u64, num_bytes, 512 * 1024 * 1024);
 
 	num_bytes = sinfo->bytes_used + sinfo->bytes_pinned +
 		    sinfo->bytes_reserved + sinfo->bytes_readonly +
-- 
1.7.10.4


