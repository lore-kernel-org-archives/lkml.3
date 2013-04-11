Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935495Ab3DKNxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:53:35 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:57868 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934557Ab3DKNxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:53:34 -0400
From: Matthieu CASTET <matthieu.castet@parrot.com>
To: linux-kernel@vger.kernel.org
Cc: Matthieu CASTET <matthieu.castet@parrot.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] binfmt_elf: fix return value in case of interpreter load failure
Date: Thu, 11 Apr 2013 15:53:09 +0200
Message-Id: <1365688389-29908-1-git-send-email-matthieu.castet@parrot.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code return the address instead of using PTR_ERR.

Also the check is done after adding e_entry. This can cause weird behaviour
because -errno + loc->interp_elf_ex.e_entry can produce a valid address.

Add a check to test load error before adding entry address. Also in this
case send SIGKILL instead of SIGSEGV to match what is done when loading binary.

Signed-off-by: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/binfmt_elf.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 3939829..8397f80 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -900,18 +900,21 @@ static int load_elf_binary(struct linux_binprm *bprm)
 					    interpreter,
 					    &interp_map_addr,
 					    load_bias);
-		if (!IS_ERR((void *)elf_entry)) {
-			/*
-			 * load_elf_interp() returns relocation
-			 * adjustment
-			 */
-			interp_load_addr = elf_entry;
-			elf_entry += loc->interp_elf_ex.e_entry;
+		if (BAD_ADDR(elf_entry)) {
+			force_sig(SIGKILL, current);
+			retval = IS_ERR((void *)elf_entry) ?
+					PTR_ERR((void *)elf_entry) : -EINVAL;
+			goto out_free_dentry;
 		}
+		/*
+		 * load_elf_interp() returns relocation
+		 * adjustment
+		 */
+		interp_load_addr = elf_entry;
+		elf_entry += loc->interp_elf_ex.e_entry;
 		if (BAD_ADDR(elf_entry)) {
 			force_sig(SIGSEGV, current);
-			retval = IS_ERR((void *)elf_entry) ?
-					(int)elf_entry : -EINVAL;
+			retval = -EINVAL;
 			goto out_free_dentry;
 		}
 		reloc_func_desc = interp_load_addr;
-- 
1.7.10.4

