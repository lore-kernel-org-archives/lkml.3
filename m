Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3BFQ6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:58:09 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:33652 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab3BFQ6G (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 6 Feb 2013 11:58:06 -0500
Message-Id: <511299A902000078000BC944@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Wed, 06 Feb 2013 16:58:01 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen-pciback: notify hypervisor about devices intended
 to be assigned to guests
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__Part29196789.2__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__Part29196789.2__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

For MSI-X capable devices the hypervisor wants to write protect the
MSI-X table and PBA, yet it can't assume that resources have been
assigned to their final values at device enumeration time. Thus have
pciback do that notification, as having the device controlled by it is
a prerequisite to assigning the device to guests anyway.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/include/asm/xen/hypercall.h |    4 +-
 drivers/xen/fallback.c               |    3 +
 drivers/xen/xen-pciback/pci_stub.c   |   59 ++++++++++++++++++++++++++----=
-----
 include/xen/interface/physdev.h      |    6 +++
 4 files changed, 54 insertions(+), 18 deletions(-)

--- 3.8-rc6/arch/x86/include/asm/xen/hypercall.h
+++ 3.8-rc6-xen-pciback-MSI-X-prepare/arch/x86/include/asm/xen/hypercall.h
@@ -382,14 +382,14 @@ HYPERVISOR_console_io(int cmd, int count
 	return _hypercall3(int, console_io, cmd, count, str);
 }
=20
-extern int __must_check HYPERVISOR_physdev_op_compat(int, void *);
+extern int __must_check xen_physdev_op_compat(int, void *);
=20
 static inline int
 HYPERVISOR_physdev_op(int cmd, void *arg)
 {
 	int rc =3D _hypercall2(int, physdev_op, cmd, arg);
 	if (unlikely(rc =3D=3D -ENOSYS))
-		rc =3D HYPERVISOR_physdev_op_compat(cmd, arg);
+		rc =3D xen_physdev_op_compat(cmd, arg);
 	return rc;
 }
=20
--- 3.8-rc6/drivers/xen/fallback.c
+++ 3.8-rc6-xen-pciback-MSI-X-prepare/drivers/xen/fallback.c
@@ -44,7 +44,7 @@ int xen_event_channel_op_compat(int cmd,
 }
 EXPORT_SYMBOL_GPL(xen_event_channel_op_compat);
=20
-int HYPERVISOR_physdev_op_compat(int cmd, void *arg)
+int xen_physdev_op_compat(int cmd, void *arg)
 {
 	struct physdev_op op;
 	int rc;
@@ -78,3 +78,4 @@ int HYPERVISOR_physdev_op_compat(int cmd
=20
 	return rc;
 }
+EXPORT_SYMBOL_GPL(xen_physdev_op_compat);
--- 3.8-rc6/drivers/xen/xen-pciback/pci_stub.c
+++ 3.8-rc6-xen-pciback-MSI-X-prepare/drivers/xen/xen-pciback/pci_stub.c
@@ -17,6 +17,7 @@
 #include <xen/events.h>
 #include <asm/xen/pci.h>
 #include <asm/xen/hypervisor.h>
+#include <xen/interface/physdev.h>
 #include "pciback.h"
 #include "conf_space.h"
 #include "conf_space_quirks.h"
@@ -85,37 +86,52 @@ static struct pcistub_device *pcistub_de
 static void pcistub_device_release(struct kref *kref)
 {
 	struct pcistub_device *psdev;
+	struct pci_dev *dev;
 	struct xen_pcibk_dev_data *dev_data;
=20
 	psdev =3D container_of(kref, struct pcistub_device, kref);
-	dev_data =3D pci_get_drvdata(psdev->dev);
+	dev =3D psdev->dev;
+	dev_data =3D pci_get_drvdata(dev);
=20
-	dev_dbg(&psdev->dev->dev, "pcistub_device_release\n");
+	dev_dbg(&dev->dev, "pcistub_device_release\n");
=20
-	xen_unregister_device_domain_owner(psdev->dev);
+	xen_unregister_device_domain_owner(dev);
=20
 	/* Call the reset function which does not take lock as this
 	 * is called from "unbind" which takes a device_lock mutex.
 	 */
-	__pci_reset_function_locked(psdev->dev);
-	if (pci_load_and_free_saved_state(psdev->dev,
-					  &dev_data->pci_saved_state)) {
-		dev_dbg(&psdev->dev->dev, "Could not reload PCI state\n");
-	} else
-		pci_restore_state(psdev->dev);
+	__pci_reset_function_locked(dev);
+	if (pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))=

+		dev_dbg(&dev->dev, "Could not reload PCI state\n");
+	else
+		pci_restore_state(dev);
+
+	if (pci_find_capability(dev, PCI_CAP_ID_MSIX)) {
+		struct physdev_pci_device ppdev =3D {
+			.seg =3D pci_domain_nr(dev->bus),
+			.bus =3D dev->bus->number,
+			.devfn =3D dev->devfn
+		};
+		int err =3D HYPERVISOR_physdev_op(PHYSDEVOP_release_msix,
+						&ppdev);
+
+		if (err)
+			dev_warn(&dev->dev, "MSI-X release failed (%d)\n",
+				 err);
+	}
=20
 	/* Disable the device */
-	xen_pcibk_reset_device(psdev->dev);
+	xen_pcibk_reset_device(dev);
=20
 	kfree(dev_data);
-	pci_set_drvdata(psdev->dev, NULL);
+	pci_set_drvdata(dev, NULL);
=20
 	/* Clean-up the device */
-	xen_pcibk_config_free_dyn_fields(psdev->dev);
-	xen_pcibk_config_free_dev(psdev->dev);
+	xen_pcibk_config_free_dyn_fields(dev);
+	xen_pcibk_config_free_dev(dev);
=20
-	psdev->dev->dev_flags &=3D ~PCI_DEV_FLAGS_ASSIGNED;
-	pci_dev_put(psdev->dev);
+	dev->dev_flags &=3D ~PCI_DEV_FLAGS_ASSIGNED;
+	pci_dev_put(dev);
=20
 	kfree(psdev);
 }
@@ -355,6 +371,19 @@ static int pcistub_init_device(struct pc
 	if (err)
 		goto config_release;
=20
+	if (pci_find_capability(dev, PCI_CAP_ID_MSIX)) {
+		struct physdev_pci_device ppdev =3D {
+			.seg =3D pci_domain_nr(dev->bus),
+			.bus =3D dev->bus->number,
+			.devfn =3D dev->devfn
+		};
+
+		err =3D HYPERVISOR_physdev_op(PHYSDEVOP_prepare_msix, =
&ppdev);
+		if (err)
+			dev_err(&dev->dev, "MSI-X preparation failed =
(%d)\n",
+				err);
+	}
+
 	/* We need the device active to save the state. */
 	dev_dbg(&dev->dev, "save state of device\n");
 	pci_save_state(dev);
--- 3.8-rc6/include/xen/interface/physdev.h
+++ 3.8-rc6-xen-pciback-MSI-X-prepare/include/xen/interface/physdev.h
@@ -251,6 +251,12 @@ struct physdev_pci_device_add {
=20
 #define PHYSDEVOP_pci_device_remove     26
 #define PHYSDEVOP_restore_msi_ext       27
+/*
+ * Dom0 should use these two to announce MMIO resources assigned to
+ * MSI-X capable devices won't (prepare) or may (release) change.
+ */
+#define PHYSDEVOP_prepare_msix          30
+#define PHYSDEVOP_release_msix          31
 struct physdev_pci_device {
     /* IN */
     uint16_t seg;



--=__Part29196789.2__=
Content-Type: text/plain; name="linux-3.8-rc6-xen-pciback-MSI-X-prepare.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="linux-3.8-rc6-xen-pciback-MSI-X-prepare.patch"

xen-pciback: notify hypervisor about devices intended to be assigned to =
guests=0A=0AFor MSI-X capable devices the hypervisor wants to write =
protect the=0AMSI-X table and PBA, yet it can't assume that resources have =
been=0Aassigned to their final values at device enumeration time. Thus =
have=0Apciback do that notification, as having the device controlled by it =
is=0Aa prerequisite to assigning the device to guests anyway.=0A=0ASigned-o=
ff-by: Jan Beulich <jbeulich@suse.com>=0A=0A---=0A arch/x86/include/asm/xen=
/hypercall.h |    4 +-=0A drivers/xen/fallback.c               |    3 +=0A =
drivers/xen/xen-pciback/pci_stub.c   |   59 ++++++++++++++++++++++++++-----=
----=0A include/xen/interface/physdev.h      |    6 +++=0A 4 files =
changed, 54 insertions(+), 18 deletions(-)=0A=0A--- 3.8-rc6/arch/x86/includ=
e/asm/xen/hypercall.h=0A+++ 3.8-rc6-xen-pciback-MSI-X-prepare/arch/x86/incl=
ude/asm/xen/hypercall.h=0A@@ -382,14 +382,14 @@ HYPERVISOR_console_io(int =
cmd, int count=0A 	return _hypercall3(int, console_io, cmd, count, =
str);=0A }=0A =0A-extern int __must_check HYPERVISOR_physdev_op_compat(int,=
 void *);=0A+extern int __must_check xen_physdev_op_compat(int, void =
*);=0A =0A static inline int=0A HYPERVISOR_physdev_op(int cmd, void =
*arg)=0A {=0A 	int rc =3D _hypercall2(int, physdev_op, cmd, arg);=0A 	if =
(unlikely(rc =3D=3D -ENOSYS))=0A-		rc =3D HYPERVISOR_physdev_o=
p_compat(cmd, arg);=0A+		rc =3D xen_physdev_op_compat(cmd, arg);=0A =
	return rc;=0A }=0A =0A--- 3.8-rc6/drivers/xen/fallback.c=0A+++ =
3.8-rc6-xen-pciback-MSI-X-prepare/drivers/xen/fallback.c=0A@@ -44,7 +44,7 =
@@ int xen_event_channel_op_compat(int cmd,=0A }=0A EXPORT_SYMBOL_GPL(xen_e=
vent_channel_op_compat);=0A =0A-int HYPERVISOR_physdev_op_compat(int cmd, =
void *arg)=0A+int xen_physdev_op_compat(int cmd, void *arg)=0A {=0A 	=
struct physdev_op op;=0A 	int rc;=0A@@ -78,3 +78,4 @@ int HYPERVISOR_=
physdev_op_compat(int cmd=0A =0A 	return rc;=0A }=0A+EXPORT_SYMBOL_GP=
L(xen_physdev_op_compat);=0A--- 3.8-rc6/drivers/xen/xen-pciback/pci_stub.c=
=0A+++ 3.8-rc6-xen-pciback-MSI-X-prepare/drivers/xen/xen-pciback/pci_stub.c=
=0A@@ -17,6 +17,7 @@=0A #include <xen/events.h>=0A #include <asm/xen/pci.h>=
=0A #include <asm/xen/hypervisor.h>=0A+#include <xen/interface/physdev.h>=
=0A #include "pciback.h"=0A #include "conf_space.h"=0A #include "conf_space=
_quirks.h"=0A@@ -85,37 +86,52 @@ static struct pcistub_device *pcistub_de=
=0A static void pcistub_device_release(struct kref *kref)=0A {=0A 	=
struct pcistub_device *psdev;=0A+	struct pci_dev *dev;=0A 	=
struct xen_pcibk_dev_data *dev_data;=0A =0A 	psdev =3D container_of(kref=
, struct pcistub_device, kref);=0A-	dev_data =3D pci_get_drvdata(psdev-=
>dev);=0A+	dev =3D psdev->dev;=0A+	dev_data =3D pci_get_drvdata(dev);=
=0A =0A-	dev_dbg(&psdev->dev->dev, "pcistub_device_release\n");=0A+	=
dev_dbg(&dev->dev, "pcistub_device_release\n");=0A =0A-	xen_unregister_devi=
ce_domain_owner(psdev->dev);=0A+	xen_unregister_device_domain_owner(=
dev);=0A =0A 	/* Call the reset function which does not take lock as =
this=0A 	 * is called from "unbind" which takes a device_lock =
mutex.=0A 	 */=0A-	__pci_reset_function_locked(psdev->dev);=0A-	if =
(pci_load_and_free_saved_state(psdev->dev,=0A-					=
  &dev_data->pci_saved_state)) {=0A-		dev_dbg(&psdev->dev->dev, =
"Could not reload PCI state\n");=0A-	} else=0A-		pci_restore=
_state(psdev->dev);=0A+	__pci_reset_function_locked(dev);=0A+	if =
(pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))=0A+		=
dev_dbg(&dev->dev, "Could not reload PCI state\n");=0A+	else=0A+		=
pci_restore_state(dev);=0A+=0A+	if (pci_find_capability(dev, PCI_CAP_ID_MSI=
X)) {=0A+		struct physdev_pci_device ppdev =3D {=0A+		=
	.seg =3D pci_domain_nr(dev->bus),=0A+			.bus =3D =
dev->bus->number,=0A+			.devfn =3D dev->devfn=0A+		=
};=0A+		int err =3D HYPERVISOR_physdev_op(PHYSDEVOP_release_msix,=
=0A+						&ppdev);=0A+=0A+		=
if (err)=0A+			dev_warn(&dev->dev, "MSI-X release failed =
(%d)\n",=0A+				 err);=0A+	}=0A =0A 	/* =
Disable the device */=0A-	xen_pcibk_reset_device(psdev->dev);=0A+	=
xen_pcibk_reset_device(dev);=0A =0A 	kfree(dev_data);=0A-	pci_set_drv=
data(psdev->dev, NULL);=0A+	pci_set_drvdata(dev, NULL);=0A =0A 	/* =
Clean-up the device */=0A-	xen_pcibk_config_free_dyn_fields(psdev->dev=
);=0A-	xen_pcibk_config_free_dev(psdev->dev);=0A+	xen_pcibk_config_fr=
ee_dyn_fields(dev);=0A+	xen_pcibk_config_free_dev(dev);=0A =0A-	psdev->dev-=
>dev_flags &=3D ~PCI_DEV_FLAGS_ASSIGNED;=0A-	pci_dev_put(psdev->dev);=0A=
+	dev->dev_flags &=3D ~PCI_DEV_FLAGS_ASSIGNED;=0A+	pci_dev_put=
(dev);=0A =0A 	kfree(psdev);=0A }=0A@@ -355,6 +371,19 @@ static int =
pcistub_init_device(struct pc=0A 	if (err)=0A 		goto =
config_release;=0A =0A+	if (pci_find_capability(dev, PCI_CAP_ID_MSIX)) =
{=0A+		struct physdev_pci_device ppdev =3D {=0A+			=
.seg =3D pci_domain_nr(dev->bus),=0A+			.bus =3D dev->bus->=
number,=0A+			.devfn =3D dev->devfn=0A+		=
};=0A+=0A+		err =3D HYPERVISOR_physdev_op(PHYSDEVOP_prepare_msi=
x, &ppdev);=0A+		if (err)=0A+			dev_err(&dev->dev, =
"MSI-X preparation failed (%d)\n",=0A+				err);=0A+	=
}=0A+=0A 	/* We need the device active to save the state. */=0A 	=
dev_dbg(&dev->dev, "save state of device\n");=0A 	pci_save_state(dev)=
;=0A--- 3.8-rc6/include/xen/interface/physdev.h=0A+++ 3.8-rc6-xen-pciback-M=
SI-X-prepare/include/xen/interface/physdev.h=0A@@ -251,6 +251,12 @@ struct =
physdev_pci_device_add {=0A =0A #define PHYSDEVOP_pci_device_remove     =
26=0A #define PHYSDEVOP_restore_msi_ext       27=0A+/*=0A+ * Dom0 should =
use these two to announce MMIO resources assigned to=0A+ * MSI-X capable =
devices won't (prepare) or may (release) change.=0A+ */=0A+#define =
PHYSDEVOP_prepare_msix          30=0A+#define PHYSDEVOP_release_msix       =
   31=0A struct physdev_pci_device {=0A     /* IN */=0A     uint16_t =
seg;=0A
--=__Part29196789.2__=--
