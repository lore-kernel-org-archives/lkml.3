Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3GJSMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:12:52 -0400
Received: from mail-pd0-f194.google.com ([209.85.192.194]:39469 "EHLO
	mail-pd0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3GJSMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:12:51 -0400
Date: Wed, 10 Jul 2013 11:12:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Wei Ni <wni@nvidia.com>, khali@linux-fr.org, swarren@wwwdotorg.org,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 2/3] hwmon: (lm90) add support to handle IRQ.
Message-ID: <20130710181248.GA22430@roeck-us.net>
References: <1373455539-2831-1-git-send-email-wni@nvidia.com>
 <1373455539-2831-3-git-send-email-wni@nvidia.com>
 <20130710170552.GA15665@dhcp-172-17-186-34.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710170552.GA15665@dhcp-172-17-186-34.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 10:05:53AM -0700, Thierry Reding wrote:
> On Wed, Jul 10, 2013 at 07:25:38PM +0800, Wei Ni wrote:
> > When the temperature exceed the limit range value,
> > the driver can handle the interrupt.
> > 
> > Signed-off-by: Wei Ni <wni@nvidia.com>
> > ---
> >  drivers/hwmon/lm90.c |   77 +++++++++++++++++++++++++++++++++++++++++---------
> >  1 file changed, 64 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> > index 2cb7f8e..88ff362 100644
> > --- a/drivers/hwmon/lm90.c
> > +++ b/drivers/hwmon/lm90.c
> > @@ -89,6 +89,7 @@
> >  #include <linux/err.h>
> >  #include <linux/mutex.h>
> >  #include <linux/sysfs.h>
> > +#include <linux/interrupt.h>
> >  
> >  /*
> >   * Addresses to scan
> > @@ -179,6 +180,19 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
> >  #define LM90_HAVE_TEMP3		(1 << 6) /* 3rd temperature sensor	*/
> >  #define LM90_HAVE_BROKEN_ALERT	(1 << 7) /* Broken alert		*/
> >  
> > +/* LM90 status */
> > +#define LM90_LTHRM	(1 << 0)	/* local THERM limit tripped */
> > +#define LM90_RTHRM	(1 << 1)	/* remote THERM limit tripped */
> > +#define LM90_OPEN	(1 << 2)	/* remote is an open circuit */
> > +#define LM90_RLOW	(1 << 3)	/* remote low temp limit tripped */
> > +#define LM90_RHIGH	(1 << 4)	/* remote high temp limit tripped */
> > +#define LM90_LLOW	(1 << 5)	/* local low temp limit tripped */
> > +#define LM90_LHIGH	(1 << 6)	/* local high temp limit tripped */
> > +#define LM90_BUSY	(1 << 7)	/* ADC is converting */
> > +
> > +#define MAX6696_RLOW	(1 << 3)	/* remote2 low temp limit tripped */
> > +#define MAX6696_RHIGH	(1 << 4)	/* remote2 high temp limit tripped */
> 
> I think this is a nice cleanup, but I'll leave it up to Guenter or Jean
> to decide if they want to have this. One problem with the above is that
> it's not immediately clear which register contains these bits. That's
> often solved by using the register name as prefix but that will in turn
> make the names for these bits rather long:
> 
> 	#define LM90_REG_R_STATUS_LTHRM	(1 << 0)
> 	...
> 
> Perhaps something like
> 
> 	#define LM90_STATUS_LTHRM	(1 << 0)
> 
> would be a good compromise?
> 
Something like that, yes.

> Also if Guenter and Jean agree that this is a nice cleanup, it should
> probably go into a separate patch since it isn't directly related to the
> IRQ support.
> 
Correct.

> >  /*
> >   * Driver data (common to all clients)
> >   */
> > @@ -1423,6 +1437,43 @@ static void lm90_init_client(struct i2c_client *client)
> >  		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, config);
> >  }
> >  
> > +static void lm90_alarm_status(struct i2c_client *client,
> > +			      u8 alarms, u8 alarms_max6696)
> > +{
> > +	if (alarms & (LM90_LLOW | LM90_LHIGH | LM90_LTHRM))
> > +		dev_warn(&client->dev,
> > +			 "temp%d out of range, please check!\n", 1);
> > +	if (alarms & (LM90_RLOW | LM90_RHIGH | LM90_RTHRM))
> > +		dev_warn(&client->dev,
> > +			 "temp%d out of range, please check!\n", 2);
> > +	if (alarms & LM90_OPEN)
> > +		dev_warn(&client->dev,
> > +			 "temp%d diode open, please check!\n", 2);
> > +
> > +	if (alarms_max6696 & (MAX6696_RLOW | MAX6696_RHIGH))
> > +		dev_warn(&client->dev,
> > +			 "temp%d out of range, please check!\n", 3);
> > +}
> > +
> > +static irqreturn_t lm90_irq_thread(int irq, void *dev_id)
> > +{
> > +	struct lm90_data *data = dev_id;
> > +	struct i2c_client *client = to_i2c_client(data->hwmon_dev->parent);
> > +	u8 alarms, alarms_max6696 = 0;
> > +
> > +	lm90_read_reg(client, LM90_REG_R_STATUS, &alarms);
> > +
> > +	if (data->kind == max6696)
> > +		lm90_read_reg(client, MAX6696_REG_R_STATUS2, &alarms_max6696);
> > +
> > +	if ((alarms & 0x7f) == 0 && (alarms_max6696 & 0xfe) == 0) {
> > +		return IRQ_NONE;
> 
> For non-MAX6696 chips this will evaluate to:
> 
> 	if ((alarms & 0x7f) == 0 && (0 & 0xfe) == 0)
> 
> and therefore be true for any value of "alarms" and therefore always
> result in IRQ_NONE being returned.
> 
Not really. If
	(alarms & 0xfe) == 0
returns false (ie thee is an alarm) the expression is false and the
if statement won't be executed. Or maybe I didn't get enough sleep
last night ;).

> One other thing that slightly bugs me about this is that it's a little
> tedious to pass alarms_max6696 around like this. Suppose yet another
> slightly different variant is supported by this chip in the future,
> it's possible it will require another alarms_XYZ variable that has to be
> passed around. I don't have a better suggestion though, so maybe it can
> remain like this and be rewritten at some point should the need arise.
> 
The driver has tables to separate chips, so masks for status and status2 can
be made generic and configurable if needed. But, yes, it would be better to
select a generic name for the variable from the beginning (status and status2
would do quite nicely).

> Thierry


