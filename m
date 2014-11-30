Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaK3MXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:23:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:62105 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbaK3MXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:23:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,487,1413270000"; 
   d="scan'208";a="630314287"
Message-ID: <1417350176.27484.10.camel@rzhang1-toshiba>
Subject: Re: [PATCH v4] Thermal: int3406_thermal: solve the dependency build
 error
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Jim Davis <jim.epost@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Date: Sun, 30 Nov 2014 20:22:56 +0800
In-Reply-To: <20141107191127.GB27438@developer>
References: <CA+r1ZhhoskOXaRSmcrnbdgapi-FsaKf+dnPHTXGkDvkYbvwQ8Q@mail.gmail.com>
	 <543F88BE.4090307@intel.com> <20141017070620.GA1538@aaronlu.sh.intel.com>
	 <20141017072236.GA12504@aaronlu.sh.intel.com> <544F33AF.1000704@intel.com>
	 <20141107191127.GB27438@developer>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 15:11 -0400, Eduardo Valentin wrote:
> Hi,
> 
> On Tue, Oct 28, 2014 at 02:11:59PM +0800, Aaron Lu wrote:
> > Jim found that the current kernel may trigger a build error with some
> > config: drivers/built-in.o: In function `int3406_thermal_probe':
> > int3406_thermal.c:(.text+0x1d10b8): undefined reference to
> > `acpi_video_get_levels'. The problem happens when CONFIG_THERMAL=y and
> > CONFIG_ACPI_VIDEO=m. Solve the problem by separating a kernel config for
> > int3406 thermal driver and add dependency on ACPI video for it.
> > 
> > Reported-by: Jim Davis <jim.epost@gmail.com>
> > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> 
Aaron, this is an incremental patch on top of the INT3406 driver patch.
As, both patches have not been shipped in Linus' tree, please merge
these two patches altogether and resend.

thanks,
rui
> Rui,
> 
> Any further comments on this change?
> 
> BR,
> 
> Eduardo Valentin
> 
> > ---
> > v4: rebased on v3.18-rc2.
> > 
> >  drivers/thermal/Kconfig                  | 26 +++-----------------
> >  drivers/thermal/int340x_thermal/Kconfig  | 41 ++++++++++++++++++++++++++++++++
> >  drivers/thermal/int340x_thermal/Makefile |  1 +
> >  3 files changed, 45 insertions(+), 23 deletions(-)
> >  create mode 100644 drivers/thermal/int340x_thermal/Kconfig
> > 
> > diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> > index f554d25b4399..ac391d8d76b4 100644
> > --- a/drivers/thermal/Kconfig
> > +++ b/drivers/thermal/Kconfig
> > @@ -229,29 +229,9 @@ config INTEL_SOC_DTS_THERMAL
> >  	  notification methods.The other trip is a critical trip point, which
> >  	  was set by the driver based on the TJ MAX temperature.
> >  
> > -config INT340X_THERMAL
> > -	tristate "ACPI INT340X thermal drivers"
> > -	depends on X86 && ACPI
> > -	select THERMAL_GOV_USER_SPACE
> > -	select ACPI_THERMAL_REL
> > -	select ACPI_FAN
> > -	help
> > -	  Newer laptops and tablets that use ACPI may have thermal sensors and
> > -	  other devices with thermal control capabilities outside the core
> > -	  CPU/SOC, for thermal safety reasons.
> > -	  They are exposed for the OS to use via the INT3400 ACPI device object
> > -	  as the master, and INT3401~INT340B ACPI device objects as the slaves.
> > -	  Enable this to expose the temperature information and cooling ability
> > -	  from these objects to userspace via the normal thermal framework.
> > -	  This means that a wide range of applications and GUI widgets can show
> > -	  the information to the user or use this information for making
> > -	  decisions. For example, the Intel Thermal Daemon can use this
> > -	  information to allow the user to select his laptop to run without
> > -	  turning on the fans.
> > -
> > -config ACPI_THERMAL_REL
> > -	tristate
> > -	depends on ACPI
> > +menu "ACPI INT340X thermal drivers"
> > +source drivers/thermal/int340x_thermal/Kconfig
> > +endmenu
> >  
> >  menu "Texas Instruments thermal drivers"
> >  source "drivers/thermal/ti-soc-thermal/Kconfig"
> > diff --git a/drivers/thermal/int340x_thermal/Kconfig b/drivers/thermal/int340x_thermal/Kconfig
> > new file mode 100644
> > index 000000000000..b92892a6afe0
> > --- /dev/null
> > +++ b/drivers/thermal/int340x_thermal/Kconfig
> > @@ -0,0 +1,41 @@
> > +#
> > +# ACPI INT340x thermal drivers configuration
> > +#
> > +
> > +config INT340X_THERMAL
> > +	tristate "ACPI INT340X thermal drivers"
> > +	depends on X86 && ACPI
> > +	select THERMAL_GOV_USER_SPACE
> > +	select ACPI_THERMAL_REL
> > +	select ACPI_FAN
> > +	help
> > +	  Newer laptops and tablets that use ACPI may have thermal sensors and
> > +	  other devices with thermal control capabilities outside the core
> > +	  CPU/SOC, for thermal safety reasons.
> > +	  They are exposed for the OS to use via the INT3400 ACPI device object
> > +	  as the master, and INT3401~INT340B ACPI device objects as the slaves.
> > +	  Enable this to expose the temperature information and cooling ability
> > +	  from these objects to userspace via the normal thermal framework.
> > +	  This means that a wide range of applications and GUI widgets can show
> > +	  the information to the user or use this information for making
> > +	  decisions. For example, the Intel Thermal Daemon can use this
> > +	  information to allow the user to select his laptop to run without
> > +	  turning on the fans.
> > +
> > +if INT340X_THERMAL
> > +
> > +config ACPI_THERMAL_REL
> > +	tristate
> > +	depends on ACPI
> > +
> > +config INT3406_THERMAL
> > +	tristate "ACPI INT3406 display thermal driver"
> > +	depends on ACPI_VIDEO
> > +	help
> > +	  The display thermal device represents the LED/LCD display panel
> > +	  that may or may not include touch support. The main function of
> > +	  the display thermal device is to allow control of the display
> > +	  brightness in order to address a thermal condition or to reduce
> > +	  power consumed by display device.
> > +
> > +endif
> > diff --git a/drivers/thermal/int340x_thermal/Makefile b/drivers/thermal/int340x_thermal/Makefile
> > index ffe40bffaf1a..a9d0429be412 100644
> > --- a/drivers/thermal/int340x_thermal/Makefile
> > +++ b/drivers/thermal/int340x_thermal/Makefile
> > @@ -1,4 +1,5 @@
> >  obj-$(CONFIG_INT340X_THERMAL)	+= int3400_thermal.o
> >  obj-$(CONFIG_INT340X_THERMAL)	+= int3402_thermal.o
> >  obj-$(CONFIG_INT340X_THERMAL)	+= int3403_thermal.o
> > +obj-$(CONFIG_INT3406_THERMAL)	+= int3406_thermal.o
> >  obj-$(CONFIG_ACPI_THERMAL_REL)	+= acpi_thermal_rel.o
> > -- 
> > 1.9.3
> > 


