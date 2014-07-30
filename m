Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbaG3Bxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:53:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaG3BuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:50:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 3.15 18/37] slab_common: fix the check for duplicate slab names
Date: Tue, 29 Jul 2014 18:48:54 -0700
Message-Id: <20140730014828.565117504@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014827.565626091@linuxfoundation.org>
References: <20140730014827.565626091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 694617474e33b8603fc76e090ed7d09376514b1a upstream.

The patch 3e374919b314f20e2a04f641ebc1093d758f66a4 is supposed to fix the
problem where kmem_cache_create incorrectly reports duplicate cache name
and fails. The problem is described in the header of that patch.

However, the patch doesn't really fix the problem because of these
reasons:

* the logic to test for debugging is reversed. It was intended to perform
  the check only if slub debugging is enabled (which implies that caches
  with the same parameters are not merged). Therefore, there should be
  #if !defined(CONFIG_SLUB) || defined(CONFIG_SLUB_DEBUG_ON)
  The current code has the condition reversed and performs the test if
  debugging is disabled.

* slub debugging may be enabled or disabled based on kernel command line,
  CONFIG_SLUB_DEBUG_ON is just the default settings. Therefore the test
  based on definition of CONFIG_SLUB_DEBUG_ON is unreliable.

This patch fixes the problem by removing the test
"!defined(CONFIG_SLUB_DEBUG_ON)". Therefore, duplicate names are never
checked if the SLUB allocator is used.

Note to stable kernel maintainers: when backporint this patch, please
backport also the patch 3e374919b314f20e2a04f641ebc1093d758f66a4.

Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -55,7 +55,7 @@ static int kmem_cache_sanity_check(const
 			continue;
 		}
 
-#if !defined(CONFIG_SLUB) || !defined(CONFIG_SLUB_DEBUG_ON)
+#if !defined(CONFIG_SLUB)
 		if (!strcmp(s->name, name)) {
 			pr_err("%s (%s): Cache name already exists.\n",
 			       __func__, name);


