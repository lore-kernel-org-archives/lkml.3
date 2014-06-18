Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaFRWnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:43:11 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63158 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752157AbaFRWnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:43:09 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: David Rientjes <rientjes@google.com>
Cc: Lan Tianyu <tianyu.lan@intel.com>, lenb@kernel.org, naszar@ya.ru,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] ACPI/Battery: Retry to get Battery information if failed during probing
Date: Thu, 19 Jun 2014 01:00:44 +0200
Message-ID: <2223803.V8Foed99uq@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.02.1406181515160.21927@chino.kir.corp.google.com>
References: <1402988994-27067-1-git-send-email-tianyu.lan@intel.com> <1474004.fDjayHqHT9@vostro.rjw.lan> <alpine.DEB.2.02.1406181515160.21927@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 18, 2014 03:15:47 PM David Rientjes wrote:
> On Tue, 17 Jun 2014, Rafael J. Wysocki wrote:
> 
> > > diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> > > index e48fc98..8ed93a3 100644
> > > --- a/drivers/acpi/battery.c
> > > +++ b/drivers/acpi/battery.c
> > > @@ -34,6 +34,7 @@
> > >  #include <linux/dmi.h>
> > >  #include <linux/slab.h>
> > >  #include <linux/suspend.h>
> > > +#include <linux/delay.h>
> > >  #include <asm/unaligned.h>
> > >  
> > >  #ifdef CONFIG_ACPI_PROCFS_POWER
> > > @@ -1119,7 +1120,7 @@ static struct dmi_system_id bat_dmi_table[] = {
> > >  
> > >  static int acpi_battery_add(struct acpi_device *device)
> > >  {
> > > -	int result = 0;
> > > +	int result = 0, retry = 5;
> > >  	struct acpi_battery *battery = NULL;
> > >  
> > >  	if (!device)
> > > @@ -1135,9 +1136,20 @@ static int acpi_battery_add(struct acpi_device *device)
> > >  	mutex_init(&battery->sysfs_lock);
> > >  	if (acpi_has_method(battery->device->handle, "_BIX"))
> > >  		set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
> > > -	result = acpi_battery_update(battery, false);
> > > +
> > > +	/*
> > > +	 * Some machines'(E,G Lenovo Z480) ECs are not stable
> > > +	 * during boot up and this causes battery driver fails to be
> > > +	 * probed due to failure of getting battery information
> > > +	 * from EC sometimes. After several retries, the operation
> > > +	 * may work. So add retry code here and 20ms sleep between
> > > +	 * every retries.
> > > +	 */
> > > +	while ((result = acpi_battery_update(battery, false)) && retry--)
> > > +		msleep(20);
> > >  	if (result)
> > >  		goto fail;
> > 
> > Why not to write this as
> > 
> > 	for (;;) {
> > 		result = acpi_battery_update(battery, false);
> > 		if (!result)
> > 			break;
> > 		else if (!--retry)
> > 			goto fail;
> > 
> > 		msleep(20);
> > 	}
> > 
> 
> I suggested a similar for loop earlier, I think it's cleaner.

Precisely.  And it would be even more clean to introduce

static bool acpi_battery_update_retry(struct acpi_battery *battery)
{
	int retry, ret;

	for (retry = 5; retry; retry--) {
		ret = acpi_battery_update(battery, false);
		if (!ret)
			break;

		msleep(20);
	}
	return ret;
}

and use that instead of the open-coded loop.

Rafael

