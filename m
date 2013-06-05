Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab3FEQRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:17:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53200 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755933Ab3FEQR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:17:28 -0400
Message-ID: <51AF63C7.9070007@ti.com>
Date: Wed, 5 Jun 2013 19:13:59 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] i2c: Let users disable "Probe an I2C bus for certain
 devices"
References: <1370367222-19353-1-git-send-email-grygorii.strashko@ti.com> <20130604174900.GA2992@katana>
In-Reply-To: <20130604174900.GA2992@katana>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
On 06/04/2013 08:49 PM, Wolfram Sang wrote:
> On Tue, Jun 04, 2013 at 08:33:42PM +0300, Grygorii Strashko wrote:
>
>> Currently the I2C devices instantiation Method 3 "Probe an I2C bus for
>> certain devices" (see Documentation/i2c/instantiating-devices) is always
>> enabled for all platforms (boards) and can't be disabled.
> Not true. Set .class = 0 for your adapter. I always ask authors of new
> drivers if they really need to set .class to something.
>
Agree, sorry, my statement is wrong. it would be right to say
"..can't be disabled without kernel code modification".

Few notes here:
1) boot delay issue isn't related to new drivers. There are
hwmon/lm75.c, i2c/busses/i2c-gpio.c and i2c/busses/i2c-omap.c

2) Initially, I've fighted with it on TI K3.4 product kernel where
DT isn't supported yet. And first thing, which I've tried to do is to 
correct
.class parameter for adapter, but with assumption:
"Default behavior shouldn't be changed as I2C detection might be used by 
some
of OMAP boards".

I've started from i2c-omap.c and OMAP4/5 (my target). As result, I was 
need to make
changes in *7* files to set and pass platform parameter to i2c-omap.c 
driver which
will allow to change .class to 0 on demand.

At this point, I've realized that i still need to deal with i2c-gpio.c - 
which
is generic driver.

3) Thinking about Mainline: To reach the same target - no I2C detection 
- and taking
into account above assumption "No changes in default behavior"
the following will need to be done:
- change i2c-omap/i2c-gpio DT bindings and add parameter which will 
allow to change
   .class value for adapter. Not sure, it's possible because this parameter
   will be Linux and not HW specific (smth. like "i2c_disable_detection")
- update drivers i2c-omap/i2c-gpio to use "i2c_disable_detection"
- update OMAP4/5 DTS files

So, It seemed a good solution for me to add 6 lines of code in i2c-core.c
instead of doing all that stuff.

Thanks/sorry for your time.

- grygorii


