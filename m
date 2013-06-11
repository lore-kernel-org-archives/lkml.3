Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab3FKKOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 06:14:39 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:61112 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3FKKOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 06:14:37 -0400
Date: Tue, 11 Jun 2013 12:14:33 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-pwm@vger.kernel.org,
        linux-doc@vger.kernel.org, poeschel@lemonage.de,
        Ryan Mallon <rmallon@gmail.com>, rob@landley.net
Subject: Re: [PATCH v4] pwm: add sysfs interface
Message-ID: <20130611101432.GA932@manwe>
References: <201306101612.07708.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <201306101612.07708.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 10, 2013 at 04:12:07PM -0700, H Hartley Sweeten wrote:
[...]
> +What:		/sys/class/pwm/pwmchipN/pwmX/duty
> +Date:		May 2013
> +KernelVersion:	3.11
> +Contact:	H Hartley Sweeten <hsweeten@visionengravers.com>
> +Description:
> +		Sets the PWM duty cycle in nanoseconds.

Sorry, I should've been more specific before. I'd like this to be named
duty_cycle. We now have the pwm_{set,get}_duty_cycle() accessors and I'd
like to eventually use the spelled-out form consistently.

> +config PWM_SYSFS
> +	bool "/sys/class/pwm/... (sysfs interface)"
> +	depends on SYSFS
> +	help
> +	  Say Y here to provide a sysfs interface to control PWMs.
> +
> +	  For every instance of a PWM device there is a pwmchipN directory
> +	  created in /sys/class/pwm. Use the export attribute to request
> +	  a PWM to be accessible from userspace and the unexport attribute
> +	  to return the PWM to the kernel. Each exported PWM will have a
> +	  pwmX directory in the pwmchipN it is associated with.

I have a small quibble with this. Introducing options like this make it
increasingly difficult to compile-test all the various combinations, so
I'd like to see this converted to a form that will play well with the
IS_ENABLED() macro. We already have the same issue with DEBUG_FS, only
to a lesser degree because it doesn't have an additional PWM-specific
Kconfig option.

In order not to burden you with too much work, one option for now would
be to unconditionally build the sysfs.c file and use something along
these lines in pwmchip_sysfs_{,un}export():

	if (!IS_ENABLED(CONFIG_PWM_SYSFS))
		return;

Which should allow the compiler to throw away all PWM_SYSFS-related
code in that file, leaving an empty function. It's not the optimal
solution, which would require the sysfs code to go into core.c and be
conditionalized there, but it's good enough. I can always go and clean
up that code later (maybe doing the same for DEBUG_FS while at it).

The big advantage of this is that we get full compile coverage of the
sysfs interface, whether it's enabled or not. Calling an empty function
once when the chip is registered is an acceptable overhead.

> diff --git a/drivers/pwm/sysfs.c b/drivers/pwm/sysfs.c
[...]
> +static ssize_t pwm_polarity_store(struct device *child,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t size)
> +{
> +	struct pwm_device *pwm = child_to_pwm_device(child);
> +	enum pwm_polarity polarity;
> +	int ret;
> +
> +	if (strncmp(buf, "normal", strlen("normal")) == 0) {
> +		polarity = PWM_POLARITY_NORMAL;
> +	} else if (strncmp(buf, "inversed", strlen("inversed")) == 0) {
> +		polarity = PWM_POLARITY_INVERSED;

I think you can use sysfs_streq() here. And no need for {} on single-
line blocks.

> +static int pwm_unexport_child(struct device *parent, struct pwm_device *pwm)
> +{
> +	struct device *child;
> +
> +	if (!test_and_clear_bit(PWMF_EXPORTED, &pwm->flags))
> +		return -ENODEV;
> +
> +	child = device_find_child(parent, pwm, pwm_unexport_match);
> +	if (!child)
> +		return -ENODEV;
> +
> +	put_device(child);		/* for device_find_child() */

Nit: can you put the comment on a line of its own above the code,
please?

> +void pwmchip_sysfs_unexport(struct pwm_chip *chip)
> +{
> +	struct device *parent;
> +
> +	parent = class_find_device(&pwm_class, NULL, chip,
> +				   pwmchip_sysfs_match);
> +	if (parent) {
> +		put_device(parent);		/* for class_find_device() */

Same here.

Thierry

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRtviIAAoJEN0jrNd/PrOhW7EP/iqh2xHu51xxEyhKqxXFiOZK
GZjYkxVx5BB2eKpXGzF+tkmFx8tp2IA1V7TkuVB2Gupy+3PqpCAPkBi7j/OCO1Fo
x7IJRyDyLW32DCAqNJ/evTLb2x1LsxapMGTe0YVa7kZMrtciI+/NlbQl/gwWC0Ig
A0wUSpBX7L+JfsFUVWe1ZR8pRpkksTHLrkEBxH/0hLuDFFFj5Q70jNFudeS257v7
uQF33bG/S4RE1awMJkrBKQaRK+jkNtZslM8jFE3C9RPIyU2LzCRmmZVRVXFWpoHk
W8yMnvwR5pRkcp29F4TcMs3libtYTISvbElV/Y+fS4jCy0rQho5dniLQqnote32O
5MbcDTdZYBTkvZErG5hAg6cR+8A0jRx6jky6wYgpUroKbq6pKPA8Rymo5SIa2MMW
zKgWp75IT0uHjSoJ4k3bXXGUm4r03eEr5YCuoMAT/HBh9EjrZZ/J+DjmY/GNMTW/
pKWNJ6OgP2Nb2vb8hfEvAskm9Rcj0KK07cBjRGigVCrNm9TefP+tErUjbJRQZ4Mr
2pkaA7UDmMvqfb1RiADFpwZsMFlQnD4RS9x6EUg7BZ3uDVSiD/T+ST7Os9T3tuSE
qFFpuToFHiT0Jmf9DW8oqPBOHhljwyNedsiTTaPu6zY3S5cI24xaFAaW5ncu38bh
UfeGHd4d/M6gBAl5yezA
=hvn6
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
