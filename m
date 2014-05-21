Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaEURUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:20:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36465 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaEURUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:20:10 -0400
Message-ID: <537CE03A.7060702@aurabindo.in>
Date: Wed, 21 May 2014 22:49:54 +0530
From: Jay Aurabind <mail@aurabindo.in>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [PATCH V2] mfd: abx500-core: Fix compiler warning larger stack
 frame
References: <536E1543.3090107@aurabindo.in> <20140520152054.GB24991@lee--X1> <537C447D.7070406@aurabindo.in> <20140521091751.GC6679@lee--X1>
In-Reply-To: <20140521091751.GC6679@lee--X1>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ljTfbmbbpxhTfLqBXdSa7Ov6g4E9eUUsu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ljTfbmbbpxhTfLqBXdSa7Ov6g4E9eUUsu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On Wednesday 21 May 2014 02:47 PM, Lee Jones wrote:
>> Change from V1 -> V2: Fix a potential null pointer dereference as repo=
rted by kbuild test robot <fengguang.wu@intel.com>.
>>
>> Inorder to report the kzalloc failure, I have just used a pr_debug sta=
tement. If it looks ugly, should I change the function's return value to =
int and give out an -ENOMEM ?
>=20
> Yes, please do that - and obviously add the checks to the calling code.=


But I cannot find any calling code. At least thats what linux cross refer=
ence has to say.

Change from V2 -> V3:
	Change abx500_dump_all_banks to return int so as to account for error ha=
ndling.

Change from V1 -> V2:=20
	Fix a potential null pointer dereference as reported by kbuild test robo=
t <fengguang.wu@intel.com>.

=46rom 19d34af7240498b2e624e94b2d003f3d9928dee8 Mon Sep 17 00:00:00 2001
From: Aurabindo J <mail@aurabindo.in>
Date: Wed, 21 May 2014 22:27:30 +0530
Subject: [PATCH] mfd: abx500-core: Fix compiler warning larger stack fram=
e
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

On systems with CONFIG_FRAME_WARN=3D1024, compiler warns the allocation o=
f
an object of struct device on stack. Make the allocation dynamically to
fix the warning. Also change the caller's return type to int so as to
account for error handling.

drivers/mfd/abx500-core.c: In function =E2=80=98abx500_dump_all_banks=E2=80=
=99:
drivers/mfd/abx500-core.c:167:1: warning: the frame size of 1032 bytes
is larger than 1024 bytes [-Wframe-larger-than=3D]

Signed-off-by: Aurabindo J <mail@aurabindo.in>
---
 drivers/mfd/abx500-core.c  | 12 ++++++++----
 include/linux/mfd/abx500.h |  2 +-
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/abx500-core.c b/drivers/mfd/abx500-core.c
index f3a15aa..d6d0ec4 100644
--- a/drivers/mfd/abx500-core.c
+++ b/drivers/mfd/abx500-core.c
@@ -151,19 +151,23 @@ int abx500_startup_irq_enabled(struct device *dev, =
unsigned int irq)
 }
 EXPORT_SYMBOL(abx500_startup_irq_enabled);
=20
-void abx500_dump_all_banks(void)
+int abx500_dump_all_banks(void)
 {
 	struct abx500_ops *ops;
-	struct device dummy_child =3D {NULL};
+	struct device *dummy_child;
 	struct abx500_device_entry *dev_entry;
=20
+	dummy_child =3D kzalloc(sizeof(struct device), GFP_KERNEL);
+	if (!dummy_child)
+		return -ENOMEM;
 	list_for_each_entry(dev_entry, &abx500_list, list) {
-		dummy_child.parent =3D dev_entry->dev;
+		dummy_child->parent =3D dev_entry->dev;
 		ops =3D &dev_entry->ops;
=20
 		if ((ops !=3D NULL) && (ops->dump_all_banks !=3D NULL))
-			ops->dump_all_banks(&dummy_child);
+			ops->dump_all_banks(dummy_child);
 	}
+	kfree(dummy_child);
 }
 EXPORT_SYMBOL(abx500_dump_all_banks);
=20
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 3301b20..df2508f 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -330,7 +330,7 @@ int abx500_mask_and_set_register_interruptible(struct=
 device *dev, u8 bank,
 int abx500_get_chip_id(struct device *dev);
 int abx500_event_registers_startup_state_get(struct device *dev, u8 *eve=
nt);
 int abx500_startup_irq_enabled(struct device *dev, unsigned int irq);
-void abx500_dump_all_banks(void);
+int abx500_dump_all_banks(void);
=20
 struct abx500_ops {
 	int (*get_chip_id) (struct device *);
--=20
1.9.1




--ljTfbmbbpxhTfLqBXdSa7Ov6g4E9eUUsu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlN84EIACgkQq5pl9aLRKAWLYAD/b2IfN13CbSq9m6X8vix8RSb+
UaA5oWg5Is9RLOqJ6cQA/RI/np4geEzEnMv1slpb9MyKWk+AFp8wx1yBcFfW+x7k
=pSes
-----END PGP SIGNATURE-----

--ljTfbmbbpxhTfLqBXdSa7Ov6g4E9eUUsu--
