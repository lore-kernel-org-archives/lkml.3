Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765100Ab3DEJBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 05:01:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50158 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab3DEJBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 05:01:07 -0400
Message-ID: <515E92CE.2000509@canonical.com>
Date: Fri, 05 Apr 2013 11:01:02 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
CC: Andy Whitcroft <apw@canonical.com>, Mel Gorman <mgorman@suse.de>
Subject: x86/mm/pageattr: Code without effect?
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig76B1CDE8C1771BF94CD89399"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig76B1CDE8C1771BF94CD89399
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

When looking through some mm code I stumbled over one part in
arch/x86/mm/pageattr.c that looks somewhat bogus to me. Cannot
say what exactly the effects are, but maybe you do (or you could
explain to me why I am wrong :)).

commit a8aed3e0752b4beb2e37cbed6df69faae88268da
Author: Andrea Arcangeli <aarcange@redhat.com>
Date:   Fri Feb 22 15:11:51 2013 -0800

    x86/mm/pageattr: Prevent PSE and GLOABL leftovers to confuse
    pmd/pte_present and pmd_huge

added the following to try_preserve_large_page:

 	/*
+	 * Set the PSE and GLOBAL flags only if the PRESENT flag is
+	 * set otherwise pmd_present/pmd_huge will return true even on
+	 * a non present pmd. The canon_pgprot will clear _PAGE_GLOBAL
+	 * for the ancient hardware that doesn't support it.
+	 */
+	if (pgprot_val(new_prot) & _PAGE_PRESENT)
+		pgprot_val(new_prot) |=3D _PAGE_PSE | _PAGE_GLOBAL;
+	else
+		pgprot_val(new_prot) &=3D ~(_PAGE_PSE | _PAGE_GLOBAL);
+
+	new_prot =3D canon_pgprot(new_prot);
+
+	/*

but (extending what follows after the changes)

	 * old_pte points to the large page base address. So we need
	 * to add the offset of the virtual address:
	 */
	pfn =3D pte_pfn(old_pte) + ((address & (psize - 1)) >> PAGE_SHIFT);
	cpa->pfn =3D pfn;

	new_prot =3D static_protections(req_prot, address, pfn);

So new_prot gets completely replaced by req_prot and all changes done to
new_prot before look to be lost (the PSE and GLOBAL bit settings as well
as the canon_pgprot call.

Maybe the hunk is useless anyway, or the breakage is subtle, or I miss so=
mething...

Thanks,
Stefan


--------------enig76B1CDE8C1771BF94CD89399
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBCgAGBQJRXpLOAAoJEOhnXe7L7s6jjI4QAJsVt0e7EQsZS1ro7BWvIQa1
R9lfG8ddqq2peGbcyBa3/8TV78IHwcF5k0qG0VTXBvlsc6D5IulMoRtK+QyykPqb
3IyqUgc+SI66QEdOxKoXHcqd+V4TFllASUjrAjxeMNnFWHDYDM+ar/EO9iIV3ayG
uZ/799KXJDQ10OrBQPipoqcacoYJ1RxxOErtd30DKxH2fY4FUvty2em7CJUr1FHM
PA957f1wD7dAQutuR1gkK1mw5dr7I4RzPYpCsbj9aEUK/A16q3jaoCe2yIW5vliY
JNrRoDBDs6xEyi4iZL1dDe42EW5PP2L23xxnb59LdgLeZtoZKFk9amt9T6cz/Ei6
ImXvnV3cWqju+LSrJF36AnVitKGBPlaZTN1geXgN258VpCe/AqTVN0FEwCH0ZxRo
L3yS2K2FUsEIuqupou3Q8t27atfdbzHrDBLvTcFGjZUEhxoCKmN17FqqcBSuNCyA
QjImo0vYCOELFIbqKMhWo0vcCGNydr00+fuPZ7pzzYgKR6d/W18qXAFgCRAYZDZy
J1c4XvDTNgv9r85jgBLZ1Qiy6034yJevx2IML9s9LHblnig9h7aYssEhHyroRDli
O/tplHAsqV+W31K9uVOL07mRf1LNs7k7zDBteO712hQyQ6IE57iMxA6AQM2DZNhl
nYADRxKvEPN4yy7eAAyh
=OT9i
-----END PGP SIGNATURE-----

--------------enig76B1CDE8C1771BF94CD89399--
