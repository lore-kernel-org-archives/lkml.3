Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab3CACvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 21:51:12 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36228 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3CACvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 21:51:10 -0500
Date: Fri, 1 Mar 2013 13:51:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-Id: <20130301135107.2c2980b911c6200e9d7b8a16@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__1_Mar_2013_13_51_07_+1100_w6zV4y1VQJt7HOkS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Mar_2013_13_51_07_+1100_w6zV4y1VQJt7HOkS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in
arch/x86/kernel/kvmclock.c between commit 5dfd486c4750 ("x86, kvm: Fix
kvm's use of __pa() on percpu areas") from Linus' tree and commit
fe1140cc3694 ("x86: kvmclock: Do not setup kvmclock vsyscall in the
absence of that clock") from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/kvmclock.c
index 0732f00,b730efa..0000000
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@@ -160,10 -160,14 +160,14 @@@ int kvm_register_clock(char *txt
  {
  	int cpu =3D smp_processor_id();
  	int low, high, ret;
- 	struct pvclock_vcpu_time_info *src =3D &hv_clock[cpu].pvti;
+ 	struct pvclock_vcpu_time_info *src;
+=20
+ 	if (!hv_clock)
+ 		return 0;
 =20
+ 	src =3D &hv_clock[cpu].pvti;
 -	low =3D (int)__pa(src) | 1;
 -	high =3D ((u64)__pa(src) >> 32);
 +	low =3D (int)slow_virt_to_phys(src) | 1;
 +	high =3D ((u64)slow_virt_to_phys(src) >> 32);
  	ret =3D native_write_msr_safe(msr_kvm_system_time, low, high);
  	printk(KERN_INFO "kvm-clock: cpu %d, msr %x:%x, %s\n",
  	       cpu, high, low, txt);

--Signature=_Fri__1_Mar_2013_13_51_07_+1100_w6zV4y1VQJt7HOkS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRMBebAAoJEECxmPOUX5FEIkAP/RuJ/8eYLcoH7Tey2+XUSPUc
XWwhhxC+QaQoL+SQucIu1FrQLtCl9LERMTwtcepEXxuyWsyV5hVaVIlTmKm8mWxe
fMk5tAV5PrmmtH+IHmmSCAXvgROoBi52z5RwcDFoYHIRLEXwfYfPqQ7kFqhO3vlj
hinjtmYkTrts2pvLKE6UdMCFBdnnStQfJ/w2JpOduGQ1tUajRSoa3+oPoLD76AcK
Migva8OwbAlGIvO0RK5B0LHCv7149ObqLTVmc4VVyxRbUDOStAMd9MX1mkxhf8e1
8Wwor6oF/m/CKdaSAZXqoaYObFS7PsabFfFtvP8BYy2m2BjJ4d9K7jpY8wc+FgtR
iZMOyOL4UkxmHOcl5empYwltAg1rxKMF3MM5t4vlfhFm3fMNwtao+LwoVdWkhRgV
HFZeR1/ac/tY4gv5HtQcHmjnkOgqWZ1QzWB26WZsv9XNOF+qV0pldES6vF35b7Li
DMNFEr2f1R4lFr6zRvCWQ72qxKZD5nHMNyr1kXGFzKECXv2qOjPsTSsZShrFe3Re
5CcjXwgxawBX8ZZJ9WJkjfE/NojmCFHRrHcvXXebj2Ci7Gz4tYY9KE8i4K5YPExk
CIUgOct9ny2kHsFdMSXbjlFOk/sjVJ8jKOP95JVRpAjP6VFf+AAINFTHz41Ytl1q
0loArA0A9KnCPqb5k18O
=MbmS
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Mar_2013_13_51_07_+1100_w6zV4y1VQJt7HOkS--
