Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3L1BG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 20:06:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58018 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3L1BGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 20:06:55 -0500
Date: Fri, 27 Dec 2013 17:06:42 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-a740576a4abf933de8f50787f24f24456cebd761@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <CA+55aFzPBdbfKovMT8Edr4SmE2_=+OKJFac9XW2awegogTkVTA@mail.gmail.com>
References: <CA+55aFzPBdbfKovMT8Edr4SmE2_=+OKJFac9XW2awegogTkVTA@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Slightly tweak the access_ok()
  C variant for better code
Git-Commit-ID: a740576a4abf933de8f50787f24f24456cebd761
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 27 Dec 2013 17:06:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a740576a4abf933de8f50787f24f24456cebd761
Gitweb:     http://git.kernel.org/tip/a740576a4abf933de8f50787f24f24456cebd761
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 27 Dec 2013 16:52:47 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 27 Dec 2013 17:02:53 -0800

x86: Slightly tweak the access_ok() C variant for better code

gcc can under very specific circumstances realize that the code
sequence:

	foo += bar;
	if (foo < bar) ...

... is equivalent to a carry out from the addition.  Tweak the
implementation of access_ok() (specifically __chk_range_not_ok()) to
make it more likely that gcc will make that connection.  It isn't
fool-proof (sometimes gcc seems to think it can make better code with
lea, and ends up with a second comparison), still, but it seems to be
able to connect the two more frequently this way.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/CA%2B55aFzPBdbfKovMT8Edr4SmE2_=%2BOKJFac9XW2awegogTkVTA@mail.gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/uaccess.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 84ecf1d..6f1bb74 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -41,7 +41,7 @@
  * Test whether a block of memory is a valid user space address.
  * Returns 0 if the range is valid, nonzero otherwise.
  */
-static inline int __chk_range_not_ok(unsigned long addr, unsigned long size, unsigned long limit)
+static inline bool __chk_range_not_ok(unsigned long addr, unsigned long size, unsigned long limit)
 {
 	/*
 	 * If we have used "sizeof()" for the size,
@@ -55,7 +55,9 @@ static inline int __chk_range_not_ok(unsigned long addr, unsigned long size, uns
 
 	/* Arbitrary sizes? Be careful about overflow */
 	addr += size;
-	return (addr < size) || (addr > limit);
+	if (addr < size)
+		return true;
+	return addr > limit;
 }
 
 #define __range_not_ok(addr, size, limit)				\
@@ -84,7 +86,7 @@ static inline int __chk_range_not_ok(unsigned long addr, unsigned long size, uns
  * this function, memory access functions may still return -EFAULT.
  */
 #define access_ok(type, addr, size) \
-	(likely(__range_not_ok(addr, size, user_addr_max()) == 0))
+	likely(!__range_not_ok(addr, size, user_addr_max()))
 
 /*
  * The exception table consists of pairs of addresses relative to the
