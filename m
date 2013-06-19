Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772Ab3FSAoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:44:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48973 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860Ab3FSAoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:44:24 -0400
Date: Wed, 19 Jun 2013 10:44:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-mpidr tree with the arm tree
Message-Id: <20130619104409.358078cdc4957fa6832f3413@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Jun_2013_10_44_09_+1000_ZIj05V==VVXoOVAi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Jun_2013_10_44_09_+1000_ZIj05V==VVXoOVAi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lorenzo,

Today's linux-next merge of the arm-mpidr tree got a conflict in
arch/arm/kernel/suspend.c between commit aa1aadc3305c ("ARM: suspend: fix
CPU suspend code for !CONFIG_MMU configurations") from the arm tree and
commit 3fed6a1e3bf0 ("ARM: kernel: implement stack pointer save array
through MPIDR hashing") from the arm-mpidr tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

P.S. that arm tree commit above has no Signed-off-by from its
committer :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/kernel/suspend.c
index 38a5067,17d02f6..0000000
--- a/arch/arm/kernel/suspend.c
+++ b/arch/arm/kernel/suspend.c
@@@ -82,3 -49,48 +85,20 @@@ void __cpu_suspend_save(u32 *ptr, u32 p
  	outer_clean_range(virt_to_phys(save_ptr),
  			  virt_to_phys(save_ptr) + sizeof(*save_ptr));
  }
+=20
 -/*
 - * Hide the first two arguments to __cpu_suspend - these are an implement=
ation
 - * detail which platform code shouldn't have to know about.
 - */
 -int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 -{
 -	struct mm_struct *mm =3D current->active_mm;
 -	int ret;
 -
 -	if (!idmap_pgd)
 -		return -EINVAL;
 -
 -	/*
 -	 * Provide a temporary page table with an identity mapping for
 -	 * the MMU-enable code, required for resuming.  On successful
 -	 * resume (indicated by a zero return code), we need to switch
 -	 * back to the correct page tables.
 -	 */
 -	ret =3D __cpu_suspend(arg, fn);
 -	if (ret =3D=3D 0) {
 -		cpu_switch_mm(mm->pgd, mm);
 -		local_flush_bp_all();
 -		local_flush_tlb_all();
 -	}
 -
 -	return ret;
 -}
 -
+ extern struct sleep_save_sp sleep_save_sp;
+=20
+ static int cpu_suspend_alloc_sp(void)
+ {
+ 	void *ctx_ptr;
+ 	/* ctx_ptr is an array of physical addresses */
+ 	ctx_ptr =3D kcalloc(mpidr_hash_size(), sizeof(u32), GFP_KERNEL);
+=20
+ 	if (WARN_ON(!ctx_ptr))
+ 		return -ENOMEM;
+ 	sleep_save_sp.save_ptr_stash =3D ctx_ptr;
+ 	sleep_save_sp.save_ptr_stash_phys =3D virt_to_phys(ctx_ptr);
+ 	sync_cache_w(&sleep_save_sp);
+ 	return 0;
+ }
+ early_initcall(cpu_suspend_alloc_sp);

--Signature=_Wed__19_Jun_2013_10_44_09_+1000_ZIj05V==VVXoOVAi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwP7gAAoJEECxmPOUX5FEs9oQAJup4gPEIiG+V22xSNsYzMEU
qP4cr3p4HdpH02XCI8UNvyMnw/y9ygy2hSSC121VkODiTEAfCAURoPFewox7DuHL
snw3Jjkfi3SfxJkMLb2d1FNDWc5yQK9Pu8dZDZAJIbVKUTD9qr9veOj15xw545XT
v7xVXVfpdzVlZ4eHuDkfc+LySI8vL0rVFb8F0ps3qqechqSDmrISpE2tXIiHS/5x
VuDBFTWb+5i+qQaJ5RY9FhfI4qDmWFN9DQNCDBuUqKdCH0FA5Gt8vHFZbM7beiGd
ZLd3Oe6WradJDmLxcmtAZySYMiVvw5WaFrTtV2Tyk3Hw2jcdKCuuGDb0w8P7pPkW
PAMGHKcRM3q5JECIybU134cuOunYMvoEVQmP7glgNSOeU6zCnodNvDY49Txqfja+
D3oIoWn+0EERp3vcCfqOwcRKekWXxpcFcrR6QrT/Lr11A2YaSf1PKv6t9r09fjpt
MPETd2buSZ0XnX0Lp2gR3koRFeEu3hidI8LH5ziImgwEOXHfmWdyVVgIXsNhlQu/
dEyivg/b0iJa8Rxot0ARPIErmjJB7vszBoKJEeynvfG6vNwVMgfC/XuL8YZT7ex+
eJjNho3MM+HaTUE61vhZ2rwjoZ1hZCZ+5DEdhN3vWMEjqd1yAqjFobDJXwtDWg4d
KLYgz3FfWOZ3eA7YzHc6
=BxcV
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Jun_2013_10_44_09_+1000_ZIj05V==VVXoOVAi--
