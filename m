Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaEUGPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 02:15:40 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:49832 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaEUGPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 02:15:39 -0400
Message-ID: <537C447D.7070406@aurabindo.in>
Date: Wed, 21 May 2014 11:45:25 +0530
From: Jay Aurabind <mail@aurabindo.in>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kbuild test robot <fengguang.wu@intel.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH V2] mfd: abx500-core: Fix compiler warning larger stack
 frame
References: <536E1543.3090107@aurabindo.in> <20140520152054.GB24991@lee--X1>
In-Reply-To: <20140520152054.GB24991@lee--X1>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7gVwSVSWtKLgkOb7R0mBw7weLlthUx9q0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7gVwSVSWtKLgkOb7R0mBw7weLlthUx9q0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

H1,

Change from V1 -> V2: Fix a potential null pointer dereference as reporte=
d by kbuild test robot <fengguang.wu@intel.com>.

Inorder to report the kzalloc failure, I have just used a pr_debug statem=
ent. If it looks ugly, should I change the function's return value to int=
 and give out an -ENOMEM ?

=46rom 6615c7a995a6bb4dcf4c1e9ac59bca823ec821a5 Mon Sep 17 00:00:00 2001
From: Aurabindo J <mail@aurabindo.in>
Date: Wed, 21 May 2014 11:18:10 +0530
Subject: [PATCH] mfd: abx500-core: Fix compiler warning larger stack fram=
e

On systems with CONFIG_FRAME_WARN=3D1024, compiler warns the allocation o=
f
an object of struct device on stack. Make the allocation dynamically to
fix the warning.

Signed-off-by: Aurabindo J <mail@aurabindo.in>
---
 drivers/mfd/abx500-core.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/abx500-core.c b/drivers/mfd/abx500-core.c
index f3a15aa..5e5098d 100644
--- a/drivers/mfd/abx500-core.c
+++ b/drivers/mfd/abx500-core.c
@@ -154,16 +154,21 @@ EXPORT_SYMBOL(abx500_startup_irq_enabled);
 void abx500_dump_all_banks(void)
 {
 	struct abx500_ops *ops;
-	struct device dummy_child =3D {NULL};
+	struct device *dummy_child;
 	struct abx500_device_entry *dev_entry;
=20
-	list_for_each_entry(dev_entry, &abx500_list, list) {
-		dummy_child.parent =3D dev_entry->dev;
-		ops =3D &dev_entry->ops;
+	dummy_child =3D kzalloc(sizeof(struct device), GFP_KERNEL);
+	if (dummy_child !=3D NULL) {
+		list_for_each_entry(dev_entry, &abx500_list, list) {
+			dummy_child->parent =3D dev_entry->dev;
+			ops =3D &dev_entry->ops;
=20
-		if ((ops !=3D NULL) && (ops->dump_all_banks !=3D NULL))
-			ops->dump_all_banks(&dummy_child);
-	}
+			if ((ops !=3D NULL) && (ops->dump_all_banks !=3D NULL))
+				ops->dump_all_banks(dummy_child);
+		}
+		kfree(dummy_child);
+	} else
+		pr_debug("kzalloc failure in abx500_dump_all_banks\n");
 }
 EXPORT_SYMBOL(abx500_dump_all_banks);
=20
--=20
1.9.1




--7gVwSVSWtKLgkOb7R0mBw7weLlthUx9q0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlN8RIQACgkQq5pl9aLRKAVdOgEAgmTmwHevmGePGtQU9QWNmKkR
2U7gV5A4wKH8FCMZLc4A/ilr4tRtK/009DtfecavX2wUIlQA+LwTO4pE9kqWydaM
=u3rc
-----END PGP SIGNATURE-----

--7gVwSVSWtKLgkOb7R0mBw7weLlthUx9q0--
