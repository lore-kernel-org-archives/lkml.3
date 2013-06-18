Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab3FRI1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:27:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368Ab3FRI1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:27:12 -0400
Message-ID: <51C019DB.5070106@redhat.com>
Date: Tue, 18 Jun 2013 10:27:07 +0200
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Duggan <aduggan@synaptics.com>
CC: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: i2c-hid: support sending HID output reports using
 the output register
References: <1371510906-16859-1-git-send-email-aduggan@synaptics.com>
In-Reply-To: <1371510906-16859-1-git-send-email-aduggan@synaptics.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 01:15 AM, Andrew Duggan wrote:
> The current i2c hid driver does not support sending HID output reports using
> the output register for devices which support receiving reports through this
> method. This patch determines which method to use to send output reports based
>  on the value of wMaxOutputLength in the device's HID descriptor.
> 
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin

> ---
> This is the second version of the patch which includes Benjamin's suggestions. The comment
> now follows the multi line guidelines and in the i2c_hid_set_report function, hidcmd is now
> a pointer.
>  drivers/hid/i2c-hid/i2c-hid.c |   20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> index 2b1799a..879b0ed 100644
> --- a/drivers/hid/i2c-hid/i2c-hid.c
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> @@ -108,6 +108,7 @@ static const struct i2c_hid_cmd hid_reset_cmd =		{ I2C_HID_CMD(0x01),
>  static const struct i2c_hid_cmd hid_get_report_cmd =	{ I2C_HID_CMD(0x02) };
>  static const struct i2c_hid_cmd hid_set_report_cmd =	{ I2C_HID_CMD(0x03) };
>  static const struct i2c_hid_cmd hid_set_power_cmd =	{ I2C_HID_CMD(0x08) };
> +static const struct i2c_hid_cmd hid_no_cmd =		{ .length = 0 };
>  
>  /*
>   * These definitions are not used here, but are defined by the spec.
> @@ -259,8 +260,11 @@ static int i2c_hid_set_report(struct i2c_client *client, u8 reportType,
>  {
>  	struct i2c_hid *ihid = i2c_get_clientdata(client);
>  	u8 *args = ihid->argsbuf;
> +	const struct i2c_hid_cmd * hidcmd = &hid_set_report_cmd;
>  	int ret;
>  	u16 dataRegister = le16_to_cpu(ihid->hdesc.wDataRegister);
> +	u16 outputRegister = le16_to_cpu(ihid->hdesc.wOutputRegister);
> +	u16 maxOutputLength = le16_to_cpu(ihid->hdesc.wMaxOutputLength);
>  
>  	/* hidraw already checked that data_len < HID_MAX_BUFFER_SIZE */
>  	u16 size =	2			/* size */ +
> @@ -278,8 +282,18 @@ static int i2c_hid_set_report(struct i2c_client *client, u8 reportType,
>  		reportID = 0x0F;
>  	}
>  
> -	args[index++] = dataRegister & 0xFF;
> -	args[index++] = dataRegister >> 8;
> +	/*
> +	 * use the data register for feature reports or if the device does not
> +	 * support the output register
> +	 */
> +	if (reportType == 0x03 || maxOutputLength == 0) {
> +		args[index++] = dataRegister & 0xFF;
> +		args[index++] = dataRegister >> 8;
> +	} else {
> +		args[index++] = outputRegister & 0xFF;
> +		args[index++] = outputRegister >> 8;
> +		hidcmd = &hid_no_cmd;
> +	}
>  
>  	args[index++] = size & 0xFF;
>  	args[index++] = size >> 8;
> @@ -289,7 +303,7 @@ static int i2c_hid_set_report(struct i2c_client *client, u8 reportType,
>  
>  	memcpy(&args[index], buf, data_len);
>  
> -	ret = __i2c_hid_command(client, &hid_set_report_cmd, reportID,
> +	ret = __i2c_hid_command(client, hidcmd, reportID,
>  		reportType, args, args_len, NULL, 0);
>  	if (ret) {
>  		dev_err(&client->dev, "failed to set a report to device.\n");
> 

