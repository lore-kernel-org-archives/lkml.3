Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab3GJT16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:27:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34698 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab3GJT14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:27:56 -0400
Message-ID: <51DDB5B8.5060909@wwwdotorg.org>
Date: Wed, 10 Jul 2013 13:27:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 2/4] pinmux: Add TB10x pinmux driver
References: <20130618092516.GC18663@ab42.lan> <1371547751-13873-2-git-send-email-christian.ruppert@abilis.com> <51C23222.2060906@wwwdotorg.org> <20130626115051.GC7095@ab42.lan> <51CB279A.1090404@wwwdotorg.org> <20130705094859.GA27196@ab42.lan> <51D71337.6030409@wwwdotorg.org> <20130708130222.GA6402@ab42.lan>
In-Reply-To: <20130708130222.GA6402@ab42.lan>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 07:02 AM, Christian Ruppert wrote:
...
> OK, a small drawing of our hardware should make this clear, let's take
> an imaginary example of one port with 10 pins, one i2c interface, one
> spi interface and one GPIO bank:
> 
>               | mux N-1|
>               +........+
>               |        |  2
>               |        +--/-- i2c
>               |        |
>            10 |        |  4
>    Pins  --/--+ mux N  +--/-- spi
>               |        |
>               |        |  10
>               |        +--/-- GPIO
>               |        |
>               +........+
>               | mux N+1|
>
> This example shows the mux N inside the pin controller. It controls
> all pins associated to port N through a single register value M. Let's
> assume the pins are configured as follows in function of the register
> value:
> 
>  pin      M=0       M=1     M=2      M=3
>   0      GPIO0   SPI_MISO  GPIO0   SPI_MISO
>   1      GPIO1   SPI_MOSI  GPIO1   SPI_MOSI
>   2      GPIO2    SPI_CK   GPIO2    SPI_CK
>   3      GPIO3    SPI_CS   GPIO3    SPI_CS
>   4      GPIO4    GPIO4    GPIO4    GPIO4
>   5      GPIO5    GPIO5    GPIO5    GPIO5
>   6      GPIO6    GPIO6    GPIO6    GPIO6
>   7      GPIO7    GPIO7    GPIO7    GPIO7
>   8      GPIO8    GPIO8   I2C_SDA  I2C_SDA
>   9      GPIO9    GPIO9   I2C_SCL  I2C_SCL


In that scenario, in the language of Linux's pinctrl subsystem, what you
have is:

10 pins, named 0..9
1 pin group, named perhaps "mux N".
4 different functions; values M==0, 1, 2, 3.

> We now have three pin groups defined, corresponding to the chip-side
> ports of the pin controller:
> GPIO = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
> SPI  = {0, 1, 2, 3}
> I2C  = {8, 9}

You would usually only define pin groups for the pin/ball/package side
of the pinmux HW. IIRC, you're also wanting to define pin groups for the
intra-chip side of the pinmux HW. However, you're not muxing functions
onto those pingroups; they're just there to help with naming the
GPIO<->pinmux mapping. You only mux functions onto the pin/ball/package
side pins/pingroups.


> abilis,pingrp now specifies one of the three pin groups. Note that I2C
>        and SPI can be requested independently in a completely orthogonal
>        manner: The information if I2C is reqired or not is confined to
>        the I2C request and does not leak into the SPI request as would
>        be the case if we configured the entire port at the same time.

The pingrp should represent the pin/ball/package side pins/groups. In
this case, it should specify "N".

> abilis,ioport specifies N.

That is replaced be pingrp.

> abilis,ioconf specifies M.

That'd be better named "function" or something like that, in order to
indicate that it specifies which function is mux'd onto the specified
pin(s)/pingroup(s).
