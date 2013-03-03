Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3CCNuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 08:50:12 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:36682 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab3CCNuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 08:50:11 -0500
Date: Sun, 3 Mar 2013 14:49:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Peter Tyser <ptyser@xes-inc.com>, Andreas Schultz <aschultz@tpip.net>
Subject: Re: [PATCH] gpio: gpio-ich: fix ichx_gpio_check_available() return
 what callers expect
Message-ID: <20130303144958.1d35592b@endymion.delvare>
In-Reply-To: <20130302091836.1DBD83E15E3@localhost>
References: <1361978715-14948-1-git-send-email-mika.westerberg@linux.intel.com>
	<20130302091836.1DBD83E15E3@localhost>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Sat, 02 Mar 2013 09:18:36 +0000, Grant Likely wrote:
> On Wed, 27 Feb 2013 17:25:15 +0200, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> > ichx_gpio_check_available() returns either 0 or -ENXIO depending on whether
> > the given GPIO is available or not. However, callers of this function treat
> > the return value as boolean:
> > 
> > 	...
> > 	if (!ichx_gpio_check_available(gpio, nr))
> > 		return -ENXIO;
> > 
> > which erroneusly fails when the GPIO is available and not vice versa.
> > 
> > Fix this by making the function return boolean as expected by the callers.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Applied, thanks.

I am very sorry for introducing this bug. Thanks Andreas and Mika for
catching it and fixing it. Too bad stable kernel 3.7 already reached
end of life :(

My original code has been working for me for months. The reason is
that, of the 4 affected functions, only ichx_gpio_direction_output() is
ever called, and its return value is never checked by the driver
(i2c-mux-gpio.) I'll update the driver to properly check the return
value so that any issue is caught earlier in the future.

Looking at the gpio-ich code, there are two things I do not understand.

The first one is in my own code. I see that there is no usability check
on ichx_gpio_request(), while there is one on ichx_gpio_get(). This
makes little sense to me and I am really curious why I made things that
way. ichx_gpio_get() could be called repeatedly so from a performance
perspective checking for usability again and again is no good. Checking
at GPIO request time would seem preferable, allowing to catch problems
earlier. I'll change that unless anyone can figure out why I made it
the way it is.

The second one is in Peter's code:

static int ichx_gpio_request(struct gpio_chip *chip, unsigned nr)
{
	/*
	 * Note we assume the BIOS properly set a bridge's USE value.  Some
	 * chips (eg Intel 3100) have bogus USE values though, so first see if
	 * the chipset's USE value can be trusted for this specific bit.
	 * If it can't be trusted, assume that the pin can be used as a GPIO.
	 */
	if (ichx_priv.desc->use_sel_ignore[nr / 32] & (1 << (nr & 0x1f)))
		return 1;

	return ichx_read_bit(GPIO_USE_SEL, nr) ? 0 : -ENODEV;
}

Documentation/gpio.txt says: "the return value is zero for success,
else a negative errno." So I have no idea what the "1" returned here is
supposed to mean. Depending on whether the caller checks for "ret" or
"ret < 0" it will see this as success or as error. This doesn't seem
right. If I understand the comment properly, we should return 0
(success) instead. Peter?

-- 
Jean Delvare
