Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3BPVZi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 16:25:38 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:46605 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab3BPVZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 16:25:37 -0500
Date: Sat, 16 Feb 2013 22:25:24 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Wolfram Sang <wolfram@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C: add i2c_master_send_exact() and friends
Message-ID: <20130216222524.0980b297@endymion.delvare>
In-Reply-To: <20130216024235.GA25913@core.coreip.homeip.net>
References: <20130216024235.GA25913@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Fri, 15 Feb 2013 18:42:35 -0800, Dmitry Torokhov wrote:
> Many i2c users consider short transfers to be an error and would prefer
> getting -EIO instead of a positive return value and having to convert
> it to error code by themselves. So let's add the following new helpers:
> 
> 	i2c_master_send_exact()
> 	i2c_master_recv_exact()
> 	i2c_transfer_exact()

This is interesting, so far people had been complaining that
i2c_transfer() wasn't telling enough to the caller on error. You're the
first one asking for less detail. But in a way this is the same
request: the current API can't report both errors and number of
transferred messages/bytes, so the interface ends up being too complex
for what it can actually do.

There was a proposal to improve that but it required touching struct
i2c_msg in a way that would break binary compatibility on some
architectures, so it was rejected.

At this point I can only think of two ways to address the issue
properly: either introduce a new i2c_msg-like structure, or add an
optional u16* parameter to i2c_transfer(), pointing to an array with
the same size as msgs, where the number of transferred bytes for each
message would be recorded. The latter doesn't look as nice but would be
better performance-wise (no need to convert between old and new i2c_msg
structures in compatibility paths.) In both cases, this would have to
be implemented optionally on a per-driver basis, and user-space
wouldn't benefit of it unless someone explicitly adds new ioctls to the
i2c-dev interface.

If this ever happens then your proposal makes sense. Otherwise it might
actually make more sense to just simplify the current API by only
returning success (0) or a negative error code, and adding some
compatibility code into i2c-dev.c so that user-space doesn't see the
change.

> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
> 
> Resending to Wolfram's new address...
> 
>  drivers/i2c/i2c-core.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c.h    |   11 ++++++++
>  2 files changed, 80 insertions(+)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index e388590..6cddb5d 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -1430,6 +1430,33 @@ int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
>  EXPORT_SYMBOL(i2c_transfer);
>  
>  /**
> + * i2c_transfer_exact - transfer given number of I2C messages
> + * @adap: Handle to I2C bus
> + * @msgs: One or more messages to execute before STOP is issued to
> + *	terminate the operation; each message begins with a START.
> + * @num: Number of messages to be executed.
> + *
> + * Returns negative errno (including -EIO on short transfer),
> + * or 0 if all messages have been tranferred successfully.
> + *
> + * Note that there is no requirement that each message be sent to
> + * the same slave address, although that is the most common model.
> + */
> +int i2c_transfer_exact(struct i2c_adapter *adap,
> +		       struct i2c_msg *msgs, int num)
> +{
> +	int ret;
> +
> +	ret = i2c_transfer(adap, msgs, num);
> +	if (ret == num)
> +		return 0;
> +
> +	return ret < 0 ? ret : -EIO;
> +
> +}
> +EXPORT_SYMBOL(i2c_transfer_exact);

Two questions here which apply to other functions as well:
* Why don't you use EXPORT_SYMBOL_GPL()?
* Did you check if an inline function wouldn't be cheaper in practice?
  i2c_transfer() is already a wrapper around __i2c_transfer(), and
  i2c_master_send/recv() are wrappers around i2c_transfer(). Adding one
  more wrapper level is going to do no good to performance and stack
  usage.

> +
> +/**
>   * i2c_master_send - issue a single I2C message in master transmit mode
>   * @client: Handle to slave device
>   * @buf: Data that will be written to the slave

-- 
Jean Delvare
