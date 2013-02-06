Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab3BFDGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 22:06:36 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50299 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab3BFDGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 22:06:33 -0500
Date: Wed, 6 Feb 2013 14:06:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <josh.h.morris@us.ibm.com>,
        Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20130206140623.04297c3ac2f0fa3437369ffe@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Feb_2013_14_06_23_+1100_CyaHjbJ=8D9xycG2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Feb_2013_14_06_23_+1100_CyaHjbJ=8D9xycG2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/block/rsxx/core.c:322:22: error: expected '=3D', ',', ';', 'asm' or=
 '__attribute__' before 'rsxx_pci_probe'
drivers/block/rsxx/core.c:513:23: error: expected '=3D', ',', ';', 'asm' or=
 '__attribute__' before 'rsxx_pci_remove'
drivers/block/rsxx/core.c:610:12: error: 'rsxx_pci_probe' undeclared here (=
not in a function)
drivers/block/rsxx/core.c:611:2: error: implicit declaration of function '_=
_devexit_p' [-Werror=3Dimplicit-function-declaration]
drivers/block/rsxx/core.c:611:25: error: 'rsxx_pci_remove' undeclared here =
(not in a function)
drivers/block/rsxx/core.c:51:8: warning: 'rsxx_disk_ida' defined but not us=
ed [-Wunused-variable]
drivers/block/rsxx/core.c:52:8: warning: 'rsxx_ida_lock' defined but not us=
ed [-Wunused-variable]
drivers/block/rsxx/core.c:219:13: warning: 'card_event_handler' defined but=
 not used [-Wunused-function]
drivers/block/rsxx/core.c:311:12: warning: 'rsxx_compatibility_check' defin=
ed but not used [-Wunused-function]

Caused by commit 8722ff8cdbfa ("block: IBM RamSan 70/80 device driver")
interacting with commit 54b956b90360 ("Remove __dev* markings from
init.h") from Linus' tree (as of v3.8-rc4).

I added the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 6 Feb 2013 14:03:13 +1100
Subject: [PATCH] block: remove new __devinit/exit annotations

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/block/rsxx/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index f752191..83dadbe 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -319,7 +319,7 @@ static int rsxx_compatibility_check(struct rsxx_cardinf=
o *card)
 	return 0;
 }
=20
-static int __devinit rsxx_pci_probe(struct pci_dev *dev,
+static int rsxx_pci_probe(struct pci_dev *dev,
 					const struct pci_device_id *id)
 {
 	struct rsxx_cardinfo *card;
@@ -510,7 +510,7 @@ failed_ida_get:
 	return st;
 }
=20
-static void __devexit rsxx_pci_remove(struct pci_dev *dev)
+static void rsxx_pci_remove(struct pci_dev *dev)
 {
 	struct rsxx_cardinfo *card =3D pci_get_drvdata(dev);
 	unsigned long flags;
@@ -608,7 +608,7 @@ static struct pci_driver rsxx_pci_driver =3D {
 	.name		=3D DRIVER_NAME,
 	.id_table	=3D rsxx_pci_ids,
 	.probe		=3D rsxx_pci_probe,
-	.remove		=3D __devexit_p(rsxx_pci_remove),
+	.remove		=3D rsxx_pci_remove,
 	.suspend	=3D rsxx_pci_suspend,
 	.shutdown	=3D rsxx_pci_shutdown,
 };
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__6_Feb_2013_14_06_23_+1100_CyaHjbJ=8D9xycG2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJREcivAAoJEECxmPOUX5FErmcQAI5nPcNbfeCl0CC1mN+4Hd50
DISmjnNYvhHtPFVpDh6vF+OgZQ+8OPnA2sJ2XCUroVU5AtVUJWx6K3VtLOuI3xZF
VfRz13u2vJx7/GtuUkxuslpHB8s2P9W6Ar+D4jvXQiK2v8UOFF551h+IWzKBeGH/
qW/0lw5fDRkwPU56e9BlACDs3Pa44XSiG8TR9m9vTBi7Q+xbmte3baKmLf4GBZzm
VD7uuzxRWT6JGQ/Iuu1vuVrhkLq9YjfUICDO4jSJJymPob9QRBkrn2RRQIQCvCsO
RVgGMIMkac8+E0YecDY1nhf5bIk9O/9F4qJwPVb/ZBagbxcQW8tWZGU+OidpHxxv
x6UdPyYj3Kl67NVoPYhCdOXkzMVhRf1JA0YGxiE6H8FwLB4WMAMz62OQL+GEu4QG
1c3+zb9kuZPL1u7J0JO4kwRN2105RyEIrhz3qPi38hwCOez8tTd9YZWLMVIA24eP
JpZkgg6g7Pds8kl3be0kdbL6Bxyh/EOFicpFOsBMqrdJIgNRlOxOqyS2eO+hzDEN
23qUruXipgKzW+9DwSd6qSY8cxWrn769tlnZECjZBpoPk1GglXPHW6kw7u7vnnpg
MqXl/t4EUpQ0ngLRnNjnhzolAqNf3sjd9jKMFoh4bG/j93UfkI4v37DtLlS1syW/
bYVJDZE0JjoNA+LkzSqB
=IprU
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Feb_2013_14_06_23_+1100_CyaHjbJ=8D9xycG2--
