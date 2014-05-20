Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaETCAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 22:00:54 -0400
Received: from ozlabs.org ([103.22.144.67]:37924 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbaETCAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 22:00:51 -0400
Date: Tue, 20 May 2014 12:00:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: linux-next: manual merge of the sparc-next tree with Linus' tree
Message-ID: <20140520120040.45de56ac@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7hrapw0VeeRPxEGD9vs02yY"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7hrapw0VeeRPxEGD9vs02yY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi David,

Today's linux-next merge of the sparc-next tree got a conflict in
arch/sparc/include/asm/pgtable_64.h between commit 26cf432551d7
("sparc64: Add basic validations to {pud,pmd}_bad()") from Linus' tree
and commit f05a68653e56 ("sparc: drop use of extern for prototypes in
arch/sparc/include/asm") from the sparc-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/sparc/include/asm/pgtable_64.h
index 1a49ffdf9da9,521b8d8c1f96..000000000000
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@@ -765,23 -757,9 +765,23 @@@ static inline int pmd_present(pmd_t pmd
 =20
  #define pmd_none(pmd)			(!pmd_val(pmd))
 =20
 +/* pmd_bad() is only called on non-trans-huge PMDs.  Our encoding is
 + * very simple, it's just the physical address.  PTE tables are of
 + * size PAGE_SIZE so make sure the sub-PAGE_SIZE bits are clear and
 + * the top bits outside of the range of any physical address size we
 + * support are clear as well.  We also validate the physical itself.
 + */
 +#define pmd_bad(pmd)			((pmd_val(pmd) & ~PAGE_MASK) || \
 +					 !__kern_addr_valid(pmd_val(pmd)))
 +
 +#define pud_none(pud)			(!pud_val(pud))
 +
 +#define pud_bad(pud)			((pud_val(pud) & ~PAGE_MASK) || \
 +					 !__kern_addr_valid(pud_val(pud)))
 +
  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
- extern void set_pmd_at(struct mm_struct *mm, unsigned long addr,
- 		       pmd_t *pmdp, pmd_t pmd);
+ void set_pmd_at(struct mm_struct *mm, unsigned long addr,
+ 		pmd_t *pmdp, pmd_t pmd);
  #else
  static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
  			      pmd_t *pmdp, pmd_t pmd)
@@@ -900,28 -881,24 +900,28 @@@ static inline void __set_pte_at(struct=20
  extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
  extern pmd_t swapper_low_pmd_dir[PTRS_PER_PMD];
 =20
- extern void paging_init(void);
- extern unsigned long find_ecache_flush_span(unsigned long size);
+ void paging_init(void);
+ unsigned long find_ecache_flush_span(unsigned long size);
 =20
  struct seq_file;
- extern void mmu_info(struct seq_file *);
+ void mmu_info(struct seq_file *);
 =20
  struct vm_area_struct;
- extern void update_mmu_cache(struct vm_area_struct *, unsigned long, pte_=
t *);
+ void update_mmu_cache(struct vm_area_struct *, unsigned long, pte_t *);
  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
- extern void update_mmu_cache_pmd(struct vm_area_struct *vma, unsigned lon=
g addr,
- 				 pmd_t *pmd);
+ void update_mmu_cache_pmd(struct vm_area_struct *vma, unsigned long addr,
+ 			  pmd_t *pmd);
 =20
 +#define __HAVE_ARCH_PMDP_INVALIDATE
 +extern void pmdp_invalidate(struct vm_area_struct *vma, unsigned long add=
ress,
 +			    pmd_t *pmdp);
 +
  #define __HAVE_ARCH_PGTABLE_DEPOSIT
- extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
- 				       pgtable_t pgtable);
+ void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
+ 				pgtable_t pgtable);
 =20
  #define __HAVE_ARCH_PGTABLE_WITHDRAW
- extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t =
*pmdp);
+ pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
  #endif
 =20
  /* Encode and de-code a swap entry */
@@@ -937,12 -914,24 +937,12 @@@
  #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 =20
  /* File offset in PTE support. */
- extern unsigned long pte_file(pte_t);
+ unsigned long pte_file(pte_t);
  #define pte_to_pgoff(pte)	(pte_val(pte) >> PAGE_SHIFT)
- extern pte_t pgoff_to_pte(unsigned long);
+ pte_t pgoff_to_pte(unsigned long);
  #define PTE_FILE_MAX_BITS	(64UL - PAGE_SHIFT - 1UL)
 =20
- extern int page_in_phys_avail(unsigned long paddr);
 -extern unsigned long sparc64_valid_addr_bitmap[];
 -
 -/* Needs to be defined here and not in linux/mm.h, as it is arch dependen=
t */
 -static inline bool kern_addr_valid(unsigned long addr)
 -{
 -	unsigned long paddr =3D __pa(addr);
 -
 -	if ((paddr >> 41UL) !=3D 0UL)
 -		return false;
 -	return test_bit(paddr >> 22, sparc64_valid_addr_bitmap);
 -}
 -
+ int page_in_phys_avail(unsigned long paddr);
 =20
  /*
   * For sparc32&64, the pfn in io_remap_pfn_range() carries <iospace> in

--Sig_/7hrapw0VeeRPxEGD9vs02yY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTerdNAAoJEMDTa8Ir7ZwVh4YP/3HttDvg8JWdTRY5zQuENuaa
7yjy5nEe5lOAq9oZad3WpyQiQvFRGDvHOJW57OLh+TZzFnNyy6RIc52kgar9QCfO
6vhopi4/2pa7eo5WRzDwZEeZunEtlbIZ3d1jsLZM0z6lRyXxq92TFhn0BCk7Z9am
FMy6f5EDJsd/LEjHCgc+5v/QPrdFh+QmgrONb5SbojuRgIgvuJOKHIyOhhx+SxSh
bgq4DZQR0ItstQlI5J0RMxxBo2v2sSIIS2Ln2E5FBczccbE7O996FH9qpF7WNXi/
ZwJBRX3vLRu6U/9iOP3Ci8eoYOVgbLFBPXSQK/aP5Fw73T/rtWFOdYpEyy11KAMI
h+xMTWqCcRHP8F9ZiMFZ+qdx/4nMRQOe7PyU0NMbVFgt/+H5vxXmwY0aCdZJB8FK
yzgMixWhJtoi28Zzeo/ZXBxc4q5SvGqbS2IYDsTPC2gPvPWhrrLiRPysl+PlvEAU
e7yp90fPKFhnk2jL9kdVj/uGOJNgxmUa8GZnjQStAbgaeP3TBcXeWy0xh0tW54uF
YLf7SrBVjef2jb8oa3BFm0OZFdAvSbrKwvuayzwldcLYUnWnJqT9Ui9fl9fcpSXf
63ehEJyYPQ+M41DqTtZq5PHYryoX3mhyybJdEtg2q6yEBh47texqf7JCCSnlMbS6
ScxoBxjVvHNYLaU0TBYo
=Cgyz
-----END PGP SIGNATURE-----

--Sig_/7hrapw0VeeRPxEGD9vs02yY--
