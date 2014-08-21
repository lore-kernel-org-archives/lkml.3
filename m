Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbaHUVl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 17:41:26 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:56356 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbaHUVlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 17:41:22 -0400
X-ASG-Debug-ID: 1408657278-0759e7416b4f09e30002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Thu, 21 Aug 2014 23:41:17 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Felipe Balbi <balbi@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Pelykh <alexey.pelykh@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        Frans Klaver <fransklaver@gmail.com>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/4] tty: omap-serial: use threaded interrupt handler
Message-ID: <20140821214117.GA7076@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [RFC PATCH 3/4] tty: omap-serial: use threaded interrupt handler
References: <1406645577-18620-1-git-send-email-frans.klaver@xsens.com>
 <1408450488-4083-1-git-send-email-frans.klaver@xsens.com>
 <1408450488-4083-4-git-send-email-frans.klaver@xsens.com>
 <20140819185701.GC22003@saruman.home>
 <20140820064028.GC9319@ci00147.xsens-tech.local>
 <20140820160604.GH24500@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140820160604.GH24500@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.49]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1408657278
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.8702
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 11:06:05AM -0500, Felipe Balbi wrote:
> On Wed, Aug 20, 2014 at 08:40:28AM +0200, Frans Klaver wrote:
> > On Tue, Aug 19, 2014 at 01:57:02PM -0500, Felipe Balbi wrote:
> > > On Tue, Aug 19, 2014 at 02:14:47PM +0200, Frans Klaver wrote:
> > > > At 3.6Mbaud, with slightly over 2Mbit/s data coming in, we see 1600 uart
> > > > rx buffer overflows within 30 seconds. Threading the interrupt handling reduces
> > > > this to about 170 overflows in 10 minutes.
> > > 
> > > Can you try Sebastian Siewior's patches for 8250_omap and 8250 dma
> > > support ? That should help you a lot.
> > 
> > I'll have a look at that series. Thanks for pointing it out.

I have had a look at Sebastian's series, but I'm not convinced
yet that we should use it. So far the serial console seems to be
missing data every now and then. I haven't gotten around to testing our
high traffic application yet.


> > > >  drivers/tty/serial/omap-serial.c | 31 ++++++++++++++++++++++++-------
> > > >  1 file changed, 24 insertions(+), 7 deletions(-)
> > > > 
> > > > diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
> > > > index 14a0167..57664b9 100644
> > > > --- a/drivers/tty/serial/omap-serial.c
> > > > +++ b/drivers/tty/serial/omap-serial.c
> > > > @@ -575,6 +575,21 @@ static void serial_omap_rdi(struct uart_omap_port *up, unsigned int lsr)
> > > >  }
> > > >  
> > > >  /**
> > > > + * serial_omap_fast_irq() - schedule interrupt handling
> > > > + */
> > > > +static irqreturn_t serial_omap_fast_irq(int irq, void *dev_id)
> > > > +{
> > > > +	struct uart_omap_port *up = dev_id;
> > > > +	unsigned int iir = serial_in(up, UART_IIR);
> > > > +
> > > > +	if (iir & UART_IIR_NO_INT)
> > > > +		return IRQ_NONE;
> > > > +
> > > > +	disable_irq_nosync(up->port.irq);
> > > 
> > > NAK. Either use IRQF_ONESHOT or actually mask the IRQs at the device's
> > > registers (basically clearing IER).
> > 
> > Given the work that's been done on the 8250 based driver, what are the
> > short-term chances omap-serial will be dropped? I'd be happy to improve
> > here if it makes sense to do so. If the 8250 based driver is going to
> > replace omap-serial anyway on the short term, I don't see the point of
> > further developing this patch. The others would still make sense in my
> > opinion.
> 
> if we find a way to maintain the same ttyO* naming scheme and make it
> coexist with ttyS* naming, then we could drop as soon as 8250_omap is
> ready for prime time.

With that in mind, for now I'll be betting on two horses.

I'll cook up a new version using oneshot.

Thanks,
Frans
