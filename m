Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab3LWD7L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 22:59:11 -0500
Received: from ozlabs.org ([203.10.76.45]:56491 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585Ab3LWD7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 22:59:08 -0500
Date: Mon, 23 Dec 2013 14:58:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: linux-next: manual merge of the akpm-current tree with Linus' tree
Message-Id: <20131223145850.c07c0c869a999fa76a319853@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Dec_2013_14_58_50_+1100_/N7CNL6+MN_2m11g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Dec_2013_14_58_50_+1100_/N7CNL6+MN_2m11g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got conflicts in
include/linux/mm.h and mm/memory.c between commit 597d795a2a78 ("mm: do
not allocate page->ptl dynamically, if spinlock_t fits to long") from
the  tree and commit 489bd4be2d70 ("mm: create a separate slab for
page->ptl allocation") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/mm.h
index bf362d053ce1,1f232229a451..000000000000
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@@ -1317,7 -1355,8 +1355,8 @@@ static inline pmd_t *pmd_alloc(struct m
  #endif /* CONFIG_MMU && !__ARCH_HAS_4LEVEL_HACK */
 =20
  #if USE_SPLIT_PTE_PTLOCKS
 -#if BLOATED_SPINLOCKS
 +#if ALLOC_SPLIT_PTLOCKS
+ void __init ptlock_cache_init(void);
  extern bool ptlock_alloc(struct page *page);
  extern void ptlock_free(struct page *page);
 =20
@@@ -1325,7 -1364,8 +1364,8 @@@ static inline spinlock_t *ptlock_ptr(st
  {
  	return page->ptl;
  }
 -#else /* BLOATED_SPINLOCKS */
 +#else /* ALLOC_SPLIT_PTLOCKS */
+ static inline void ptlock_cache_init(void) {}
  static inline bool ptlock_alloc(struct page *page)
  {
  	return true;
diff --cc mm/memory.c
index 6768ce9e57d2,cf6098c10084..000000000000
--- a/mm/memory.c
+++ b/mm/memory.c
@@@ -4271,7 -4271,14 +4271,14 @@@ void copy_user_huge_page(struct page *d
  }
  #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 =20
 -#if USE_SPLIT_PTE_PTLOCKS && BLOATED_SPINLOCKS
 +#if USE_SPLIT_PTE_PTLOCKS && ALLOC_SPLIT_PTLOCKS
+ static struct kmem_cache *page_ptl_cachep;
+ void __init ptlock_cache_init(void)
+ {
+ 	page_ptl_cachep =3D kmem_cache_create("page->ptl", sizeof(spinlock_t), 0,
+ 			SLAB_PANIC, NULL);
+ }
+=20
  bool ptlock_alloc(struct page *page)
  {
  	spinlock_t *ptl;

--Signature=_Mon__23_Dec_2013_14_58_50_+1100_/N7CNL6+MN_2m11g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSt7UIAAoJEMDTa8Ir7ZwVTp0QAI8Poef1vWPWg58viUllTUEL
kdSIvw1SfR5DGl1br91SZaiIZ8Pc97u5Qi1qq2P12DCbYeJOKQN5AqJ5ekiGaQNz
/ZoCdBmJCpIQ4iuD3mYFs3PwGuuqGQlAcWa7jQKBybBMt/yDZ3/2blnuaXXduz5D
YR1Z4tlsvq4P7vva14AwWZeChkaRZcaih3+qBVZy+7W/KZA/ddJjfkg3WHF9aaMi
k6qaJgU7OJbfI8/n1iRYOiH0tTe+koMN5vYp52rBn3iU1EJC6A5cAbJs9/lET3t6
JV4aj3+SEaQ+Jo+FcQkX3PzZ8Gz+6KAiEUJy3gRClQHs/C/Mfpa9Yi1Ph3eINW3E
eCI9SYB6spsoDxdDETCmxm7mtKlgBoV0MISbVpT0z90xGOfhcGDW2uAqpGby4XA/
wBwPZpVw9bfed5FAUPyqzjSMZacgMNFAr/fssSHDlMvQEvF15EaAQZpZsmfUET30
btb2x6WnK3knqolqz01a3vExJuGiR0xTLi9GdJ+gSPYWPivAMd+wDfCx5mfYQZ+D
aBApg5hwUczVOefb6Gx7UWkE3V7y2tn7kCd+OtC2ZANp5+fST/ByIaUEt0Xk6UCS
QMDlaWYR9dXH1potmjrWZ0J/6plWVLJsxHL4+bHr+mxhnHY/Z8JsyjZ+RFfP9KRq
GG17tfD6wk5wIjOkRWm+
=ZpZl
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Dec_2013_14_58_50_+1100_/N7CNL6+MN_2m11g--
