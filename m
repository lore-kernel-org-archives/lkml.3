Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965664Ab3GSF0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:26:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965630Ab3GSF0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>
Subject: [ 26/72] parisc: optimize mtsp(0,sr) inline assembly
Date: Thu, 18 Jul 2013 22:25:43 -0700
Message-Id: <20130719052601.655272428@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 92b59929825d67db575043a76651865d16873b36 upstream.

If the value which should be moved into a space register is zero, we can
optimize the inline assembly to become "mtsp %r0,%srX".

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/asm/special_insns.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/parisc/include/asm/special_insns.h
+++ b/arch/parisc/include/asm/special_insns.h
@@ -32,9 +32,12 @@ static inline void set_eiem(unsigned lon
 	cr;				\
 })
 
-#define mtsp(gr, cr) \
-	__asm__ __volatile__("mtsp %0,%1" \
+#define mtsp(val, cr) \
+	{ if (__builtin_constant_p(val) && ((val) == 0)) \
+	 __asm__ __volatile__("mtsp %%r0,%0" : : "i" (cr) : "memory"); \
+	else \
+	 __asm__ __volatile__("mtsp %0,%1" \
 		: /* no outputs */ \
-		: "r" (gr), "i" (cr) : "memory")
+		: "r" (val), "i" (cr) : "memory"); }
 
 #endif /* __PARISC_SPECIAL_INSNS_H */


