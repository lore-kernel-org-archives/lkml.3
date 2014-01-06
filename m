Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaAFHSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 02:18:45 -0500
Received: from ozlabs.org ([203.10.76.45]:60721 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbaAFHSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 02:18:44 -0500
Date: Mon, 6 Jan 2014 18:18:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chen, Gong" <gong.chen@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: linux-next: manual merge of the tip tree with the pm tree
Message-Id: <20140106181837.3f47b95ea5fafc48df78d1b0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Jan_2014_18_18_37_+1100_AdZ_3FjBRrsKBhDe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Jan_2014_18_18_37_+1100_AdZ_3FjBRrsKBhDe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
drivers/acpi/acpi_extlog.c between commit 7ede9f8a1805 ("ACPI / extlog:
replace open-coded _DSM code with helper functions") from the pm tree and
commit 42139eb356e3 ("ACPI, eMCA: Combine eMCA/EDAC event reporting
priority") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/acpi/acpi_extlog.c
index 94166680b3a3,5d33c5415405..000000000000
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@@ -9,8 -9,10 +9,9 @@@
 =20
  #include <linux/module.h>
  #include <linux/acpi.h>
 -#include <acpi/acpi_bus.h>
  #include <linux/cper.h>
  #include <linux/ratelimit.h>
+ #include <linux/edac.h>
  #include <asm/cpu.h>
  #include <asm/mce.h>
 =20
@@@ -40,7 -44,9 +41,9 @@@ struct extlog_l1_head=20
  	u8  rev1[12];
  };
 =20
+ static int old_edac_report_status;
+=20
 -static u8 extlog_dsm_uuid[] =3D "663E35AF-CC10-41A4-88EA-5470AF055295";
 +static u8 extlog_dsm_uuid[] __initdata =3D "663E35AF-CC10-41A4-88EA-5470A=
F055295";
 =20
  /* L1 table related physical address */
  static u64 elog_base;
@@@ -147,16 -153,53 +150,16 @@@ static int extlog_print(struct notifier
 =20
  	rc =3D print_extlog_rcd(NULL, (struct acpi_generic_status *)elog_buf, cp=
u);
 =20
- 	return NOTIFY_DONE;
+ 	return NOTIFY_STOP;
  }
 =20
 -static int extlog_get_dsm(acpi_handle handle, int rev, int func, u64 *ret)
 +static bool __init extlog_get_l1addr(void)
  {
 -	struct acpi_buffer buf =3D {ACPI_ALLOCATE_BUFFER, NULL};
 -	struct acpi_object_list input;
 -	union acpi_object params[4], *obj;
  	u8 uuid[16];
 -	int i;
 +	acpi_handle handle;
 +	union acpi_object *obj;
 =20
  	acpi_str_to_uuid(extlog_dsm_uuid, uuid);
 -	input.count =3D 4;
 -	input.pointer =3D params;
 -	params[0].type =3D ACPI_TYPE_BUFFER;
 -	params[0].buffer.length =3D 16;
 -	params[0].buffer.pointer =3D uuid;
 -	params[1].type =3D ACPI_TYPE_INTEGER;
 -	params[1].integer.value =3D rev;
 -	params[2].type =3D ACPI_TYPE_INTEGER;
 -	params[2].integer.value =3D func;
 -	params[3].type =3D ACPI_TYPE_PACKAGE;
 -	params[3].package.count =3D 0;
 -	params[3].package.elements =3D NULL;
 -
 -	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_DSM", &input, &buf)))
 -		return -1;
 -
 -	*ret =3D 0;
 -	obj =3D (union acpi_object *)buf.pointer;
 -	if (obj->type =3D=3D ACPI_TYPE_INTEGER) {
 -		*ret =3D obj->integer.value;
 -	} else if (obj->type =3D=3D ACPI_TYPE_BUFFER) {
 -		if (obj->buffer.length <=3D 8) {
 -			for (i =3D 0; i < obj->buffer.length; i++)
 -				*ret |=3D (obj->buffer.pointer[i] << (i * 8));
 -		}
 -	}
 -	kfree(buf.pointer);
 -
 -	return 0;
 -}
 -
 -static bool extlog_get_l1addr(void)
 -{
 -	acpi_handle handle;
 -	u64 ret;
 =20
  	if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle)))
  		return false;

--Signature=_Mon__6_Jan_2014_18_18_37_+1100_AdZ_3FjBRrsKBhDe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSyljSAAoJEMDTa8Ir7ZwVR3wP/jRFawXFHqzjDKrJBH5VuIvY
c4WKjuP6eutRAFhvCEAieG9Yd0Mc/pFqf2wsWuUmuVrFZEn2tCxWlnf0ClX5Dh4a
02b8Pn5oLXlIWkmvf/ekAPdfjvQmVqF6WmHcmyKC3Z3/AwmrP4Ydty6NvTXIj0l1
e4Nslfvo74NRB/R7iQc7CR9wd2FLoWEzhmtLRZk33fr593QVrW+h6nyInghMqotY
laMkU5b9hiHMrdeBKEve1L92WCOPq1NJLNqi9vDxTVx74F86JC7iIcxkp8dkLJRC
F7oQFoyOXbyQnSalaIW8vXRB5okzed6zNZxv2gPOa6ChYs8LIPCnqTEKWg4Q2/yO
hom61XQDBoEjOkvi1TKd/PQexeaJj++TAywxOAIhWJzXUCLenPDwti2F0PKzd15O
ZO0Acza/lV28n7cneticteKuNCMiuANY7FHvghMBnTTUQvr5wKhUC+nm3Xi4lK+8
ZHMxC4O5XOg+Jh9fMruEg69rRq07QD5RB86B5IpAHllp+V9JO6IlaRh20uCaNTTg
svfmmErfK9Tra4PcoO2dStIy+AVB7rqMNELb6Z9VCsltkpX2e1DYTmBAytuty/ou
yyo31ZzHldRwbw36kd/Stv3DvgI7yuSrpmkhSK1/fdqKKvjqC0p20I5PYJmyGGD3
SU3OSjOdCtpfw9wFIvYb
=nCNZ
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Jan_2014_18_18_37_+1100_AdZ_3FjBRrsKBhDe--
