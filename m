Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbaAFWMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:12:08 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56495 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755809AbaAFWMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:12:06 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Lan Tianyu <tianyu.lan@intel.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        fcr@adinet.com.uy, l@dorileo.org, "3.8+" <stable@vger.kernel.org>
Subject: Re: [PATCH V2] ACPI/Battery: Add a _BIX quirk for NEC LZ750/LS
Date: Mon, 06 Jan 2014 23:25:53 +0100
Message-ID: <1793775.ULjNzyMivD@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140106175912.GA2754@core.coreip.homeip.net>
References: <1389019837-13619-1-git-send-email-tianyu.lan@intel.com> <20140106175912.GA2754@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 06, 2014 09:59:12 AM Dmitry Torokhov wrote:
> Hi Lan,
> 
> On Mon, Jan 06, 2014 at 10:50:37PM +0800, Lan Tianyu wrote:
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

Queued up as a fix for 3.13 (I fixed up the indentation).

Thanks!

> > ---
> > Change since v1:
> > 	Remove battery_bix_package_quirk() function and set
> > battery_bix_broken_package flag according the returned value
> > of dmi_check_system().
> > 
> >  drivers/acpi/battery.c | 22 +++++++++++++++++++++-
> >  1 file changed, 21 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> > index e90ef8b..d21cc1a 100644
> > --- a/drivers/acpi/battery.c
> > +++ b/drivers/acpi/battery.c
> > @@ -61,6 +61,7 @@ MODULE_AUTHOR("Alexey Starikovskiy <astarikovskiy@suse.de>");
> >  MODULE_DESCRIPTION("ACPI Battery Driver");
> >  MODULE_LICENSE("GPL");
> >  
> > +static int battery_bix_broken_package;
> >  static unsigned int cache_time = 1000;
> >  module_param(cache_time, uint, 0644);
> >  MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
> > @@ -415,7 +416,12 @@ static int acpi_battery_get_info(struct acpi_battery *battery)
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
> > @@ -753,6 +759,17 @@ static int battery_notify(struct notifier_block *nb,
> >  	return 0;
> >  }
> >  
> > +static struct dmi_system_id bat_dmi_table[] = {
> > +	{
> > +	.ident = "NEC LZ750/LS",
> > +	.matches = {
> > +		DMI_MATCH(DMI_SYS_VENDOR, "NEC"),
> > +		DMI_MATCH(DMI_PRODUCT_NAME, "PC-LZ750LS"),
> > +		},
> 
> This does not appear at be indented properly. I see there some
> inventive formatting in drivers/acpi, but I believe the proper form is:
> 
> static struct dmi_system_id bat_dmi_table[] = {
> 	{
> 		.ident = "NEC LZ750/LS",
> 		.matches = {
> 			DMI_MATCH(DMI_SYS_VENDOR, "NEC"),
> 			DMI_MATCH(DMI_PRODUCT_NAME, "PC-LZ750LS"),
> 		},
> 	},
> 	{}
> };
> 
> Otherwise:
> 
> Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> Thanks.
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
