Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaAHN3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:29:08 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:1526 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbaAHN3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:29:04 -0500
Date: Wed, 8 Jan 2014 14:28:49 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Peter Wu <lekensteyn@gmail.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How should dev_[gs]et_drvdata be used?
Message-ID: <20140108142849.3993341c@endymion.delvare>
In-Reply-To: <1716344.EUMSGCAAKK@al>
References: <20130123174204.00463f98@endymion.delvare>
	<2690400.fFjCFlrrIR@al>
	<1387820241.30327.105.camel@bling.home>
	<1716344.EUMSGCAAKK@al>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Dec 2013 01:18:03 +0100, Peter Wu wrote:
> On Monday 23 December 2013 10:37:21 Alex Williamson wrote:
> > On Mon, 2013-12-23 at 16:49 +0100, Peter Wu wrote:
> [..]
> > > 
> > > There is still one thing I do not fully understand, how should
> > > dev_set_drvdata and dev_get_drvdata be used? For the devices passed
> > > to probe functions, the core takes care of setting to NULL on error.
> > > Then device_unregister frees the memory, right?
> > > 
> > > Now, what if the dev_set_drvdata (or aliases such as pci_set_drvdata,
> > > i2c_set_adapinfo, etc.) are manually called outside probe functions?

FWIW I don't think this is supposed to happen.

> > > Or inside the probe function, but not for the device that is being
> > > probed (such as is the case with the i801 i2c driver)?

This OTOH does happen. Is suspect any driver which instantiates class
devices will do exactly that. It's nothing i2c specific. For example
media drivers call video_set_drvdata() in their probe functions.

> (...)
> Clear examples of how to use dev_{s,g}et_drvdata correctly in i2c is
> still wanted. I stepped in it yesterday, i2c seems to have its own
> way to register new devices.

What makes you think so? It's as standard as I can imagine.

> More specifically, how can the memory
> associated with dev_set_drvdata be free'd on error paths if the
> device is not registered with device_register (as is done in the
> probe function of the i801 i2c driver)?

There are two pieces of data to consider here. The data structure which
is pointed to by dev_get_drvdata (or i2c_get_adapdata) is allocated
explicitly by the driver and must be freed explicitly by the driver
(unless devm_kzalloc is used, in which case the cleanup is automatic).

The data structure used internally by the driver core (dev->p) is
allocated transparently and is thus the core's responsibility to free.
I remember looking into this some time ago after someone reported a
possible memleak to me, and was not fully convinced that the core was
properly releasing dev->p in all cases. This may be the same problem
you are looking at right now.

I do not understand your claim that i2c_adapter class devices are not
registered with device_register. I2c bus drivers such as i2c-i801 call
i2c_add_adapter(), which calls i2c_register_adapter(), which calls
device_register().

Having looked at the code in deeper detail, I think I understand what
is going on. The problem is with:

	i2c_set_adapdata(&priv->adapter, priv);

at the beginning of i801_probe(). It triggers the allocation of dev->p
by the driver core. If we bail out at any point before i2c_add_adapter
(and subsequently device_register) is called, then that memory is never
freed.

Unfortunately it is not possible to move the i2c_set_adapdata() call
after i2c_add_adapter(), because the data pointer is needed by code
which runs as part of i2c_add_adapter().

We could move it right before the call to i2c_add_adapter(), to make
the problem window smaller, but this wouldn't solve the problem
completely, as i2c_add_adapter() itself can fail before
device_register() is called.

The only solution I can think of at this point is to stop using
i2c_set_adapdata() altogether, and use i2c_adapter.algo_data instead:

From: Jean Delvare <khali@linux-fr.org>
Subject: i2c-i801: Use i2c_adapter.algo_data

Use i2c_adapter.algo_data instead of i2c_set/get_adapdata(). The
latter makes use of the driver core's private data mechanism, which
allocates memory. That memory is never released if an error happens
between the call to i2c_set_adapdata() and the actual i2c_adapter
registration.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Peter Wu <lekensteyn@gmail.com>
---
 drivers/i2c/busses/i2c-i801.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -671,7 +671,7 @@ static s32 i801_access(struct i2c_adapte
 	int hwpec;
 	int block = 0;
 	int ret, xact = 0;
-	struct i801_priv *priv = i2c_get_adapdata(adap);
+	struct i801_priv *priv = adap->algo_data;
 
 	hwpec = (priv->features & FEATURE_SMBUS_PEC) && (flags & I2C_CLIENT_PEC)
 		&& size != I2C_SMBUS_QUICK
@@ -774,7 +774,7 @@ static s32 i801_access(struct i2c_adapte
 
 static u32 i801_func(struct i2c_adapter *adapter)
 {
-	struct i801_priv *priv = i2c_get_adapdata(adapter);
+	struct i801_priv *priv = adapter->algo_data;
 
 	return I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE |
 	       I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA |
@@ -1117,7 +1117,7 @@ static int i801_probe(struct pci_dev *de
 	if (!priv)
 		return -ENOMEM;
 
-	i2c_set_adapdata(&priv->adapter, priv);
+	priv->adapter.algo_data = priv;
 	priv->adapter.owner = THIS_MODULE;
 	priv->adapter.class = i801_get_adapter_class(priv);
 	priv->adapter.algo = &smbus_algorithm;

I can't think of any drawback, other than the feeling that switching
from a generic implementation to a specific one is a move in the wrong
direction.

If the above is the proper fix then we may consider just changing the
implementation of i2c_set/get_adapdata to use adapter.algo_data instead
of calling dev_set/get_drvdata(). This would let us fix all the drivers
at once.

I'll bring the topic upstream for discussion.

-- 
Jean Delvare
