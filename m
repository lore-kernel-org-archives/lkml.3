Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbaELMDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 08:03:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42581 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaELMDa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 08:03:30 -0400
Date: Mon, 12 May 2014 13:03:24 +0100
From: Javi Merino <javi.merino@arm.com>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>, Andreas Mohr <andi@lisas.de>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v3 4/6] acerhdf: Use bang-bang thermal governor
Message-ID: <20140512120324.GA5163@e102654-lin.cambridge.arm.com>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1399139966-10625-1-git-send-email-peter@piie.net>
 <1399139966-10625-5-git-send-email-peter@piie.net>
 <20140506105029.GC2858@e102654-lin.cambridge.arm.com>
 <cone.1399890428.265455.932.1000@mups>
MIME-Version: 1.0
In-Reply-To: <cone.1399890428.265455.932.1000@mups>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 12 May 2014 12:03:35.0160 (UTC) FILETIME=[3383AF80:01CF6DDA]
X-MC-Unique: 114051213032709401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, May 12, 2014 at 11:27:08AM +0100, Peter Feuerer wrote:
> Javi Merino writes:
> > On Sat, May 03, 2014 at 06:59:24PM +0100, Peter Feuerer wrote:
> >> acerhdf has been doing an on-off fan control using hysteresis by
> >> post-manipulating the outcome of thermal subsystem trip point handling.
> >> This patch enables acerhdf to use the bang-bang governor, which is
> >> intended for on-off controlled fans.
> >> 
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> CC: Zhang Rui <rui.zhang@intel.com>
> >> Cc: Andreas Mohr <andi@lisas.de>
> >> Cc: Borislav Petkov <bp@suse.de>
> >> Cc: Javi Merino <javi.merino@arm.com>
> >> Signed-off-by: Peter Feuerer <peter@piie.net>
> >> ---
> >>  drivers/platform/x86/Kconfig   |  2 +-
> >>  drivers/platform/x86/acerhdf.c | 34 +++++++++++++++++++++++++++++-----
> >>  2 files changed, 30 insertions(+), 6 deletions(-)
> >> 
> >> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> >> index 27df2c5..0c15d89 100644
> >> --- a/drivers/platform/x86/Kconfig
> >> +++ b/drivers/platform/x86/Kconfig
> >> @@ -38,7 +38,7 @@ config ACER_WMI
> >>  
> >>  config ACERHDF
> >>  	tristate "Acer Aspire One temperature and fan driver"
> >> -	depends on THERMAL && ACPI
> >> +	depends on ACPI && THERMAL_GOV_BANG_BANG
> >>  	---help---
> >>  	  This is a driver for Acer Aspire One netbooks. It allows to access
> >>  	  the temperature sensor and to control the fan.
> >> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> >> index 176edbd..afaa849 100644
> >> --- a/drivers/platform/x86/acerhdf.c
> >> +++ b/drivers/platform/x86/acerhdf.c
> >> @@ -50,7 +50,7 @@
> >>   */
> >>  #undef START_IN_KERNEL_MODE
> >>  
> >> -#define DRV_VER "0.5.30"
> >> +#define DRV_VER "0.5.31"
> >>  
> >>  /*
> >>   * According to the Atom N270 datasheet,
> >> @@ -259,6 +259,14 @@ static const struct bios_settings_t bios_tbl[] = {
> >>  
> >>  static const struct bios_settings_t *bios_cfg __read_mostly;
> >>  
> >> +/*
> >> + * this struct is used to instruct thermal layer to use bang_bang instead of
> >> + * default governor for acerhdf
> >> + */
> >> +static struct thermal_zone_params acerhdf_zone_params = {
> >> +	.governor_name = "bang_bang",
> >> +};
> >> +
> >>  static int acerhdf_get_temp(int *temp)
> >>  {
> >>  	u8 read_temp;
> >> @@ -440,6 +448,15 @@ static int acerhdf_get_trip_type(struct thermal_zone_device *thermal, int trip,
> >>  	return 0;
> >>  }
> >>  
> >> +static int acerhdf_get_trip_hyst(struct thermal_zone_device *thermal, int trip,
> >> +				 unsigned long *temp)
> >> +{
> >> +	if (trip == 0)
> >> +		*temp = fanon - fanoff;
> >> +
> >> +	return 0;
> >> +}
> >> +
> > 
> > I think you should only return 0 if you've updated the temperature.
> > Otherwise you're telling the calling function that everything went all
> > right but you may be leaving garbage in *temp.  What about
> > 
> > 	if (trip != 0)
> > 		return -EINVAL;
> > 
> > 	*temp = fanon - fanoff;
> > 	return 0;
> 
> Yes, sounds good.  What about trip == 1?  This is a valid trip point for 
> acerhdf (critical) and one could argue, that it has a valid hysteresis of 
> 0.  - Thus EINVAL would be wrong here.

Then for trip == 1 you should also write something in *temp if it's a
valid trip point and you don't want to return -EINVAL.  I don't know
what is the correct hysteresis for trip == 1. Maybe 0?  What I'm
trying to say is that you should return 0 only if you've updated
*temp.

Cheers,
Javi

