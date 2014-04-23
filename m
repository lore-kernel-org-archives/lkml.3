Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbaDWHeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:34:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:1708 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756642AbaDWHeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:34:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,910,1389772800"; 
   d="scan'208";a="525394964"
Date: Wed, 23 Apr 2014 10:40:56 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Lan, Tianyu" <tianyu.lan@intel.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "awilliam@redhat.com" <awilliam@redhat.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [Resend Patch 9/9] I2C/ACPI: Add CONFIG_I2C_ACPI config
Message-ID: <20140423074056.GU30677@intel.com>
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-10-git-send-email-tianyu.lan@intel.com>
 <20140422114510.GM30677@intel.com>
 <53575227.7080407@intel.com>
 <1AE640813FDE7649BE1B193DEA596E88025577CB@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88025577CB@SHSMSX101.ccr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 06:47:05AM +0000, Zheng, Lv wrote:
> Hi, Tianyu
> 
> > From: Lan, Tianyu
> > Sent: Wednesday, April 23, 2014 1:40 PM
> > 
> > On 2014年04月22日 19:45, Mika Westerberg wrote:
> > > On Tue, Apr 22, 2014 at 02:24:15PM +0800, Lan Tianyu wrote:
> > >> This patch is to add CONFIG_I2C_ACPI. Current there is a race between
> > >> removing I2C ACPI operation region and ACPI AML code accessing.
> > >> So make i2c core built-in if CONFIG_I2C_ACPI is set.
> > >>
> > >> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> > >> ---
> > >>  drivers/i2c/Kconfig  | 17 ++++++++++++++++-
> > >>  drivers/i2c/Makefile |  2 +-
> > >>  include/linux/i2c.h  |  2 +-
> > >>  3 files changed, 18 insertions(+), 3 deletions(-)
> > >>
> > >> diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
> > >> index 7b7ea32..c670d49 100644
> > >> --- a/drivers/i2c/Kconfig
> > >> +++ b/drivers/i2c/Kconfig
> > >> @@ -2,7 +2,9 @@
> > >>  # I2C subsystem configuration
> > >>  #
> > >>
> > >> -menuconfig I2C
> > >> +menu "I2C support"
> > >> +
> > >> +config I2C
> > >>  	tristate "I2C support"
> > >>  	select RT_MUTEXES
> > >>  	---help---
> > >> @@ -21,6 +23,17 @@ menuconfig I2C
> > >>  	  This I2C support can also be built as a module.  If so, the module
> > >>  	  will be called i2c-core.
> > >>
> > >> +config I2C_ACPI
> > >> +	bool "I2C ACPI support"
> > >> +	select I2C
> > >> +	depends on ACPI
> > >> +	default y
> > >> +	help
> > >> +	  Say Y here if you want to enable I2C ACPI function. ACPI table
> > >> +	  provides I2C slave devices' information to enumerate these devices.
> > >> +	  This option also allows ACPI AML code to access I2C slave devices
> > >> +	  via I2C ACPI operation region to fulfill ACPI method.
> > >> +
> > >
> > > I'm wondering, can we provide some sort of wrapper function from ACPI core
> > > that is guaranteed to be built in to the kernel image and use it instead of
> > > adding new Kconfig options?
> > >
> > Cc: LV
> > 
> > LV tried to fix the issue via wrapper solution in the ACPI code before.
> > https://lkml.org/lkml/2013/7/23/87
> > 
> > He has a plan to resolve the issue in ACPICA later.
> > 
> > Other choice is to increase the i2c-core module count to prevent it
> > being unloaded when i2c operation region handler is installed. Remove
> > the code When LV finish his job.
> 
> You may see it implemented in ACPICA after several release.
> If you need a fix for now, you can use the patch pointed to by the link you've provided,
> Or you could find an updated one here:
>  acpi-ipmi13.patch archived in (https://bugzilla.kernel.org/attachment.cgi?id=112611)
> 
> I think the solution you've provided in this patch is also reasonable for now.
> IPMI also uses a similar solution to solve this issue.
> Please refer to the CONFIG_ACPI_IPMI.
> 
> The story can be found at:
> http://www.spinics.net/lists/linux-acpi/msg49044.html
> And the similar solution can be found at:
> http://www.spinics.net/lists/linux-acpi/msg49184.html

Thanks for the pointers.

Given that the IPMI problem was solved like this I guess I2C operation
regions can follow the same pattern if there is no better solution
available.

Out of curiousity: how did you plan to fix this in ACPICA?
