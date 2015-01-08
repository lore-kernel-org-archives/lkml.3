Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbbAHK3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:29:00 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:55655 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbbAHK27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:28:59 -0500
Message-ID: <54AE5BE8.1050701@gmail.com>
Date: Thu, 08 Jan 2015 11:28:56 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: mtk.manpages@gmail.com, Dave Hansen <dave.hansen@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        "Michael Kerrisk (gmail)" <mtk.manpages@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, mpx: Ensure unused arguments of prctl() MPX requests
 are 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Kerrisk <mtk.manpages@gmail.com>

commit fe8c7f5cbf91124987106faa3bdf0c8b955c4cf7 added two new prctl()
operations, PR_MPX_ENABLE_MANAGEMENT and PR_MPX_DISABLE_MANAGEMENT.
However, no checks were included to ensure that unused arguments
are zero, as is done in many existing prctl()s and as should be 
done for all new prctl()s. This patch adds the required checks.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
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
-- 
1.9.3
-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
