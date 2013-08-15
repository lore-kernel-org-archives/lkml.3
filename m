Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473Ab3HOHXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:23:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:2832 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759993Ab3HOHXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:23:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,883,1367996400"; 
   d="scan'208";a="282283416"
Message-ID: <1376551441.2335.118.camel@rzhang-lenovo>
Subject: Re: [PATCH] thermal: new asus driver
From: Zhang Rui <rui.zhang@intel.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-pm@vger.kernel.org, Eduardo Valentin <eduardo.valentin@ti.com>,
        linux-kernel@vger.kernel.org, corentin.chary@gmail.com,
        matthew.garrett@nebula.com,
        x86-drivers <platform-driver-x86@vger.kernel.org>
Date: Thu, 15 Aug 2013 15:24:01 +0800
In-Reply-To: <1376551353.2335.117.camel@rzhang-lenovo>
References: <1375829300-14081-1-git-send-email-felipe.contreras@gmail.com>
	 <1376551353.2335.117.camel@rzhang-lenovo>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 四, 2013-08-15 at 15:22 +0800, Zhang Rui wrote:
> On 二, 2013-08-06 at 17:48 -0500, Felipe Contreras wrote:
> > Simple driver to enable control of the fan in ASUS laptops. So far this
> > has only been tested in ASUS Zenbook Prime UX31A, but according to some
> > online reference [1], it should work in other models as well.
> > 
> I'd rather prefer to do this in the vendor driver like asus-laptop.c.
> Say, it is the asus-laptop driver that knows the fan control ability of
> the platform and register to the thermal framework.
> 
> > Another source was a patch acpi4asus-user's mailing list [2].
> > 
> > [1]
> > http://forum.notebookreview.com/asus/705656-fan-control-asus-prime-ux31-ux31a-ux32a-ux32vd.html
> > [2]
> > http://www.mail-archive.com/acpi4asus-user@lists.sourceforge.net/msg00065.html
> > 
> > Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> > ---
> > 
> > I've never implemented a driver like this, so I've no idea if this is the right way to do it.
> > 
> >  drivers/thermal/Kconfig        |  7 ++++
> >  drivers/thermal/Makefile       |  1 +
> >  drivers/thermal/asus_thermal.c | 94 ++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 102 insertions(+)
> >  create mode 100644 drivers/thermal/asus_thermal.c
> > 
> > diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> > index e988c81..0c5b624 100644
> > --- a/drivers/thermal/Kconfig
> > +++ b/drivers/thermal/Kconfig
> > @@ -184,4 +184,11 @@ menu "Texas Instruments thermal drivers"
> >  source "drivers/thermal/ti-soc-thermal/Kconfig"
> >  endmenu
> >  
> > +config ASUS_THERMAL
> > +	tristate "ASUS thermal driver"
> > +	depends on THERMAL
> > +	depends on X86
> > +	help
> > +	  Enables control of the fan in ASUS laptops.
> > +
> >  endif
> > diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> > index 67184a2..ab4ea6f 100644
> > --- a/drivers/thermal/Makefile
> > +++ b/drivers/thermal/Makefile
> > @@ -25,3 +25,4 @@ obj-$(CONFIG_DB8500_CPUFREQ_COOLING)	+= db8500_cpufreq_cooling.o
> >  obj-$(CONFIG_INTEL_POWERCLAMP)	+= intel_powerclamp.o
> >  obj-$(CONFIG_X86_PKG_TEMP_THERMAL)	+= x86_pkg_temp_thermal.o
> >  obj-$(CONFIG_TI_SOC_THERMAL)	+= ti-soc-thermal/
> > +obj-$(CONFIG_ASUS_THERMAL)	+= asus_thermal.o
> > diff --git a/drivers/thermal/asus_thermal.c b/drivers/thermal/asus_thermal.c
> > new file mode 100644
> > index 0000000..eceeee3
> > --- /dev/null
> > +++ b/drivers/thermal/asus_thermal.c
> > @@ -0,0 +1,94 @@
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/init.h>
> > +#include <linux/acpi.h>
> > +#include <linux/thermal.h>
> > +#include <linux/dmi.h>
> > +
> > +MODULE_AUTHOR("Felipe Contreras <felipe.contreras@gmail.com>");
> > +MODULE_DESCRIPTION("ASUS fan driver");
> > +MODULE_LICENSE("GPL");
> > +
> > +static struct thermal_cooling_device *cdev;
> > +
> > +static int fan_get_max_state(struct thermal_cooling_device *cdev,
> > +		unsigned long *state)
> > +{
> > +	*state = 0xff;
> > +	return 0;
> > +}
> > +
> > +static int fan_get_cur_state(struct thermal_cooling_device *cdev,
> > +		unsigned long *state)
> > +{
> > +	struct acpi_object_list params;
> > +	union acpi_object in_objs[1];
> > +	unsigned long long value;
> > +	acpi_status r;
> > +
> > +	params.count = ARRAY_SIZE(in_objs);
> > +	params.pointer = in_objs;
> > +	in_objs[0].type = ACPI_TYPE_INTEGER;
> > +	in_objs[0].integer.value = 0;
> > +
> > +	r = acpi_evaluate_integer(NULL, "\\_TZ.RFAN", &params, &value);
> > +	if (r != AE_OK)
> > +		return r;
> > +
> > +	*state = value;
> > +
> > +	return 0;
> > +}
> > +
> > +static int fan_set(struct thermal_cooling_device *cdev, int fan, int speed)
> > +{
> > +	struct acpi_object_list params;
> > +	union acpi_object in_objs[2];
> > +	unsigned long long value;
> > +
> > +	params.count = ARRAY_SIZE(in_objs);
> > +	params.pointer = in_objs;
> > +	in_objs[0].type = ACPI_TYPE_INTEGER;
> > +	in_objs[0].integer.value = fan;
> > +	in_objs[1].type = ACPI_TYPE_INTEGER;
> > +	in_objs[1].integer.value = speed;
> > +
> > +	return acpi_evaluate_integer(NULL, "\\_SB.PCI0.LPCB.EC0.SFNV", &params, &value);
> > +}
> > +
> I checked a couple of BIOS, and it seems that both of these two methods
> can be invoked by ATKD.WMNB indirectly.
> So I'm wondering if it is proper to invoke these two methods directly,
> and if these are some features/functionalities that are still missing in
> the asus-laptop driver.
> 
> CC Corentin and Matthew.
> 
CC x86 platform drivers mailing list as well.

