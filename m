Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996Ab3LGA7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 19:59:20 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:39343 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757806Ab3LGA7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:59:18 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] serial: 8250_dw: Improve unwritable LCR workaround
Date: Fri, 06 Dec 2013 16:59:16 -0800 (PST)
Message-ID: <3010367.6CxxZ6Dpea@radagast>
Organization: Imagination Technologies
User-Agent: KMail/4.10.5 (Linux/3.12.3+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAAYSxhpR664Od7AaWZrX0rE=iDUHo0h+4=uY=gvkFps4Hz4aew@mail.gmail.com>
References: <1380647888-32473-1-git-send-email-tim.kryger@linaro.org> <5548535.pYirbknue4@radagast> <CAAYSxhpR664Od7AaWZrX0rE=iDUHo0h+4=uY=gvkFps4Hz4aew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4686749.xIa1pOB4H8"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart4686749.xIa1pOB4H8
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday 06 December 2013 16:31:38 Tim Kryger wrote:
> On Fri, Dec 6, 2013 at 3:51 PM, James Hogan <james.hogan@imgtec.com> wrote:
> > On Friday 06 December 2013 23:29:02 James Hogan wrote:
> >> So it looks like the LCR does always change immediately for me in this
> >> case
> >> (obviously it hasn't hit the BUSY case), but not all the bits can be
> >> written. In particular bit 5 and bit 7 at the least. If I do this (sorry
> >> for whitespace munging):
> >> 
> >> diff --git a/drivers/tty/serial/8250/8250_dw.c
> >> b/drivers/tty/serial/8250/8250_dw.c
> >> index 4658e3e..722d448 100644
> >> --- a/drivers/tty/serial/8250/8250_dw.c
> >> +++ b/drivers/tty/serial/8250/8250_dw.c
> >> @@ -96,7 +96,7 @@ static void dw8250_serial_out(struct uart_port *p, int
> >> offset, int value)
> >> 
> >>       if (offset == UART_LCR) {
> >>       
> >>               int tries = 1000;
> >>               while (tries--) {
> >> 
> >> -                     if (value == p->serial_in(p, UART_LCR))
> >> +                     if (value & ~0xa0 == p->serial_in(p, UART_LCR) &
> >> ~0xa0)>> 
> >>                               return;
> >>                       
> >>                       dw8250_force_idle(p);
> >>                       writeb(value, p->membase + (UART_LCR <<
> >>                       p->regshift));
> >> 
> >> @@ -132,7 +132,7 @@ static void dw8250_serial_out32(struct uart_port *p,
> >> int offset, int value)
> >> 
> >>       if (offset == UART_LCR) {
> >>       
> >>               int tries = 1000;
> >>               while (tries--) {
> >> 
> >> -                     if (value == p->serial_in(p, UART_LCR))
> >> +                     if (value & ~0xa0 == p->serial_in(p, UART_LCR) &
> >> ~0xa0)> 
> > My appologies, that should have had some more brackets (I should have
> > retested after cleaning up my debugging). I.e.
> > +                       if ((value & ~0xa0) == (p->serial_in(p, UART_LCR)
> > & ~0xa0))
> > 
> > Cheers
> > James
> 
> James,
> 
> Thanks for the information.  This is really helpful.
> 
> You are right about bit 5 being a problem.  Its behavior differs
> between IP versions 3.00a and 3.14c per the docs.
> 
> As for bit 7, when it doesn't change this indicates the UART was busy
> and we need to do the workaround.
> 
> Would you mind testing it again using a mask of ~0x20?

It appears to work with ~0x20 too, and the workaround isn't getting hit (only 
tested boot and logging in - nothing fancy). I think having the printks in 
this code with the console directed at the serial must have caused 
resursion/busy problems somehow.

Cheers
James
--nextPart4686749.xIa1pOB4H8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJSonLiAAoJEKHZs+irPybfmJQP/Rasja9V2xVHOZ8EcoSsLEdS
xFJHnkagHIeaWloTBXkqJZHqZRU+leKrXSgpNTXFVkrlBgFtBTMX2Ct0wp3uaLKy
srJdZMAbv2PRjP0F6hOt7pL0ghKdgkBD4tyOFkVlmBOAUYMaXNdwP26sCvPMhwvm
QEFtPC2089DBn5S/u/QdUR+jxV4WU0BJKdjEOc6hpP1FHom+f7bJZqns8Ba94n7c
Z/1SXvGCkvZki0yIOq1HjXU0focNhZlBBmHDKy5dz/3bVXE96cJZJH/QxTvG7z4q
cpVa0CkrpKyc3v+P05CFezvuQ3G5WhBeHi/Juz0Mb1m5KlHowzi/6TAbKiiwVTnb
v1T2lXqCn6n++yCqLhXzAWBr+p+8e+5/6uXpXcQPQQwmp+K1rvNNK9e2wVWtXvlt
Xvownr0uFpYz14EAcXtwByq1kBuRwXAX4xM4/kj33m/CDbqw0PceFWr2k0Jn3xaF
ZJS9KEELLY8r8HaJv+5kHrXvU6wS7R4icOgguHCbFQ8MXQSJkEH5ZGt1FsV5cXNs
MBxaj8iignxMkIUuOcmXHM5ObyAsmXASNtCikrMiNt6tYS47ZSurfkp/aAFgJdj5
Iv2lAZ8G2H3xr8gJ4o/zRxOBVhQwXzzbOmo+HywBNNXqwEGp6hGdqIbEpx7zxwk0
VPVLt1ddVrpGTiqxgQYC
=Spzc
-----END PGP SIGNATURE-----

--nextPart4686749.xIa1pOB4H8--

