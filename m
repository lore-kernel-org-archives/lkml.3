Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbaF1Rv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:51:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731AbaF1RvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.15 036/139] arm64: ptrace: fix empty registers set in prstatus of aarch32 process core
Date: Sat, 28 Jun 2014 10:46:37 -0700
Message-Id: <20140628174607.079174777@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/ptrace.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -650,11 +650,16 @@ static int compat_gpr_get(struct task_st
 			reg = task_pt_regs(target)->regs[idx];
 		}
 
-		ret = copy_to_user(ubuf, &reg, sizeof(reg));
-		if (ret)
-			break;
+		if (kbuf) {
+			memcpy(kbuf, &reg, sizeof(reg));
+			kbuf += sizeof(reg);
+		} else {
+			ret = copy_to_user(ubuf, &reg, sizeof(reg));
+			if (ret)
+				break;
 
-		ubuf += sizeof(reg);
+			ubuf += sizeof(reg);
+		}
 	}
 
 	return ret;
@@ -684,11 +689,16 @@ static int compat_gpr_set(struct task_st
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


