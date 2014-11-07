Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaKGTrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:47:36 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:33324 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbaKGTre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:47:34 -0500
Date: Fri, 7 Nov 2014 11:47:28 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v5 34/48] acpi: Register power-off handler with kernel
 power-off handler
Message-ID: <20141107194728.GB18609@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
 <1415292213-28652-35-git-send-email-linux@roeck-us.net>
 <2274417.WekTW87bGm@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2274417.WekTW87bGm@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.545D21D6.004F,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 11:32:26PM +0100, Rafael J. Wysocki wrote:
> On Thursday, November 06, 2014 08:43:18 AM Guenter Roeck wrote:
> > Register with kernel power-off handler instead of setting pm_power_off
> > directly. Register with high priority to reflect that the driver explicitly
> > overrides existing power-off handlers.
> > 
> > Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> > Cc: Len Brown <lenb@kernel.org>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> 
> That's fine by me.
> 
I'll record that as an Acked-by: unless I hear otherwise from you.

Thanks,
Guenter

> Rafael
> 
> 
> > ---
> > v5:
> > - Rebase to v3.18-rc3
> > v4:
> > - Do not use notifiers but internal functions and data structures to manage
> >   the list of power-off handlers. Drop unused parameters from callbacks, and
> >   make the power-off function type void
> > v3:
> > - Replace poweroff in all newly introduced variables and in text
> >   with power_off or power-off as appropriate
> > - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> > - Replace acpi: with ACPI: in log message
> > v2:
> > - Use define to specify poweroff handler priority
> > - Use pr_warn instead of pr_err
> > 
> >  drivers/acpi/sleep.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> > index 05a31b5..a73cfad 100644
> > --- a/drivers/acpi/sleep.c
> > +++ b/drivers/acpi/sleep.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/device.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/suspend.h>
> > +#include <linux/pm.h>
> >  #include <linux/reboot.h>
> >  #include <linux/acpi.h>
> >  #include <linux/module.h>
> > @@ -827,7 +828,7 @@ static void acpi_power_off_prepare(void)
> >  	acpi_disable_all_gpes();
> >  }
> >  
> > -static void acpi_power_off(void)
> > +static void acpi_power_off(struct power_off_handler_block *this)
> >  {
> >  	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
> >  	printk(KERN_DEBUG "%s called\n", __func__);
> > @@ -835,6 +836,11 @@ static void acpi_power_off(void)
> >  	acpi_enter_sleep_state(ACPI_STATE_S5);
> >  }
> >  
> > +static struct power_off_handler_block acpi_power_off_hb = {
> > +	.handler = acpi_power_off,
> > +	.priority = POWER_OFF_PRIORITY_HIGH,
> > +};
> > +
> >  int __init acpi_sleep_init(void)
> >  {
> >  	char supported[ACPI_S_STATE_COUNT * 3 + 1];
> > @@ -851,7 +857,8 @@ int __init acpi_sleep_init(void)
> >  	if (acpi_sleep_state_supported(ACPI_STATE_S5)) {
> >  		sleep_states[ACPI_STATE_S5] = 1;
> >  		pm_power_off_prepare = acpi_power_off_prepare;
> > -		pm_power_off = acpi_power_off;
> > +		if (register_power_off_handler(&acpi_power_off_hb))
> > +			pr_warn("ACPI: Failed to register power-off handler\n");
> >  	}
> >  
> >  	supported[0] = 0;
> > 
> 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
