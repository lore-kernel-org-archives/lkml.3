Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab3HTOGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:06:00 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55207 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751206Ab3HTOF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:05:59 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>
Subject: Re: [RFC PATCH 1/2] i2c: prepare runtime PM support for I2C client devices
Date: Tue, 20 Aug 2013 16:16:31 +0200
Message-ID: <68875641.UkNsrXLDeP@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1377007416-13851-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1377007416-13851-1-git-send-email-mika.westerberg@linux.intel.com> <1377007416-13851-2-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 20, 2013 05:03:35 PM Mika Westerberg wrote:
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
> However, this does not yet make runtime PM happen for the device, it has to
> be explicitly allowed from userspace per each I2C client device. The
> reason for this is that things like HID over I2C might not work as smoothly
> when runtime PM is active. So we leave it to the user to balance between
> performance and power efficiency.
> 
> User can allow runtime PM for the client device by running:
> 
> 	# echo auto > /sys/bus/i2c/devices/<device>/power/control
> 
> and it can be forbidden again by:
> 
> 	# echo on > /sys/bus/i2c/devices/<device>/power/control
> 
> Status of the device can be monitored by reading files under the device
> power directory.
> 
> If the driver doesn't support runtime PM (like most of the existing I2C
> client drivers), the device in question is regarded as being runtime PM
> active and powered on.
> 
> The patch adds also runtime PM support for the adapter device because it is
> needed to be able to runtime power manage the I2C controller device. The
> adapter device is handled along with the I2C controller device (it uses
> pm_runtime_no_callbacks()).
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/i2c/i2c-core.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 3d44292..8fad5ac 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -254,11 +254,34 @@ static int i2c_device_probe(struct device *dev)
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
> +	 *
> +	 * User still needs to allow the PM runtime before it can actually
> +	 * happen.
> +	 */
> +	pm_runtime_forbid(&client->dev);
> +	pm_runtime_get_noresume(&client->dev);
> +	pm_runtime_set_active(&client->dev);
> +	pm_runtime_enable(&client->dev);
> +
>  	status = driver->probe(client, i2c_match_id(driver->id_table, client));
>  	if (status) {
>  		client->driver = NULL;
>  		i2c_set_clientdata(client, NULL);
> +
> +		pm_runtime_disable(&client->dev);
> +		pm_runtime_set_suspended(&client->dev);
> +		pm_runtime_put_noidle(&client->dev);
>  	}
> +
> +	pm_runtime_put(&client->adapter->dev);
> +
>  	return status;
>  }
>  
> @@ -271,6 +294,8 @@ static int i2c_device_remove(struct device *dev)
>  	if (!client || !dev->driver)
>  		return 0;
>  
> +	pm_runtime_get_sync(&client->adapter->dev);
> +
>  	driver = to_i2c_driver(dev->driver);
>  	if (driver->remove) {
>  		dev_dbg(dev, "remove\n");
> @@ -283,6 +308,13 @@ static int i2c_device_remove(struct device *dev)
>  		client->driver = NULL;
>  		i2c_set_clientdata(client, NULL);
>  	}
> +
> +	/* Undo the runtime PM done in i2c_probe() */
> +	pm_runtime_disable(&client->dev);
> +	pm_runtime_set_suspended(&client->dev);
> +	pm_runtime_put_noidle(&client->dev);
> +
> +	pm_runtime_put(&client->adapter->dev);
>  	return status;
>  }
>  
> @@ -294,8 +326,11 @@ static void i2c_device_shutdown(struct device *dev)
>  	if (!client || !dev->driver)
>  		return;
>  	driver = to_i2c_driver(dev->driver);
> -	if (driver->shutdown)
> +	if (driver->shutdown) {
> +		pm_runtime_get_sync(&client->adapter->dev);
>  		driver->shutdown(client);
> +		pm_runtime_put(&client->adapter->dev);
> +	}
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> @@ -1263,6 +1298,15 @@ exit_recovery:
>  	bus_for_each_drv(&i2c_bus_type, NULL, adap, __process_new_adapter);
>  	mutex_unlock(&core_lock);
>  
> +	/*
> +	 * Make sure the adapter runtime PM follows the parent device (the
> +	 * host controller) so that we can suspend it once there aren't any
> +	 * active clients anymore.
> +	 */
> +	pm_runtime_set_active(&adap->dev);
> +	pm_runtime_no_callbacks(&adap->dev);
> +	pm_runtime_enable(&adap->dev);
> +
>  	return 0;
>  
>  out_list:
> @@ -1427,6 +1471,8 @@ void i2c_del_adapter(struct i2c_adapter *adap)
>  		return;
>  	}
>  
> +	pm_runtime_disable(&adap->dev);
> +
>  	/* Tell drivers about this removal */
>  	mutex_lock(&core_lock);
>  	bus_for_each_drv(&i2c_bus_type, NULL, adap,
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
