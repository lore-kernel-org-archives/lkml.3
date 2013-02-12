Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964Ab3BLBio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 20:38:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44252 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab3BLBin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 20:38:43 -0500
Date: Mon, 11 Feb 2013 17:37:52 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, jamie@shareable.org,
        ville.syrjala@linux.intel.com, bp@alien8.de, linux@arm.linux.org.uk,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jamie@shareable.org, torvalds@linux-foundation.org,
        ville.syrjala@linux.intel.com, bp@alien8.de, linux@arm.linux.org.uk,
        tglx@linutronix.de
In-Reply-To: <20130209110031.GA17833@n2100.arm.linux.org.uk>
References: <20130209110031.GA17833@n2100.arm.linux.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance get_user()
  warnings
Git-Commit-ID: b390784dc1649f6e6c5e66e5f53c21e715ccf39b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 17:37:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b390784dc1649f6e6c5e66e5f53c21e715ccf39b
Gitweb:     http://git.kernel.org/tip/b390784dc1649f6e6c5e66e5f53c21e715ccf39b
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 11 Feb 2013 16:27:28 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 11 Feb 2013 17:26:51 -0800

x86, mm: Use a bitfield to mask nuisance get_user() warnings

Even though it is never executed, gcc wants to warn for casting from
a large integer to a pointer.  Furthermore, using a variable with
__typeof__() doesn't work because __typeof__ retains storage
specifiers (const, restrict, volatile).

However, we can declare a bitfield using sizeof(), which is legal
because sizeof() is a constant expression.  This quiets the warning,
although the code generated isn't 100% identical from the baseline
before 96477b4 x86-32: Add support for 64bit get_user():

[x86-mb is baseline, x86-mm is this commit]

   text      data        bss     filename
113716147  15858380   35037184   tip.x86-mb/o.i386-allconfig/vmlinux
113716145  15858380   35037184   tip.x86-mm/o.i386-allconfig/vmlinux
 12989837   3597944   12255232   tip.x86-mb/o.i386-modconfig/vmlinux
 12989831   3597944   12255232   tip.x86-mm/o.i386-modconfig/vmlinux
  1462784    237608    1401988   tip.x86-mb/o.i386-noconfig/vmlinux
  1462837    237608    1401964   tip.x86-mm/o.i386-noconfig/vmlinux
  7938994    553688    7639040   tip.x86-mb/o.i386-pae/vmlinux
  7943136    557784    7639040   tip.x86-mm/o.i386-pae/vmlinux
  7186126    510572    6574080   tip.x86-mb/o.i386/vmlinux
  7186124    510572    6574080   tip.x86-mm/o.i386/vmlinux
103747269  33578856   65888256   tip.x86-mb/o.x86_64-allconfig/vmlinux
103746949  33578856   65888256   tip.x86-mm/o.x86_64-allconfig/vmlinux
 12116695  11035832   20160512   tip.x86-mb/o.x86_64-modconfig/vmlinux
 12116567  11035832   20160512   tip.x86-mm/o.x86_64-modconfig/vmlinux
  1700790    380524     511808   tip.x86-mb/o.x86_64-noconfig/vmlinux
  1700790    380524     511808   tip.x86-mm/o.x86_64-noconfig/vmlinux
 12413612   1133376    1101824   tip.x86-mb/o.x86_64/vmlinux
 12413484   1133376    1101824   tip.x86-mm/o.x86_64/vmlinux

Cc: Jamie Lokier <jamie@shareable.org>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20130209110031.GA17833@n2100.arm.linux.org.uk
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/uaccess.h | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 1e96326..a8d1265 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -168,31 +168,29 @@ do {						      \
 #define get_user(x, ptr)						\
 ({									\
 	int __ret_gu;							\
-	unsigned long __val_gu;						\
-	unsigned long long __val_gu8;					\
+	struct {							\
+		unsigned long long __val_n : 8*sizeof(*(ptr));		\
+	} __val_gu;							\
 	__chk_user_ptr(ptr);						\
 	might_fault();							\
 	switch (sizeof(*(ptr))) {					\
 	case 1:								\
-		__get_user_x(1, __ret_gu, __val_gu, ptr);		\
+		__get_user_x(1, __ret_gu, __val_gu.__val_n, ptr);	\
 		break;							\
 	case 2:								\
-		__get_user_x(2, __ret_gu, __val_gu, ptr);		\
+		__get_user_x(2, __ret_gu, __val_gu.__val_n, ptr);	\
 		break;							\
 	case 4:								\
-		__get_user_x(4, __ret_gu, __val_gu, ptr);		\
+		__get_user_x(4, __ret_gu, __val_gu.__val_n, ptr);	\
 		break;							\
 	case 8:								\
-		__get_user_8(__ret_gu, __val_gu8, ptr);			\
+		__get_user_8(__ret_gu, __val_gu.__val_n, ptr);		\
 		break;							\
 	default:							\
-		__get_user_x(X, __ret_gu, __val_gu, ptr);		\
+		__get_user_x(X, __ret_gu, __val_gu.__val_n, ptr);	\
 		break;							\
 	}								\
-	if (sizeof(*(ptr)) == 8)					\
-		(x) = (__typeof__(*(ptr)))__val_gu8;			\
-	else								\
-		(x) = (__typeof__(*(ptr)))__val_gu;			\
+	(x) = (__typeof__(*(ptr)))__val_gu.__val_n;			\
 	__ret_gu;							\
 })
 
