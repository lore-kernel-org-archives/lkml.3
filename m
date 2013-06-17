Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783Ab3FQLlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:41:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:34809 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547Ab3FQLlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:41:53 -0400
Message-ID: <51BEF5F4.4090600@linutronix.de>
Date: Mon, 17 Jun 2013 13:41:40 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 01/22] mfd/ti_am335x_tscadc: remove regmap
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de> <1370950268-7224-2-git-send-email-bigeasy@linutronix.de> <20130611142336.GE29135@zurbaran> <51B7358D.7000605@linutronix.de> <20130614135358.GR1403@sirena.org.uk>
In-Reply-To: <20130614135358.GR1403@sirena.org.uk>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 03:53 PM, Mark Brown wrote:
> On Tue, Jun 11, 2013 at 04:34:53PM +0200, Sebastian Andrzej Siewior
> wrote:
> 
> It does give you tracepoints and debugfs.  If it's making things at
> all complicated we need to look at why that is and figure out how
> to fix that since it's probably an issue for other users.

debugfs are tracepoints is our offer? Let me check the price one more
time.

A simply mmio read does right now:
- lock + unlock.
  each time you chase another pointer plus enable/disable interrupts
  plus you have to save flags in another structure.

- _regmap_read()
  We check a few variables and then we go after reg_read and we end up
  in _regmap_raw_read().
  Here we call _regmap_range_lookup() which should return NULL. Next
  thing we invoke map->format.format_reg(). Finally we can call
  map->bus->read() which brings us to regmap_mmio_read().
  At the end we invoke map->format.parse_val().

write looks most likely the same.

A simple register read invokes 5 functions pointers. I am not counting
the function arguments in between and I am also not counting the number
of arguments which are involved and take pointer as well. This is a lot
of stuff that is done for a simple read of an mmio.

I understand that most of this may not be expensive in total if it
comes to SPI or I2C and all the goodies like reg caching and one
interface which deals with SPI and I2C. I also understand that some
chips have a non standard interface and are either BE or LE. We have
similar things on USB where people wired the BUS wrongly either at the
BUS level or at the SoC level so some PowerPC have an in-core ehci
controller but its registers are BE and not LE like it should be. The
solution here was variable check a simple swap() in that case.
I like abstractions but this gone a little too far I think.

This is a lot of for a simple mmio access. In terms of performance: If
I add a trace point to my read and write I have still less code which
is called and it can be disabled. This regmap overhead is always there
chasing pointers.

As I said before: I doubt that you get this regmap access in an one GiB
network driver and in turn remove their trace points to register access.

Please don't get me wrong: It is still nice for slow buses and this ADC
driver isn't anything close to high performance like a 1GiB network
driver but it adds a lot of unwanted overhead which I prefer not to
have.

Sebastian
