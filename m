Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaKRAFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:05:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48970 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaKRAFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:05:34 -0500
Date: Mon, 17 Nov 2014 16:05:23 -0800
From: tip-bot for Qiaowei Ren <tipbot@zytor.com>
Message-ID: <tip-ee1b58d36aa1b5a79eaba11f5c3633c88231da83@git.kernel.org>
Cc: dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org,
        qiaowei.ren@intel.com, mingo@kernel.org, dave@sr71.net, hpa@zytor.com,
        tglx@linutronix.de
Reply-To: tglx@linutronix.de, hpa@zytor.com, dave@sr71.net, mingo@kernel.org,
        linux-kernel@vger.kernel.org, qiaowei.ren@intel.com,
        dave.hansen@linux.intel.com
In-Reply-To: <20141114151819.1908C900@viggo.jf.intel.com>
References: <20141114151819.1908C900@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] mpx:
  Extend siginfo structure to include bound violation information
Git-Commit-ID: ee1b58d36aa1b5a79eaba11f5c3633c88231da83
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee1b58d36aa1b5a79eaba11f5c3633c88231da83
Gitweb:     http://git.kernel.org/tip/ee1b58d36aa1b5a79eaba11f5c3633c88231da83
Author:     Qiaowei Ren <qiaowei.ren@intel.com>
AuthorDate: Fri, 14 Nov 2014 07:18:19 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 18 Nov 2014 00:58:53 +0100

mpx: Extend siginfo structure to include bound violation information

This patch adds new fields about bound violation into siginfo
structure. si_lower and si_upper are respectively lower bound
and upper bound when bound violation is caused.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-mm@kvack.org
Cc: linux-mips@linux-mips.org
Cc: Dave Hansen <dave@sr71.net>
Link: http://lkml.kernel.org/r/20141114151819.1908C900@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/uapi/asm-generic/siginfo.h | 9 ++++++++-
 kernel/signal.c                    | 4 ++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
index ba5be7f..1e35520 100644
--- a/include/uapi/asm-generic/siginfo.h
+++ b/include/uapi/asm-generic/siginfo.h
@@ -91,6 +91,10 @@ typedef struct siginfo {
 			int _trapno;	/* TRAP # which caused the signal */
 #endif
 			short _addr_lsb; /* LSB of the reported address */
+			struct {
+				void __user *_lower;
+				void __user *_upper;
+			} _addr_bnd;
 		} _sigfault;
 
 		/* SIGPOLL */
@@ -131,6 +135,8 @@ typedef struct siginfo {
 #define si_trapno	_sifields._sigfault._trapno
 #endif
 #define si_addr_lsb	_sifields._sigfault._addr_lsb
+#define si_lower	_sifields._sigfault._addr_bnd._lower
+#define si_upper	_sifields._sigfault._addr_bnd._upper
 #define si_band		_sifields._sigpoll._band
 #define si_fd		_sifields._sigpoll._fd
 #ifdef __ARCH_SIGSYS
@@ -199,7 +205,8 @@ typedef struct siginfo {
  */
 #define SEGV_MAPERR	(__SI_FAULT|1)	/* address not mapped to object */
 #define SEGV_ACCERR	(__SI_FAULT|2)	/* invalid permissions for mapped object */
-#define NSIGSEGV	2
+#define SEGV_BNDERR	(__SI_FAULT|3)  /* failed address bound checks */
+#define NSIGSEGV	3
 
 /*
  * SIGBUS si_codes
diff --git a/kernel/signal.c b/kernel/signal.c
index 8f0876f..2c403a4 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2748,6 +2748,10 @@ int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
 		if (from->si_code == BUS_MCEERR_AR || from->si_code == BUS_MCEERR_AO)
 			err |= __put_user(from->si_addr_lsb, &to->si_addr_lsb);
 #endif
+#ifdef SEGV_BNDERR
+		err |= __put_user(from->si_lower, &to->si_lower);
+		err |= __put_user(from->si_upper, &to->si_upper);
+#endif
 		break;
 	case __SI_CHLD:
 		err |= __put_user(from->si_pid, &to->si_pid);
