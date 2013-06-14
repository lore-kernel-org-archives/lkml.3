Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab3FNXLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 19:11:31 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37823 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab3FNXL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 19:11:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tony Luck <tony.luck@gmail.com>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "Lu, Aaron" <aaron.lu@intel.com>
Subject: Re: [PATCH 0/5] ACPI / scan: Make it possible to use the container hotplug with other scan handlers
Date: Sat, 15 Jun 2013 01:20:43 +0200
Message-ID: <3321228.vG97AE80O6@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+8MBbKZBvqVA+wKTK7GpXorpBvDLGCJURc+PQz+QfDiwA1a8A@mail.gmail.com>
References: <1417592.vuSG0cUIGo@vostro.rjw.lan> <3168584.RRBYoY5UXf@vostro.rjw.lan> <CA+8MBbKZBvqVA+wKTK7GpXorpBvDLGCJURc+PQz+QfDiwA1a8A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 14, 2013 03:32:42 PM Tony Luck wrote:
> On Fri, Jun 14, 2013 at 3:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Can you please just test patch [5/5] alone without patches [1-4/5]?  We believe
> > that this should work too and if that's the case, we'll only need that patch
> > and a reworked [1/5].
> 
> Your belief is sound - I popped all five patches and then applied just
> 5/5 ... and
> the system still works.

Great, thanks!

Can you please apply the appended patch on top of it and see if the system
still works then?

Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / scan: Do not bind ACPI drivers to objects with scan handlers

ACPI drivers must not be bound to device objects having scan handlers
attatched to them, so make acpi_device_probe() fail with -EINVAL if the
device object being probed has an ACPI scan handler.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c  |    3 +++
 drivers/acpi/video.c |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -939,6 +939,9 @@ static int acpi_device_probe(struct devi
 	struct acpi_driver *acpi_drv = to_acpi_driver(dev->driver);
 	int ret;
 
+	if (acpi_dev->handler)
+		return -EINVAL;
+
 	if (!acpi_drv->ops.add)
 		return -ENOSYS;
 
Index: linux-pm/drivers/acpi/video.c
===================================================================
--- linux-pm.orig/drivers/acpi/video.c
+++ linux-pm/drivers/acpi/video.c
@@ -1722,9 +1722,6 @@ static int acpi_video_bus_add(struct acp
 	int error;
 	acpi_status status;
 
-	if (device->handler)
-		return -EINVAL;
-
 	status = acpi_walk_namespace(ACPI_TYPE_DEVICE,
 				device->parent->handle, 1,
 				acpi_video_bus_match, NULL,

