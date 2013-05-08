Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab3EHWJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 18:09:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3EHWJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 18:09:34 -0400
Date: Wed, 8 May 2013 15:09:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Mason <clmason@fusionio.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] Fix crash during slab init
Message-Id: <20130508150932.e6ea333eb8e023940d15ac46@linux-foundation.org>
In-Reply-To: <20130508195628.4271.97115@localhost.localdomain>
References: <alpine.LFD.2.03.1305070936320.2383@kernel.org>
	<20130508003022.GS28721@atomide.com>
	<20130508042422.GU28721@atomide.com>
	<20130508181353.23991.17852@localhost.localdomain>
	<0000013e856463fa-9a895b58-ef76-42fa-a33d-778b89f97cf2-000000@email.amazonses.com>
	<20130508184817.4271.72594@localhost.localdomain>
	<0000013e85852607-fd84223c-112e-46b9-a60f-73d9597d90ac-000000@email.amazonses.com>
	<20130508195628.4271.97115@localhost.localdomain>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 May 2013 15:56:28 -0400 Chris Mason <clmason@fusionio.com> wrote:

> Commit 8a965b3b introduced a regression that caused us to crash early
> during boot.  The commit was introducing ordering of slab creation,
> making sure two odd-sized slabs were created after specific powers of
> two sizes.
> 
> But, if any of the  power of two slabs were created earlier during boot,
> slabs at index 1 or 2 might not get created at all.  This patch makes
> sure none of the slabs get skipped.
> 
> Tony Lindgren bisected this down to the offending commit, which really
> helped because bisect kept bringing me to almost but not quite this one.

err, yes.  Without your patch, current mainline does an ignominious
faceplant on my test box.


From: Chris Mason <clmason@fusionio.com>
Subject: slab: fix crash during slab init

Commit 8a965b3b ("mm, slab_common: Fix bootstrap creation of kmalloc
caches") introduced a regression that caused us to crash early during
boot.  The commit was introducing ordering of slab creation, making sure
two odd-sized slabs were created after specific powers of two sizes.

But, if any of the power of two slabs were created earlier during boot,
slabs at index 1 or 2 might not get created at all.  This patch makes sure
none of the slabs get skipped.

Tony Lindgren bisected this down to the offending commit, which really
helped because bisect kept bringing me to almost but not quite this one.

Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Tested-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Pekka Enberg <penberg@kernel.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/slab_common.c~slab-fix-crash-during-slab-init mm/slab_common.c
--- a/mm/slab_common.c~slab-fix-crash-during-slab-init
+++ a/mm/slab_common.c
@@ -446,18 +446,18 @@ void __init create_kmalloc_caches(unsign
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
_

