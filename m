Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaDOGCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 02:02:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbaDOGB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 02:01:59 -0400
Date: Tue, 15 Apr 2014 08:00:32 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, bp@suse.de,
        paul.gortmaker@windriver.com, JBeulich@suse.com, prarit@redhat.com,
        drjones@redhat.com, toshi.kani@hp.com, riel@redhat.com,
        gong.chen@linux.intel.com, andi@firstfloor.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4 3/5] acpi_processor: do not mark present at boot but
 not onlined CPU as onlined
Message-ID: <20140415080032.787580b9@nial.usersys.redhat.com>
In-Reply-To: <1612053.dzUdn6OW1L@vostro.rjw.lan>
References: <1397488277-14865-1-git-send-email-imammedo@redhat.com>
	<1397488277-14865-4-git-send-email-imammedo@redhat.com>
	<1612053.dzUdn6OW1L@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014 07:48:30 +0200
"Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:

> On Monday, April 14, 2014 05:11:15 PM Igor Mammedov wrote:
> > acpi_processor_add() assumes that present at boot CPUs
> > are always onlined, it is not so if a CPU failed to become
> > onlined. As result acpi_processor_add() will mark such CPU
> > device as onlined in sysfs and following attempts to
> > online/offline it using /sys/device/system/cpu/cpuX/online
> > attribute will fail.
> > 
> > Do not poke into device internals in acpi_processor_add()
> > and touch "struct device { .offline }" attribute, since
> > for CPUs onlined at boot it's set by:
> >   topology_init() -> arch_register_cpu() -> register_cpu()
> > before ACPI device tree is parsed, and for hotplugged
> > CPUs it's set when userspace onlines CPU via sysfs.
> > 
> > Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> > ---
> > v2:
> >  - fix regression in v1 leading to NULL pointer dereference
> >    on CPU unplug, do not remove "pr->dev = dev;"
> 
> Yeah.
> 
> Does this patch depend on any other patches in the series?
> 
> I don't think so, but just asking.
> 
> If it doesn't, why is it part of this series at all?
It's doesn't depend on any other patches in here, it was just
convenient to post it as a part of fixes found in CPU hotplug
code and nothing more.

> 
> > ---
> >  drivers/acpi/acpi_processor.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> > index c29c2c3..42d66f8 100644
> > --- a/drivers/acpi/acpi_processor.c
> > +++ b/drivers/acpi/acpi_processor.c
> > @@ -404,7 +404,6 @@ static int acpi_processor_add(struct acpi_device *device,
> >  		goto err;
> >  
> >  	pr->dev = dev;
> > -	dev->offline = pr->flags.need_hotplug_init;
> >  
> >  	/* Trigger the processor driver's .probe() if present. */
> >  	if (device_attach(dev) >= 0)
> > 
> 

