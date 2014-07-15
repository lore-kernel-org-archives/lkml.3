Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbaGOVyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:54:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54843 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbaGOViV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Victor Kamensky <victor.kamensky@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 156/198] arm64: ptrace: fix empty registers set in prstatus of aarch32 process core
Date: Tue, 15 Jul 2014 14:30:26 -0700
Message-Id: <1405459868-15089-157-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Kamensky <victor.kamensky@linaro.org>

commit 2227901a0230d8fde81ba9c602d649839390f56b upstream.

Currently core file of aarch32 process prstatus note has empty
registers set. As result aarch32 core files create by V8 kernel are
not very useful.

It happens because compat_gpr_get and compat_gpr_set functions can
copy registers values to/from either kbuf or ubuf. ELF core file
collection function fill_thread_core_info calls compat_gpr_get
with kbuf set and ubuf set to 0. But current compat_gpr_get and
compat_gpr_set function handle copy to/from only ubuf case.

Fix is to handle kbuf and ubuf as two separate cases in similar
way as other functions like user_regset_copyout, user_regset_copyin do.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/kernel/ptrace.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index bf288e4..7a50b86 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -650,11 +650,16 @@ static int compat_gpr_get(struct task_struct *target,
 			reg = task_pt_regs(target)->regs[idx];
 		}
 
-		ret = copy_to_user(ubuf, &reg, sizeof(reg));
-		if (ret)
-			break;
-
-		ubuf += sizeof(reg);
+		if (kbuf) {
+			memcpy(kbuf, &reg, sizeof(reg));
+			kbuf += sizeof(reg);
+		} else {
+			ret = copy_to_user(ubuf, &reg, sizeof(reg));
+			if (ret)
+				break;
+
+			ubuf += sizeof(reg);
+		}
 	}
 
 	return ret;
@@ -684,11 +689,16 @@ static int compat_gpr_set(struct task_struct *target,
 		unsigned int idx = start + i;
 		compat_ulong_t reg;
 
-		ret = copy_from_user(&reg, ubuf, sizeof(reg));
-		if (ret)
-			return ret;
+		if (kbuf) {
+			memcpy(&reg, kbuf, sizeof(reg));
+			kbuf += sizeof(reg);
+		} else {
+			ret = copy_from_user(&reg, ubuf, sizeof(reg));
+			if (ret)
+				return ret;
 
-		ubuf += sizeof(reg);
+			ubuf += sizeof(reg);
+		}
 
 		switch (idx) {
 		case 15:
-- 
1.9.1

