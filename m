Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965001AbaFJAqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:46:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933309AbaFJAV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:21:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.4 17/88] mm: rmap: fix use-after-free in __put_anon_vma
Date: Mon,  9 Jun 2014 17:24:27 -0700
Message-Id: <20140610002425.105821990@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Ryabinin <a.ryabinin@samsung.com>

commit 624483f3ea82598ab0f62f1bdb9177f531ab1892 upstream.

While working address sanitizer for kernel I've discovered
use-after-free bug in __put_anon_vma.

For the last anon_vma, anon_vma->root freed before child anon_vma.
Later in anon_vma_free(anon_vma) we are referencing to already freed
anon_vma->root to check rwsem.

This fixes it by freeing the child anon_vma before freeing
anon_vma->root.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/rmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1721,10 +1721,9 @@ void __put_anon_vma(struct anon_vma *ano
 {
 	struct anon_vma *root = anon_vma->root;
 
+	anon_vma_free(anon_vma);
 	if (root != anon_vma && atomic_dec_and_test(&root->refcount))
 		anon_vma_free(root);
-
-	anon_vma_free(anon_vma);
 }
 
 #ifdef CONFIG_MIGRATION


