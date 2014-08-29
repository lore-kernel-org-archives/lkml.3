Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaH2O1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:27:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56790 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbaH2O1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:27:42 -0400
Message-ID: <54008DDA.3040701@canonical.com>
Date: Fri, 29 Aug 2014 16:27:38 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Kees Cook <keescook@chromium.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Solved the Xen PV/KASLR riddle
References: <20140827204940.GA10556@laptop.dumpdata.com> <1409248903-19625-1-git-send-email-stefan.bader@canonical.com> <20140829140823.GF3609@laptop.dumpdata.com>
In-Reply-To: <20140829140823.GF3609@laptop.dumpdata.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="SXPvX99XgnmPsPfhX9hjgW692hE137Xxd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SXPvX99XgnmPsPfhX9hjgW692hE137Xxd
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 29.08.2014 16:08, Konrad Rzeszutek Wilk wrote:
> On Thu, Aug 28, 2014 at 08:01:43PM +0200, Stefan Bader wrote:
>>>> So not much further... but then I think I know what I do next. Proba=
bly should
>>>> have done before. I'll replace the WARN_ON in vmalloc that triggers =
by a panic
>>>> and at least get a crash dump of that situation when it occurs. Then=
 I can dig
>>>> in there with crash (really should have thought of that before)...
>>>
>>> <nods> I dug a bit in the code (arch/x86/xen/mmu.c) but there is noth=
ing there
>>> that screams at me, so I fear I will have to wait until you get the c=
rash
>>> and get some clues from that.
>>
>> Ok, what a journey. So after long hours of painful staring at the code=
=2E..
>> (and btw, if someone could tell me how the heck one can do a mfn_to_pf=
n
>> in crash, I really would appreaciate :-P)
>>
>> So at some point I realized that level2_fixmap_pgt seemed to contain
>> an oddly high number of entries (given that the virtual address that
>> failed would be mapped by entry 0). And suddenly I realized that apart=

>> from entries 506 and 507 (actual fixmap and vsyscalls) the whole list
>> actually was the same as level2_kernel_gpt (without the first 16M
>> cleared).
>>
>> And then I realized that xen_setup_kernel_pagetable is wrong to a
>> degree which makes one wonder how this ever worked. Adding PMD_SIZE
>> as an offset (2M) isn't changing l2 at all. This just copies Xen's
>> kernel mapping, AGAIN!.
>>
>> I guess we all just were lucky that in most cases modules would not
>> use more than 512M (which is the correctly cleaned up remainder
>> of kernel_level2_pgt)..
>>
>> I still need to compile a kernel with the patch and the old layout
>> but I kind of got exited by the find. At least this is tested with
>> the 1G/~1G layout and it comes up without vmalloc errors.
>=20
> Woot!

Oh yeah! :)

>>
>> -Stefan
>>
>> >From 4b9a9a45177284e29d345eb54c545bd1da718e1b Mon Sep 17 00:00:00 200=
1
>> From: Stefan Bader <stefan.bader@canonical.com>
>> Date: Thu, 28 Aug 2014 19:17:00 +0200
>> Subject: [PATCH] x86/xen: Fix setup of 64bit kernel pagetables
>>
>> This seemed to be one of those what-the-heck moments. When trying to
>> figure out why changing the kernel/module split (which enabling KASLR
>> does) causes vmalloc to run wild on boot of 64bit PV guests, after
>> much scratching my head, found that the current Xen code copies the
>=20
> s/current Xen/xen_setup_kernel_pagetable/

ok

>=20
>> same L2 table not only to the level2_ident_pgt and level2_kernel_pgt,
>> but also (due to miscalculating the offset) to level2_fixmap_pgt.
>>
>> This only worked because the normal kernel image size only covers the
>> first half of level2_kernel_pgt and module space starts after that.
>> With the split changing, the kernel image uses the full PUD range of
>> 1G and module space starts in the level2_fixmap_pgt. So basically:
>>
>> L4[511]->level3_kernel_pgt[510]->level2_kernel_pgt
>>                           [511]->level2_fixmap_pgt
>>
>=20
> Perhaps you could add a similar drawing of what it looked like
> without the kaslr enabled? AS in the 'normal kernel image' scenario?

