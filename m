Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbaLWAkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 19:40:18 -0500
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36096 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaLWAkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 19:40:12 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 1/2] x86, vdso: Use asm volatile in __getcpu
Date: Mon, 22 Dec 2014 16:39:56 -0800
Message-Id: <6a3798f5f28095773dd71cf98fcee2b8edb77f2d.1419295081.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1419295081.git.luto@amacapital.net>
References: <cover.1419295081.git.luto@amacapital.net>
In-Reply-To: <cover.1419295081.git.luto@amacapital.net>
References: <cover.1419295081.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Linux 3.18 and below, GCC hoists the lsl instructions in the
pvclock code all the way to the beginning of __vdso_clock_gettime,
slowing the non-paravirt case significantly.  For unknown reasons,
presumably related to the removal of a branch, the performance issue
is gone as of

e76b027e6408 x86,vdso: Use LSL unconditionally for vgetcpu

but I don't trust GCC enough to expect the problem to stay fixed.

There should be no correctness issue, because the __getcpu calls in
__vdso_vlock_gettime were never necessary in the first place.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/vgtod.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index e7e9682a33e9..f556c4843aa1 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -80,9 +80,11 @@ static inline unsigned int __getcpu(void)
 
 	/*
 	 * Load per CPU data from GDT.  LSL is faster than RDTSCP and
-	 * works on all CPUs.
+	 * works on all CPUs.  This is volatile so that it orders
+	 * correctly wrt barrier() and to keep gcc from cleverly
+	 * hoisting it out of the calling function.
 	 */
-	asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
+	asm volatile ("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
 
 	return p;
 }
-- 
2.1.0

