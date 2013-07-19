Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965648Ab3GSF0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:26:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965471Ab3GSF0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Lameter <cl@linux.com>,
        Tetsuo Handa <penguin-kernel@I-Love.SAKURA.ne.jp>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [ 23/72] slab: fix init_lock_keys
Date: Thu, 18 Jul 2013 22:25:40 -0700
Message-Id: <20130719052601.448402333@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Lameter <cl@linux.com>

commit 0f8f8094d28eb53368ac09186ea6b3a324cc7d44 upstream.

Some architectures (e.g. powerpc built with CONFIG_PPC_256K_PAGES=y
CONFIG_FORCE_MAX_ZONEORDER=11) get PAGE_SHIFT + MAX_ORDER > 26.

In 3.10 kernels, CONFIG_LOCKDEP=y with PAGE_SHIFT + MAX_ORDER > 26 makes
init_lock_keys() dereference beyond kmalloc_caches[26].
This leads to an unbootable system (kernel panic at initializing SLAB)
if one of kmalloc_caches[26...PAGE_SHIFT+MAX_ORDER-1] is not NULL.

Fix this by making sure that init_lock_keys() does not dereference beyond
kmalloc_caches[26] arrays.

Signed-off-by: Christoph Lameter <cl@linux.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-Love.SAKURA.ne.jp>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab.c
+++ b/mm/slab.c
@@ -565,7 +565,7 @@ static void init_node_lock_keys(int q)
 	if (slab_state < UP)
 		return;
 
-	for (i = 1; i < PAGE_SHIFT + MAX_ORDER; i++) {
+	for (i = 1; i <= KMALLOC_SHIFT_HIGH; i++) {
 		struct kmem_cache_node *n;
 		struct kmem_cache *cache = kmalloc_caches[i];
 


