Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaAPXtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:49:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbaAPXs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:48:58 -0500
Date: Thu, 16 Jan 2014 18:48:17 -0500
From: Kyle McMartin <kyle@redhat.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com
Subject: [PATCH] arm64: fix strnlen_user when count <= strlen
Message-ID: <20140116234817.GP18705@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I received a bug report about the ruby test-suite failing on AArch64 when
attempting to pass MAX_ARG_STRLEN sized args to execv[1]. It was
expecting an E2BIG returned, but instead was receiving ENOMEM, and
concatenating the argument strings in funky ways.

The problem appeared to be in __strnlen_user on arm64, as when
instrumenting fs/exec.c to compare the results of the asm-generic
strnlen_user, I noticed an off-by-one on the result:
long-param-test: optimized strnlen_user (131072) and naive (131073) disagree!

As a result, fix strnlen_user to match expected behaviour as documented
in lib/strnlen_user.c, and return count+1 when count would be exceeded.

I didn't feel comfortable prodding the assembler, so I just worked
around it in the wrapper.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

1. https://bugzilla.redhat.com/show_bug.cgi?id=1038676

---

I tested that this behaves the same as the lib/strnlen_user.c version
with some hacked together code here:
http://kyle.fedorapeople.org/strnlen_user-test.tar.xz

{master}kmcmarti ~/strnlen_user-test $ ./test
=== count = 0 ===
strnlen_user = 0
__strnlen_user = 0
fixed__strnlen_user = 0
=== count < strlen ===
strnlen_user = 7
__strnlen_user = 6
fixed__strnlen_user = 7
=== count = strlen ===
strnlen_user = 13
__strnlen_user = 12
fixed__strnlen_user = 13
=== count > strlen ===
strnlen_user = 13
__strnlen_user = 13
fixed__strnlen_user = 13

--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -290,9 +290,15 @@ static inline long __must_check strnlen_user(const char __user *s, long n)
 {
 	unsigned long res = 0;
 
+	if (unlikely(n <= 0))
+		return 0;
+
 	if (__addr_ok(s))
 		res = __strnlen_user(s, n);
 
+	if (unlikely(res >= n))
+		return n + 1;
+
 	return res;
 }
 
