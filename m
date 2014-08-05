Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaHEX6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:58:55 -0400
Received: from ozlabs.org ([103.22.144.67]:50127 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbaHEX6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:58:53 -0400
Date: Wed, 6 Aug 2014 09:58:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        bob picco <bpicco@meloft.net>
Subject: linux-next: manual merge of the sparc-next tree with the sparc tree
Message-ID: <20140806095845.25491f00@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/1pFgn4189QotAELIPQ12rP/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1pFgn4189QotAELIPQ12rP/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi David,

Today's linux-next merge of the sparc-next tree got a conflict in
arch/sparc/mm/init_64.c between commit 4ca9a23765da ("sparc64: Guard
against flushing openfirmware mappings") from the sparc tree and commit
f6d4fb5cc047 ("sparc64 - add mem to iomem resource") from the
sparc-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/sparc/mm/init_64.c
index 2cfb0f25e0ed,9f4f532e2627..000000000000
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@@ -2708,25 -2701,66 +2709,89 @@@ void hugetlb_setup(struct pt_regs *regs
  }
  #endif
 =20
 +#ifdef CONFIG_SMP
 +#define do_flush_tlb_kernel_range	smp_flush_tlb_kernel_range
 +#else
 +#define do_flush_tlb_kernel_range	__flush_tlb_kernel_range
 +#endif
 +
 +void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 +{
 +	if (start < HI_OBP_ADDRESS && end > LOW_OBP_ADDRESS) {
 +		if (start < LOW_OBP_ADDRESS) {
 +			flush_tsb_kernel_range(start, LOW_OBP_ADDRESS);
 +			do_flush_tlb_kernel_range(start, LOW_OBP_ADDRESS);
 +		}
 +		if (end > HI_OBP_ADDRESS) {
 +			flush_tsb_kernel_range(end, HI_OBP_ADDRESS);
 +			do_flush_tlb_kernel_range(end, HI_OBP_ADDRESS);
 +		}
 +	} else {
 +		flush_tsb_kernel_range(start, end);
 +		do_flush_tlb_kernel_range(start, end);
 +	}
 +}
++
+ static struct resource code_resource =3D {
+ 	.name	=3D "Kernel code",
+ 	.flags	=3D IORESOURCE_BUSY | IORESOURCE_MEM
+ };
+=20
+ static struct resource data_resource =3D {
+ 	.name	=3D "Kernel data",
+ 	.flags	=3D IORESOURCE_BUSY | IORESOURCE_MEM
+ };
+=20
+ static struct resource bss_resource =3D {
+ 	.name	=3D "Kernel bss",
+ 	.flags	=3D IORESOURCE_BUSY | IORESOURCE_MEM
+ };
+=20
+ static inline resource_size_t compute_kern_paddr(void *addr)
+ {
+ 	return (resource_size_t) (addr - KERNBASE + kern_base);
+ }
+=20
+ static void __init kernel_lds_init(void)
+ {
+ 	code_resource.start =3D compute_kern_paddr(_text);
+ 	code_resource.end   =3D compute_kern_paddr(_etext - 1);
+ 	data_resource.start =3D compute_kern_paddr(_etext);
+ 	data_resource.end   =3D compute_kern_paddr(_edata - 1);
+ 	bss_resource.start  =3D compute_kern_paddr(__bss_start);
+ 	bss_resource.end    =3D compute_kern_paddr(_end - 1);
+ }
+=20
+ static int __init report_memory(void)
+ {
+ 	int i;
+ 	struct resource *res;
+=20
+ 	kernel_lds_init();
+=20
+ 	for (i =3D 0; i < pavail_ents; i++) {
+ 		res =3D kzalloc(sizeof(struct resource), GFP_KERNEL);
+=20
+ 		if (!res) {
+ 			pr_warn("Failed to allocate source.\n");
+ 			break;
+ 		}
+=20
+ 		res->name =3D "System RAM";
+ 		res->start =3D pavail[i].phys_addr;
+ 		res->end =3D pavail[i].phys_addr + pavail[i].reg_size - 1;
+ 		res->flags =3D IORESOURCE_BUSY | IORESOURCE_MEM;
+=20
+ 		if (insert_resource(&iomem_resource, res) < 0) {
+ 			pr_warn("Resource insertion failed.\n");
+ 			break;
+ 		}
+=20
+ 		insert_resource(res, &code_resource);
+ 		insert_resource(res, &data_resource);
+ 		insert_resource(res, &bss_resource);
+ 	}
+=20
+ 	return 0;
+ }
+ device_initcall(report_memory);

--Sig_/1pFgn4189QotAELIPQ12rP/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT4W+6AAoJEMDTa8Ir7ZwVcRYP/j/tqSA20IdbF4t5IPTb2dFa
vWDKFl+T9YfcjIMRfI2r4r3aOlUu1qiMs+/ssR8Q+ilA12iV9XOgy1n9GQLH9LgL
cFDIx06X6uUBvL3rZSkjtcRzARW6asdVksui+K9cbtR/fylkhxgkqDIKa112BSwR
8UGoiH6lgsBG+CsVDtIITXU+MVWx8GWsyi0ycEn5HQTybiC1y1Y9RNYqK2PgHhhk
sEs/dtlFBhZjJRw+CWI8YyWnq8uj6v5+Cpfx56gF+QKayfZBxBzHZ0fXB9HDyjtr
LXmcCS03muGQU3Xjjo3v/uSc5q1j4ZeFl3mf1UxBSo1nbgY4QHrBcg9vljcYL13G
pEdSO2tw63ModKjd7+E4bS6Ez/0T4FvGXe9eEOQnqpK+bx1jcQL+RIfDE5fIn5fR
Nr9kHVB29f1a8Q09dJluYNQoLBNk/Vv1K4mSutWBfA3HaU0SjJ3USWr+LTdPplJI
oz/vxQCM7lH6vEltheMSoO8bgJVRyXD7S4ruFPBnbx7fy2bih7AOanj34cHnW0Z7
qzACODI8ZBz1UhmHWOP9Hkp1p/VMKavwDBMWIH/bN16/e9lI5nf2o7cQHd4n/TVd
7MCh90vo8vkP6eh4ngIsSWHtn92DLlrArUq+i1+803EHSRMRAjO3wqkXrasCEQ8w
YNmkV1ZlJDKyZqySnjYT
=kB8G
-----END PGP SIGNATURE-----

--Sig_/1pFgn4189QotAELIPQ12rP/--
