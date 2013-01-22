Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab3AVJ10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:27:26 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:57321 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3AVJ1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:27:24 -0500
Date: Tue, 22 Jan 2013 09:27:17 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Anton Vorontsov <anton@enomsg.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 23/24] ab8500-bm: Fix minor niggles experienced during
 testing
Message-ID: <20130122092717.GI6857@gmail.com>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
 <1358769840-4763-24-git-send-email-lee.jones@linaro.org>
 <20130121191324.GA15037@lizard.mcd01528.sjc.wayport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130121191324.GA15037@lizard.mcd01528.sjc.wayport.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jan 2013, Anton Vorontsov wrote:

> On Mon, Jan 21, 2013 at 12:03:59PM +0000, Lee Jones wrote:
> > When compile testing the new AB8500 Battery Management changes
> > due for inclusion into upstream, there were a few minor niggles
> > which required repairing, or adapting for use against the
> > Mainline kernel. This patch is a collection of them all.
> 
> No. This is the third time I'm saying it: the last time I checked, this is
> not how we do development in the mainline.

Okay, all of these changes have now been fixed-up into the patches
which caused the issues. I have also added Stable to the patch you
requested it on.

How would you like to proceed? Do you want a pull-request, or for me
to send the patches to the list again?

> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/power/ab8500_fg.h       |    6 ++++--
> >  drivers/power/abx500_chargalg.c |    4 ++--
> >  drivers/power/pm2301_charger.c  |    4 ++--
> >  3 files changed, 8 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/power/ab8500_fg.h b/drivers/power/ab8500_fg.h
> > index 946840b..bb78dc9 100644
> > --- a/drivers/power/ab8500_fg.h
> > +++ b/drivers/power/ab8500_fg.h
> > @@ -182,6 +182,7 @@ struct ab8500_fg_test {
> >   * @fg_check_hw_failure_work:	Work for checking HW state
> >   * @cc_lock:		Mutex for locking the CC
> >   * @fg_kobject:		Structure of type kobject
> > + * @test:		Structure of type ab8500_fg_test for test purpose
> >   */
> >  struct ab8500_fg {
> >  	struct device *dev;
> > @@ -224,6 +225,7 @@ struct ab8500_fg {
> >  	struct delayed_work fg_check_hw_failure_work;
> >  	struct mutex cc_lock;
> >  	struct kobject fg_kobject;
> > +	struct ab8500_fg_test test;
> 
> You are introducing it, but I don't see any users.
> 
> >  };
> >  
> >  extern char *discharge_state[];
> > @@ -232,8 +234,8 @@ extern char *charge_state[];
> >  int ab8500_fg_coulomb_counter(struct ab8500_fg *di, bool enable);
> >  void ab8500_fg_charge_state_to(struct ab8500_fg *di,
> >  		enum ab8500_fg_charge_state new_state);
> > -void ab8500_fg_discharge_state_to(struct ab8500_fg *di,
> > -		enum ab8500_fg_charge_state new_state);
> > +static void ab8500_fg_discharge_state_to(struct ab8500_fg *di,
> > +		enum ab8500_fg_discharge_state new_state);
> >  /* test initialization */
> >  #ifdef CONFIG_AB8500_BM_DEEP_DEBUG
> >  void ab8500_fg_test_init(struct ab8500_fg *di);
> > diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
> > index 694f592..cacf512 100644
> > --- a/drivers/power/abx500_chargalg.c
> > +++ b/drivers/power/abx500_chargalg.c
> > @@ -1664,8 +1664,8 @@ static int abx500_chargalg_get_property(struct power_supply *psy,
> >  static ssize_t ab8500_chargalg_sysfs_show(struct kobject *kobj,
> >  					  struct attribute *attr, char *buf)
> >  {
> > -	struct ab8500_chargalg *di = container_of(kobj,
> > -               struct ab8500_chargalg, chargalg_kobject);
> > +	struct abx500_chargalg *di = container_of(kobj,
> > +               struct abx500_chargalg, chargalg_kobject);
> 
> Spaces.
> 
> >  
> >  	return sprintf(buf, "%d\n",
> >  		       di->susp_status.ac_suspended &&
> > diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
> > index 14e37b2..5ebae88 100644
> > --- a/drivers/power/pm2301_charger.c
> > +++ b/drivers/power/pm2301_charger.c
> > @@ -22,8 +22,8 @@
> >  #include <linux/i2c.h>
> >  #include <linux/workqueue.h>
> >  #include <linux/kobject.h>
> > -#include <linux/mfd/ab8500.h>
> >  #include <linux/mfd/abx500.h>
> > +#include <linux/mfd/abx500/ab8500.h>
> >  #include <linux/mfd/abx500/ab8500-bm.h>
> >  #include <linux/mfd/abx500/ab8500-gpadc.h>
> >  #include <linux/mfd/abx500/ux500_chargalg.h>
> > @@ -867,7 +867,7 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
> >  
> >  	/* get parent data */
> >  	pm2->dev = &i2c_client->dev;
> > -	pm2->gpadc = ab8500_gpadc_get();
> > +	pm2->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
> 
> Was the driver even compilable before? You've just introduced the new
> driver in this exact series. :-/
> 
> Since pm2301 is a new driver, please merge all pm2301 stuff into one
> patch.
> 
> Or, if you want to preserve the development history of the new driver,
> this is also fine, but then I'd prefer to take it via a pull-request with
> only this driver.
> 
> Thanks,
> Anton

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
