Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbaIXUqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:46:39 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58273 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753266AbaIXUqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:46:35 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Huewe <peterhuewe@gmx.de>, Wolfram Sang <wsa@the-dreams.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [REGRESSION] i2c-acpi: Fix NULL Pointer dereference
Date: Wed, 24 Sep 2014 23:06:24 +0200
Message-ID: <1696265.yGhHYgE97A@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410548987-3558-1-git-send-email-peterhuewe@gmx.de>
References: <1410548987-3558-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Do you want me to take care of this or are you going to handle it?

It has been ACKed by Mika already: https://patchwork.kernel.org/patch/4897751/

Rafael


On Friday, September 12, 2014 09:09:47 PM Peter Huewe wrote:
> If adapter->dev.parent == NULL there is a NULL pointer dereference in
> acpi_i2c_install_space_handler and acpi_i2c_remove_space_handler.
> 
> This is present since introduction of this code:
> 366047515c6e "i2c: rework kernel config I2C_ACPI" or even
> da3c6647ee08 "I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI"
> 
> The adapter->dev.parent == NULL case is valid for the i2c_stub,
> so loading i2c_stub with ACPI_I2C_OPREGION enabled results in an oops.
> This is also valid at least for i2c_tiny_usb and i2c_robotfuzz_osif.
> 
> Fix by checking whether it is null before calling ACPI_HANDLE.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/i2c/i2c-acpi.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-acpi.c b/drivers/i2c/i2c-acpi.c
> index 0dbc18c..c456b17 100644
> --- a/drivers/i2c/i2c-acpi.c
> +++ b/drivers/i2c/i2c-acpi.c
> @@ -308,10 +308,15 @@ acpi_i2c_space_handler(u32 function, acpi_physical_address command,
>  
>  int acpi_i2c_install_space_handler(struct i2c_adapter *adapter)
>  {
> -	acpi_handle handle = ACPI_HANDLE(adapter->dev.parent);
> +	acpi_handle handle;
>  	struct acpi_i2c_handler_data *data;
>  	acpi_status status;
>  
> +	if (!adapter->dev.parent)
> +		return -ENODEV;
> +
> +	handle = ACPI_HANDLE(adapter->dev.parent);
> +
>  	if (!handle)
>  		return -ENODEV;
>  
> @@ -344,10 +349,15 @@ int acpi_i2c_install_space_handler(struct i2c_adapter *adapter)
>  
>  void acpi_i2c_remove_space_handler(struct i2c_adapter *adapter)
>  {
> -	acpi_handle handle = ACPI_HANDLE(adapter->dev.parent);
> +	acpi_handle handle;
>  	struct acpi_i2c_handler_data *data;
>  	acpi_status status;
>  
> +	if (!adapter->dev.parent)
> +		return;
> +
> +	handle = ACPI_HANDLE(adapter->dev.parent);
> +
>  	if (!handle)
>  		return;
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
