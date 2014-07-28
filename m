Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbaG1TFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:05:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaG1TFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:05:40 -0400
From: Eduardo Habkost <ehabkost@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Chris Wright <chrisw@sous-sol.org>,
        Alok Kataria <akataria@vmware.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86, paravirt: BUG_ON on {rd,wr}msr exceptions
Date: Mon, 28 Jul 2014 16:04:38 -0300
Message-Id: <1406574278-23946-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_PARAVIRT is enabled, the kernel is ignoring exceptions on
the {rd,wr}msr instructions. This makes serious issues (either on the
guest kernel, or on the host) be silently ignored, and is different from
the native MSR code (which does not ignore the exceptions).

As paravirt.h already includes linux/bug.h, I don't see what was the
original issue preventing BUG_ON from being used.

Change rdmsr(), wrmsr(), and rdmsrl() to BUG_ON() on errors.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
* Build-tested using allyesconfig, with no build errors.

* Tested by being able to detect the following host bug:
  https://bugzilla.redhat.com/show_bug.cgi?id=1025868
  (#GP exception on wrmsr(0x410, 0xfffffffffffffbff) during MCE
  initialization)
---
 arch/x86/include/asm/paravirt.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index cd6e161..7d42ca4 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -133,24 +133,27 @@ static inline int paravirt_write_msr(unsigned msr, unsigned low, unsigned high)
 	return PVOP_CALL3(int, pv_cpu_ops.write_msr, msr, low, high);
 }
 
-/* These should all do BUG_ON(_err), but our headers are too tangled. */
 #define rdmsr(msr, val1, val2)			\
 do {						\
 	int _err;				\
 	u64 _l = paravirt_read_msr(msr, &_err);	\
+	BUG_ON(_err);				\
 	val1 = (u32)_l;				\
 	val2 = _l >> 32;			\
 } while (0)
 
-#define wrmsr(msr, val1, val2)			\
-do {						\
-	paravirt_write_msr(msr, val1, val2);	\
+#define wrmsr(msr, val1, val2)				\
+do {							\
+	int _err;					\
+	_err = paravirt_write_msr(msr, val1, val2);	\
+	BUG_ON(_err);					\
 } while (0)
 
 #define rdmsrl(msr, val)			\
 do {						\
 	int _err;				\
 	val = paravirt_read_msr(msr, &_err);	\
+	BUG_ON(_err);				\
 } while (0)
 
 #define wrmsrl(msr, val)	wrmsr(msr, (u32)((u64)(val)), ((u64)(val))>>32)
-- 
1.9.3

