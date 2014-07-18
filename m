Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030476AbaGRPcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:32:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36622 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761776AbaGRPcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:32:05 -0400
Date: Fri, 18 Jul 2014 10:31:16 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <balbi@ti.com>, Peter Hurley <peter@hurleysoftware.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH 4/5] tty: serial: 8250 core: add runtime pm
Message-ID: <20140718153116.GN24914@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405521903-5877-5-git-send-email-bigeasy@linutronix.de>
 <20140716151604.GG1365@saruman.home>
 <53C6A050.2050409@linutronix.de>
 <20140716160614.GI1365@saruman.home>
 <53C7EC6F.6060902@hurleysoftware.com>
 <20140717154300.GA16623@linutronix.de>
 <20140717160206.GI10459@saruman.home>
 <53C7F4A3.5080508@linutronix.de>
 <20140717161848.GK10459@saruman.home>
 <53C8DC3E.3020701@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LvAn5G4Ewe70kJ1i"
Content-Disposition: inline
In-Reply-To: <53C8DC3E.3020701@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LvAn5G4Ewe70kJ1i
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 10:35:10AM +0200, Sebastian Andrzej Siewior wrote:
> On 07/17/2014 06:18 PM, Felipe Balbi wrote:
>=20
> >> No, this is okay. If you look, it checks for "up->ier &=20
> >> UART_IER_THRI". On the second invocation it will see that this
> >> bit is already set and therefore won't call get_sync() for the
> >> second time. That bit is removed in the _stop_tx() path.
> >=20
> > oh, right. But that's actually unnecessary. Calling
> > pm_runtime_get() multiple times will just increment the usage
> > counter multiple times, which means you can call __stop_tx()
> > multiple times too and everything gets balanced, right ?
>=20
> No. start_tx() will be called multiple times but only the first
> invocation invoke pm_runtime_get(). Now I noticed that I forgot to

right, but that's unnecessary. You can pm_runtime_get() every time
start_tx() is called. Just make sure to put everytime stop_tx() is
called too.

> remove pm_runtime_put_autosuspend() at the bottom of it. But you get
> the idea right?
> pm_get() on the while the UART_IER_THRI is not yet set. pm_put() once
> the fifo is completely empty.
>=20
> >> Do you have other ideas? It doesn't look like this is exported at
> >> all. If we call _stop_tx() right away, then we have 64 bytes in
> >> the TX fifo in the worst case. They should be gone "soon" but the
> >> HW-flow control may delay it (in theory for a long time)).
> >=20
> > this can be problematic, specially for OMAP which can go into OFF
> > while idle. Whatever is in the FIFO would get lost. It seems like
> > omap-serial solved this within transmit_chars().
>=20
> No, it didn't.
>=20
> > See how transmit_chars() is called from within IRQ handler with
> > clocks enabled then it conditionally calls serial_omap_stop_tx()
> > which will pm_runtime_get_sync() -> do_the_harlem_shake() ->=20
> > pm_runtime_put_autosuspend(). That leaves one unbalanced=20
> > pm_runtime_get() which is balanced when we're exitting the IRQ
> > handler.
>=20
> omap-serial and the 8250 do the following on tx path:
> - start_tx()
>   -> sets UART_IER_THRI. This will generate an interrupt once the FIFO
>      is empty.
> - interrupt, notices the empty fifo, invokes serial8250_start_tx()/
>   transmit_chars().
>   Both have a while loop that fills the FIFO. This loop is left once
>   the tty-buffer is empty (uart_circ_empty() is true) or the FIFO full.
>=20
> Lets say you filled 64 bytes into the FIFO and then left because your
> FIFO is full and tty-buffer is empty. That means you will invoke
> serial_omap_stop_tx() and remove UART_IER_THRI bit.
> This is okay because you are not interested in further FIFO empty
> interrupts because you don't have any TX-bytes to be sent. However,
> once you leave the transmit_chars() you leave serial_omap_irq() which
> does the last pm_put(). That means you have data in the TX FIFO that is
> about to be sent and the device is in auto-suspend.
> This is "fine" as long as the timeout is greater then the time required
> for the data be sent (plus assuming HW-float control does not stall it
> for too long) so nobody notices a thing.

the time is set to -1 by default. I guess this only works because nobody
has ever tested long transfers with slow baud rates :-p

> For that reason I added the hack / #if0 block in the 8250 driver. To
> ensure we do not disable the TX-FIFO-empty interrupt even if there is
> nothing to send. Instead we enter serial8250_tx_chars() once again with
> empty FIFO and empty tty-buffer and will invoke _stop_tx() which also
> finally does the pm_put().
> That is the plan. The problem I have is how to figure out that the
> device is using auto-suspend. If I don't then I would have to remove
> the #if0 block and that would mean for everybody an extra interrupt
> (which I wanted to avoid).

looks like the closest you have is:

if (pm_runtime_autosuspend_expiration(dev) > 0)
	foo();

Another possibility would be to implement the ->runtime_idle() callback
and only return 0 if fifo is empty, otherwise return -EAGAIN ? then, if
the autosuspend timer expires, ->runtime_idle gets called and you can do
the right thing depending on fifo empty or not.

Take a look at
drivers/usb/core/driver.c::usb_runtime_{idle,resume,suspend} for
examples. That seems to work pretty well.

> > This seems work fine and dandy without DMA, but for DMA work, I
> > think we need to make sure this IP stays powered until we get DMA
> > completion callback. But that's future, I guess.
>=20
> Yes, probably. That means one get at dma start, one put at dma complete
> callback. And I assume we get that callbacks once the DMA transfer is
> complete, not when the FIFO is empty :) So lets leave it to the future
> for now=E2=80=A6

k

--=20
balbi

--LvAn5G4Ewe70kJ1i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTyT3EAAoJEIaOsuA1yqREjngQAJp5ukOPmx++Ifn4cEsvb//g
5FOEZEaQ56oyW6mWrPZAVY+zMXpBecGJ5wbW2JgP5y6D/co+fmcgcLCoDlX4ugto
wsgg2LfUhMB4i0AsCy3Jp0W4H+LH5pvWWz1Z2kJhwCrhjCN5C8K5CITT3LNRmWsE
l/diz6acIEkUUIS7iCfF1LbN4Qh/svLj4T8SsIkgyxUO9bG8nFQ/6XyRtV7MQ2D8
xBPkcTyObLLNMZjSqF5/YGBiU7WzG1JC+2h3mv2RqOApqmKHz7JyQMN3A3B0t5t6
KHqPS/okrrK7e/6kZWk3z0PGlRsTLOrC4k/RqU8IVnnqyPVv5hiqaqNhz1dzWr0a
9/XYwWE9PwB90l/LSW7JoEwgGXp6nrA9IUv101pbrO4DYx9pok/P1tE3YqXwR7OU
vO7XQDBIHw1eVioiLdkQ4jQLdlvy3Lo4PzoFmuwwDeU0xdQNzXy0TCXK62kN6URu
xbnr+RuVScK9PE+nXK1kHv1XdeCxLrqf9iLLhu+U1fvi/lRB3z+9G/BE0VJHN8YO
6bz6YpCu1ZmJ5hTyn5+exaYGrzmzjDrsdkJT5eohh1kt+vWcx7o5WC92SgRdtH3f
ldYrf9rTJvIqsB50wDW3eIWxJZW4HCXCY/kf9XVtlQ7RdroidBOi6nGlRk//BKBY
uXZ1aBRKMFUeZ0qSUsQ1
=hzjS
-----END PGP SIGNATURE-----

--LvAn5G4Ewe70kJ1i--
