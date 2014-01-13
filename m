Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbaAMQpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:45:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53183 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbaAMQCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 080/208] arm64: ptrace: avoid using HW_BREAKPOINT_EMPTY for disabled events
Date: Mon, 13 Jan 2014 15:58:41 +0000
Message-Id: <1389628849-1614-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit cdc27c27843248ae7eb0df5fc261dd004eaa5670 upstream.

Commit 8f34a1da35ae ("arm64: ptrace: use HW_BREAKPOINT_EMPTY type for
disabled breakpoints") fixed an issue with GDB trying to zero breakpoint
control registers. The problem there is that the arch hw_breakpoint code
will attempt to create a (disabled), execute breakpoint of length 0.

This will fail validation and report unexpected failure to GDB. To avoid
this, we treated disabled breakpoints as HW_BREAKPOINT_EMPTY, but that
seems to have broken with recent kernels, causing watchpoints to be
treated as TYPE_INST in the core code and returning ENOSPC for any
further breakpoints.

This patch fixes the problem by prioritising the `enable' field of the
breakpoint: if it is cleared, we simply update the perf_event_attr to
indicate that the thing is disabled and don't bother changing either the
type or the length. This reinforces the behaviour that the breakpoint
control register is essentially read-only apart from the enable bit
when disabling a breakpoint.

Reported-by: Aaron Liu <liucy214@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/kernel/ptrace.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index fecdbf7..c484d56 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -214,31 +214,29 @@ static int ptrace_hbp_fill_attr_ctrl(unsigned int note_type,
 {
 	int err, len, type, disabled = !ctrl.enabled;
 
-	if (disabled) {
-		len = 0;
-		type = HW_BREAKPOINT_EMPTY;
-	} else {
-		err = arch_bp_generic_fields(ctrl, &len, &type);
-		if (err)
-			return err;
-
-		switch (note_type) {
-		case NT_ARM_HW_BREAK:
-			if ((type & HW_BREAKPOINT_X) != type)
-				return -EINVAL;
-			break;
-		case NT_ARM_HW_WATCH:
-			if ((type & HW_BREAKPOINT_RW) != type)
-				return -EINVAL;
-			break;
-		default:
+	attr->disabled = disabled;
+	if (disabled)
+		return 0;
+
+	err = arch_bp_generic_fields(ctrl, &len, &type);
+	if (err)
+		return err;
+
+	switch (note_type) {
+	case NT_ARM_HW_BREAK:
+		if ((type & HW_BREAKPOINT_X) != type)
 			return -EINVAL;
-		}
+		break;
+	case NT_ARM_HW_WATCH:
+		if ((type & HW_BREAKPOINT_RW) != type)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	attr->bp_len	= len;
 	attr->bp_type	= type;
-	attr->disabled	= disabled;
 
 	return 0;
 }
-- 
1.8.3.2

