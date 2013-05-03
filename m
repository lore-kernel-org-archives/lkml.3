Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab3ECKH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 06:07:26 -0400
Received: from smtp-out-053.synserver.de ([212.40.185.53]:1059 "EHLO
	smtp-out-053.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761851Ab3ECKHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 06:07:25 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 8535
Message-ID: <51838C3E.5090303@metafoo.de>
Date: Fri, 03 May 2013 12:06:54 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Xiong Zhou <jencce.kernel@gmail.com>
CC: anton@enomsg.org, dwmw2@infradead.org, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] power: fix bq27x00_battery kconfig
References: <alpine.DEB.2.02.1305031743190.6400@M2420>
In-Reply-To: <alpine.DEB.2.02.1305031743190.6400@M2420>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 11:56 AM, Xiong Zhou wrote:
> From: Xiong Zhou <jencce.kernel@gmail.com>
> 
> This patch fixes build failure(randconfig) of next-20130501.
> When config I2C as m, BATTERY_BQ27x00 as y, here comes the failure.
> BATTERY_BQ27x00 depends on I2C according to the code.
> 

> Failure message:
> drivers/built-in.o: In function `bq27x00_read_i2c':
> bq27x00_battery.c:(.text+0x1082a7): undefined reference to `i2c_transfer'
> drivers/built-in.o: In function `bq27x00_battery_init':
> bq27x00_battery.c:(.init.text+0x6085): undefined reference to `i2c_register_driver'
> bq27x00_battery.c:(.init.text+0x60c7): undefined reference to `i2c_del_driver'
> drivers/built-in.o: In function `bq27x00_battery_exit':
> bq27x00_battery.c:(.exit.text+0xbf0): undefined reference to `i2c_del_driver'
> make: *** [vmlinux] Error 1
> 
> Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>

It's actually a bit more tricky. The driver can be built without I2C
support, so it does not depend on I2C, but if I2C is built as a module the
driver should also only be built as a module.

I think the best solution is to put the platform code and the i2c code of
the bq27x00 driver each in their on module, but if you want a quick solution

depends on I2C || I2C=n

should work.

> ---
> drivers/power/Kconfig |    1 +
> 1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 0d0b5d7..89e5ebd 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -152,6 +152,7 @@ config BATTERY_SBS
>  
>  config BATTERY_BQ27x00
>  	tristate "BQ27x00 battery driver"
> +	depends on I2C
>  	help
>  	  Say Y here to enable support for batteries with BQ27x00 (I2C/HDQ) chips.
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

