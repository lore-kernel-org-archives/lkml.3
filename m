Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaIPJpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:45:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:17701 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbaIPJo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:44:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,534,1406617200"; 
   d="scan'208";a="573752125"
Date: Tue, 16 Sep 2014 12:44:49 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: wsa@the-dreams.de, jdelvare@suse.de, arnd@arndb.de, dianders@chromium.org,
        sjg@chromium.org, laurent.pinchart+renesas@ideasonboard.com,
        u.kleine-koenig@pengutronix.de, boris.brezillon@free-electrons.com,
        maxime.coquelin@st.com, max.schwarz@online.de, schwidefsky@de.ibm.com,
        iivanov@mm-sol.com, jacob.jun.pan@linux.intel.com,
        soren.brinkmann@xilinx.com, bjorn.andersson@sonymobile.com,
        andrew@lunn.ch, skuribay@pobox.com, christian.ruppert@abilis.com,
        Romain.Baeriswyl@abilis.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c-designware: Intel BayTrail PMIC I2C bus support
Message-ID: <20140916094449.GZ10854@lahna.fi.intel.com>
References: <1410543367-6565-1-git-send-email-david.e.box@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410543367-6565-1-git-send-email-david.e.box@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 10:36:07AM -0700, David E. Box wrote:
> This patch implements an I2C bus sharing mechanism between the host and platform
> hardware on select Intel BayTrail SoC platforms using the XPower AXP288 PMIC.
> 
> On these platforms access to the PMIC must be shared with platform hardware. The
> hardware unit assumes full control of the I2C bus and the host must request
> access through a special semaphore. Hardware control of the bus also makes it
> necessary to disable runtime pm to avoid interfering with hardware transactions.

Is this because we need to access the PMIC from host as well? I mean
from some PMIC driver (which driver btw)?

Otherwise it would be best to just detect _SEM and return -ENODEV.

> 
> Signed-off-by: David E. Box <david.e.box@linux.intel.com>
> ---
>  drivers/i2c/busses/Kconfig                  |  10 +++
>  drivers/i2c/busses/Makefile                 |   1 +
>  drivers/i2c/busses/i2c-designware-core.h    |  14 ++++
>  drivers/i2c/busses/i2c-designware-platdrv.c |  78 +++++++++++++++++++--
>  drivers/i2c/busses/i2c-shared-controller.c  | 101 ++++++++++++++++++++++++++++
>  5 files changed, 200 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/i2c/busses/i2c-shared-controller.c
> 
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 2ac87fa..672ef23 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -441,6 +441,16 @@ config I2C_DESIGNWARE_PCI
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called i2c-designware-pci.
>  
> +config I2C_SHARED_CONTROLLER
> +	tristate "Intel Baytrail PMIC shared I2C bus support"
> +	depends on ACPI
> +	select IOSF_MBI
> +	select I2C_DESIGNWARE_CORE
> +	help
> +	  This driver enables shared access to the PMIC I2C bus on select Intel
> +	  BayTrail platforms using the XPower AXP288 PMIC. This driver is
> +	  required for host access to the PMIC on these platforms.

Can't we detect this runtime in the i2c-designware-platdrv.c code so
that you look (in the ACPI part of the driver) for _SEM and in that case
change the xfer function behaviour a bit to return -EBUSY or whatever?

Without this horrible #ifdeffery.
