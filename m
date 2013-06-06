Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab3FFRxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:53:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48624 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753782Ab3FFRxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:53:22 -0400
Message-ID: <1370541200.2209.6.camel@joe-AO722>
Subject: Re: [PATCH 3/6] keucr: migrate printk to dev_dbg/info/warn/err
From: Joe Perches <joe@perches.com>
To: Johannes Schilling <of82ecuq@cip.cs.fau.de>
Cc: linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de,
        Al Cho <acho@novell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Kurt Kanzenbach <shifty91@gmail.com>, devel@driverdev.osuosl.org,
        Laura Lawniczak <laura.lawniczak@googlemail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 06 Jun 2013 10:53:20 -0700
In-Reply-To: <1370535050-7167-4-git-send-email-of82ecuq@cip.cs.fau.de>
References: <20130605094517.GS28112@mwanda>
	 <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
	 <1370535050-7167-4-git-send-email-of82ecuq@cip.cs.fau.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-06 at 18:10 +0200, Johannes Schilling wrote:
> From: Laura Lawniczak <laura.lawniczak@googlemail.com>
[]
> diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
[]
> @@ -19,13 +19,13 @@ int ENE_InitMedia(struct us_data *us)
[]
> -	printk(KERN_INFO "MiscReg03 = %x\n", MiscReg03);
> +	dev_info(&us->pusb_dev->dev, "MiscReg03 = %x\n", MiscReg03);

I suggest adding a few convenience macros to make
this a bit shorter and more likely to fit on a single
line without exceeding 80 cols.

Adding something like:

#define us_<level>(us, fmt, ...)				\
	dev_<level>(&us->pusb_dev->dev, fmt, ##__VA_ARGS__)

so these uses become

	us_info(us, "MiscReg03\n", MiscReg03);

which is shorter and more readable.

> diff --git a/drivers/staging/keucr/smilsub.c b/drivers/staging/keucr/smilsub.c
[]
> @@ -214,7 +214,7 @@ int Ssfdc_D_ReadSect(struct us_data *us, BYTE *buf, BYTE *redundant)
>  
>  	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
>  	if (result != USB_STOR_XFER_GOOD) {
> -		printk("Load SM RW Code Fail !!\n");
> +		dev_err(&us->pusb_dev->dev, "Load SM RW Code Fail !!\n");

Also, there's no need to shout in the logs.
These are reported at KERN_ERR level, so using

	us_err(us, "loading SM RW code failed\n")

would be fine.


