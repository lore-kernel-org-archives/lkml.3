Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab3LDRQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:16:34 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57802 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3LDRQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:16:31 -0500
Date: Wed, 4 Dec 2013 09:16:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, linux-input@vger.kernel.org,
        linux-serial <linux-serial@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        Manuel Krause <manuelkrause@netscape.net>
Subject: Re: 3.12.x looses serial mouse over hibernate + resume
Message-ID: <20131204171626.GD8838@core.coreip.homeip.net>
References: <52951E69.7090602@netscape.net>
 <529B591F.1020909@hurleysoftware.com>
 <529CB07C.2040609@netscape.net>
 <19253701.sgP3OieFUq@dtor-d630.eng.vmware.com>
 <20131202164525.GA32406@core.coreip.homeip.net>
 <529CD303.4040103@netscape.net>
 <20131202190730.GA5245@core.coreip.homeip.net>
 <529CF034.1060505@netscape.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529CF034.1060505@netscape.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 09:40:20PM +0100, Manuel Krause wrote:
> On 2013-12-02 20:07, Dmitry Torokhov wrote:
> >
> >Thank you Manuel, but IO think the patch is not complete as we need to
> >re-enable PNP devices after we make a snapshot to make sure they are
> >working and can handle saving the data. Coudl you please try the patch
> >below?
> >
> 
> PNP: fix restoring devices after hibernation
> 
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> On returning from hibernation 'restore; callback is called, not
> 'resume'.
> This fixes breakage introduced by commit
> eaf140b60ec961252083ab8adaf67aef29a362dd
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/pnp/driver.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
> index a39ee38..2bd5c5f 100644
> --- a/drivers/pnp/driver.c
> +++ b/drivers/pnp/driver.c
> @@ -197,6 +197,11 @@ static int pnp_bus_freeze(struct device *dev)
>  	return __pnp_bus_suspend(dev, PMSG_FREEZE);
>  }
> 
> +static int pnp_bus_poweroff(struct device *dev)
> +{
> +	return __pnp_bus_suspend(dev, PMSG_HIBERNATE);
> +}
> +
>  static int pnp_bus_resume(struct device *dev)
>  {
>  	struct pnp_dev *pnp_dev = to_pnp_dev(dev);
> @@ -234,9 +239,14 @@ static int pnp_bus_resume(struct device *dev)
>  }
> 
>  static const struct dev_pm_ops pnp_bus_dev_pm_ops = {
> +	/* Suspend callbacks */
>  	.suspend = pnp_bus_suspend,
> -	.freeze = pnp_bus_freeze,
>  	.resume = pnp_bus_resume,
> +	/* Hibernate callbacks */
> +	.freeze = pnp_bus_freeze,
> +	.thaw = pnp_bus_resume,
> +	.poweroff = pnp_bus_poweroff,
> +	.restore = pnp_bus_resume,
>  };
> 
>  struct bus_type pnp_bus_type = {
> 
> ALSO, YES, this second patch version does cure the issue, on here,
> too.

Rafael,

Will you please take this patch in? It would also make sense to add it
to stable I think.

Thanks.

-- 
Dmitry