Sure. Btw, someone also contacted me saying they have the same problem wi=
thout
changing the layout but having really big initrd (500M). While that feels=
 like
it should be impossible (if the kernel+initrd+xen stuff has to fix the 51=
2M
kernel image size area then). But if it can happen, then surely it does c=
ause
mappings to be where the module space starts then.

>=20
>> And now the incorrect copy of the kernel mapping in that range bites
>> (hard).
>=20
> Want to include the vmalloc warning you got?

Yeah, that is a good idea.

>=20
>>
>> This change might not be the fully correct approach as it basically
>> removes the pre-set page table entry for the fixmap that is compile
>> time set (level2_fixmap_pgt[506]->level1_fixmap_pgt). For one the
>> level1 page table is not yet declared in C headers (that might be
>> fixed). But also with the current bug, it was removed, too. Since
>> the Xen mappings for level2_kernel_pgt only covered kernel + initrd
>> and some Xen data this did never reach that far. And still, something
>> does create entries at level2_fixmap_pgt[506..507]. So it should be
>> ok. At least I was able to successfully boot a kernel with 1G kernel
>> image size without any vmalloc whinings.
>>
>> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
>> ---
>>  arch/x86/xen/mmu.c | 26 +++++++++++++++++---------
>>  1 file changed, 17 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
>> index e8a1201..803034c 100644
>> --- a/arch/x86/xen/mmu.c
>> +++ b/arch/x86/xen/mmu.c
>> @@ -1902,8 +1902,22 @@ void __init xen_setup_kernel_pagetable(pgd_t *p=
gd, unsigned long max_pfn)
>>  		/* L3_i[0] -> level2_ident_pgt */
>>  		convert_pfn_mfn(level3_ident_pgt);
>>  		/* L3_k[510] -> level2_kernel_pgt
>> -		 * L3_i[511] -> level2_fixmap_pgt */
>> +		 * L3_k[511] -> level2_fixmap_pgt */
>>  		convert_pfn_mfn(level3_kernel_pgt);
>> +
>> +		/* level2_fixmap_pgt contains a single entry for the
>> +		 * fixmap area at offset 506. The correct way would
>> +		 * be to convert level2_fixmap_pgt to mfn and set the
>> +		 * level1_fixmap_pgt (which is completely empty) to RO,
>> +		 * too. But currently this page table is not delcared,
>=20
> declared.
>> +		 * so it would be a bit of voodoo to get its address.
>> +		 * And also the fixmap entry was never set anyway due
>=20
> s/anyway//

Too much slang I guess. Ok :)

>> +		 * to using the wrong l2 when getting Xen's tables.
>> +		 * So let's just nuke it.
>> +		 * This orphans level1_fixmap_pgt, but that should be
>> +		 * as it always has been.
>=20
> 'as it always has been.' ? Not sure I follow that sentence?

Probably need to be more verbose and say "the same basically happens with=
 the
current code, too".

>=20
>> +		 */
>> +		memset(level2_fixmap_pgt, 0, 512*sizeof(long));
>>  	}
>>  	/* We get [511][511] and have Xen's version of level2_kernel_pgt */
>>  	l3 =3D m2v(pgd[pgd_index(__START_KERNEL_map)].pgd);
>> @@ -1913,21 +1927,15 @@ void __init xen_setup_kernel_pagetable(pgd_t *=
pgd, unsigned long max_pfn)
>>  	addr[1] =3D (unsigned long)l3;
>>  	addr[2] =3D (unsigned long)l2;
>>  	/* Graft it onto L4[272][0]. Note that we creating an aliasing probl=
em:
>> -	 * Both L4[272][0] and L4[511][511] have entries that point to the s=
ame
>> +	 * Both L4[272][0] and L4[511][510] have entries that point to the s=
ame
>>  	 * L2 (PMD) tables. Meaning that if you modify it in __va space
>>  	 * it will be also modified in the __ka space! (But if you just
>>  	 * modify the PMD table to point to other PTE's or none, then you
>>  	 * are OK - which is what cleanup_highmap does) */
>>  	copy_page(level2_ident_pgt, l2);
>> -	/* Graft it onto L4[511][511] */
>> +	/* Graft it onto L4[511][510] */
>>  	copy_page(level2_kernel_pgt, l2);
>> =20
>> -	/* Get [511][510] and graft that in level2_fixmap_pgt */
>> -	l3 =3D m2v(pgd[pgd_index(__START_KERNEL_map + PMD_SIZE)].pgd);
>> -	l2 =3D m2v(l3[pud_index(__START_KERNEL_map + PMD_SIZE)].pud);
>> -	copy_page(level2_fixmap_pgt, l2);
>> -	/* Note that we don't do anything with level1_fixmap_pgt which
>> -	 * we don't need. */
>=20
> Later during bootup we do set the fixmap with entries. I recall (vaguel=
y)
> that on the SLES kernels (Classic) the fixmap was needed during early
> bootup. The reason was that it used the right away for bootparams (mayb=
e?).

