Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab3GORdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:33:24 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:33958 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab3GORdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:33:23 -0400
Date: Mon, 15 Jul 2013 10:33:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Wei Ni <wni@nvidia.com>, thierry.reding@gmail.com,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 2/4] hwmon: (lm90) use macro defines for the status bit
Message-ID: <20130715173322.GA20484@roeck-us.net>
References: <1373615287-18502-1-git-send-email-wni@nvidia.com>
 <1373615287-18502-3-git-send-email-wni@nvidia.com>
 <20130715185727.4ebde8c4@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715185727.4ebde8c4@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 06:57:27PM +0200, Jean Delvare wrote:
> Hi Wei, Guenter,
> 
> On Fri, 12 Jul 2013 15:48:05 +0800, Wei Ni wrote:
> > Add bit defines for the status register.
> 
> Regarding the subject: for me these are constants, not macros. AFAIK
> the term "macro" refers to defines with parameters only.
> 
> > Signed-off-by: Wei Ni <wni@nvidia.com>
> > ---
> >  drivers/hwmon/lm90.c |   72 ++++++++++++++++++++++++++++++++++----------------
> >  1 file changed, 49 insertions(+), 23 deletions(-)
> > 
> > diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> > index 5f30f90..c90037f 100644
> > --- a/drivers/hwmon/lm90.c
> > +++ b/drivers/hwmon/lm90.c
> > @@ -179,6 +179,19 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
> >  #define LM90_HAVE_TEMP3		(1 << 6) /* 3rd temperature sensor	*/
> >  #define LM90_HAVE_BROKEN_ALERT	(1 << 7) /* Broken alert		*/
> >  
> > +/* LM90 status */
> > +#define LM90_STATUS_LTHRM	(1 << 0) /* local THERM limit tripped */
> > +#define LM90_STATUS_RTHRM	(1 << 1) /* remote THERM limit tripped */
> > +#define LM90_STATUS_OPEN	(1 << 2) /* remote is an open circuit */
> > +#define LM90_STATUS_RLOW	(1 << 3) /* remote low temp limit tripped */
> > +#define LM90_STATUS_RHIGH	(1 << 4) /* remote high temp limit tripped */
> > +#define LM90_STATUS_LLOW	(1 << 5) /* local low temp limit tripped */
> > +#define LM90_STATUS_LHIGH	(1 << 6) /* local high temp limit tripped */
> > +#define LM90_STATUS_BUSY	(1 << 7) /* ADC is converting */
> 
> LM90_STATUS_BUSY is never used anywhere so please don't define it.
> 
> > +
> > +#define MAX6696_STATUS2_RLOW	(1 << 3) /* remote2 low temp limit tripped */
> > +#define MAX6696_STATUS2_RHIGH	(1 << 4) /* remote2 high temp limit tripped */
> > +
> >  /*
> >   * Driver data (common to all clients)
> >   */
> > @@ -1417,6 +1430,36 @@ static void lm90_init_client(struct i2c_client *client)
> >  		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, config);
> >  }
> >  
> > +static bool lm90_is_tripped(struct i2c_client *client)
> > +{
> > +	struct lm90_data *data = i2c_get_clientdata(client);
> > +	u8 status, status2 = 0;
> > +
> > +	lm90_read_reg(client, LM90_REG_R_STATUS, &status);
> > +
> > +	if (data->kind == max6696)
> > +		lm90_read_reg(client, MAX6696_REG_R_STATUS2, &status2);
> > +
> > +	if ((status & 0x7f) == 0 && (status2 & 0xfe) == 0)
> > +		return false;
> 
> It's a bit disappointing to not use the freshly introduced constants.
> That being said I agree it would make the code hard to read, so you can
> leave it as is.
> 
> Unrelated to this patch, but Guenter, I am worried about the MAX6696
> handling here. I realize that I am the one who accepted your code, but
> now it looks wrong. Specifically:
> * We check for (status2 & 0xfe) i.e. 7 alarm bits, but the code below
>   only reports 2 alarms bits. So if any of the 5 other alarm bits in
>   STATUS2 are, we may return true (chip is tripped) but not print the
>   cause.
> * At least bits 1 and 2 of STATUS 2 fit totally fine in the driver as
>   it currently exists, so I can't think of any reason for not handling
>   them. Why are we not? Ideally we should print a message for every
>   alarm bit so that we never return "true" without printing a message.
>   Even though OT2 limits aren't handled by the driver...
> * If you think this piece of code shouldn't deal with OT/THERM limits
>   because they do not trigger an SMBus alarm, this can be discussed,
>   but all chips should be handled the same in this respect then.
> * Why in the first place is max6696's data->alert_alarms set to 0x187c
>   and not 0x1c7c? Including 1OPEN but not 2OPEN makes no sense.
> 
I am about to leave for vacation, so this will have to wait for a couple of
weeks. I'll look at it after I am back.

Guenter

> > +
> > +	if (status & (LM90_STATUS_LLOW | LM90_STATUS_LHIGH | LM90_STATUS_LTHRM))
> > +		dev_warn(&client->dev,
> > +			 "temp%d out of range, please check!\n", 1);
> > +	if (status & (LM90_STATUS_RLOW | LM90_STATUS_RHIGH | LM90_STATUS_RTHRM))
> > +		dev_warn(&client->dev,
> > +			 "temp%d out of range, please check!\n", 2);
> > +	if (status & LM90_STATUS_OPEN)
> > +		dev_warn(&client->dev,
> > +			 "temp%d diode open, please check!\n", 2);
> > +
> > +	if (status2 & (MAX6696_STATUS2_RLOW | MAX6696_STATUS2_RHIGH))
> > +		dev_warn(&client->dev,
> > +			 "temp%d out of range, please check!\n", 3);
> > +
> > +	return true;
> > +}
> > +
> >  static int lm90_probe(struct i2c_client *client,
> >  		      const struct i2c_device_id *id)
> >  {
> > @@ -1515,36 +1558,19 @@ static int lm90_remove(struct i2c_client *client)
> >  
> >  static void lm90_alert(struct i2c_client *client, unsigned int flag)
> >  {
> > -	struct lm90_data *data = i2c_get_clientdata(client);
> > -	u8 config, alarms, alarms2 = 0;
> > -
> > -	lm90_read_reg(client, LM90_REG_R_STATUS, &alarms);
> > -
> > -	if (data->kind == max6696)
> > -		lm90_read_reg(client, MAX6696_REG_R_STATUS2, &alarms2);
> > -
> > -	if ((alarms & 0x7f) == 0 && (alarms2 & 0xfe) == 0) {
> > +	if (!lm90_is_tripped(client)) {
> 
> You could swap the success and failure cases to avoid this negation.
> 
> >  		dev_info(&client->dev, "Everything OK\n");
> >  	} else {
> > -		if (alarms & 0x61)
> > -			dev_warn(&client->dev,
> > -				 "temp%d out of range, please check!\n", 1);
> > -		if (alarms & 0x1a)
> > -			dev_warn(&client->dev,
> > -				 "temp%d out of range, please check!\n", 2);
> > -		if (alarms & 0x04)
> > -			dev_warn(&client->dev,
> > -				 "temp%d diode open, please check!\n", 2);
> > -
> > -		if (alarms2 & 0x18)
> > -			dev_warn(&client->dev,
> > -				 "temp%d out of range, please check!\n", 3);
> > -
> >  		/*
> >  		 * Disable ALERT# output, because these chips don't implement
> >  		 * SMBus alert correctly; they should only hold the alert line
> >  		 * low briefly.
> >  		 */
> > +		struct lm90_data *data = i2c_get_clientdata(client);
> > +		u8 config, alarms;
> > +
> > +		lm90_read_reg(client, LM90_REG_R_STATUS, &alarms);
> 
> You end up reading LM90_REG_R_STATUS, which is not OK. This register
> contains self-clearing bits, so there is no guarantee that the second
> read will return the same value as the first read. You'll have to come
> up with a different approach that reads LM90_REG_R_STATUS only once.
> 
> > +
> >  		if ((data->flags & LM90_HAVE_BROKEN_ALERT)
> >  		 && (alarms & data->alert_alarms)) {
> >  			dev_dbg(&client->dev, "Disabling ALERT#\n");
> 
> 
> -- 
> Jean Delvare
> 
