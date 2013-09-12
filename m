Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab3ILVe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 17:34:27 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35424 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab3ILVeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 17:34:25 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client devices
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
	<1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 12 Sep 2013 14:34:21 -0700
In-Reply-To: <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
	(Mika Westerberg's message of "Wed, 11 Sep 2013 18:32:32 +0300")
Message-ID: <87vc25pvvm.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mika Westerberg <mika.westerberg@linux.intel.com> writes:

> From: Aaron Lu <aaron.lu@intel.com>
>
> This patch adds runtime PM support for the I2C bus in a similar way that
> has been done for PCI bus already. This means that the I2C bus core
> prepares runtime PM for a client device just before a driver is about to be
> bound to it. Devices that are not bound to any driver are not prepared for
> runtime PM.
>
> In order to take advantage of this runtime PM support, the client device
> driver needs drop the device runtime PM reference count by calling
> pm_runtime_put() in its ->probe() callback and possibly implement rest of
> the runtime PM callbacks.
>
> If the driver doesn't support runtime PM (like most of the existing I2C
> client drivers), the device in question is regarded as being runtime PM
> active and powered on.

But for existing drivers which already support runtime PM (at least 7 by
a quick grep), they will be stuck runtime enabled and stop hitting
low-power states after this patch.

> The patch adds also runtime PM support for the adapter device because it is
> needed to be able to runtime power manage the I2C controller device. The
> adapter device is handled along with the I2C controller device (it uses
> pm_runtime_no_callbacks()).
>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/i2c/i2c-core.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 43 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index f32ca29..44374b4 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -248,11 +248,30 @@ static int i2c_device_probe(struct device *dev)
>  					client->flags & I2C_CLIENT_WAKE);
>  	dev_dbg(dev, "probe\n");
>  
> +	/* Make sure the adapter is active */
> +	pm_runtime_get_sync(&client->adapter->dev);
> +
> +	/*
> +	 * Enable runtime PM for the client device. If the client wants to
> +	 * participate on runtime PM it should call pm_runtime_put() in its
> +	 * probe() callback.
> +	 */
> +	pm_runtime_get_noresume(&client->dev);
> +	pm_runtime_set_active(&client->dev);

Why the set_active here?

For hardware that is disabled/powered-off on startup, there will now be
a mismatch between the hardware state an the RPM core state.

Kevin
