Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212Ab3EAWte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:49:34 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46313 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760091Ab3EAWtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:49:31 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH] fs/binfmt_misc: avoid accidental exec disable via binfmt_misc loop
Date: Wed,  1 May 2013 15:49:20 -0700
Message-Id: <1367448560-15514-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050122-5806-0000-0000-000020F6B220
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my ubuntu system the update-binfmts command recently went berserk and
added a binfmt_misc for executing x86_64 elf files via a static qemu.
That static qemu is also an x86_64 elf (as are the majority of the
binaries on my x86_64 system). This prevented me from execing any new
programs and, due to the lack of an open root shell, made it impossible
for me to disable the offending binfmt.

[For anyone in a similar situation with update-binfmts going berserk, delete your
native arch's qemu from /var/lib/binfmts/ to allow binfmt-support to be installed]

This fix is a hack to disable binfmt_misc handlers when a loop occurs in
the hope of saving the system. Ideally, it would also attempt to
re-resolve the binfmt that was currently being resolved instead of
failing that one and allowing all that follows, but this behavior is
much better than the failure of everything that occurs right now.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 fs/binfmt_misc.c | 5 +++++
 1 file changed, 5 insertions(+)

---

If this is considered too terrible, even adding a hack to sysrq to let me
recover the system (in the future) without a system reset would be appreciated.

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 751df5e..24e1ce6 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -197,6 +197,11 @@ static int load_misc_binary(struct linux_binprm *bprm)
 		goto _error;
 
 	retval = search_binary_handler(bprm);
+	if (retval == -ELOOP) {
+		pr_err("binfmt misc %s is involved in a loop, disabling.\n",
+				fmt->name);
+		clear_bit(Enabled, &fmt->flags);
+	}
 	if (retval < 0)
 		goto _error;
 
-- 
1.8.2.2

