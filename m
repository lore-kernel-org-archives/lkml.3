Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965551AbaCUNyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:54:00 -0400
Received: from mail1.windriver.com ([147.11.146.13]:52491 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965429AbaCUNxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:53:55 -0400
Message-ID: <532C4476.2030706@windriver.com>
Date: Fri, 21 Mar 2014 09:53:58 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jim Davis <jim.epost@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] drivers/video: fix mb862xx_i2c depends issue build failure
References: <1395328560-48497-1-git-send-email-paul.gortmaker@windriver.com> <532C3F64.2020601@ti.com>
In-Reply-To: <532C3F64.2020601@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-03-21 09:32 AM, Tomi Valkeinen wrote:
> Hi,
> 
> On 20/03/14 17:16, Paul Gortmaker wrote:
>> Any randconfig that sets I2C=m and FB_MB862XX_I2C=y will
>> encounter a final link failure that looks like this:
> 
> It compiles fine with I2C=m, FB_MB862XX=m and FB_MB862XX_I2C=y.
> 
>> drivers/built-in.o: In function `mb862xx_i2c_init':
>> drivers/video/mb862xx/mb862xx-i2c.c:165: undefined reference to `i2c_add_adapter'
>> drivers/built-in.o: In function `mb862xx_i2c_exit':
>> drivers/video/mb862xx/mb862xx-i2c.c:176: undefined reference to `i2c_del_adapter'
>>
>> Since FB_MB862XX_I2C is a bool and not tristate, simply
>> don't offer it at all if core I2C support is not built in.
> 
> FB_MB862XX_I2C is not a driver, it just adds the i2c support to
> FB_MB862XX. The relevant thing is whether FB_MB862XX is m or y, so
> compiling with:
> 
> I2C=m, FB_MB862XX=y and FB_MB862XX_I2C=y
> 
> will fail.

How would you suggest we fix it then?  Perhaps we could simplify the
Kconfig space and just get rid of FB_MB862XX_I2C entirely?  Is there
ever a reason why someone would want it turned off when I2C is present?

Paul.
--

> 
>> Reported-by: Jim Davis <jim.epost@gmail.com>
>> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>>
>> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
>> index dade5b7699bc..aefd1b9a3cbd 100644
>> --- a/drivers/video/Kconfig
>> +++ b/drivers/video/Kconfig
>> @@ -2338,7 +2338,7 @@ endchoice
>>  
>>  config FB_MB862XX_I2C
>>  	bool "Support I2C bus on MB862XX GDC"
>> -	depends on FB_MB862XX && I2C
>> +	depends on FB_MB862XX && I2C=y
>>  	default y
>>  	help
>>  	  Selecting this option adds Coral-P(A)/Lime GDC I2C bus adapter
> 
> This fix is not correct, as it prevents the following, valid, config:
> 
> I2C=m, FB_MB862XX=m and FB_MB862XX_I2C=y
> 
>  Tomi
> 
> 
