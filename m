Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbaIWLZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:25:32 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:43267 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbaIWLYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:24:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Sep 2014 13:24:18 +0200
From: Stefan Agner <stefan@agner.ch>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] pinctrl: imx: add gpio pinmux support for vf610
In-Reply-To: <CACRpkdYk0zW12qNXgOstTLmdVDYacu0Un+8quTN+J_azOic7AA@mail.gmail.com>
References: <cover.1410020458.git.stefan@agner.ch>
 <4cf96e22ce2c7646513b64260c7bb1a2279e232d.1410020459.git.stefan@agner.ch>
 <CACRpkdYk0zW12qNXgOstTLmdVDYacu0Un+8quTN+J_azOic7AA@mail.gmail.com>
Message-ID: <0498face86b4dcbdf35619c8b124675c@agner.ch>
User-Agent: Roundcube Webmail/1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-09-23 11:48, schrieb Linus Walleij:
> On Sat, Sep 6, 2014 at 6:25 PM, Stefan Agner <stefan@agner.ch> wrote:
> 
>> Add pinmux support for GPIO for Vybrid (vf610) IOMUX controller.
>> This is needed since direction configuration is not part of the
>> GPIO module in Vybrid.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
> (...)
> 
>> -arch_initcall(vf610_pinctrl_init);
>> +postcore_initcall(vf610_pinctrl_init);
> 
> Why is this necessary? You should be able to rely on deferred
> probing to do its work here. I think this should be module_init()
> or driver_initcall() really.

Currently deferred probe doesn't work for gpiolib drivers which try to
add gpio-ranges from device tree:
gpiochip_add calls of_gpiochip_add_pin_range (through of_gpiochip_add).
This function tries to get the pinctrl driver, which is not registred at
that time. Currently the driver does not defer probing but fails
silently...

We would need to alter the return values of those two functions
(of_gpiochip_add_pin_range/of_gpiochip_add) and honor the return value
in gpiochip_add. 

Currently, it seems that we quite often use an early initcall to get the
pinctrl loaded early:
$ grep -h -o ".*_initcall" drivers/pinctrl/*.c | sort | uniq -c
     18 arch_initcall
      3 core_initcall
      3 postcore_initcall
      1 subsys_initcall

IMHO for those core services, it also makes sense to have them
initialized early. I'd rather prefer this hard coded than having dozens
of "requests probe deferral" messages...

--
Stefan
