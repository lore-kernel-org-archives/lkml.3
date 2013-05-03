Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762933Ab3ECSEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 14:04:22 -0400
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:37214 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755483Ab3ECSEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 14:04:21 -0400
Date: Fri, 3 May 2013 18:04:18 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <201305031726.BJG78631.tQSOVOLHJFMFFO@I-love.SAKURA.ne.jp>
Message-ID: <0000013e6b90e65e-e0e184d9-7da5-4873-9572-3b40958552e2-000000@email.amazonses.com>
References: <0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com> <201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp> <0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
 <201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp> <0000013e6705da99-094923c6-e239-43d2-8f0c-5e661656a27c-000000@email.amazonses.com> <201305031726.BJG78631.tQSOVOLHJFMFFO@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.03-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling various debugging options increases the size of structures and
the subslab handling in SLABs kmem_cache_create will start to fail.


Here is a fix for that:

Subject: Fix bootstrap creation of kmalloc caches

For SLAB the kmalloc caches must be created in ascending sizes
in order for the OFF_SLAB sub-slab cache to work properly.

Create the non power of two caches immediately after the prior power
of two kmalloc cache. Do not create the non power of two caches
before all other caches.

Signed-off-by: Christoph Lamete <cl@linux.com>

Index: linux/mm/slab_common.c
===================================================================
--- linux.orig/mm/slab_common.c	2013-05-03 11:16:45.764382372 -0500
+++ linux/mm/slab_common.c	2013-05-03 12:59:40.431797020 -0500
@@ -444,18 +444,24 @@ void __init create_kmalloc_caches(unsign
 		for (i = 128 + 8; i <= 192; i += 8)
 			size_index[size_index_elem(i)] = 8;
 	}
-	/* Caches that are not of the two-to-the-power-of size */
-	if (KMALLOC_MIN_SIZE <= 32 && !kmalloc_caches[1])
-		kmalloc_caches[1] = create_kmalloc_cache(NULL, 96, flags);
-
-	if (KMALLOC_MIN_SIZE <= 64 && !kmalloc_caches[2])
-		kmalloc_caches[2] = create_kmalloc_cache(NULL, 192, flags);
-
-	for (i = KMALLOC_SHIFT_LOW; i < KMALLOC_SHIFT_HIGH; i++)
-		if (!kmalloc_caches[i])
+	for (i = KMALLOC_SHIFT_LOW; i < KMALLOC_SHIFT_HIGH; i++) {
+		if (!kmalloc_caches[i]) {
 			kmalloc_caches[i] = create_kmalloc_cache(NULL,
 							1 << i, flags);

+			/*
+			 * Caches that are not of the two-to-the-power-of size.
+			 * These have to be created immediately after the
+			 * earlier power of two caches
+			 */
+			if (KMALLOC_MIN_SIZE <= 32 && !kmalloc_caches[1] && i == 6)
+				kmalloc_caches[1] = create_kmalloc_cache(NULL, 96, flags);
+
+			if (KMALLOC_MIN_SIZE <= 64 && !kmalloc_caches[2] && i == 7)
+				kmalloc_caches[2] = create_kmalloc_cache(NULL, 192, flags);
+		}
+	}
+
 	/* Kmalloc array is now usable */
 	slab_state = UP;

