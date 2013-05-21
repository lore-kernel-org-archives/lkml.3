Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3EUDZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:25:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55289 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab3EUDZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:25:45 -0400
Date: Tue, 21 May 2013 13:25:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wang YanQing <udknight@gmail.com>
Subject: linux-next: build failure after merge of the tty tree
Message-Id: <20130521132532.197ed9fa356199cbbda7389a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__21_May_2013_13_25_32_+1000_0P7AsvYlRzRXrKpP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_May_2013_13_25_32_+1000_0P7AsvYlRzRXrKpP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/usb/misc/sisusbvga/sisusb_con.c: In function 'sisusb_console_init':
drivers/usb/misc/sisusbvga/sisusb_con.c:1493:2: error: implicit declaration=
 of function 'take_over_console' [-Werror=3Dimplicit-function-declaration]
  ret =3D take_over_console(&sisusb_con, first - 1, last - 1, 0);
  ^
cc1: some warnings being treated as errors

Caused by commit dc9641895abb ("vt: delete unneeded functions
register_con_driver|take_over_console").  Grep is your friend!  There is
more to clean up here:

Documentation/console/console.txt:call take_over_console() will succeed in =
the takeover regardless of the type
Documentation/console/console.txt:	 take_over_console() - load and bind dri=
ver to console layer
Documentation/console/console.txt:take_over_console() is now broken up into:
Documentation/console/console.txt:   or take_over_console(). register_con_d=
river() will just add the driver to
Documentation/console/console.txt:   console. take_over_console(), as it na=
me implies, will also take over (or
arch/alpha/kernel/console.c:	take_over_console(&vga_con, 0, MAX_NR_CONSOLES=
-1, 1);
arch/alpha/kernel/process.c:		take_over_console(&dummy_con, 0, MAX_NR_CONSO=
LES-1, 1);
arch/mips/pci/pci-bcm1480.c:	take_over_console(&vga_con, 0, MAX_NR_CONSOLES=
-1, 1);
arch/mips/pci/pci-sb1250.c:	take_over_console(&vga_con, 0, MAX_NR_CONSOLES =
- 1, 1);
arch/parisc/kernel/setup.c:	conswitchp =3D &dummy_con;	/* we use take_over_=
console() later ! */
drivers/tty/vt/vt.c: *	take_over_console is basically a register followed b=
y unbind
drivers/usb/misc/sisusbvga/sisusb_con.c:	/* This is called by take_over_con=
sole(),
drivers/usb/misc/sisusbvga/sisusb_con.c:	/* This is called by take_over_con=
sole()
drivers/usb/misc/sisusbvga/sisusb_con.c:	ret =3D take_over_console(&sisusb_=
con, first - 1, last - 1, 0);
drivers/usb/misc/sisusbvga/sisusb_con.c:				take_over_console(&sisusb_dummy=
_con, i, i, 0);
drivers/usb/misc/sisusbvga/sisusb_con.c:				 * consoles is executed by take=
_over_console().
drivers/video/console/fbcon.c:/* NOTE: fbcon cannot be __init: it may be ca=
lled from take_over_console later */
drivers/video/console/mdacon.c:	return take_over_console(&mda_con, mda_firs=
t_vc-1, mda_last_vc-1, 0);
drivers/video/console/newport_con.c:/* Can't be __init, take_over_console m=
ay call it later */
drivers/video/console/newport_con.c:	return take_over_console(&newport_con,=
 0, MAX_NR_CONSOLES - 1, 1);
drivers/video/console/sticon.c:	return take_over_console(&sti_con, 0, MAX_N=
R_CONSOLES - 1, 1);

Documentation/console/console.txt:	 register_con_driver()
Documentation/console/console.txt:     register_con_driver()
Documentation/console/console.txt:1. All drivers, except system drivers, mu=
st call either register_con_driver()
Documentation/console/console.txt:   or take_over_console(). register_con_d=
river() will just add the driver to

I have used the version of the tty tree from next-20130520 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__21_May_2013_13_25_32_+1000_0P7AsvYlRzRXrKpP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRmuksAAoJEECxmPOUX5FELIsP/Rtt80insLGYdodX+o6gu2FR
50PjdtgBKKeg14AgfG6BkRL7VBmDAlCavFzKAOVlBmZTAxoNEcTpsjknF3ytrN+p
krRxevoARtED4BtiM1ArGNK1VuGXnd7LxX/j3dtWwsibj/X7kNHmSLQnjTNVfgZz
Xvn1RxeuAcMy91/i+RKNqQYAkiFsQdToiegxjahADyOqWu60bovSAvavwn80P0vG
RnYhWdYIihow8xXHuLm9xEd3jKkXbkSLGghVabjdQYot97r3pR/jip2lfh7rc8ou
5acK6Ixo34TTsdHhs3rhM1HJG2IWqYW7gxfenZ/4yTPJL+8+UPaQUSK6M18VQBKQ
Y/6YJ2zDN1kjE6px75D0jKVa/17+uhuBg0+VaXA5OAR6tKY98UzRMo1iKJ30fZFw
zWR6Lnxa2Dxli78VSKuenV1dh+Zmc4SpzLK0lGUEw0UV+ZT7bpBWEYGBONi/4z7c
NvVesUyWNqwzyXn+vwNaFjYAhlCZ+6T0GDIJ52ThVrVH405t2+kUieFHlF29cnTV
ZiSPZCcaOutNq0zL67diVE+En/PEAaCXZaG8eXQWPVl2IboREDWCUh1flPjZSBAi
xdYsbfQHvpOThLo2sivGXjMM9XeuBW0frk/yM4rhOLWWtfRj18krjLQbI7Hh2Ffd
eNs7Hkog7+lG/afuXxbL
=FTD9
-----END PGP SIGNATURE-----

--Signature=_Tue__21_May_2013_13_25_32_+1000_0P7AsvYlRzRXrKpP--
