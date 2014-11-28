Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaK1NsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:48:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57755 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaK1NsR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:48:17 -0500
Date: Fri, 28 Nov 2014 14:48:13 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Peter Wu <lekensteyn@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How should dev_[gs]et_drvdata be used?
Message-ID: <20141128144813.3e6fd8d9@endymion.delvare>
In-Reply-To: <20141125211432.GA6008@pengutronix.de>
References: <20130123174204.00463f98@endymion.delvare>
	<2690400.fFjCFlrrIR@al>
	<1387820241.30327.105.camel@bling.home>
	<1716344.EUMSGCAAKK@al>
	<20140108142849.3993341c@endymion.delvare>
	<20141125211432.GA6008@pengutronix.de>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Tue, 25 Nov 2014 22:14:32 +0100, Uwe Kleine-König wrote:
> On Wed, Jan 08, 2014 at 02:28:49PM +0100, Jean Delvare wrote:
> > Having looked at the code in deeper detail, I think I understand what
> > is going on. The problem is with:
> > 
> > 	i2c_set_adapdata(&priv->adapter, priv);
> > 
> > at the beginning of i801_probe(). It triggers the allocation of dev->p
> > by the driver core. If we bail out at any point before i2c_add_adapter
> > (and subsequently device_register) is called, then that memory is never
> > freed.
> > 
> > Unfortunately it is not possible to move the i2c_set_adapdata() call
> > after i2c_add_adapter(), because the data pointer is needed by code
> > which runs as part of i2c_add_adapter().
> > 
> > We could move it right before the call to i2c_add_adapter(), to make
> > the problem window smaller, but this wouldn't solve the problem
> > completely, as i2c_add_adapter() itself can fail before
> > device_register() is called.
> > 
> > The only solution I can think of at this point is to stop using
> > i2c_set_adapdata() altogether, and use i2c_adapter.algo_data instead:
> > 
> > From: Jean Delvare <khali@linux-fr.org>
> > Subject: i2c-i801: Use i2c_adapter.algo_data
> > 
> > Use i2c_adapter.algo_data instead of i2c_set/get_adapdata(). The
> > latter makes use of the driver core's private data mechanism, which
> > allocates memory. That memory is never released if an error happens
> > between the call to i2c_set_adapdata() and the actual i2c_adapter
> > registration.
>
> Since commit 1bb6c08abfb6 (which makes the driver core use a pointer in
> struct device again for dev_set_drvdata; went into v3.16-rc1) this patch
> is obsolete, right?

Correct. It was never applied upstream anyway, which is good as I never
liked it.

> (Still there might be the opportunity for a few patches converting all
> driver to i2c_set_adapdata and then drop adapter.algo_data.)

That's at least 35 bus drivers that would have to be converted then.
But you should first check if it is possible to get rid of
i2c_adapter.algo_data without breaking i2c-algo-bit and i2c-mux. If not
then converting the bus drivers would really only be a minor cleanup
with no real benefit (not saying it's not worth it though.)

> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Cc: Peter Wu <lekensteyn@gmail.com>
> > ---
> >  drivers/i2c/busses/i2c-i801.c |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > --- a/drivers/i2c/busses/i2c-i801.c
> > +++ b/drivers/i2c/busses/i2c-i801.c
> > @@ -671,7 +671,7 @@ static s32 i801_access(struct i2c_adapte
> >  	int hwpec;
> >  	int block = 0;
> >  	int ret, xact = 0;
> > -	struct i801_priv *priv = i2c_get_adapdata(adap);
> > +	struct i801_priv *priv = adap->algo_data;
> >  
> >  	hwpec = (priv->features & FEATURE_SMBUS_PEC) && (flags & I2C_CLIENT_PEC)
> >  		&& size != I2C_SMBUS_QUICK
> > @@ -774,7 +774,7 @@ static s32 i801_access(struct i2c_adapte
> >  
> >  static u32 i801_func(struct i2c_adapter *adapter)
> >  {
> > -	struct i801_priv *priv = i2c_get_adapdata(adapter);
> > +	struct i801_priv *priv = adapter->algo_data;
> >  
> >  	return I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE |
> >  	       I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA |
> > @@ -1117,7 +1117,7 @@ static int i801_probe(struct pci_dev *de
> >  	if (!priv)
> >  		return -ENOMEM;
> >  
> > -	i2c_set_adapdata(&priv->adapter, priv);
> > +	priv->adapter.algo_data = priv;
> >  	priv->adapter.owner = THIS_MODULE;
> >  	priv->adapter.class = i801_get_adapter_class(priv);
> >  	priv->adapter.algo = &smbus_algorithm;
> > 
> > I can't think of any drawback, other than the feeling that switching
> > from a generic implementation to a specific one is a move in the wrong
> > direction.
> > 
> > If the above is the proper fix then we may consider just changing the
> > implementation of i2c_set/get_adapdata to use adapter.algo_data instead
> > of calling dev_set/get_drvdata(). This would let us fix all the drivers
> > at once.
> > 
> > I'll bring the topic upstream for discussion.

-- 
Jean Delvare
SUSE L3 Support
