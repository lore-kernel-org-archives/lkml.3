Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbaLUSsL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 13:48:11 -0500
Received: from hygieia.santi-shop.eu ([78.46.175.2]:44287 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbaLUSsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 13:48:07 -0500
Date: Sun, 21 Dec 2014 19:47:53 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: dwalker@fifo99.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: add per console loglevel
Message-ID: <20141221194753.49c12693@neptune.home>
In-Reply-To: <20141220224908.GB4466@fifo99.com>
References: <20141220224908.GB4466@fifo99.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/8qDh9wOxY93xfMIFwDRjC5E"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8qDh9wOxY93xfMIFwDRjC5E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 20 December 2014 dwalker@fifo99.com wrote:
> This adds to to the console=3D command line options allowing the
> addition of a per console log level setting.
>=20
> examples,
>=20
> 	console=3DttyS0,ll4
> 	console=3Dtty0,ll6
>=20
> This can be used on systems which have multiple serial consoles, but
> it's desired for logging to be light on one and heavy on another.

Looks useful to me.
What would be the best way to make these per-console loglevels
configurable at runtime? `dmesg -n $LEVEL` only affects the global
limit.

One drawback to letting global loglevel have precedence is that
all consoles that should not get detailed log messages need to have
their loglevel explicitly lowered and it's not possible to have
one console forced to show more than the global loglevel.


An approach I would prefer is to have all consoles follow global
loglevel except when something different had been explicitly requested
for them.
This way a single console can be added later on (e.g. netconsole)
and set to pass through debug messages without affecting anyone else.

Bruno

> Signed-off-by: Daniel Walker <dwalker@fifo99.com>
> ---
>  Documentation/kernel-parameters.txt | 24 ++++++++++++++++++------
>  include/linux/console.h             |  1 +
>  kernel/printk/console_cmdline.h     |  9 +++++----
>  kernel/printk/printk.c              | 37 +++++++++++++++++++++++++++++++=
+++++-
>  4 files changed, 60 insertions(+), 11 deletions(-)
>=20
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-p=
arameters.txt
> index 4df73da..7e65d5b 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -696,30 +696,42 @@ bytes respectively. Such letter suffixes can also b=
e entirely omitted.
> =20
>  	console=3D	[KNL] Output console device and options.
> =20
> -		tty<n>	Use the virtual console device <n>.
> +		tty<n>[,llX]	Use the virtual console device <n>.
> =20
> -		ttyS<n>[,options]
> -		ttyUSB0[,options]
> +		ttyS<n>[,options][,llX]
> +		ttyUSB0[,options][,llX]
>  			Use the specified serial port.  The options are of
>  			the form "bbbbpnf", where "bbbb" is the baud rate,
>  			"p" is parity ("n", "o", or "e"), "n" is number of
>  			bits, and "f" is flow control ("r" for RTS or
>  			omit it).  Default is "9600n8".
> =20
> +			"llX" explained below,
> +
>  			See Documentation/serial-console.txt for more
>  			information.  See
>  			Documentation/networking/netconsole.txt for an
>  			alternative.
> =20
> -		uart[8250],io,<addr>[,options]
> -		uart[8250],mmio,<addr>[,options]
> +		uart[8250],io,<addr>[,options][,llX]
> +		uart[8250],mmio,<addr>[,options][,llX]
>  			Start an early, polled-mode console on the 8250/16550
>  			UART at the specified I/O port or MMIO address,
>  			switching to the matching ttyS device later.  The
>  			options are the same as for ttyS, above.
> -		hvc<n>	Use the hypervisor console device <n>. This is for
> +
> +			"llX" explained below,
> +
> +		hvc<n>[,llX]
> +			Use the hypervisor console device <n>. This is for
>  			both Xen and PowerPC hypervisors.
> =20
> +			"llX" is used to define the loglevel per console. The "X"
> +			defines the loglevel number for this console. The usage
> +			is similar to the "loglevel=3D" option, and the effect is
> +			the same only per console. The "loglevel=3D" option takes
> +			precedence of this option.
> +
>                  If the device connected to the port is not a TTY but a b=
raille
>                  device, prepend "brl," before the device type, for insta=
nce
>  			console=3Dbrl,ttyS0
> diff --git a/include/linux/console.h b/include/linux/console.h
> index 7571a16..99020d5 100644
> --- a/include/linux/console.h
> +++ b/include/linux/console.h
> @@ -118,6 +118,7 @@ static inline int con_debug_leave(void)
> =20
>  struct console {
>  	char	name[16];
> +	int	loglevel;
>  	void	(*write)(struct console *, const char *, unsigned);
>  	int	(*read)(struct console *, char *, unsigned);
>  	struct tty_driver *(*device)(struct console *, int *);
> diff --git a/kernel/printk/console_cmdline.h b/kernel/printk/console_cmdl=
ine.h
> index cbd69d8..6f6f98f 100644
> --- a/kernel/printk/console_cmdline.h
> +++ b/kernel/printk/console_cmdline.h
> @@ -3,11 +3,12 @@
> =20
>  struct console_cmdline
>  {
> -	char	name[8];			/* Name of the driver	    */
> -	int	index;				/* Minor dev. to use	    */
> -	char	*options;			/* Options for the driver   */
> +	char	name[8];		/* Name of the driver		*/
> +	int	index;			/* Minor dev. to use		*/
> +	int	loglevel;		/* Log level for this console	*/
> +	char	*options;		/* Options for the driver	*/
>  #ifdef CONFIG_A11Y_BRAILLE_CONSOLE
> -	char	*brl_options;			/* Options for braille driver */
> +	char	*brl_options;		/* Options for braille driver	*/
>  #endif
>  };
> =20
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 02d6b6d..218d94d 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -1414,6 +1414,9 @@ static void call_console_drivers(int level, const c=
har *text, size_t len)
>  		if (!cpu_online(smp_processor_id()) &&
>  		    !(con->flags & CON_ANYTIME))
>  			continue;
> +		if (con->loglevel && !ignore_loglevel &&
> +		    level >=3D con->loglevel)
> +			continue;
>  		con->write(con, text, len);
>  	}
>  }
> @@ -1925,6 +1928,33 @@ asmlinkage __visible void early_printk(const char =
*fmt, ...)
>  }
>  #endif
> =20
> +
> +char *setup_per_console_loglevel(struct console_cmdline *con, char *opti=
ons)
> +{
> +	int size =3D options ? strlen(options) : 0;
> +
> +	if (size >=3D 3 &&
> +	    options[size - 3] =3D=3D 'l' &&
> +	    options[size - 2] =3D=3D 'l' &&
> +	    options[size - 1] >=3D  '1' && options[size - 1] <=3D '9') {
> +		con->loglevel =3D options[size - 1] - '0';
> +
> +		/* Catch if the user added a comma after some serial console
> +		 * options,
> +		 * i.e. console=3DttyS0,9600n8,ll3
> +		 * the first comma is gone at this point, but we need to delete
> +		 * the second one.
> +		 */
> +		if (size > 3 && options[size - 4] =3D=3D ',')
> +			options[size - 4] =3D 0;
> +		else
> +			options[size - 3] =3D 0;
> +	} else
> +		con->loglevel =3D 0;
> +
> +	return options;
> +}
> +
>  static int __add_preferred_console(char *name, int idx, char *options,
>  				   char *brl_options)
>  {
> @@ -1949,12 +1979,15 @@ static int __add_preferred_console(char *name, in=
t idx, char *options,
>  	if (!brl_options)
>  		selected_console =3D i;
>  	strlcpy(c->name, name, sizeof(c->name));
> -	c->options =3D options;
> +
> +	c->options =3D setup_per_console_loglevel(c, options);
> +
>  	braille_set_options(c, brl_options);
> =20
>  	c->index =3D idx;
>  	return 0;
>  }
> +
>  /*
>   * Set up a console.  Called via do_early_param() in init/main.c
>   * for each "console=3D" parameter in the boot command line.
> @@ -2478,6 +2511,8 @@ void register_console(struct console *newcon)
>  		if (newcon->setup &&
>  		    newcon->setup(newcon, console_cmdline[i].options) !=3D 0)
>  			break;
> +
> +		newcon->loglevel =3D c->loglevel;
>  		newcon->flags |=3D CON_ENABLED;
>  		newcon->index =3D c->index;
>  		if (i =3D=3D selected_console) {

--Sig_/8qDh9wOxY93xfMIFwDRjC5E
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQGcBAEBAgAGBQJUlxXfAAoJECnQXSfLoWYAffAL/Am/BfjOH3zn9MmKVsGjrMjj
bl/udheO3tVBFF0yLlMMJU3x8xI+VsAmoe+5eEkkT+DPIObdFPKYSBsK3v77XhhK
v81P6tY3zlTXzPapJzeLRqU2XHCgptv7aqasN2U+cvQD4LTV83mpVATYhj019AVx
yOuu3gquFs7bgeuYorQqLHmsJRvgSwS1LFBgOBe18aeMKQdwQ4LDR9rga7/qA3QH
RjxBmouEzPmwvyqbphZWKoerHPG8EqXY0A5abBA3Yk13OalXIC+HBlWYKA74ypm4
zbGMXJdvk3qqiHPH8Iuwn7hDAGqEXRTHpccoWPDLLsPA4FDiGQwSsgc54ymiz65w
wo01yYQZK3FIZVPB/WLLvs5RGM4uGchTY5BVweO5Y+5RPi7fvk783GkC4ujc0yyz
cYH2nTCeUdPb3NUWLy+jqFcUagljbnYw7YExDTocVRHH/9i/h2AoOcgmu3dQkAXE
AiaUyEn8G6MNa9iVot5vNiZFK2NDVNqR/61f2Km8YQ==
=g8s8
-----END PGP SIGNATURE-----

--Sig_/8qDh9wOxY93xfMIFwDRjC5E--
