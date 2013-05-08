Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3EHT4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 15:56:32 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:48758 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab3EHT4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 15:56:31 -0400
X-ASG-Debug-ID: 1368042990-0421b536855dcb0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Christoph Lameter <cl@linux.com>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <0000013e85852607-fd84223c-112e-46b9-a60f-73d9597d90ac-000000@email.amazonses.com>
CC: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
References: <alpine.LFD.2.03.1305070936320.2383@kernel.org>
 <20130508003022.GS28721@atomide.com> <20130508042422.GU28721@atomide.com>
 <20130508181353.23991.17852@localhost.localdomain>
 <0000013e856463fa-9a895b58-ef76-42fa-a33d-778b89f97cf2-000000@email.amazonses.com>
 <20130508184817.4271.72594@localhost.localdomain>
 <0000013e85852607-fd84223c-112e-46b9-a60f-73d9597d90ac-000000@email.amazonses.com>
Message-ID: <20130508195628.4271.97115@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: [PATCH] Fix crash during slab init
Date: Wed, 8 May 2013 15:56:28 -0400
X-ASG-Orig-Subj: [PATCH] Fix crash during slab init
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1368042990
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.130388
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8a965b3b introduced a regression that caused us to crash early
during boot.  The commit was introducing ordering of slab creation,
making sure two odd-sized slabs were created after specific powers of
two sizes.

But, if any of the  power of two slabs were created earlier during boot,
slabs at index 1 or 2 might not get created at all.  This patch makes
sure none of the slabs get skipped.

Tony Lindgren bisected this down to the offending commit, which really
helped because bisect kept bringing me to almost but not quite this one.

Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Tony Lindgren <tony@atomide.com>

---

v1->v2 reword description

diff --git a/mm/slab_common.c b/mm/slab_common.c
index d2517b0..ff3218a 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -446,18 +446,18 @@ void __init create_kmalloc_caches(unsigned long flags)
 		if (!kmalloc_caches[i]) {
 			kmalloc_caches[i] = create_kmalloc_cache(NULL,
 							1 << i, flags);
+		}
 
-			/*
-			 * Caches that are not of the two-to-the-power-of size.
-			 * These have to be created immediately after the
-			 * earlier power of two caches
-			 */
-			if (KMALLOC_MIN_SIZE <= 32 && !kmalloc_caches[1] && i == 6)
-				kmalloc_caches[1] = create_kmalloc_cache(NULL, 96, flags);
+		/*
+		 * Caches that are not of the two-to-the-power-of size.
+		 * These have to be created immediately after the
+		 * earlier power of two caches
+		 */
+		if (KMALLOC_MIN_SIZE <= 32 && !kmalloc_caches[1] && i == 6)
+			kmalloc_caches[1] = create_kmalloc_cache(NULL, 96, flags);
 
-			if (KMALLOC_MIN_SIZE <= 64 && !kmalloc_caches[2] && i == 7)
-				kmalloc_caches[2] = create_kmalloc_cache(NULL, 192, flags);
-		}
+		if (KMALLOC_MIN_SIZE <= 64 && !kmalloc_caches[2] && i == 7)
+			kmalloc_caches[2] = create_kmalloc_cache(NULL, 192, flags);
 	}
 
 	/* Kmalloc array is now usable */
