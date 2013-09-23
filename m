Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3IWJ7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:59:07 -0400
Received: from multi.imgtec.com ([194.200.65.239]:44853 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab3IWJ7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:59:04 -0400
Message-ID: <524010D5.9000208@imgtec.com>
Date: Mon, 23 Sep 2013 10:58:45 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "Aurelien Jacquiot" <a-jacquiot@ti.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chris Zankel <chris@zankel.net>, "H. Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@redhat.com>, Jonas Bonn <jonas@southpole.se>,
        Mark Salter <msalter@redhat.com>, Max Filippov <jcmvbkbc@gmail.com>,
        Michal Simek <monstr@monstr.eu>, <microblaze-uclinux@itee.uq.edu.au>,
        Paul Mackerras <paulus@samba.org>, Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <vgupta@synopsys.com>, Will Deacon <will.deacon@arm.com>,
        <x86@kernel.org>
Subject: Re: [PATCH 00/28] Early flattened DT init consolidation
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="vcARjtQXn4SQ7Ckqik1vUmP4TsVHqeQMx"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_09_23_10_58_53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vcARjtQXn4SQ7Ckqik1vUmP4TsVHqeQMx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17/09/13 00:08, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>=20
> This is the first of 2 series to do some consolidation of per
> architecture Device Tree code. We now have 12 architectures with DT
> support. As new architectures have been added, much of the DT related
> code for the early flattened DT scanning has been duplicated. Yet littl=
e
> of this code is architecture specific. This series has 4 main parts:
>=20
> - Create a common function to copy built-in dtb's out of init section
> - Create a single, common function to scan the FDT
> - Removal of early_init_dt_setup_initrd_arch
> - Create common functions for machine matching with DT
>=20
> The entire series is available here:
> git://sources.calxeda.com/kernel/linux.git dt-cleanup

Hi Rob,

I gave this branch a try on metag.

The following patches break the build:
e09b397e of: only include prom.h on sparc
740de19c of: remove empty arch prom.h headers

because metag's prom.h has a setup_machine_fdt function declaration
which is used in arch/metag/kernel/setup.c (and defined in
arch/metag/kernel/devtree.c). Please move that declaration elsewhere
(asm/setup.h would seem appropriate) if you're going to remove prom.h.


Also I appear to hit the BUG_ON at
drivers/of/fdt.c:511/of_get_flat_dt_root().

This is because on metag we try interpreting the command line argument
as a device tree and only use the built-in DT if that fails. Previously
we relied on the be32_to_cpu(devtree->magic) !=3D OF_DT_HEADER check in
setup_machine_fdt. The following seems to fix it:

diff --git a/arch/metag/kernel/devtree.c b/arch/metag/kernel/devtree.c
index abe607e..550dd91 100644
--- a/arch/metag/kernel/devtree.c
+++ b/arch/metag/kernel/devtree.c
@@ -52,7 +52,10 @@ struct machine_desc * __init setup_machine_fdt(void *d=
t)
 {
 	struct machine_desc *mdesc;

-	early_init_dt_scan(dt);
+	/* check device tree validity */
+	if (!early_init_dt_scan(dt))
+		return NULL;
+
 	mdesc =3D of_flat_dt_match_machine(NULL, arch_get_next_mach);
 	if (!mdesc)
 		dump_machine_table(); /* does not return */

Cheers
James

>=20
> Compiled on arm, arm64, microblaze, mips, openrisc, powerpc, sparc,
> xtensa.
>=20
> Rob
>=20
> Rob Herring (28):
>   c6x: use boot_command_line instead of private c6x_command_line
>   openrisc: use boot_command_line instead of private cmd_line
>   of: create unflatten_and_copy_device_tree
>   arc: use unflatten_and_copy_device_tree
>   openrisc: use unflatten_and_copy_device_tree
>   x86: use unflatten_and_copy_device_tree
>   xtensa: use unflatten_and_copy_device_tree
>   metag: use unflatten_and_copy_device_tree
>   of: Introduce common early_init_dt_scan
>   arc: use early_init_dt_scan
>   arm: use early_init_dt_scan
>   arm64: use early_init_dt_scan
>   c6x: use early_init_dt_scan
>   microblaze: use early_init_dt_scan
>   mips: use early_init_dt_scan
>   openrisc: use early_init_dt_scan
>   xtensa: use early_init_dt_scan
>   of: create default early_init_dt_add_memory_arch
>   arm: set initrd_start/initrd_end for fdt scan
>   arm64: set initrd_start/initrd_end for fdt scan
>   of: remove early_init_dt_setup_initrd_arch
>   openrisc: remove unnecessary prom.c includes
>   of: introduce common FDT machine related functions
>   arc: use common of_flat_dt_match_machine
>   arm: use common of_flat_dt_match_machine
>   arm64: use common of_flat_dt_get_machine_name
>   metag: use common of_flat_dt_match_machine
>   mips: use common of_flat_dt_get_machine_name
>=20
>  arch/arc/include/asm/mach_desc.h |   1 -
>  arch/arc/kernel/devtree.c        |  94 +++++++------------------------=
--
>  arch/arc/kernel/setup.c          |   3 +-
>  arch/arc/mm/init.c               |   7 ---
>  arch/arm/kernel/devtree.c        |  57 ++++++++------------
>  arch/arm/mm/init.c               |  13 ++---
>  arch/arm64/kernel/setup.c        |  60 ++-------------------
>  arch/arm64/mm/init.c             |  24 +++------
>  arch/c6x/include/asm/setup.h     |   2 -
>  arch/c6x/kernel/devicetree.c     |  29 ----------
>  arch/c6x/kernel/setup.c          |  13 +----
>  arch/metag/kernel/devtree.c      |  87 ++++++------------------------
>  arch/metag/kernel/setup.c        |   4 +-
>  arch/metag/mm/init.c             |   9 ----
>  arch/microblaze/kernel/prom.c    |  31 ++---------
>  arch/microblaze/kernel/setup.c   |   2 +-
>  arch/mips/include/asm/prom.h     |   3 --
>  arch/mips/kernel/prom.c          |  60 +--------------------
>  arch/openrisc/kernel/prom.c      |  70 +-----------------------
>  arch/openrisc/kernel/setup.c     |   6 +--
>  arch/powerpc/kernel/prom.c       |   9 ----
>  arch/x86/kernel/devicetree.c     |  42 +++------------
>  arch/xtensa/kernel/setup.c       |  55 +++++--------------
>  drivers/of/fdt.c                 | 111 +++++++++++++++++++++++++++++++=
++++++--
>  include/linux/of_fdt.h           |  18 +++----
>  25 files changed, 223 insertions(+), 587 deletions(-)
>=20


--vcARjtQXn4SQ7Ckqik1vUmP4TsVHqeQMx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJSQBDbAAoJEKHZs+irPybfsrMQAIobUBOlG9bZUZ4zTjQ1Imkt
GN4oa8tohktTKuUA1sQLEWPKCNulgtMW9aRXP/gMdsgy1zjWgBYtjq/6zTve+yiF
Oc/JTWGzi6n9cNWdqr2vnznjfeDreH/H4i/mK6jqn3YnhAo37A9zdklecMH2oxOI
iDGJyXmMYK+GjwrYj6izaiBPQ8VS/cOAQ5l2lmzHo+VHN05UZFijrbJA4pHxH0u5
kZbDcY+jNLUrGJuylXJPRKHqrdbLu6dj23N/5qu0aItqAw8zmIv9Z+0CZE6xoxui
jMdgf2YPb/shuKdlfGrtAccLqYo5gSjxeTHMXDIAyzj4gsfhZcdU1UYCXiVnJgIk
c77hRZ5pbiavXCTnRGooJdazXifxy+w32BjxNVlmkhOMgi51jU/s7oGwowDwUZrY
w60bb6EzVVGMprVv8LKNTIZkWNKdpT4UhODGrhiBp5PJfR4jF9HicdfSmT6snYzJ
q3OtTKwLcKKD2OqAX6zbhQJmznZedjf9SVidZazpp6vtI3yBQA4nwCVXRqdHvDGw
AogHmZ5EvCq2io9M+U+Uhsau3u9dekVWBKCGyChwvTckfiJXsgyhXdiK62cnjHWY
GH3p8ATF/mGizX+2yuityQQ6SlYyyWgXLYB3YURBQ8gaOse8VLJ1SCxEklPfJYnw
9eDEY9qCV02jEZ3nbE2r
=76Xd
-----END PGP SIGNATURE-----

--vcARjtQXn4SQ7Ckqik1vUmP4TsVHqeQMx--

