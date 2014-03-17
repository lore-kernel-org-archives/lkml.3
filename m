Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbaCPXrE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 19:47:04 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49568 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754404AbaCPXrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 19:47:02 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: v3.14-rc1+: new error: "nsc-ircc, Wrong chip version ff"
Date: Mon, 17 Mar 2014 01:02:26 +0100
Message-ID: <3120107.Slm5jUkmCN@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1395006095.2002.8.camel@x41>
References: <1395006095.2002.8.camel@x41>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 16, 2014 10:41:35 PM Paul Bolle wrote:
> Rafael,
> 
> 0) Ever since v3.14-rc1 I've noticed two new boot messages on an,
> outdated, ThinkPad X41:
>     nsc-ircc, Found chip at base=0x164e
>     nsc-ircc, Wrong chip version ff
> 
> The first is printed at info level, so I would have ignored it, but the
> second is printed at error level.

It looks like one driver thinks there's something interesting for it, but
finds out that there really is nothing and gives up.

> 1) I've finally managed to bisect these messages to commit 202317a573b2
> ("ACPI / scan: Add acpi_device objects for all device nodes in the
> namespace"). That's a rather big commit, so I've not even bothered to
> try to revert it on top on v3.14-rc6.

And there really is no reason to do that, because those messages don't indicate
any real problems. :-)

> 2) What should I do to make that error go away?

This is not an error, but a message whose log level is too high.  It basically
means "I found something, but I don't like it, so I'm not going to handle it."

The messages come from nsc_ircc_setup(), which is called from nsc_ircc_open(),
which in turn is called by nsc_ircc_init(), which is a module intialization
function of the nsc-ircc module.

I *guess* what happens is that the PNP layer creates a PNP device object
for something it didn't create an object for previously, so I wonder if the
patch below makes those messages go away?

Rafael


---
 drivers/acpi/internal.h    |    1 -
 drivers/pnp/pnpacpi/core.c |    5 ++++-
 include/acpi/acpi_bus.h    |    1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

Index: linux-pm/drivers/pnp/pnpacpi/core.c
===================================================================
--- linux-pm.orig/drivers/pnp/pnpacpi/core.c
+++ linux-pm/drivers/pnp/pnpacpi/core.c
@@ -258,7 +258,10 @@ static int __init pnpacpi_add_device(str
 	if (!pnpid)
 		return 0;
 
-	if (is_exclusive_device(device) || !device->status.present)
+	if (acpi_bus_get_status(device))
+		return 0;
+
+	if (is_exclusive_device(device) || !acpi_device_is_present(device))
 		return 0;
 
 	dev = pnp_alloc_dev(&pnpacpi_protocol, num, pnpid);
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -97,7 +97,6 @@ void acpi_device_add_finalize(struct acp
 void acpi_free_pnp_ids(struct acpi_device_pnp *pnp);
 int acpi_bind_one(struct device *dev, struct acpi_device *adev);
 int acpi_unbind_one(struct device *dev);
-bool acpi_device_is_present(struct acpi_device *adev);
 bool acpi_device_is_battery(struct acpi_device *adev);
 
 /* --------------------------------------------------------------------------
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -422,6 +422,7 @@ void acpi_bus_put_acpi_device(struct acp
 acpi_status acpi_bus_get_status_handle(acpi_handle handle,
 				       unsigned long long *sta);
 int acpi_bus_get_status(struct acpi_device *device);
+bool acpi_device_is_present(struct acpi_device *adev);
 
 int acpi_bus_set_power(acpi_handle handle, int state);
 const char *acpi_power_state_string(int state);

