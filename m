Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762390Ab3DCOwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:52:09 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:48717 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761357Ab3DCOwG (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 3 Apr 2013 10:52:06 -0400
Message-Id: <515C5E6202000078000CA6BE@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 03 Apr 2013 15:52:50 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen: drop tracking of IRQ vector
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__Part75457552.3__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__Part75457552.3__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

For quite a few Xen versions, this wasn't the IRQ vector anymore
anyway, and it is not being used by the kernel for anything. Hence
drop the field from struct irq_info, and respective function
parameters.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

---
 arch/x86/pci/xen.c   |    6 +++---
 drivers/xen/events.c |   13 ++++---------
 include/xen/events.h |    3 +--
 3 files changed, 8 insertions(+), 14 deletions(-)

--- 3.9-rc5/arch/x86/pci/xen.c
+++ 3.9-rc5-xen-irq-no-vector/arch/x86/pci/xen.c
@@ -177,7 +177,7 @@ static int xen_setup_msi_irqs(struct pci
 		goto error;
 	i =3D 0;
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq =3D xen_bind_pirq_msi_to_irq(dev, msidesc, v[i], 0,
+		irq =3D xen_bind_pirq_msi_to_irq(dev, msidesc, v[i],
 					       (type =3D=3D PCI_CAP_ID_MSIX=
) ?
 					       "pcifront-msi-x" :
 					       "pcifront-msi",
@@ -244,7 +244,7 @@ static int xen_hvm_setup_msi_irqs(struct
 			dev_dbg(&dev->dev,
 				"xen: msi already bound to pirq=3D%d\n", =
pirq);
 		}
-		irq =3D xen_bind_pirq_msi_to_irq(dev, msidesc, pirq, 0,
+		irq =3D xen_bind_pirq_msi_to_irq(dev, msidesc, pirq,
 					       (type =3D=3D PCI_CAP_ID_MSIX=
) ?
 					       "msi-x" : "msi",
 					       DOMID_SELF);
@@ -326,7 +326,7 @@ static int xen_initdom_setup_msi_irqs(st
 		}
=20
 		ret =3D xen_bind_pirq_msi_to_irq(dev, msidesc,
-					       map_irq.pirq, map_irq.index,=

+					       map_irq.pirq,
 					       (type =3D=3D PCI_CAP_ID_MSIX=
) ?
 					       "msi-x" : "msi",
 						domid);
--- 3.9-rc5/drivers/xen/events.c
+++ 3.9-rc5-xen-irq-no-vector/drivers/xen/events.c
@@ -85,8 +85,7 @@ enum xen_irq_type {
  * event channel - irq->event channel mapping
  * cpu - cpu this event channel is bound to
  * index - type-specific information:
- *    PIRQ - vector, with MSB being "needs EIO", or physical IRQ of the =
HVM
- *           guest, or GSI (real passthrough IRQ) of the device.
+ *    PIRQ - physical IRQ, GSI, flags, and owner domain
  *    VIRQ - virq number
  *    IPI - IPI vector
  *    EVTCHN -
@@ -105,7 +104,6 @@ struct irq_info {
 		struct {
 			unsigned short pirq;
 			unsigned short gsi;
-			unsigned char vector;
 			unsigned char flags;
 			uint16_t domid;
 		} pirq;
@@ -211,7 +209,6 @@ static void xen_irq_info_pirq_init(unsig
 				   unsigned short evtchn,
 				   unsigned short pirq,
 				   unsigned short gsi,
-				   unsigned short vector,
 				   uint16_t domid,
 				   unsigned char flags)
 {
@@ -221,7 +218,6 @@ static void xen_irq_info_pirq_init(unsig
=20
 	info->u.pirq.pirq =3D pirq;
 	info->u.pirq.gsi =3D gsi;
-	info->u.pirq.vector =3D vector;
 	info->u.pirq.domid =3D domid;
 	info->u.pirq.flags =3D flags;
 }
@@ -714,7 +710,7 @@ int xen_bind_pirq_gsi_to_irq(unsigned gs
 		goto out;
 	}
=20
-	xen_irq_info_pirq_init(irq, 0, pirq, gsi, irq_op.vector, DOMID_SELF=
,
+	xen_irq_info_pirq_init(irq, 0, pirq, gsi, DOMID_SELF,
 			       shareable ? PIRQ_SHAREABLE : 0);
=20
 	pirq_query_unmask(irq);
@@ -762,8 +758,7 @@ int xen_allocate_pirq_msi(struct pci_dev
 }
=20
 int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc =
*msidesc,
-			     int pirq, int vector, const char *name,
-			     domid_t domid)
+			     int pirq, const char *name, domid_t domid)
 {
 	int irq, ret;
=20
@@ -776,7 +771,7 @@ int xen_bind_pirq_msi_to_irq(struct pci_
 	irq_set_chip_and_handler_name(irq, &xen_pirq_chip, handle_edge_irq,=

 			name);
=20
-	xen_irq_info_pirq_init(irq, 0, pirq, 0, vector, domid, 0);
+	xen_irq_info_pirq_init(irq, 0, pirq, 0, domid, 0);
 	ret =3D irq_set_msi_desc(irq, msidesc);
 	if (ret < 0)
 		goto error_irq;
--- 3.9-rc5/include/xen/events.h
+++ 3.9-rc5-xen-irq-no-vector/include/xen/events.h
@@ -90,8 +90,7 @@ int xen_bind_pirq_gsi_to_irq(unsigned gs
 int xen_allocate_pirq_msi(struct pci_dev *dev, struct msi_desc *msidesc);
 /* Bind an PSI pirq to an irq. */
 int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc =
*msidesc,
-			     int pirq, int vector, const char *name,
-			     domid_t domid);
+			     int pirq, const char *name, domid_t domid);
 #endif
=20
 /* De-allocates the above mentioned physical interrupt. */



--=__Part75457552.3__=
Content-Type: text/plain; name="linux-3.9-rc5-xen-irq-no-vector.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="linux-3.9-rc5-xen-irq-no-vector.patch"

xen: drop tracking of IRQ vector=0A=0AFor quite a few Xen versions, this =
wasn't the IRQ vector anymore=0Aanyway, and it is not being used by the =
kernel for anything. Hence=0Adrop the field from struct irq_info, and =
respective function=0Aparameters.=0A=0ASigned-off-by: Jan Beulich =
<jbeulich@suse.com>=0ACc: Stefano Stabellini <stefano.stabellini@eu.citrix.=
com>=0A=0A---=0A arch/x86/pci/xen.c   |    6 +++---=0A drivers/xen/events.c=
 |   13 ++++---------=0A include/xen/events.h |    3 +--=0A 3 files =
changed, 8 insertions(+), 14 deletions(-)=0A=0A--- 3.9-rc5/arch/x86/pci/xen=
.c=0A+++ 3.9-rc5-xen-irq-no-vector/arch/x86/pci/xen.c=0A@@ -177,7 +177,7 =
@@ static int xen_setup_msi_irqs(struct pci=0A 		goto error;=0A 	i =
=3D 0;=0A 	list_for_each_entry(msidesc, &dev->msi_list, list) {=0A-	=
	irq =3D xen_bind_pirq_msi_to_irq(dev, msidesc, v[i], 0,=0A+		=
irq =3D xen_bind_pirq_msi_to_irq(dev, msidesc, v[i],=0A 			=
		       (type =3D=3D PCI_CAP_ID_MSIX) ?=0A 			=
		       "pcifront-msi-x" :=0A 					=
       "pcifront-msi",=0A@@ -244,7 +244,7 @@ static int xen_hvm_setup_msi_i=
rqs(struct=0A 			dev_dbg(&dev->dev,=0A 				=
"xen: msi already bound to pirq=3D%d\n", pirq);=0A 		}=0A-		=
irq =3D xen_bind_pirq_msi_to_irq(dev, msidesc, pirq, 0,=0A+		=
irq =3D xen_bind_pirq_msi_to_irq(dev, msidesc, pirq,=0A 			=
		       (type =3D=3D PCI_CAP_ID_MSIX) ?=0A 			=
		       "msi-x" : "msi",=0A 					=
       DOMID_SELF);=0A@@ -326,7 +326,7 @@ static int xen_initdom_setup_msi_=
irqs(st=0A 		}=0A =0A 		ret =3D xen_bind_pirq_msi_t=
o_irq(dev, msidesc,=0A-					       map_irq.pirq=
, map_irq.index,=0A+					       map_irq.pirq=
,=0A 					       (type =3D=3D PCI_CAP_ID_MSIX=
) ?=0A 					       "msi-x" : "msi",=0A 		=
				domid);=0A--- 3.9-rc5/drivers/xen/events.c=
=0A+++ 3.9-rc5-xen-irq-no-vector/drivers/xen/events.c=0A@@ -85,8 +85,7 @@ =
enum xen_irq_type {=0A  * event channel - irq->event channel mapping=0A  * =
cpu - cpu this event channel is bound to=0A  * index - type-specific =
information:=0A- *    PIRQ - vector, with MSB being "needs EIO", or =
physical IRQ of the HVM=0A- *           guest, or GSI (real passthrough =
IRQ) of the device.=0A+ *    PIRQ - physical IRQ, GSI, flags, and owner =
domain=0A  *    VIRQ - virq number=0A  *    IPI - IPI vector=0A  *    =
EVTCHN -=0A@@ -105,7 +104,6 @@ struct irq_info {=0A 		struct =
{=0A 			unsigned short pirq;=0A 			=
unsigned short gsi;=0A-			unsigned char vector;=0A 		=
	unsigned char flags;=0A 			uint16_t domid;=0A =
		} pirq;=0A@@ -211,7 +209,6 @@ static void xen_irq_info_pirq=
_init(unsig=0A 				   unsigned short evtchn,=0A 		=
		   unsigned short pirq,=0A 				   =
unsigned short gsi,=0A-				   unsigned short =
vector,=0A 				   uint16_t domid,=0A 			=
	   unsigned char flags)=0A {=0A@@ -221,7 +218,6 @@ static void =
xen_irq_info_pirq_init(unsig=0A =0A 	info->u.pirq.pirq =3D pirq;=0A 	=
info->u.pirq.gsi =3D gsi;=0A-	info->u.pirq.vector =3D vector;=0A 	=
info->u.pirq.domid =3D domid;=0A 	info->u.pirq.flags =3D flags;=0A =
}=0A@@ -714,7 +710,7 @@ int xen_bind_pirq_gsi_to_irq(unsigned gs=0A 		=
goto out;=0A 	}=0A =0A-	xen_irq_info_pirq_init(irq, 0, pirq, gsi, =
irq_op.vector, DOMID_SELF,=0A+	xen_irq_info_pirq_init(irq, 0, pirq, gsi, =
DOMID_SELF,=0A 			       shareable ? PIRQ_SHAREABLE : 0);=0A =
=0A 	pirq_query_unmask(irq);=0A@@ -762,8 +758,7 @@ int xen_allocate_pirq=
_msi(struct pci_dev=0A }=0A =0A int xen_bind_pirq_msi_to_irq(struct =
pci_dev *dev, struct msi_desc *msidesc,=0A-			     int =
pirq, int vector, const char *name,=0A-			     domid_t =
domid)=0A+			     int pirq, const char *name, domid_t =
domid)=0A {=0A 	int irq, ret;=0A =0A@@ -776,7 +771,7 @@ int xen_bind_pirq_m=
si_to_irq(struct pci_=0A 	irq_set_chip_and_handler_name(irq, =
&xen_pirq_chip, handle_edge_irq,=0A 			name);=0A =0A-	=
xen_irq_info_pirq_init(irq, 0, pirq, 0, vector, domid, 0);=0A+	xen_irq_inf=
o_pirq_init(irq, 0, pirq, 0, domid, 0);=0A 	ret =3D irq_set_msi_desc(ir=
q, msidesc);=0A 	if (ret < 0)=0A 		goto error_irq;=0A-=
-- 3.9-rc5/include/xen/events.h=0A+++ 3.9-rc5-xen-irq-no-vector/include/xen=
/events.h=0A@@ -90,8 +90,7 @@ int xen_bind_pirq_gsi_to_irq(unsigned gs=0A =
int xen_allocate_pirq_msi(struct pci_dev *dev, struct msi_desc *msidesc);=
=0A /* Bind an PSI pirq to an irq. */=0A int xen_bind_pirq_msi_to_irq(struc=
t pci_dev *dev, struct msi_desc *msidesc,=0A-			     int =
pirq, int vector, const char *name,=0A-			     domid_t =
domid);=0A+			     int pirq, const char *name, domid_t =
domid);=0A #endif=0A =0A /* De-allocates the above mentioned physical =
interrupt. */=0A
--=__Part75457552.3__=--
