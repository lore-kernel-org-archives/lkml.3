Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab3LLJZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:25:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab3LLJZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:25:43 -0500
Date: Thu, 12 Dec 2013 17:25:42 +0800
From: Dave Young <dyoung@redhat.com>
To: akpm@linux-foundation.org, rob@landley.net, gregkh@linuxfoundation.org,
        grant.likely@secretlab.ca, sebastian.capella@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] use initmpfs even if there's root= cmdline
Message-ID: <20131212092542.GA14218@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Current code use ramfs instead of tmpfs for stub when root= defined.

But for real use case with initramfs, usually there's like cmdline like
root=UUID=$UUID the root dev is the real device. For that case we have
no way to use initmpfs, thus this patch removes the limitation so tmpfs
can benefit more people.

The logic become:
if CONFIG_TMPFS && rootfstype is not ramfs
    use tmpfs
else
    use ramfs

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 init/do_mounts.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 8e5addc..6fde471 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -622,8 +622,8 @@ int __init init_rootfs(void)
 	if (err)
 		return err;
 
-	if (IS_ENABLED(CONFIG_TMPFS) && !saved_root_name[0] &&
-		(!root_fs_names || strstr(root_fs_names, "tmpfs"))) {
+	if (IS_ENABLED(CONFIG_TMPFS) &&
+		(root_fs_names && !(strstr(root_fs_names, "ramfs")))) {
 		err = shmem_init();
 		is_tmpfs = true;
 	} else {

