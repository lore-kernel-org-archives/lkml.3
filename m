Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaBUFrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 00:47:20 -0500
Received: from ozlabs.org ([203.10.76.45]:47388 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbaBUFrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 00:47:18 -0500
Date: Fri, 21 Feb 2014 16:47:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: linux-next: build failure after merge of the char-misc tree
Message-Id: <20140221164711.9e62ae1f03fe1166943a2a14@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Feb_2014_16_47_11_+1100_P_edYjAu//9CpyOG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Feb_2014_16_47_11_+1100_P_edYjAu//9CpyOG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the char-misc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from drivers/misc/mei/hw-txe.c:25:0:
drivers/misc/mei/hw-txe.h:63:1: error: unknown type name 'irqreturn_t'
 irqreturn_t mei_txe_irq_quick_handler(int irq, void *dev_id);
 ^
drivers/misc/mei/hw-txe.h:64:1: error: unknown type name 'irqreturn_t'
 irqreturn_t mei_txe_irq_thread_handler(int irq, void *dev_id);
 ^
drivers/misc/mei/hw-txe.c:879:1: error: unknown type name 'irqreturn_t'
 irqreturn_t mei_txe_irq_quick_handler(int irq, void *dev_id)
 ^
drivers/misc/mei/hw-txe.c: In function 'mei_txe_irq_quick_handler':
drivers/misc/mei/hw-txe.c:884:10: error: 'IRQ_WAKE_THREAD' undeclared (firs=
t use in this function)
   return IRQ_WAKE_THREAD;
          ^
drivers/misc/mei/hw-txe.c:884:10: note: each undeclared identifier is repor=
ted only once for each function it appears in
drivers/misc/mei/hw-txe.c:885:9: error: 'IRQ_NONE' undeclared (first use in=
 this function)
  return IRQ_NONE;
         ^
drivers/misc/mei/hw-txe.c: At top level:
drivers/misc/mei/hw-txe.c:898:1: error: unknown type name 'irqreturn_t'
 irqreturn_t mei_txe_irq_thread_handler(int irq, void *dev_id)
 ^
drivers/misc/mei/hw-txe.c: In function 'mei_txe_irq_thread_handler':
drivers/misc/mei/hw-txe.c:1007:9: error: 'IRQ_HANDLED' undeclared (first us=
e in this function)
  return IRQ_HANDLED;
         ^
drivers/misc/mei/hw-txe.c: In function 'mei_txe_irq_quick_handler':
drivers/misc/mei/hw-txe.c:886:1: warning: control reaches end of non-void f=
unction [-Wreturn-type]
 }
 ^
drivers/misc/mei/hw-txe.c: In function 'mei_txe_irq_thread_handler':
drivers/misc/mei/hw-txe.c:1008:1: warning: control reaches end of non-void =
function [-Wreturn-type]
 }
 ^

Caused by commit 266f6178d1f1 ("mei: txe: add hw-txe.h header file") but
probably exposed by commit 46cb7b1bd86f ("PCI: Remove unused SR-IOV VF
Migration support") from the pci tree which removed the include of
irqreturn.h from pci.h ...

See Rule 1 from Documentation/SubmitChecklist ...

I added the following merge fix patch (this should be applied to the
char-misc tree):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 21 Feb 2014 16:38:28 +1100
Subject: [PATCH] mei: txe: include irqreturn.h for irqreturn_t etc

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/misc/mei/hw-txe.c | 1 +
 drivers/misc/mei/hw-txe.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/misc/mei/hw-txe.c b/drivers/misc/mei/hw-txe.c
index 19579e560dad..49a5ed376969 100644
--- a/drivers/misc/mei/hw-txe.c
+++ b/drivers/misc/mei/hw-txe.c
@@ -18,6 +18,7 @@
 #include <linux/jiffies.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/irqreturn.h>
=20
 #include <linux/mei.h>
=20
diff --git a/drivers/misc/mei/hw-txe.h b/drivers/misc/mei/hw-txe.h
index 857d88ccef61..fdb665f44d5d 100644
--- a/drivers/misc/mei/hw-txe.h
+++ b/drivers/misc/mei/hw-txe.h
@@ -17,6 +17,8 @@
 #ifndef _MEI_HW_TXE_H_
 #define _MEI_HW_TXE_H_
=20
+#include <linux/irqreturn.h>
+
 #include "hw.h"
 #include "hw-txe-regs.h"
=20
--=20
1.9.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__21_Feb_2014_16_47_11_+1100_P_edYjAu//9CpyOG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTBuhjAAoJEMDTa8Ir7ZwVl6sP/R+AAj4SiGXoMH/uGgK7b/69
iauSTN8pFfdY1/IaStvxOtCPuSvp8O+9JKxYcQB5HGI9k2kTM64porkPDN4YE787
rvd0MvkUEnQHLvt0BX1wC6wp/BSogaiGC3LSx4oBgQtz+D0wGKQQe4fEN7xql/W7
rVF788LOBO61k3JsZSfk3lffi5Ka0kLh6ubf5EcsVlhC8tTSh9Wke/TnEYsRXY8q
m2sj1kIODrR+ewWfHAT4fOKHEs0ifXweZ3oQ9ucLR5n+s3hRCIch74nGkCrDdAi9
pTe3+QP7ZrcJTKD1Ok0RPTZvAgIvOknQEoLO/jBiCxk5ALkSW2TJThWyrDyzi7FU
PQRDMjLVAxkYi1n0z/soUWaty877VTN4ugze5JewZ7XOTXE609pavYWbecn5V0i+
mYWXEUtQRMp5+zZtd2nNfGn8HZdQcd0BfKl06QrGCbkZjuZF+OGbvv3N0/ugFbhe
nL3fFb9YuN47DpN8CUn7aJhzxYDniAtN+GyOL0ZS9yxmz/Pf4hMhPwaq09e9PDs1
oQbKZGj81Hcc+oLWfaTGodfQs2jR/nW+yhyNfn8EpnFgxpToHhilTqs8RYB+yoyR
23YkZba/RqA/L3fH68bfcPJBPgWKo4TFEiToASGRAzsrIP67jGKLmOu8OZszvY/j
Xj8mZ+cbrHYshOzptP9q
=aSm4
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Feb_2014_16_47_11_+1100_P_edYjAu//9CpyOG--