> thanks,
> rui
> > +static int fan_set_cur_state(struct thermal_cooling_device *cdev,
> > +		unsigned long state)
> > +{
> > +	return fan_set(cdev, 1, state);
> > +}
> > +
> > +static int fan_set_auto(struct thermal_cooling_device *cdev)
> > +{
> > +	return fan_set(cdev, 0, 0);
> > +}
> > +
> > +static const struct thermal_cooling_device_ops fan_cooling_ops = {
> > +	.get_max_state = fan_get_max_state,
> > +	.get_cur_state = fan_get_cur_state,
> > +	.set_cur_state = fan_set_cur_state,
> > +};
> > +
> > +static int __init fan_init(void)
> > +{
> > +	if (strcmp(dmi_get_system_info(DMI_SYS_VENDOR), "ASUSTeK COMPUTER INC."))
> > +		return -ENODEV;
> > +	cdev = thermal_cooling_device_register("Fan", NULL, &fan_cooling_ops);
> > +	if (IS_ERR(cdev))
> > +		return PTR_ERR(cdev);
> > +	fan_set_auto(cdev);
> > +	return 0;
> > +}
> > +
> > +static void __exit fan_exit(void)
> > +{
> > +	fan_set_auto(cdev);
> > +	thermal_cooling_device_unregister(cdev);
> > +}
> > +
> > +module_init(fan_init);
> > +module_exit(fan_exit);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


