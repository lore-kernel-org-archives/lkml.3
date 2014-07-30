Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbaG3Bt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:49:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60354 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbaG3Bt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jonathan Brassow <jbrassow@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 3.10 10/21] slab_common: Do not check for duplicate slab names
Date: Tue, 29 Jul 2014 18:48:39 -0700
Message-Id: <20140730014830.873136277@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014830.424826215@linuxfoundation.org>
References: <20140730014830.424826215@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Lameter <cl@linux.com>

commit 3e374919b314f20e2a04f641ebc1093d758f66a4 upstream.

SLUB can alias multiple slab kmem_create_requests to one slab cache to save
memory and increase the cache hotness. As a result the name of the slab can be
stale. Only check the name for duplicates if we are in debug mode where we do
not merge multiple caches.

This fixes the following problem reported by Jonathan Brassow:

  The problem with kmem_cache* is this:

  *) Assume CONFIG_SLUB is set
  1) kmem_cache_create(name="foo-a")
  - creates new kmem_cache structure
  2) kmem_cache_create(name="foo-b")
  - If identical cache characteristics, it will be merged with the previously
    created cache associated with "foo-a".  The cache's refcount will be
    incremented and an alias will be created via sysfs_slab_alias().
  3) kmem_cache_destroy(<ptr>)
  - Attempting to destroy cache associated with "foo-a", but instead the
    refcount is simply decremented.  I don't even think the sysfs aliases are
    ever removed...
  4) kmem_cache_create(name="foo-a")
  - This FAILS because kmem_cache_sanity_check colides with the existing
    name ("foo-a") associated with the non-removed cache.

  This is a problem for RAID (specifically dm-raid) because the name used
  for the kmem_cache_create is ("raid%d-%p", level, mddev).  If the cache
  persists for long enough, the memory address of an old mddev will be
  reused for a new mddev - causing an identical formulation of the cache
  name.  Even though kmem_cache_destory had long ago been used to delete
  the old cache, the merging of caches has cause the name and cache of that
  old instance to be preserved and causes a colision (and thus failure) in
  kmem_cache_create().  I see this regularly in my testing.

Reported-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slab_common.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -55,6 +55,7 @@ static int kmem_cache_sanity_check(struc
 			continue;
 		}
 
+#if !defined(CONFIG_SLUB) || !defined(CONFIG_SLUB_DEBUG_ON)
 		/*
 		 * For simplicity, we won't check this in the list of memcg
 		 * caches. We have control over memcg naming, and if there
@@ -68,6 +69,7 @@ static int kmem_cache_sanity_check(struc
 			s = NULL;
 			return -EINVAL;
 		}
+#endif
 	}
 
 	WARN_ON(strchr(name, ' '));	/* It confuses parsers */


