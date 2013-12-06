Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230Ab3LFX3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:29:21 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:62397 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759320Ab3LFX3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:29:16 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Tim Kryger <tim.kryger@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] serial: 8250_dw: Improve unwritable LCR workaround
Date: Fri, 06 Dec 2013 23:29:02 +0000
Message-ID: <4548523.McqEijQYrs@radagast>
Organization: Imagination Technologies
User-Agent: KMail/4.10.5 (Linux/3.12.3+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131126183559.GA18570@localhost>
References: <1380647888-32473-1-git-send-email-tim.kryger@linaro.org> <20131126183559.GA18570@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5548530.8nabKUZjb3"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart5548530.8nabKUZjb3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Tuesday 26 November 2013 15:36:00 Ezequiel Garcia wrote:
> Hello,
>=20
> On Tue, Oct 01, 2013 at 10:18:08AM -0700, Tim Kryger wrote:
> > When configured with UART_16550_COMPATIBLE=3DNO or in versions prio=
r to
> > the introduction of this option, the Designware UART will ignore wr=
ites
> > to the LCR if the UART is busy.  The current workaround saves a cop=
y of
> > the last written LCR and re-writes it in the ISR for a special inte=
rrupt
> > that is raised when a write was ignored.
> >=20
> > Unfortunately, interrupts are typically disabled prior to performin=
g a
> > sequence of register writes that include the LCR so the point at wh=
ich
> > the retry occurs is too late.  An example is serial8250_do_set_term=
ios()
> > where an ignored LCR write results in the baud divisor not being se=
t and
> > instead a garbage character is sent out the transmitter.
> >=20
> > Furthermore, since serial_port_out() offers no way to indicate fail=
ure,
> > a serious effort must be made to ensure that the LCR is actually up=
dated
> > before returning back to the caller.  This is difficult, however, a=
s a
> > UART that was busy during the first attempt is likely to still be b=
usy
> > when a subsequent attempt is made unless some extra action is taken=
.
> >=20
> > This updated workaround reads back the LCR after each write to conf=
irm
> > that the new value was accepted by the hardware.  Should the hardwa=
re
> > ignore a write, the TX/RX FIFOs are cleared and the receive buffer =
read
> > before attempting to rewrite the LCR out of the hope that doing so =
will
> > force the UART into an idle state.  While this may seem unnecessari=
ly
> > aggressive, writes to the LCR are used to change the baud rate, par=
ity,
> > stop bit, or data length so the data that may be lost is likely not=

> > important.  Admittedly, this is far from ideal but it seems to be t=
he
> > best that can be done given the hardware limitations.
> >=20
> > Lastly, the revised workaround doesn't touch the LCR in the ISR, so=
 it
> > avoids the possibility of a "serial8250: too much work for irq" loc=
k up.
> > This problem is rare in real situations but can be reproduced easil=
y by
> > wiring up two UARTs and running the following commands.
> >=20
> >   # stty -F /dev/ttyS1 echo
> >   # stty -F /dev/ttyS2 echo
> >   # cat /dev/ttyS1 &
> >   [1] 375
> >   # echo asdf > /dev/ttyS1
> >   asdf
> >  =20
> >   [   27.700000] serial8250: too much work for irq96
> >   [   27.700000] serial8250: too much work for irq96
> >   [   27.710000] serial8250: too much work for irq96
> >   [   27.710000] serial8250: too much work for irq96
> >   [   27.720000] serial8250: too much work for irq96
> >   [   27.720000] serial8250: too much work for irq96
> >   [   27.730000] serial8250: too much work for irq96
> >   [   27.730000] serial8250: too much work for irq96
> >   [   27.740000] serial8250: too much work for irq96
> >=20
> > Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> > Reviewed-by: Matt Porter <matt.porter@linaro.org>
> > Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> > ---
> >=20
> > Changes in v2:
> >   - Rebased on tty-next
> >   - Updated commit messsage to mention UART_16550_COMPATIBLE
> >   - Removed potentially unnecessary read of LSR and MSR
> >   - Only attempt workaround when LCR write is ignored
> > =20
> >  drivers/tty/serial/8250/8250_dw.c | 41
> >  ++++++++++++++++++++++++++++++--------- 1 file changed, 32
> >  insertions(+), 9 deletions(-)
> >=20
> > diff --git a/drivers/tty/serial/8250/8250_dw.c
> > b/drivers/tty/serial/8250/8250_dw.c index d04a037..4658e3e 100644
> > --- a/drivers/tty/serial/8250/8250_dw.c
> > +++ b/drivers/tty/serial/8250/8250_dw.c
> > @@ -57,7 +57,6 @@
> >=20
> >  struct dw8250_data {
> > =20
> >  =09u8=09=09=09usr_reg;
> >=20
> > -=09int=09=09=09last_lcr;
> >=20
> >  =09int=09=09=09last_mcr;
> >  =09int=09=09=09line;
> >  =09struct clk=09=09*clk;
> >=20
> > @@ -77,17 +76,33 @@ static inline int dw8250_modify_msr(struct uart=
_port
> > *p, int offset, int value)>=20
> >  =09return value;
> > =20
> >  }
> >=20
> > +static void dw8250_force_idle(struct uart_port *p)
> > +{
> > +=09serial8250_clear_and_reinit_fifos(container_of
> > +=09=09=09=09=09  (p, struct uart_8250_port, port));
> > +=09(void)p->serial_in(p, UART_RX);
> > +}
> > +
> >=20
> >  static void dw8250_serial_out(struct uart_port *p, int offset, int=
 value)
> >  {
> > =20
> >  =09struct dw8250_data *d =3D p->private_data;
> >=20
> > -=09if (offset =3D=3D UART_LCR)
> > -=09=09d->last_lcr =3D value;
> > -
> >=20
> >  =09if (offset =3D=3D UART_MCR)
> >  =09
> >  =09=09d->last_mcr =3D value;
> >  =09
> >  =09writeb(value, p->membase + (offset << p->regshift));
> >=20
> > +
> > +=09/* Make sure LCR write wasn't ignored */
> > +=09if (offset =3D=3D UART_LCR) {
> > +=09=09int tries =3D 1000;
> > +=09=09while (tries--) {
> > +=09=09=09if (value =3D=3D p->serial_in(p, UART_LCR))
> > +=09=09=09=09return;
> > +=09=09=09dw8250_force_idle(p);
> > +=09=09=09writeb(value, p->membase + (UART_LCR << p->regshift));
> > +=09=09}
> > +=09=09dev_err(p->dev, "Couldn't set LCR to %d\n", value);
> > +=09}
> >=20
> >  }
> > =20
> >  static unsigned int dw8250_serial_in(struct uart_port *p, int offs=
et)
> >=20
> > @@ -108,13 +123,22 @@ static void dw8250_serial_out32(struct uart_p=
ort *p,
> > int offset, int value)>=20
> >  {
> > =20
> >  =09struct dw8250_data *d =3D p->private_data;
> >=20
> > -=09if (offset =3D=3D UART_LCR)
> > -=09=09d->last_lcr =3D value;
> > -
> >=20
> >  =09if (offset =3D=3D UART_MCR)
> >  =09
> >  =09=09d->last_mcr =3D value;
> >  =09
> >  =09writel(value, p->membase + (offset << p->regshift));
> >=20
> > +
> > +=09/* Make sure LCR write wasn't ignored */
> > +=09if (offset =3D=3D UART_LCR) {
> > +=09=09int tries =3D 1000;
> > +=09=09while (tries--) {
> > +=09=09=09if (value =3D=3D p->serial_in(p, UART_LCR))
> > +=09=09=09=09return;
> > +=09=09=09dw8250_force_idle(p);
> > +=09=09=09writel(value, p->membase + (UART_LCR << p->regshift));
> > +=09=09}
> > +=09=09dev_err(p->dev, "Couldn't set LCR to %d\n", value);
> > +=09}
> >=20
> >  }
> > =20
> >  static unsigned int dw8250_serial_in32(struct uart_port *p, int of=
fset)
> >=20
> > @@ -132,9 +156,8 @@ static int dw8250_handle_irq(struct uart_port *=
p)
> >=20
> >  =09if (serial8250_handle_irq(p, iir)) {
> >  =09
> >  =09=09return 1;
> >  =09
> >  =09} else if ((iir & UART_IIR_BUSY) =3D=3D UART_IIR_BUSY) {
> >=20
> > -=09=09/* Clear the USR and write the LCR again. */
> > +=09=09/* Clear the USR */
> >=20
> >  =09=09(void)p->serial_in(p, d->usr_reg);
> >=20
> > -=09=09p->serial_out(p, UART_LCR, d->last_lcr);
> >=20
> >  =09=09return 1;
> >  =09
> >  =09}
>=20
> Since v3.13-rc1, this commit seems to have introduced some oddities o=
n
> some of our boards. See this log snippet:
>=20
> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDR=EF=BF=BDconsole [ttyS0] enabled=

> console [ttyS0] enabled
> bootconsole [earlycon0] disabled
> bootconsole [earlycon0] disabled
> dw-apb-uart d0012100.serial: Couldn't set LCR to 191
> dw-apb-uart d0012100.serial: Couldn't set LCR to 191
> dw-apb-uart d0012100.serial: Couldn't set LCR to 224
> dw-apb-uart d0012100.serial: Couldn't set LCR to 224
> d0012100.serial: ttyS1 at MMIO 0xd0012100 (irq =3D 18, base_baud =3D =
15625000)
> is a 16550A
>=20
> This behavior appear in at least Armada 370 and Armada XP boxes.
>=20
> I confirm reverting this commit fixes the issue and things get back t=
o
> normal. Here's the complete kernel log: sprunge.us/gMdL
>=20
> Ideas?

Hi,

This commit is causing problems for me too on v3.13-rc1. I get the LCR =
errors=20
during boot. Output works fine (the console log is on ttyS0), but input=
 just=20
doesn't respond. Reverting this commit makes it work again.

I added some debug to print on first loop iteration:
* the previous last_lcr
* the read back LCR before the LCR write
* the new written LCR value
* the read back LCR after the LCR write
Also added a print in the special busy handling in dw8250_handle_irq wh=
ich=20
doesn't get hit in this case.
This is the ooutput:

Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
LCR set failed [0]->3->[bf]->9f
dw-apb-uart 2004b00.uart: Couldn't set LCR to 191
LCR set succeeded [bf]->9f->[0]->0
LCR set succeeded [0]->0->[80]->80
LCR set failed [80]->80->[bf]->9f
dw-apb-uart 2004b00.uart: Couldn't set LCR to 191
LCR set succeeded [bf]->9f->[0]->0
LCR set failed [0]->0->[e0]->c0
dw-apb-uart 2004b00.uart: Couldn't set LCR to 224
LCR set succeeded [e0]->c0->[0]->0
LCR set failed [0]->0->[e0]->c0
dw-apb-uart 2004b00.uart: Couldn't set LCR to 224
LCR set failed [e0]->c0->[0]->80
dw-apb-uart 2004b00.uart: Couldn't set LCR to 0
LCR set failed [0]->80->[0]->80
dw-apb-uart 2004b00.uart: Couldn't set LCR to 0
LCR set succeeded [0]->80->[80]->80
LCR set failed [80]->80->[0]->80
dw-apb-uart 2004b00.uart: Couldn't set LCR to 0
LCR set failed [0]->80->[3]->80
dw-apb-uart 2004b00.uart: Couldn't set LCR to 3
2004b00.uart: ttyS0 at MMIO 0x2004b00 (irq =3D 4, base_baud =3D 114495)=
 is a=20
XScale

So it looks like the LCR does always change immediately for me in this =
case=20
(obviously it hasn't hit the BUSY case), but not all the bits can be wr=
itten.=20
In particular bit 5 and bit 7 at the least. If I do this (sorry for whi=
tespace=20
munging):

diff --git a/drivers/tty/serial/8250/8250_dw.c=20
b/drivers/tty/serial/8250/8250_dw.c
index 4658e3e..722d448 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -96,7 +96,7 @@ static void dw8250_serial_out(struct uart_port *p, in=
t=20
offset, int value)
 =09if (offset =3D=3D UART_LCR) {
 =09=09int tries =3D 1000;
 =09=09while (tries--) {
-=09=09=09if (value =3D=3D p->serial_in(p, UART_LCR))
+=09=09=09if (value & ~0xa0 =3D=3D p->serial_in(p, UART_LCR) & ~0xa0)
 =09=09=09=09return;
 =09=09=09dw8250_force_idle(p);
 =09=09=09writeb(value, p->membase + (UART_LCR << p->regshift));
@@ -132,7 +132,7 @@ static void dw8250_serial_out32(struct uart_port *p=
, int=20
offset, int value)
 =09if (offset =3D=3D UART_LCR) {
 =09=09int tries =3D 1000;
 =09=09while (tries--) {
-=09=09=09if (value =3D=3D p->serial_in(p, UART_LCR))
+=09=09=09if (value & ~0xa0 =3D=3D p->serial_in(p, UART_LCR) & ~0xa0)
 =09=09=09=09return;
 =09=09=09dw8250_force_idle(p);
 =09=09=09writel(value, p->membase + (UART_LCR << p->regshift));

Then all is well again (note, BUSY case not actually tested).

According to include/uapi/linux/serial_reg.h:

#define UART_LCR_DLAB=09=090x80 /* Divisor latch access bit */
#define UART_LCR_SPAR=09=090x20 /* Stick parity (?) */

I don't know much about the 8250 interface to have much clue why these =
bits=20
wouldn't change. I suppose it's conceivable bit 5 is simply unimplement=
ed in=20
the hardware since it sounds like it's just for debugging purposes, Not=
e the=20
last failure which failed to set 0x80 -> 0x03 (software probably thinki=
ng=20
0x00->0x03).

Thoughts anybody? Any other useful info I can provide?

Thanks
James
--nextPart5548530.8nabKUZjb3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJSol3HAAoJEKHZs+irPybfIJIP/0n4jzkBzUMAspjTPvZtWUO5
E2rbZxJENx+Lq5NfOGeBX6T7L20CFt6semYeDgfGwgDSAEDx+ofBmzCoPodwBfKr
P6svSU1eW+EVogR0c5FZ6DYLoRlAkyK/iXRRYTKI6kldKqcnO4szEKazScQ+Ooc9
mvy7Strht6h79vDXbR08SoCHTWVu/6ncgakKJevDfrAogptYOFuFRjGP/AJFEY2W
lVkFNIqMi2LXx1obMCHkqkhKoYn3DOFW076MRzwEXcXgYvhlWBE4nfo/2YNLIxPT
oclcfCLaW51T8AjQ5+L3WQdF4yg/8GP/yOUEZt5OoJpGmVaTmj1pjXgqunYwtH5V
sbjjTXqbez2YTowVVBKPVqjPOdV/8ARK+awrH+vuTEsvw7Y7ypdm3nDEBp2N9dNz
fBa1L4V2zvACqUrBAZX9dEq6LydYEnvGhIhcA5xx5kAvW5U2XGZCa7T4cponGkUd
UEJXJgKoS+lECGzpFRyeKle4GxEJTM4wISX1h243r5hZA0v18xVNi7d6hJyTXjIa
MFevQd9CbAfT6YZ/Ft1d6OeIAKcu4FRRLoJTW9oVuyRTfXHER+2eLaL4HGL/KHkW
trnuwdSsJkOyM1bCYJGGaW20SqvTjcQcjyZ1zKu8wOtvews0dcDItwYLCAl311RD
m6D3gkLrDNWn73Lihmpa
=Banx
-----END PGP SIGNATURE-----

--nextPart5548530.8nabKUZjb3--

