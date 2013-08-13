Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104Ab3HMUP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:15:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43490 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759053Ab3HMUPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:15:23 -0400
Message-ID: <1376424911.11676.1.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] modpost, tpm_tis: Remove wildcard ACPI and PNP aliases
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Cc: tpmdd-devel@lists.sourceforge.net, Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 13 Aug 2013 22:15:11 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-27CiI3MAeZDdMwhmhNDC"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 80.83.48.229
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-27CiI3MAeZDdMwhmhNDC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tpm_tis has a 'spare' entry in its device ID table for adding
user-specified device IDs.  This will be ignored by the driver
matching logic, but modpost turns it into:

alias:          acpi*::*
alias:          pnp:d*

This seems to result in the driver being loaded on almost all PCs.
Change do_pnp_device_entry() to stop if it finds such an entry,
similarly to do_usb_entry_multi().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 scripts/mod/file2alias.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 2370863..7dc7edf 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -535,6 +535,14 @@ static void do_pnp_device_entry(void *symval, unsigned=
 long size,
 		char acpi_id[sizeof(*id)];
 		int j;
=20
+		/*
+		 * Some modules (tpm_tis) have empty slots as
+		 * placeholder for run-time specification that results
+		 * in catch-all alias
+		 */
+		if (!**id)
+			return;
+
 		buf_printf(&mod->dev_table_buf,
 			   "MODULE_ALIAS(\"pnp:d%s*\");\n", *id);
=20



--=-27CiI3MAeZDdMwhmhNDC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUgqTz+e/yOyVhhEJAQpK9Q/9GVan0HoCF/a0WWwMG0sF2B6MkjJxTPEl
WQ+C35vJqHwASd8uasW1IfWa3AduDlurVjRH+l71okCGfQwiHYzhoYiNeTvvbk9f
wVCESwgGv/PC6uA7o/swqekt5fFNmJP/B+8p6EvhkNI5VjGJnQY/wE6SspHM+SiV
BW6D7gFJgep3eGq1BRlgnBC+Mbg5lx43dVwUQsXjDIPtSvt95dQEVWFEgAY2S7jW
aP509Gr3PIwSu4Kurt3MZHdstoDKuj8+5y1nRsku2LNANXt69q6KXJI6fyASHXaf
w/1qRBLXt9dd33yiOmo/6wRlXgfS1Ru9xlwVkfW86GX4kQMZmITM3WIxO/4/1nPN
kLsQtcnR3PJbjrSL6gAhq7iVyM5/L6wt40vkjkWXmD43B7nWJwM5qyadfcxCfjCM
V++MN0ONXdAHpyXwDTDGh0r5luhKhpJU0vmvu0/su9Qo/qmJ1XNlNqI9gl7gPRMb
LoSEzKeN966klqcyf0Eh3Ei1GMPR1heQiV6mcxOWZjUUYWIdyrW1ZZXm9tQz2XUN
7ICo3ciQ8z3E9BCCTwcFrCxtMW+avkvzJpf/NwRhIs98jWp+mFfIcQ3OY4SpUnY5
cwu6fdmlKPYoTzsmDg9rm8HeXF2blI0opg4OHiHpiScpZ+p9rkj/DKeUTBORg60J
p1dHkuag6s8=
=lP8f
-----END PGP SIGNATURE-----

--=-27CiI3MAeZDdMwhmhNDC--
