Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaACBFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 20:05:20 -0500
Received: from ring0.de ([91.143.88.219]:35804 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbaACBFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 20:05:17 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Fri, 3 Jan 2014 02:05:21 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>
Subject: Re: [PATCH v4] Bluetooth: Add hci_h4p driver
Message-ID: <20140103010519.GA27678@earth.universe>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Marcel Holtmann <marcel@holtmann.org>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	=?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= <freemangordon@abv.bg>,
	"Gustavo F. Padovan" <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"linux-bluetooth@vger.kernel.org development" <linux-bluetooth@vger.kernel.org>,
	Ville Tervo <ville.tervo@nokia.com>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <20140102161824.GA8204@amd.pavel.ucw.cz>
 <A5B72277-42D4-4A24-8A29-9BE18762E8C4@holtmann.org>
 <20140103001753.GA21023@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <20140103001753.GA21023@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Fri, Jan 03, 2014 at 01:17:54AM +0100, Pavel Machek wrote:
> Changes from v3: Moved platform data into
> include/linux/platform_data/, something I missed before.

As I wrote before Tony plans to remove the boardcode for all
OMAP boards including the Nokia N900 for 3.14, so you cannot
boot without DT from 3.14 onwards.

The drivers can still be initialized the old way using pdata quirks
until all drivers are converted, but I think this driver can simply
be prepared for DT directly:

> [...]
>
> +struct hci_h4p_platform_data {
> +	int chip_type;

This can be "extracted" from the compatible string.

> +	int bt_sysclk;

This can be converted into a vendor property.

> +	unsigned int bt_wakeup_gpio;
> +	unsigned int host_wakeup_gpio;
> +	unsigned int reset_gpio;

These can easily be acquired via DT.

> +	int reset_gpio_shared;

This looks like a simple property in the DT structure.

You should use a boolean type for this btw.

> +	unsigned int uart_irq;

This one can also simply be aquired via DT.

> +	phys_addr_t uart_base;

I see multiple ways for this one:

 1. Just put the memory address into the dts file.
 2. Make this a phandle to the UART node and get
    the memory address from the referenced node.
 3. Make the bluetooth node a subnode of the UART
    node and get the address from the parent node.

IMHO solution 3 is the best solution, since the bluetooth
chip is basically connected to the system via the UART.

> +	const char *uart_iclk;
> +	const char *uart_fclk;

There is currently work going on to move OMAP's clock
data into DT. When that work is done the clocks can
be acquired via phandles. I think it's expected to
be merged into 3.14.

> +	void (*set_pm_limits)(struct device *dev, bool set);

If I'm not mistaken set_pm_limits is only referenced by
hci_h4p_set_pm_limits(). The hci_h4p_set_pm_limits()
function is not referenced anywhere, thus both can be
removed.

> +};

-- Sebastian

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSxgzPAAoJENju1/PIO/qaw88P/jzPKXubPsIY2Ze8LVk4MTk2
YssFeJluE+5/XHwXNwZxPATJFaSckgwUrT8UOtO9NDVyBLgZw/2uHBG4vBHFwIdM
nNT8Y9hupK70zWLIUhx1/iqNjOOYdk3vsvIiBE+i1Srzvn44RLptVVWe+C8mMV6s
i6CuI2mZatvw/P5DUjyv0ALca5CMfwvyhaWI1agyBVTYolX3gwx9gcIjaHkZlVd8
pM1lc9l2vvMA7pTi2ZdiwWubl4lhr3gf220au1EO+/BG90j0FlYv/cby9cTe5gts
wLOjJkXzfIjQUTRunmBvIEtzCOSefF5E51Vzad9jy/s0eybKMVsUoQ7lAGZ34pYx
C1pkt5eZ333ubAsJnggQUki1jLZukjBNSeESfz/BwtZGfQ63k4BhB5jfF6AdbETi
+NqG0O3Jr1VuR//fxgPmeSvFUacZOEDSmwCIipxe+r50UbRmBazDzIBuw035BH/p
muvrlpPTQWo7Radfspyr1lqkDghH5XpHod2Ppvy+axtrxBXho5kizcFf1JBGj3M3
L0pXrIGLHPQhboe9A/NRGhqzs72tlY4cx1tUfFyCaL3X0xh87/FJUECAyjG8G5Gj
3umuCHVF9DNZX9fezab8SKWGyW4xLNSBFT7gE/TgMVmcdFKqzSW6nfuEosSVBKUS
3SSuYAIMYg5hSu0gG0IP
=0PwV
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
