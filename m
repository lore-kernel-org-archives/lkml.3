Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab3JKHIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:08:05 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:60311 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749Ab3JKHIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:08:02 -0400
Message-ID: <5257A402.5030806@metafoo.de>
Date: Fri, 11 Oct 2013 09:08:50 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Marek Belisko <marek@goldelico.com>, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] omapdss: Add new panel driver for Topolly td028ttec1
 LCD.
References: <1381352915-17219-1-git-send-email-marek@goldelico.com> <525662F5.3090600@ti.com> <7FAC77D4-5E1E-4B11-B067-3A8233C69240@goldelico.com> <52568B40.4040802@ti.com> <04AC7291-38E4-421B-979C-BF03D52E94BD@goldelico.com> <525699EF.6090803@ti.com> <52569CE8.5070201@metafoo.de> <A7739B52-2632-4DD8-924D-B657A6BFE3ED@goldelico.com> <5256F8DF.2020801@metafoo.de> <5257815F.5070803@ti.com>
In-Reply-To: <5257815F.5070803@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 06:41 AM, Tomi Valkeinen wrote:
> On 10/10/13 21:58, Lars-Peter Clausen wrote:
>
>> According to the datasheet the the panel as a dedicated dout pin. Maybe
>> you did not connect it in your design, which means you won't be able to
>> read any data from the panel at all.
>
> I don't see a dedicated dout in the datasheet...
> http://dl.wolfgang-draxinger.net/openmoko/doc/TD028TTEC1.pdf

Hm, ok, looks like the display controller used in the panel (the jbt6k74) has 
separate DIN and DOUT, but the panel only has one pin. But the datasheet for 
the panel is not exactly clear on whether it's DIN pin is both the DIN and DOUT 
pin from the controller or, just DIN and DOUT not being connected at all.

>
>> Also your custom bitbang code looks a bit strange:
>>
>>      gpio_set_value(data->dout_gpio, 1);
>>      if (gpio_get_value(data->din_gpio) == 0)
>>          return 1;
>>
>> You set the state on the dout pin and then read the din pin, if both do
>> not match you abort with an error. This suggest that, for whatever
>> reason, you feed the dout pin back into the din pin in your design. Btw.
>> this is also the only place where din is used in your driver.
>
> Yes, he said the single "Serial interface data input/output" pin is
> connected to both din and dout on the SoC. I guess the purpose of that
> gpio_get_value() is to ensure that the panel is not pulling the line
> when the SoC is writing to it. Not that I really understand how that can
> work, but I'm not a HW guy =).

Hm, ok. I don't think the panel will ever actively drive the line. So in my 
opinion using either the McBSP SPI master or the GPIO bitbang SPI master should 
work just fine. You just wouldn't be able to read any register from the device. 
But the driver is not attempting to do this, so it should be fine.

- Lars
