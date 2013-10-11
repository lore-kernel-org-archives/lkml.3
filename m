Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab3JKH3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:29:13 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:50766 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab3JKH3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:29:11 -0400
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat+g9Pvwo0=
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH] omapdss: Add new panel driver for Topolly td028ttec1 LCD.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <5257815F.5070803@ti.com>
Date: Fri, 11 Oct 2013 09:29:07 +0200
Cc: Lars-Peter Clausen <lars@metafoo.de>, Marek Belisko <marek@goldelico.com>,
        <plagnioj@jcrosoft.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <1EA899F5-EAFE-40DE-A233-E6B8AEF893B1@goldelico.com>
References: <1381352915-17219-1-git-send-email-marek@goldelico.com> <525662F5.3090600@ti.com> <7FAC77D4-5E1E-4B11-B067-3A8233C69240@goldelico.com> <52568B40.4040802@ti.com> <04AC7291-38E4-421B-979C-BF03D52E94BD@goldelico.com> <525699EF.6090803@ti.com> <52569CE8.5070201@metafoo.de> <A7739B52-2632-4DD8-924D-B657A6BFE3ED@goldelico.com> <5256F8DF.2020801@metafoo.de> <5257815F.5070803@ti.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Am 11.10.2013 um 06:41 schrieb Tomi Valkeinen:

> On 10/10/13 21:58, Lars-Peter Clausen wrote:
> 
>> According to the datasheet the the panel as a dedicated dout pin. Maybe
>> you did not connect it in your design, which means you won't be able to
>> read any data from the panel at all.
> 
> I don't see a dedicated dout in the datasheet...
> http://dl.wolfgang-draxinger.net/openmoko/doc/TD028TTEC1.pdf
> 
>> Also your custom bitbang code looks a bit strange:
>> 
>>    gpio_set_value(data->dout_gpio, 1);
>>    if (gpio_get_value(data->din_gpio) == 0)
>>        return 1;
>> 
>> You set the state on the dout pin and then read the din pin, if both do
>> not match you abort with an error. This suggest that, for whatever
>> reason,

Detecting hardware failure.

If the panel is not connected or broken (short circuit) reading back
may fail and this can help to detect a hardware failure.

>> you feed the dout pin back into the din pin in your design. Btw.
>> this is also the only place where din is used in your driver.

Ok, I see the issue with that. It assumes this type of feedback which does
not necessarily exist. I.e. if someone else doesn't have this feedback
line the driver will not work.

So a more general solution should work with any setup, even if no
din gpio has been defined. I.e. do this test only if the din_gpio exists.

The main reason that we don't use din_gpio elsewhere is that we have
no jbt_read() function because we lack information what we can
read from the panel controller chip - and have not seen a use-case
for that.

And thanks to your hint, I think either returning 1 is wrong (should be
some -EIO or similar). Or the return r; at the end of td028ttec1_panel_enable
is wrong (should be return rc ? -EIO : 0; ).

We will check that.

> Yes, he said the single "Serial interface data input/output" pin is
> connected to both din and dout on the SoC.

I have found two public links which may describe what we do:

The panel data sheet [1], Section 9 describes the interface as
"3 wire serial interface".

It sometimes calls the data lines DIN and DOUT and describes them
separately, i.e. like a 4 wire interface.

So I guess the jbt6k chip has indeed 4 wires, but (as you said),

din/dout are lines are tied together on the panel side to save
(share) one wire in the flex cable.
 
[2] shows in figure 2 an example how to connect a 3-wire interface
to a 4-wire SPI SoC. This is the way we have done it.


>  I guess the purpose of that
> gpio_get_value() is to ensure that the panel is not pulling the line
> when the SoC is writing to it. Not that I really understand how that can
> work, but I'm not a HW guy =).

Finally, I have checked one detail which rules out to use a standard
SPI driver for OMAP on our board. The reason is that we have a McBSP
port of the OMAP3 and not a McSPI. So we have to run this "3 wire
serial interface protocol" by bitbanging.

IMHO, the most flexible way to hook up the panel (and driver) to arbitrary
hardware is by using GPIOs and not having the panel driver restrict to a
SPI interface.

And having the bitbanging encapsulated in the driver itself (instead on
relying on some spi-bitbang) makes it less dependent on changes
somewhere else. I.e. the driver module is indeed a module.

Marek is preparing an updated patch for further discussion.

BR,
Nikolaus


[1]: http://dl.wolfgang-draxinger.net/openmoko/doc/TD028TTEC1.pdf
[2]: http://www.totalphase.com/support/kb/10059/

