Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab3FNQfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:35:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab3FNQfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:35:38 -0400
Message-ID: <51BB4654.2020405@redhat.com>
Date: Fri, 14 Jun 2013 18:35:32 +0200
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Duggan <aduggan@synaptics.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] HID: i2c-hid: support sending HID output reports using
 the output register
References: <1371164054-15953-1-git-send-email-aduggan@synaptics.com>
In-Reply-To: <1371164054-15953-1-git-send-email-aduggan@synaptics.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 06/14/2013 12:54 AM, Andrew Duggan wrote:
> The current i2c hid driver does not support sending HID output reports using
> the output register for devices which support receiving reports through this
> method. This patch determines which method to use to send output reports based
>  on the value of wMaxOutputLength in the device's HID descriptor.
> 
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>

I have very few comments (actually we already discussed this off-list).

I'm just nitpicking, so I think I can give my:
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Jiri, you can decide whether it worth a v2 or not (I'm fine with the
current code):

> ---
>  drivers/hid/i2c-hid/i2c-hid.c |   18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> index 2b1799a..a71c9a7 100644
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
> +	struct i2c_hid_cmd hidcmd = hid_set_report_cmd;

We can use a pointer here instead of an allocated structure (as
hid_set_report_cmd is a const).

>  	int ret;
>  	u16 dataRegister = le16_to_cpu(ihid->hdesc.wDataRegister);
> +	u16 outputRegister = le16_to_cpu(ihid->hdesc.wOutputRegister);
> +	u16 maxOutputLength = le16_to_cpu(ihid->hdesc.wMaxOutputLength);
>  
>  	/* hidraw already checked that data_len < HID_MAX_BUFFER_SIZE */
>  	u16 size =	2			/* size */ +
> @@ -278,8 +282,16 @@ static int i2c_hid_set_report(struct i2c_client *client, u8 reportType,
>  		reportID = 0x0F;
>  	}
>  
> -	args[index++] = dataRegister & 0xFF;
> -	args[index++] = dataRegister >> 8;
> +	/* use the data register for feature reports or if the device does not
> +	 * support the output register */

This comment does not follow the multi lines comments guideline. It
should be:
/*
 * use the data register for feature reports or if the device does not
 * support the output register
 */

So, just few not very important things. Sorry for not spotting this earlier.

Cheers,
Benjamin

> +	if (reportType == 0x03 || maxOutputLength == 0) {
> +		args[index++] = dataRegister & 0xFF;
> +		args[index++] = dataRegister >> 8;
> +	} else {
> +		args[index++] = outputRegister & 0xFF;
> +		args[index++] = outputRegister >> 8;
> +		hidcmd = hid_no_cmd;
> +	}
>  
>  	args[index++] = size & 0xFF;
>  	args[index++] = size >> 8;
> @@ -289,7 +301,7 @@ static int i2c_hid_set_report(struct i2c_client *client, u8 reportType,
>  
>  	memcpy(&args[index], buf, data_len);
>  
> -	ret = __i2c_hid_command(client, &hid_set_report_cmd, reportID,
> +	ret = __i2c_hid_command(client, &hidcmd, reportID,
>  		reportType, args, args_len, NULL, 0);
>  	if (ret) {
>  		dev_err(&client->dev, "failed to set a report to device.\n");
> 

