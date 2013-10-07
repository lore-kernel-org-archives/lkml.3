Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3JGXmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 19:42:21 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53076 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3JGXmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 19:42:19 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <525346D3.30500@roeck-us.net>
Date: Mon, 07 Oct 2013 16:42:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Chris Murphy <bugzilla@colorremedies.com>,
        Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: applesmc oops in 3.10/3.11
References: <20130927175926.GA6267@roeck-us.net> <B6E9FB4C-665C-454E-9DEB-B95B85C1D0E0@colorremedies.com> <524615B1.6000106@roeck-us.net> <4FFB3671-DDB4-40F7-BA5D-C9AA9391BDA9@colorremedies.com> <524A4384.4040403@roeck-us.net> <20131002035156.GA566@roeck-us.net> <20131002095339.GA2716@polaris.bitmath.org> <524C1FE1.4050207@roeck-us.net> <20131002163418.GA4557@polaris.bitmath.org> <20131002164718.GA7392@roeck-us.net> <20131002172410.GA381@polaris.bitmath.org>
In-Reply-To: <20131002172410.GA381@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 10:24 AM, Henrik Rydberg wrote:

>>From 4451da32414080bd0563ee9e061f19bf90463cc5 Mon Sep 17 00:00:00 2001
> From: Henrik Rydberg <rydberg@euromail.se>
> Date: Wed, 2 Oct 2013 19:15:03 +0200
> Subject: [PATCH] applesmc remedy take 2
>
> Conjectured problem: there are remnant bytes ready on the data line
> which corrupts the read after a failure.
>
> Remedy: assuming bit0 is the read valid line, try to flush it before
> starting a new command.
>
> Tests by Chris suggests reading the status is enough for the problem
> to go away, which is consistent with a change in the SMC interface,
> where the number of bytes to read is no longer specified, but found
> out by reading until end of data.
>
> Tested on a MacBookAir3,1, but the original problem has not been
> reproduced.

So, what should we do with this patch ? Apply it ?

Thanks,
Guenter

> ---
>   drivers/hwmon/applesmc.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
>
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index 98814d1..c0ff350 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
> @@ -230,6 +230,7 @@ static int send_argument(const char *key)
>
>   static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
>   {
> +	u8 status, data;
>   	int i;
>
>   	if (send_command(cmd) || send_argument(key)) {
> @@ -237,6 +238,7 @@ static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
>   		return -EIO;
>   	}
>
> +	/* This has no effect on newer (2012) SMCs */
>   	if (send_byte(len, APPLESMC_DATA_PORT)) {
>   		pr_warn("%.4s: read len fail\n", key);
>   		return -EIO;
> @@ -250,6 +252,17 @@ static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
>   		buffer[i] = inb(APPLESMC_DATA_PORT);
>   	}
>
> +	/* Read the data port until bit0 is cleared */
> +	for (i = 0; i < 16; i++) {
> +		udelay(APPLESMC_MIN_WAIT);
> +		status = inb(APPLESMC_CMD_PORT);
> +		if (!(status & 0x01))
> +			break;
> +		data = inb(APPLESMC_DATA_PORT);
> +	}
> +	if (i)
> +		pr_warn("flushed %d bytes, last value is: %d\n", i, data);
> +
>   	return 0;
>   }
>
>

