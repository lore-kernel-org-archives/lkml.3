Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaGYOnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:43:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:25721 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbaGYOnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:43:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,731,1400050800"; 
   d="scan'208";a="575405165"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 2/2] x86: Resolve some shadow warnings
Date: Fri, 25 Jul 2014 07:43:17 -0700
Message-Id: <1406299397-30077-2-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406299397-30077-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1406299397-30077-1-git-send-email-jeffrey.t.kirsher@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Resolve some shadow warnings and also eliminate some hazards
for possible name clashes on local variables declared in inner
blocks produced by those macros. Passing an outer variable with
the same name as an inner variable would cause serious confusion,
so prepend the inner variables with underscores to reduce the
exposure.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 arch/x86/ia32/ia32_signal.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index f9e181a..11e4987 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -135,7 +135,7 @@ int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
 #define loadsegment_ds(v)	loadsegment(ds, v)
 #define loadsegment_es(v)	loadsegment(es, v)
 
-#define get_user_seg(seg)	({ unsigned int v; savesegment(seg, v); v; })
+#define get_user_seg(seg)	({ unsigned int _v; savesegment(seg, _v); _v; })
 #define set_user_seg(seg, v)	loadsegment_##seg(v)
 
 #define COPY(x)			{		\
@@ -143,9 +143,9 @@ int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
 }
 
 #define GET_SEG(seg)		({			\
-	unsigned short tmp;				\
-	get_user_ex(tmp, &sc->seg);			\
-	tmp;						\
+	unsigned short _tmp;				\
+	get_user_ex(_tmp, &sc->seg);			\
+	_tmp;						\
 })
 
 #define COPY_SEG_CPL3(seg)	do {			\
@@ -153,11 +153,11 @@ int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
 } while (0)
 
 #define RELOAD_SEG(seg)		{		\
-	unsigned int pre = GET_SEG(seg);	\
-	unsigned int cur = get_user_seg(seg);	\
-	pre |= 3;				\
-	if (pre != cur)				\
-		set_user_seg(seg, pre);		\
+	unsigned int _pre = GET_SEG(seg);	\
+	unsigned int _cur = get_user_seg(seg);	\
+	_pre |= 3;				\
+	if (_pre != _cur)			\
+		set_user_seg(seg, _pre);	\
 }
 
 static int ia32_restore_sigcontext(struct pt_regs *regs,
-- 
1.9.3

