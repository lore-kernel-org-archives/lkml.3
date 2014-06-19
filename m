Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbaFSKzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 06:55:37 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42993 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756475AbaFSKzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:55:36 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <catalin.marinas@arm.com>, <will.deacon@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] arm64: add the ability to hook the fault code
Date: Thu, 19 Jun 2014 18:54:56 +0800
Message-ID: <1403175296-25181-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-19_04:2014-06-19,2014-06-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1406190128
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ability to hook the fault code for future use.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 arch/arm64/include/asm/system_misc.h |    4 ++++
 arch/arm64/mm/fault.c                |   12 ++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
index 7a18fab..a8c19dd 100644
--- a/arch/arm64/include/asm/system_misc.h
+++ b/arch/arm64/include/asm/system_misc.h
@@ -37,6 +37,10 @@ void hook_debug_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
 					     struct pt_regs *),
 			   int sig, int code, const char *name);
 
+void hook_fault_code(int nr,
+		int (*fn)(unsigned long, unsigned int, struct pt_regs *),
+		int sig, int code, const char *name);
+
 struct mm_struct;
 extern void show_pte(struct mm_struct *mm, unsigned long addr);
 extern void __show_regs(struct pt_regs *);
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index bcc965e..7902fb6 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -447,6 +447,18 @@ static const char *fault_name(unsigned int esr)
 	return inf->name;
 }
 
+void __init hook_fault_code(int nr,
+		int (*fn)(unsigned long, unsigned int, struct pt_regs *),
+		int sig, int code, const char *name)
+{
+	BUG_ON(nr < 0 || nr >= ARRAY_SIZE(fault_info));
+
+	fault_info[nr].fn   = fn;
+	fault_info[nr].sig  = sig;
+	fault_info[nr].code = code;
+	fault_info[nr].name = name;
+}
+
 /*
  * Dispatch a data abort to the relevant handler.
  */
-- 
1.7.9.5

