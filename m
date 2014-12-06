Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaLFABE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 19:01:04 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:55518 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaLFABA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 19:01:00 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] MPILIB: Deobfuscate mpi_cmp
Date: Sat,  6 Dec 2014 01:00:42 +0100
Message-Id: <1417824042-539-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417824042-539-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1417824042-539-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The condition preceding 'return 1;' makes my head hurt. At this point,
we know that u and v have the same sign; if they are negative, they
compare opposite to how their absolute values compare (which
mpihelp_cmp found for us), otherwise cmp itself is the
answer. Negating cmp is ok since mpihelp_cmp returns {-1,0,1};
-INT_MIN==INT_MIN won't bite us.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/mpi/mpi-cmp.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/lib/mpi/mpi-cmp.c b/lib/mpi/mpi-cmp.c
index 3801694240d8..d25e9e96c310 100644
--- a/lib/mpi/mpi-cmp.c
+++ b/lib/mpi/mpi-cmp.c
@@ -61,10 +61,8 @@ int mpi_cmp(MPI u, MPI v)
 	if (!usize)
 		return 0;
 	cmp = mpihelp_cmp(u->d, v->d, usize);
-	if (!cmp)
-		return 0;
-	if ((cmp < 0 ? 1 : 0) == (u->sign ? 1 : 0))
-		return 1;
-	return -1;
+	if (u->sign)
+		return -cmp;
+	return cmp;
 }
 EXPORT_SYMBOL_GPL(mpi_cmp);
-- 
2.1.3

