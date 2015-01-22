Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbbAVUNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:13:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32903 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbbAVUNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:13:38 -0500
Date: Thu, 22 Jan 2015 12:13:23 -0800
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-e9d1b4f3c60997fe197bf0243cb4a41a44387a88@git.kernel.org>
Cc: dave@sr71.net, dave.hansen@linux.intel.com, luto@amacapital.net,
        mingo@kernel.org, mtk.manpages@gmail.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Reply-To: hpa@zytor.com, mtk.manpages@gmail.com, mingo@kernel.org,
        dave.hansen@linux.intel.com, luto@amacapital.net, dave@sr71.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20150108223022.7F56FD13@viggo.jf.intel.com>
References: <20150108223022.7F56FD13@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mpx: Strictly enforce empty prctl() args
Git-Commit-ID: e9d1b4f3c60997fe197bf0243cb4a41a44387a88
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

Commit-ID:  e9d1b4f3c60997fe197bf0243cb4a41a44387a88
Gitweb:     http://git.kernel.org/tip/e9d1b4f3c60997fe197bf0243cb4a41a44387a88
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Thu, 8 Jan 2015 14:30:22 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 21:11:06 +0100

x86, mpx: Strictly enforce empty prctl() args

Description from Michael Kerrisk.  He suggested an identical patch
to one I had already coded up and tested.

commit fe3d197f8431 "x86, mpx: On-demand kernel allocation of bounds
tables" added two new prctl() operations, PR_MPX_ENABLE_MANAGEMENT and
PR_MPX_DISABLE_MANAGEMENT.  However, no checks were included to ensure
that unused arguments are zero, as is done in many existing prctl()s
and as should be done for all new prctl()s. This patch adds the
required checks.

Suggested-by: Andy Lutomirski <luto@amacapital.net>
Suggested-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Hansen <dave@sr71.net>
Link: http://lkml.kernel.org/r/20150108223022.7F56FD13@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sys.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sys.c b/kernel/sys.c
index a8c9f5a..ea9c881 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2210,9 +2210,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		up_write(&me->mm->mmap_sem);
 		break;
 	case PR_MPX_ENABLE_MANAGEMENT:
+		if (arg2 || arg3 || arg4 || arg5)
+			return -EINVAL;
 		error = MPX_ENABLE_MANAGEMENT(me);
 		break;
 	case PR_MPX_DISABLE_MANAGEMENT:
+		if (arg2 || arg3 || arg4 || arg5)
+			return -EINVAL;
 		error = MPX_DISABLE_MANAGEMENT(me);
 		break;
 	default:
