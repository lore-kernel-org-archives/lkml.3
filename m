Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbaFBN5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:57:31 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63544 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbaFBN53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:57:29 -0400
Date: Mon, 2 Jun 2014 14:57:22 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wsa@the-dreams.de
Cc: linus.walleij@linaro.org, grant.likely@linaro.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/3] i2c: Provide 'device type' to 'OF device node'
 look-up
Message-ID: <20140602135722.GC4146@lee--X1>
References: <1401716463-23457-1-git-send-email-lee.jones@linaro.org>
 <1401716463-23457-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401716463-23457-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We have a problem.  There are lots of I2C device ID tables scattered
> around the kernel which are redundant in all Device Tree and/or ACPI
> only supported device drivers.  After recent discussions it has become
> apparent that the only thing blocking the complete removal of these
> tables is the continued support of 'register an I2C device via sysfs'
> functionality.  As the sysfs method doesn't know anything about Device
> Tree or ACPI, we can not pass any nodes in.  This patch searches all
> known Device Tree nodes and attempts to acquire a match from the
> device name provided via sysfs.  It can not fail, but if found assigns
> the matching of_node to i2c_board_info prior to registering.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/i2c/i2c-core.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)

[...]

> +static struct device_node *of_i2c_type_to_node(char *type)
> +{
> +	struct device_node *np;
> +	const char *compatible, *name;
> +	int len;
> +
> +	if (!type)
> +		return NULL;
> +
> +	for_each_of_allnodes(np) {
> +		compatible = of_get_property(np, "compatible", &len);
> +		if (!compatible)
> +			continue;
> +
> +		name = strchr(compatible, ',');
> +		if (!name)
> +			name = compatible;
> +		else
> +			name++;
> +
> +		if (!strncmp(name, type, len - (name - compatible)))
> +			return np;
> +	}
> +
> +	return NULL;
> +}

Ah, this _might_ not work if there are more than one devices of the
same type.  I guess I need to check the 'reg' property too.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
