Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbaLEXu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:50:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaLEWpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.17 006/122] MIPS: asm: uaccess: Add v1 register to clobber list on EVA
Date: Fri,  5 Dec 2014 14:43:00 -0800
Message-Id: <20141205223306.465117381@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit 58563817cfed0432e9a54476d5fc6c3aeba475e4 upstream.

When EVA is turned on and prefetching is being used in memcpy.S,
the v1 register is being used as a helper register to the PREFE
instruction. However, v1 ($3) was not in the clobber list, which
means that the compiler did not preserve it across function calls,
and that could corrupt the value of the register leading to all
sorts of userland crashes. We fix this problem by using the
DADDI_SCRATCH macro to define the clobbered register when
CONFIG_EVA && CONFIG_CPU_HAS_PREFETCH are enabled.

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/8510/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/uaccess.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/mips/include/asm/uaccess.h
+++ b/arch/mips/include/asm/uaccess.h
@@ -773,10 +773,11 @@ extern void __put_user_unaligned_unknown
 	"jal\t" #destination "\n\t"
 #endif
 
-#ifndef CONFIG_CPU_DADDI_WORKAROUNDS
-#define DADDI_SCRATCH "$0"
-#else
+#if defined(CONFIG_CPU_DADDI_WORKAROUNDS) || (defined(CONFIG_EVA) &&	\
+					      defined(CONFIG_CPU_HAS_PREFETCH))
 #define DADDI_SCRATCH "$3"
+#else
+#define DADDI_SCRATCH "$0"
 #endif
 
 extern size_t __copy_user(void *__to, const void *__from, size_t __n);


