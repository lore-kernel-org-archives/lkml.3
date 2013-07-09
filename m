Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3GITdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 15:33:24 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:28103 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab3GITdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 15:33:22 -0400
Message-ID: <1373398362.24916.4.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI / scan: Always call acpi_bus_scan() for bus check
 notifications
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Date: Tue, 09 Jul 2013 13:32:42 -0600
In-Reply-To: <2230821.QbNohsyO0O@vostro.rjw.lan>
References: <2230821.QbNohsyO0O@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-08 at 02:10 +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> An ACPI_NOTIFY_BUS_CHECK notification means that we should scan the
> entire namespace starting from the given handle even if the device
> represented by that handle is present (other devices below it may
> just have been added).
> 
> For this reason, modify acpi_scan_bus_device_check() to always run
> acpi_bus_scan() if the notification being handled is of type
> ACPI_NOTIFY_BUS_CHECK.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: 3.10+ <stable@vger.kernel.org>

Acked-by: Toshi Kani <toshi.kani@hp.com>

But, I think we need the additional patch below.

Thanks,
-Toshi

=====
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI: Do not call attach() if device is attached

attach() of ACPI scan handlers does not expect to be called multiple
times on a same device.  Also, the attached handler may not be changed
without calling its detach().  Change acpi_scan_attach_handler() not
to call attach() when the given device is already attached.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/scan.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 20757e0..2b9e867 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1885,6 +1885,9 @@ static int acpi_scan_attach_handler(struct
acpi_device *device)
 	struct acpi_hardware_id *hwid;
 	int ret = 0;
 
+	if (device->handler)
+		return 1;
+
 	list_for_each_entry(hwid, &device->pnp.ids, list) {
 		const struct acpi_device_id *devid;
 		struct acpi_scan_handler *handler;


