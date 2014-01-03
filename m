Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbaACXks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 18:40:48 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:61217 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbaACXj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 18:39:58 -0500
Date: Fri, 3 Jan 2014 15:12:50 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Leandro Dorileo <l@dorileo.org>
Cc: Lan Tianyu <tianyu.lan@intel.com>, lenb@kernel.org, rjw@rjwysocki.net,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        fcr@adinet.com.uy, "3.8+" <stable@vger.kernel.org>
Subject: Re: [PATCH] ACPI/Battery: Add a _BIX quirk for NEC LZ750/LS
Message-ID: <20140103231250.GD13489@core.coreip.homeip.net>
References: <1388648277-23453-1-git-send-email-tianyu.lan@intel.com>
 <20140103190033.GA20314@dorilex-lnv.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140103190033.GA20314@dorilex-lnv.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 05:01:11PM -0200, Leandro Dorileo wrote:
> On Thu, Jan 02, 2014 at 03:37:57PM +0800, Lan Tianyu wrote:
> > The aml method _BIX of NEC LZ750/LS returns a broken package which
> > skip the first member "Revision" according ACPI 5.0 spec Table 10-234.
> > 
> > This patch is to add a quirk for this machine to skip member "Revision"
> > during parsing _BIX returned package.
> > 
> > Reported-and-tested-by: Francisco Castro <fcr@adinet.com.uy>
> > Reference: https://bugzilla.kernel.org/show_bug.cgi?id=67351
> > Cc: 3.8+ <stable@vger.kernel.org>
> > Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> > ---
> >  drivers/acpi/battery.c |   28 +++++++++++++++++++++++++++-
> >  1 file changed, 27 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> > index fbf1ace..3d64a87 100644
> > --- a/drivers/acpi/battery.c
> > +++ b/drivers/acpi/battery.c
> > @@ -62,6 +62,7 @@ MODULE_AUTHOR("Alexey Starikovskiy <astarikovskiy@suse.de>");
> >  MODULE_DESCRIPTION("ACPI Battery Driver");
> >  MODULE_LICENSE("GPL");
> >  
> > +static int battery_bix_broken_package;
> >  static unsigned int cache_time = 1000;
> >  module_param(cache_time, uint, 0644);
> >  MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
> > @@ -416,7 +417,12 @@ static int acpi_battery_get_info(struct acpi_battery *battery)
> >  		ACPI_EXCEPTION((AE_INFO, status, "Evaluating %s", name));
> >  		return -ENODEV;
> >  	}
> > -	if (test_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags))
> > +
> > +	if (battery_bix_broken_package)
> > +		result = extract_package(battery, buffer.pointer,
> > +				extended_info_offsets + 1,
> > +				ARRAY_SIZE(extended_info_offsets) - 1);
> > +	else if (test_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags))
> >  		result = extract_package(battery, buffer.pointer,
> >  				extended_info_offsets,
> >  				ARRAY_SIZE(extended_info_offsets));
> > @@ -754,6 +760,24 @@ static int battery_notify(struct notifier_block *nb,
> >  	return 0;
> >  }
> >  
> > +static int battery_bix_package_quirk(const struct dmi_system_id *id)
> > +{
> > +	battery_bix_broken_package = 1;
> > +	return 0;
> > +}
> > +
> 
> 
> Do you really need this callback? Why don't you just do:
> 
> if (dmi_check_system(bat_dmi_table))
>        battery_bix_broken_package = 1;
> 

Callback would be useful if we were to print the DMI data of the match,
otherwise not so much.

-- 
Dmitry
