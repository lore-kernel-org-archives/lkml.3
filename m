Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088AbbAHWbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:31:15 -0500
Received: from mga14.intel.com ([192.55.52.115]:14993 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756826AbbAHWaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:30:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,725,1413270000"; 
   d="scan'208";a="658980772"
Subject: [PATCH 3/3] x86 mpx: strictly enforce empty prctl() args
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, x86@kernel.org, luto@amacapital.net,
        Dave Hansen <dave@sr71.net>, mtk.manpages@gmail.com,
        dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Thu, 08 Jan 2015 14:30:22 -0800
References: <20150108223018.A57DEE63@viggo.jf.intel.com>
In-Reply-To: <20150108223018.A57DEE63@viggo.jf.intel.com>
Message-Id: <20150108223022.7F56FD13@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Description from Michael Kerrisk.  He suggested an identical patch
to one I had already coded up and tested.

commit fe8c7f5cbf91124987106faa3bdf0c8b955c4cf7 added two new prctl()
operations, PR_MPX_ENABLE_MANAGEMENT and PR_MPX_DISABLE_MANAGEMENT.
However, no checks were included to ensure that unused arguments
are zero, as is done in many existing prctl()s and as should be 
done for all new prctl()s. This patch adds the required checks.

Suggested-by: Andy Lutomirski <luto@amacapital.net>
Suggested-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/kernel/sys.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/sys.c~x86-mpx-strictly-enforce-empty-prctl-args kernel/sys.c
--- a/kernel/sys.c~x86-mpx-strictly-enforce-empty-prctl-args	2015-01-08 12:48:09.868898228 -0800
+++ b/kernel/sys.c	2015-01-08 12:48:09.872898408 -0800
@@ -2210,9 +2210,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
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
_