Ah ok. Yeah I was confident that it got set somewhere else after
xen_setup_kernel_pagetable ran. Because in the dump fixmap and vsyscall e=
ntries
where in place while I was pretty sure they are not set in the l2 table t=
hat is
copied in from the pagetables provided by the xen toolstack.

>=20
> I think your patch is correct in ripping out level1_fixmap_pgt
> and level2_fixmap_pgt.

l1 effectively was already ripped out (not used). The only reason I could=
 think
of for preserving the compile-time l2 table would have been if fixmap wou=
ld be
not there. But obviously that is (and was) created along with some dynami=
c l1 table.


Ok, I rework the patch and re-send it (freshly, iow not part of this thre=
ad).
And while I am at it, I would add the stable tag.

-Stefan

>=20
>>  	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
>>  		/* Make pagetable pieces RO */
>>  		set_page_prot(init_level4_pgt, PAGE_KERNEL_RO);
>> --=20
>> 1.9.1
>>



--SXPvX99XgnmPsPfhX9hjgW692hE137Xxd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUAI3aAAoJEOhnXe7L7s6j5ywQAOKMOMwpeEczYyZVb3QFrCXh
oIfEY1j+WOb75BF5RSzy6+WQgUOverCkf6JN2i/tZSqrQIl0ZHT1JN8eCXRiH8Ty
jm98Y/VhCE7hI/xJ9VNchbNBK9a5v3anu2bG95L3oUJ/ENbs0Vv44Shiw3I9Rdt1
1dboUmzPYIbO0vHHNf2jkwlVB6455LZqW8zTNa02lFGF0KBdWv4TUDSWqICJZsuu
oLWyEdl76EonwyR2Z0N4ugjzBuKj2JoQHGUD+lYjKB96LC+TA52o+jo2JN4CvKWO
XN4dQl2eD0ZnLLteoYKUjMDwAKaLYO4GXSiwxsQbhHd4SeLXx4x5GYxUfWsNXGMj
MagCr0QJmQ6gbT825G5E+cBwpYDcO31AAhZCvx9NreNQdv4/23GWKCp8VEaOa3pR
CGEmlYfvfIjCWNCWtB62DxTDqzWoNO+qbluNZAJ/9ASLH9zJ/MKBoULLFfAwNb1H
pO2SFk3kqam+kV5NFU5fLRbuEto+AMa849DzgnMfzvtbr+xGXAJT0jqbjGNfNwGv
teWBjZb3b55t7tdsyAxxMo56NKFrro8W4hXT/z77//LJ6Yv6Cw1uRdAawh8bymNs
DQjFXpPoIyTxYU4UGLZqd3hpTVCpzF2mZ27T6fCU69J4I6t8sIo732h5pqcUqAI9
nZLF/GzghmXOPnhhics+
=WW7V
-----END PGP SIGNATURE-----

--SXPvX99XgnmPsPfhX9hjgW692hE137Xxd--
