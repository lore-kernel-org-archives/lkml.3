Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619AbaHYXOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 19:14:31 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61014 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754242AbaHYXO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 19:14:29 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: bebl@mageta.org, Lan Tianyu <tianyu.lan@intel.com>,
        Knut Petersen <Knut_Petersen@t-online.de>
Cc: lenb@kernel.org, davem@davemloft.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ACPI: Run fixed button devices' notify callback in the process context
Date: Tue, 26 Aug 2014 01:33:36 +0200
Message-ID: <3697885.H2NjtMFh3C@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53F78516.3040607@mageta.org>
References: <1408693091-16268-1-git-send-email-tianyu.lan@intel.com> <3313221.quKCYo2xmm@vostro.rjw.lan> <53F78516.3040607@mageta.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 22, 2014 07:59:50 PM Benjamin Block wrote:
> This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
> --jcnP2A9R7oLCVKLLsxCrieJLxfXGKbBUw
> Content-Type: text/plain; charset=utf-8
> Content-Transfer-Encoding: quoted-printable
> 
> On 08/22/2014 07:33 PM, Rafael J. Wysocki wrote:
> > On Friday, August 22, 2014 03:37:55 PM Lan Tianyu wrote:
> >> Currently fixed button devices' notify callbacks are running in the
> >> interrupt context. It's not necessary and prevent calling functions
> >> with mutex lock(E,G evaluating ACPI method). Otherwise, it's different=
> 
> >> with non-fixed button device whose notify callback is running in the p=
> rocess
> >> context. This patch is to make fixed button device's notify
> >> callback in the process context and this also can avoid dead lock
> >> when using netlink to report button event to user space.
> >=20
> > I guess this is the main reason for the patch?
> >=20
> > Is there a bug report regarding this?
> >
> 
> There is: https://lkml.org/lkml/2014/8/21/606

OK, below is my version.

Benjamin, Knut, can you please test this one just in case?

Rafael


---
From: Lan Tianyu <tianyu.lan@intel.com>
Subject: ACPI: Run fixed event device notifications in process context

Currently, notify callbacks for fixed button events are run from
interrupt context.  That is not necessary and after commit 0bf6368ee8f2
(ACPI / button: Add ACPI Button event via netlink routine) it causes
netlink routines to be called from interrupt context which is not
correct.

Also, that is different from non-fixed device events (including
non-fixed button events) whose notify callbacks are all executed from
process context.

For the above reasons, make fixed button device notify callbacks run
in process context which will avoid the deadlock when using netlink
to report button events to user space.

Fixes: 0bf6368ee8f2 (ACPI / button: Add ACPI Button event via netlink routine)
Link: https://lkml.org/lkml/2014/8/21/606
Reported-by: Benjamin Block <bebl@mageta.org>
Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
[rjw: Function names, subject and changelog.]
Cc: 3.15+ <stable@vger.kernel.org> # 3.15+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
drivers/acpi/scan.c | 9 +++++++--
 drivers/acpi/scan.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -922,12 +922,17 @@ static void acpi_device_notify(acpi_hand
 	device->driver->ops.notify(device, event);
 }
 
-static acpi_status acpi_device_notify_fixed(void *data)
+static void acpi_device_notify_fixed(void *data)
 {
 	struct acpi_device *device = data;
 
 	/* Fixed hardware devices have no handles */
 	acpi_device_notify(NULL, ACPI_FIXED_HARDWARE_EVENT, device);
+}
+
+static acpi_status acpi_device_fixed_event(void *data)
+{
+	acpi_os_execute(OSL_NOTIFY_HANDLER, acpi_device_notify_fixed, data);
 	return AE_OK;
 }
 
@@ -938,12 +943,12 @@ static int acpi_device_install_notify_ha
 	if (device->device_type == ACPI_BUS_TYPE_POWER_BUTTON)
 		status =
 		    acpi_install_fixed_event_handler(ACPI_EVENT_POWER_BUTTON,
-						     acpi_device_notify_fixed,
+						     acpi_device_fixed_event,
 						     device);
 	else if (device->device_type == ACPI_BUS_TYPE_SLEEP_BUTTON)
 		status =
 		    acpi_install_fixed_event_handler(ACPI_EVENT_SLEEP_BUTTON,
-						     acpi_device_notify_fixed,
+						     acpi_device_fixed_event,
 						     device);
 	else
 		status = acpi_install_notify_handler(device->handle,
@@ -960,10 +965,10 @@ static void acpi_device_remove_notify_ha
 {
 	if (device->device_type == ACPI_BUS_TYPE_POWER_BUTTON)
 		acpi_remove_fixed_event_handler(ACPI_EVENT_POWER_BUTTON,
-						acpi_device_notify_fixed);
+						acpi_device_fixed_event);
 	else if (device->device_type == ACPI_BUS_TYPE_SLEEP_BUTTON)
 		acpi_remove_fixed_event_handler(ACPI_EVENT_SLEEP_BUTTON,
-						acpi_device_notify_fixed);
+						acpi_device_fixed_event);
 	else
 		acpi_remove_notify_handler(device->handle, ACPI_DEVICE_NOTIFY,
 					   acpi_device_notify);

