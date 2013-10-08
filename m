Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3JHMHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:07:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47066 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3JHMHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:07:22 -0400
Date: Tue, 8 Oct 2013 14:05:17 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-pwm@vger.kernel.org, voice.shen@atmel.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] PWM: atmel-pwm: use request/free instead of
 enable/disable
Message-ID: <20131008120516.GA16196@ulmo.nvidia.com>
References: <1380554553-25676-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <1380554553-25676-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 30, 2013 at 05:22:33PM +0200, Alexandre Belloni wrote:
> I found that disabling a pwm while it is at a low level will actually put it
> back at a high level. The main symptom is that leds-pwm is calling pwm_disable()
> after setting the duty cycle to 0. Hence, instead of getting a switched off LED,
> you get an LED lit up at full brightness.

I wonder why that's the case. What's causing the PWM to go back to full
duty cycle when disabled? There was a similar issue with some other PWM
driver a while back and the cause was tracked down to be that you had to
wait for a full period to make sure the signal was constantly low before
switching off the clock. Perhaps something similar is the issue here?

> Solve that by using the request and free callbacks to enable and disable the
> pwm channels and the clock.

"pwm" -> "PWM",  please.

> diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
[...]
> +static int atmel_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	/*
> +	 * This is a dummy function, required to be able to register the pwm
> +	 * chip, see pwmadd_chip() in pwm/core.c
> +	 */
> +	return 0;
> +}
> +
> +static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	/*
> +	 * This is a dummy function, required to be able to register the pwm
> +	 * chip, see pwmadd_chip() in pwm/core.c
> +	 */
> +}

This just doesn't feel right. Can somebody please investigate what the
real reason is for the behaviour described in the commit message and see
if we can't solve this in some other way? .request() and .free() are
typically called very early or very late, respectively, so this patch
will keep the PWM clock on forever (pretty much).

Thierry

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSU/T8AAoJEN0jrNd/PrOhRz0QAJOSQvXzANS1IQRpLNd/DJbD
sRwYvMA1EDGlVQN390LCm86YlI9uecpdZQuwPP3UTqAE/R11PgxdZLp6U9VrtG01
Q12Q1LXCIhYRDi7Dk7R6OY9XPQIFixv50WX9zCWxLZNtrNctsVpizPYJmEvbXuD5
dKyPYFFu39feD9aedJ8rEG7mZyIH607+fX4xaYuFx4lZj6znheva+ydL1N7aAHex
mEF0G8V1JRcu+Xha1aVYLGG1R0laQ/uHGCp0Hjeat/P4BKm7Qei3zCYFaGN3rQEA
hmnJZlPq+5Wvvc28beL9GER9PQa+8O52hlm1CyWEUXoQxi9b1ssCGqUsxzeKCkml
gruDGJxUuSHf53y9WF/KTEb5WzGjiVo2F8TWMEWDgs0HO0SKUbCapHkJzzVtltBf
5njoMyH4T0k5aUHzC5CkOOQ4BquwME0ssEII9JAshM3gyF4fpLwGlf+0iu5Yf/rv
rCeG+ataY+MSC7XDra+oDXrMT4ELGOKdUF4EsiegMqgvhrDXXqSbA5H9G/w8RBm2
4OuMkn+xSorosJu5A6N53Qu5tFP5v4dWyhziamhz58//6Zl1HPXxwaZUCUKDDkzb
nDaG1534QLvAkK67lLdE09Qj7Bq9LiH3I8ma4lqWMx+jeVEZMZnPCf8RtEKXXlsW
2i1NzTqSF72xmqkZs2J6
=SpYy
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
