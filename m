Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab3BVOu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:50:56 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42652 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab3BVOuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:50:54 -0500
Date: Fri, 22 Feb 2013 09:50:47 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.9-rc0-tag
Message-ID: <20130222145047.GA8017@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9zSXsLTf0vkW971A
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.9-rc0-tag

which has two new ACPI drivers for Xen - a physical CPU offline/online and
a memory hotplug. The way this works is that ACPI kicks the drivers and they
make the appropiate hypercall to the hypervisor to tell it that there is a new
CPU or memory. There also some changes to the Xen ARM ABIs and couple of fixes.
One particularly nasty bug in the Xen PV spinlock code was fixed by Stefan Bader
- and has been there since the 2.6.32!

During the linux-next cycle we found that some of the changes in Rafael's
pm+acpi-3.9-rc1 tree will cause compile conflicts with my tree.
Stephen Rothwell found and developed a fix - which I am including as an
attachment to this - please apply it immediately after my tree. There are some
other patches that ought to be done on top of this to deal with the new ACPI API
changes - I've them in this #linux-next-resolved tree:

http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=shortlog;h=refs/heads/linux-next-resolved

if you are curious - but I was thinking to submit them _after_ the rc1 has been
tagged as I am sure I will have some bug-fixes. There looks to be a lot
of regressions this season already :-(

 arch/arm/include/asm/xen/events.h |  22 ++
 arch/arm/include/asm/xen/page.h   |   4 +
 arch/arm/xen/enlighten.c          |   8 +-
 arch/x86/include/asm/xen/events.h |   3 +
 arch/x86/include/asm/xen/page.h   |   2 +
 arch/x86/xen/smp.c                |  42 ++--
 arch/x86/xen/spinlock.c           |   1 -
 drivers/tty/hvc/hvc_xen.c         |   2 +-
 drivers/xen/Kconfig               |  34 +++
 drivers/xen/Makefile              |   3 +
 drivers/xen/events.c              | 115 +++++----
 drivers/xen/evtchn.c              |  14 +-
 drivers/xen/grant-table.c         |   2 +-
 drivers/xen/pcpu.c                |  35 +++
 drivers/xen/tmem.c                |   2 +-
 drivers/xen/xen-acpi-cpuhotplug.c | 471 +++++++++++++++++++++++++++++++++++++
 drivers/xen/xen-acpi-memhotplug.c | 483 ++++++++++++++++++++++++++++++++++++++
 drivers/xen/xen-stub.c            | 101 ++++++++
 drivers/xen/xenbus/xenbus_probe.c |   2 +-
 include/xen/acpi.h                |  35 +++
 include/xen/interface/memory.h    |   6 +
 include/xen/interface/platform.h  |  21 +-
 include/xen/interface/xen.h       |   8 +-
 23 files changed, 1331 insertions(+), 85 deletions(-)

Ian Campbell (2):
      xen: implement updated XENMEM_add_to_physmap_range ABI
      xen: event channel arrays are xen_ulong_t and not unsigned long

Konrad Rzeszutek Wilk (2):
      xen/smp: Move the common CPU init code a bit to prep for PVH patch.
      xen/tmem: Add missing %s in the printk statement.

Liu Jinsong (6):
      xen/stub: driver for memory hotplug
      xen/acpi: ACPI memory hotplug
      xen/stub: driver for CPU hotplug
      xen/acpi: Move xen_acpi_get_pxm to Xen's acpi.h
      xen/acpi: ACPI cpu hotplug
      xen/acpi: move xen_acpi_get_pxm under CONFIG_XEN_DOM0

Stefan Bader (1):
      xen: Send spinlock IPI to all waiters

Stefano Stabellini (1):
      xen: introduce xen_remap, use it instead of ioremap

Wei Liu (2):
      xen-evtchn: correct comment and error output
      xen: close evtchn port if binding to irq fails


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-xen-acpi-fix-up-for-apci_bus_add-api-change.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 56810ee0f6d5ce9da9f5dddfc459ee0041eb22cc Mon Sep 17 00:00:00 2001
=46rom: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 15 Feb 2013 15:45:51 +1100
Subject: [PATCH] xen/acpi: fix up for apci_bus_add api change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-acpi-cpuhotplug.c | 2 +-
 drivers/xen/xen-acpi-memhotplug.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xen-acpi-cpuhotplug.c b/drivers/xen/xen-acpi-cpuho=
tplug.c
index 9eefbb0..acc5b12 100644
--- a/drivers/xen/xen-acpi-cpuhotplug.c
+++ b/drivers/xen/xen-acpi-cpuhotplug.c
@@ -251,7 +251,7 @@ int acpi_processor_device_add(acpi_handle handle, struc=
t acpi_device **device)
 	if (acpi_bus_get_device(phandle, &pdev))
 		return -ENODEV;
=20
-	if (acpi_bus_add(device, pdev, handle, ACPI_BUS_TYPE_PROCESSOR))
+	if (acpi_bus_scan(handle))
 		return -ENODEV;
=20
 	return 0;
diff --git a/drivers/xen/xen-acpi-memhotplug.c b/drivers/xen/xen-acpi-memho=
tplug.c
index 678680c..164287b 100644
--- a/drivers/xen/xen-acpi-memhotplug.c
+++ b/drivers/xen/xen-acpi-memhotplug.c
@@ -188,7 +188,7 @@ acpi_memory_get_device(acpi_handle handle,
 	 * Now add the notified device.  This creates the acpi_device
 	 * and invokes .add function
 	 */
-	result =3D acpi_bus_add(&device, pdevice, handle, ACPI_BUS_TYPE_DEVICE);
+	result =3D acpi_bus_scan(handle);
 	if (result) {
 		pr_warn(PREFIX "Cannot add acpi bus\n");
 		return -EINVAL;
--=20
1.8.0.2


--oyUTqETQ0mS9luUI--

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQEcBAEBAgAGBQJRJ4XBAAoJEFjIrFwIi8fJKQYIAKT23ASusPoYamrmn7hKFdx8
9C+GpeQY+HeuLanH17dRZuIRFtclXKGNugV8nswhJEGzsxkEFWV/8xo+A2wX3X3w
qsu8L1LSsvGERGGqNs0BQK0A+aeIeRi1hZMGhYhpIK+XqqLoAJrBHOpuu/jJea5N
v8PxrY3jCuanBnq7EsfLTGMCJBG7tClXel6sHXSU/htCPwPT+zo+f4tOC+uwkDqN
FFG36vTsdnFpbzqP9IaIfYRwFuFz0pAF5OZOnl9lp0rIghGHQs+9CwzvDB0rYrnx
bVa7dVe2E6CVY9rMw3UoesJaSZzsdO3WO+ItpbBqN8OLadmpMoFAX1pECY1+eNs=
=B8G4
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
