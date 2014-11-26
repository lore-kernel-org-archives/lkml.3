Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaKZTbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:31:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaKZTbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:31:20 -0500
Message-ID: <54762A73.4080801@redhat.com>
Date: Wed, 26 Nov 2014 14:30:59 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <koct9i@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Tim Hartrick <tim@edgecast.com>,
        Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v3] mm: prevent endless growth of anon_vma hierarchy
References: <20141126191145.3089.90947.stgit@zurg>
In-Reply-To: <20141126191145.3089.90947.stgit@zurg>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/26/2014 01:11 PM, Konstantin Khlebnikov wrote:

> diff --git a/include/linux/rmap.h b/include/linux/rmap.h index
> c0c2bce..b1d140c 100644 --- a/include/linux/rmap.h +++
> b/include/linux/rmap.h @@ -45,6 +45,22 @@ struct anon_vma { *
> mm_take_all_locks() (mm_all_locks_mutex). */ struct rb_root
> rb_root;	/* Interval tree of private "related" vmas */ + +	/* +	 *
> Count of child anon_vmas and VMAs which points to this anon_vma. +
> * +	 * This counter is used for making decision about reusing old
> anon_vma +	 * instead of forking new one. It allows to detect
> anon_vmas which have +	 * just one direct descendant and no vmas.
> Reusing such anon_vma not +	 * leads to significant preformance
> regression but prevents degradation +	 * of anon_vma hierarchy to
> endless linear chain. +	 * +	 * Root anon_vma is never reused
> because it is its own parent and it has +	 * at leat one vma or
> child, thus at fork it's degree is at least 2. +	 */ +	unsigned
> degree; + +	struct anon_vma *parent;	/* Parent of this anon_vma */ 
> };

Could this be put earlier in the struct, so the "unsigned degree" can be
packed into the same long word as the spinlock, on 64 bit systems?

Otherwise there are two 4-byte entities in the struct, each of which get
padded out to 8 bytes.


> diff --git a/mm/rmap.c b/mm/rmap.c index 19886fb..df5c44e 100644 
> --- a/mm/rmap.c +++ b/mm/rmap.c @@ -72,6 +72,8 @@ static inline
> struct anon_vma *anon_vma_alloc(void) anon_vma =
> kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL); if (anon_vma) { 
> atomic_set(&anon_vma->refcount, 1); +		anon_vma->degree = 1;	/*
> Reference for first vma */ +		anon_vma->parent = anon_vma; /* *
> Initialise the anon_vma root to point to itself. If called * from
> fork, the root will be reset to the parents anon_vma. @@ -188,6
> +190,8 @@ int anon_vma_prepare(struct vm_area_struct *vma) if
> (likely(!vma->anon_vma)) { vma->anon_vma = anon_vma; 
> anon_vma_chain_link(vma, avc, anon_vma); +			/* vma link if merged
> or child link for new root */ +			anon_vma->degree++; allocated =
> NULL; avc = NULL; } @@ -256,7 +260,17 @@ int anon_vma_clone(struct
> vm_area_struct *dst, struct vm_area_struct *src) anon_vma =
> pavc->anon_vma; root = lock_anon_vma_root(root, anon_vma); 
> anon_vma_chain_link(dst, avc, anon_vma); + +		/* +		 * Reuse
> existing anon_vma if its degree lower than two, +		 * that means it
> has no vma and just one anon_vma child. +		 */ +		if
> (!dst->anon_vma && anon_vma != src->anon_vma && +
> anon_vma->degree < 2) +			dst->anon_vma = anon_vma; }

Why can src->anon_vma not be reused if it still not shared with
any other task?

Would it be more readable to use a "reuse_anon_vma" pointer here,
and assign dst->anon_vma the value of reuse_anon_vma if we choose
to reuse one?

Assigning different things to dst->anon_vma looks a little confusing.

Would it make sense to rename anon_vma->degree to anon_vma->sharing
or anon_vma->shared, or even anon_vma->users, to indicate that it is
a counter of how many VMAs are sharing this anon_vma?

> +	if (dst->anon_vma) +		dst->anon_vma->degree++; 
> unlock_anon_vma_root(root); return 0;
> 
> @@ -279,6 +293,9 @@ int anon_vma_fork(struct vm_area_struct *vma,
> struct vm_area_struct *pvma) if (!pvma->anon_vma) return 0;
> 
> +	/* Drop inherited anon_vma, we'll reuse old one or allocate new.
> */ +	vma->anon_vma = NULL;

Use of a temporary variable in anon_vma_clone() would avoid this.

> @@ -286,6 +303,10 @@ int anon_vma_fork(struct vm_area_struct *vma,
> struct vm_area_struct *pvma) if (anon_vma_clone(vma, pvma)) return
> -ENOMEM;
> 
> +	/* An old anon_vma has been reused. */

s/old/existing/  ?

> +	if (vma->anon_vma) +		return 0; + /* Then add our own anon_vma.
> */ anon_vma = anon_vma_alloc(); if (!anon_vma)

Overall the patch looks good.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUdipzAAoJEM553pKExN6Db2kH/20CfKy2ntayKb03tqYnlohu
OUxtCwqiow8XsfYc2cEBrCznCNPD5B0sdDdEgRWybBnRCikHNQS4vUBhNl/F13gS
Hu8LM+RElhZwr69cCshUXefIx5xMKimUeAsHutpvy09onZy0DvYutdR958/Nhca/
1OjXqtE+LbPd0aG87OQQlagk4DQls0uA2l609qBRKsfMgm2444MRPAN0RGQwlYIv
SENvzVFN4ZvIdzsU8IoSw2EkhBankYDKbbTxAy+sHCHaxKzq0eKn+JgRaoZLjxU9
+43snI/fkWNN+S5KLgshUKIVO84kAmRAIfdKUjt/DYYkOj6YPp48aJnOKVFwjIY=
=Bhp4
-----END PGP SIGNATURE-----
