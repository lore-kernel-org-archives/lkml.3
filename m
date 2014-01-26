Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaAZVpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 16:45:47 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34462 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbaAZVpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 16:45:45 -0500
Date: Sun, 26 Jan 2014 13:45:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] max8925_power: Use "IS_ENABLED(CONFIG_OF)" for DT code.
Message-ID: <20140126214542.GC18840@core.coreip.homeip.net>
References: <1390720540-13350-1-git-send-email-badarkhe.manish@gmail.com>
 <52E50C24.8030305@gmail.com>
 <CAKDJKT5TvkgUN2Ee-2NignzxY1F54SHEiNL2i6c+hMjnLHOg5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKDJKT5TvkgUN2Ee-2NignzxY1F54SHEiNL2i6c+hMjnLHOg5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 07:31:50PM +0530, Manish Badarkhe wrote:
> Hi Tomasz,
> 
> Thank you for your review comments.
> 
> On Sun, Jan 26, 2014 at 6:52 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> >
> > Hi Manish,
> >
> >
> > On 26.01.2014 08:15, Manish Badarkhe wrote:
> >>
> >> Instead of "#if define CONFIG_OF" use "IS_ENABLED(CONFIG_OF)"
> >> option for DT code to avoid if-deffery in code.
> >>
> >> Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
> >> ---
> >> :100644 100644 b4513f2... d353fbc... M  drivers/power/max8925_power.c
> >>   drivers/power/max8925_power.c |   14 +++++---------
> >>   1 file changed, 5 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
> >> index b4513f2..d353fbc 100644
> >> --- a/drivers/power/max8925_power.c
> >> +++ b/drivers/power/max8925_power.c
> >> @@ -427,7 +427,6 @@ static int max8925_deinit_charger(struct max8925_power_info *info)
> >>         return 0;
> >>   }
> >>
> >> -#ifdef CONFIG_OF
> >>   static struct max8925_power_pdata *
> >>   max8925_power_dt_init(struct platform_device *pdev)
> >>   {
> >> @@ -468,13 +467,6 @@ max8925_power_dt_init(struct platform_device *pdev)
> >>
> >>         return pdata;
> >>   }
> >> -#else
> >> -static struct max8925_power_pdata *
> >> -max8925_power_dt_init(struct platform_device *pdev)
> >> -{
> >> -       return pdev->dev.platform_data;
> >> -}
> >> -#endif
> >>
> >>   static int max8925_power_probe(struct platform_device *pdev)
> >>   {
> >> @@ -483,7 +475,11 @@ static int max8925_power_probe(struct platform_device *pdev)
> >>         struct max8925_power_info *info;
> >>         int ret;
> >>
> >> -       pdata = max8925_power_dt_init(pdev);
> >> +       if (IS_ENABLED(CONFIG_OF))
> >> +               pdata = max8925_power_dt_init(pdev);
> >> +       else
> >> +               pdata = pdev->dev.platform_data;
> >> +
> >
> >
> > This does not look much better than before this patch. Instead of "if-deffery" outside function bodies you are adding "iffery" (if there is such a word) inside a function.
> > What about adding
> >
> >         if (!IS_ENABLED(CONFIG_OF))
> >                 return pdev->dev.platform_data;
> >
> > on top of max8925_power_dt_init() instead or maybe also renaming this function to max8925_get_pdata()?
> 
> Okay, I will rename function "max8925_power_dt_init()" to "max8925_get_pdata()".
> As you suggested, in the body of this function  will add a logic to
> retrieve  data in case
> of DT and non-DT platforms.

Should we not always favor platform-supplied data regardless of
CONFIG_OF state and fall back to DT (firmware) supplied data if platform
data is absent? This way one can tweak kernel behavior without needing
to change firmware.

Thanks.

-- 
Dmitry
