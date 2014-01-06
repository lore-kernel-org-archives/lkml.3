Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbaAFBVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 20:21:23 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51630 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751890AbaAFBVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 20:21:22 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: yanmin_zhang@linux.intel.com
Cc: shuox.liu@intel.com, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        yanmin.zhang@intel.com, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] pnp: Bypass the calling to pnp_stop_dev at suspend when there is a protocol suspend
Date: Mon, 06 Jan 2014 02:35:07 +0100
Message-ID: <2307791.CbWIVoHDXX@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1388971251.2960.11.camel@ymzhang>
References: <1387848951-26999-1-git-send-email-shuox.liu@intel.com> <1388971251.2960.11.camel@ymzhang>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 06, 2014 09:20:51 AM Yanmin Zhang wrote:
> On 二, 2013-12-24 at 09:35 +0800, shuox.liu@intel.com wrote:
> > From: Zhang Yanmin <yanmin.zhang@intel.com>
> > 
> > pnp pnp_bus_suspend/_resume have an issue.
> > pnp_bus_suspend calls pnp_stop_dev to disable the device. With ACPI,
> > pnp_stop_dev turns off the dev usually. Then,
> > pnp_bus_suspend=>pnp_dev->protocol->suspend accesses the device and
> > suspend it again.
> > 
> > pnp_bus_resume has the similar issue.
> > 
> > Another issue is firmware might just provide _DIS, but no_STS method.
> > 
> > The patch fixes it by adding a checking. If there is
> > pnp_dev->protocol->suspend, pnp_bus_suspend doesn't call pnp_stop_dev.
> > Do the similar thing for _resume.
> Rafael,
> 
> What's your idea about this patch?

I haven't had the time to look deeper into that, sorry.  I'll let you know
when I do that.

Thanks!

> We hit the issue when enabling Android on a latest tablet. After
> suspend-to-ram wakeup, serial console doesn't work.
> This serial port is bound by pnpcore driver.
> At suspending, 
> static int __pnp_bus_suspend(struct device *dev, pm_message_t state)
> {
> 	...
> 
>         if (pnp_can_disable(pnp_dev)) {
>                 error = pnp_stop_dev(pnp_dev);
>                 if (error)
>                         return error;
>         }
> 
>         if (pnp_dev->protocol->suspend)
>                 pnp_dev->protocol->suspend(pnp_dev, state);
>         return 0;
> }
> 
> pnp_stop_dev calls dev->protocol->disable.
> As for ACPI device, that disable callback calls _DIS. Based
> on ACPI spec, driver need turn off the device before disabling it
> by _DIS. That means, after pnp_stop_dev returns, the device is at OFF
> state.
> 
> Then, __pnp_bus_suspend calls pnp_dev->protocol->suspend, which
> continues to access the device while the device is at OFF.
> 
> Our firmware just provides _DIS for the device. There is no _STS
> method. Then, after wakeup, the device doesn't work.
> 
> But just like what the patch points out, pnp_dev->protocol->suspend
> continues to access the device while the device is at OFF. It's not safe.
> 
> The patch looks like a workaround. Another possible fix is to just
> delete the calling of pnp_stop_dev in function __pnp_bus_suspend, as
> suspend is not equal to _disable_.
> The deletion might be a little intrusive. That's why we sent a workaround
> patch to LKML.
> 
> Which one is better?
> 
> Thanks,
> Yanmin
> 
> > 
> > Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
> > Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
> > ---
> >  drivers/pnp/driver.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
> > index f748cc8..2512e47 100644
> > --- a/drivers/pnp/driver.c
> > +++ b/drivers/pnp/driver.c
> > @@ -176,7 +176,7 @@ static int __pnp_bus_suspend(struct device *dev, pm_message_t state)
> >  			return error;
> >  	}
> >  
> > -	if (pnp_can_disable(pnp_dev)) {
> > +	if (pnp_can_disable(pnp_dev) && !pnp_dev->protocol->suspend) {
> >  		error = pnp_stop_dev(pnp_dev);
> >  		if (error)
> >  			return error;
> > @@ -215,9 +215,7 @@ static int pnp_bus_resume(struct device *dev)
> >  		error = pnp_dev->protocol->resume(pnp_dev);
> >  		if (error)
> >  			return error;
> > -	}
> > -
> > -	if (pnp_can_write(pnp_dev)) {
> > +	} else if (pnp_can_write(pnp_dev)) {
> >  		error = pnp_start_dev(pnp_dev);
> >  		if (error)
> >  			return error;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
