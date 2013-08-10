Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031734Ab3HJACo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 20:02:44 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:1945 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031651Ab3HJACn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 20:02:43 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zcb8kzbb2dI98dIc89bh936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1155h)
Message-ID: <1376092951.15633.93.camel@snotra.buserror.net>
Subject: Re: [v2] Enhanced support for MPC8xx/8xxx watchdog
From: Scott Wood <scottwood@freescale.com>
To: leroy christophe <christophe.leroy@c-s.fr>
CC: Wim Van Sebroeck <wim@iguana.be>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-watchdog@vger.kernel.org>
Date: Fri, 9 Aug 2013 19:02:31 -0500
In-Reply-To: <520331C1.4060406@c-s.fr>
References: <201302280852.r1S8qMYu003742@localhost.localdomain>
	 <20130625230431.GA29393@home.buserror.net> <520331C1.4060406@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 07:50 +0200, leroy christophe wrote:
> Le 26/06/2013 01:04, Scott Wood a écrit :
> > What happens if there's a race?  If another CPU updates wdt_last_ping in
> > parallel, then you could see wdt_last_ping greater than the value you
> > read for jiffies.  Since this is an unsigned comparison, it will fail to
> > call keepalive.  You might get saved by pinging it twice as often as
> > necessary, but you shouldn't rely on that.
> Euh ... This watchdog is integrated inside the CPU, so there is no 
> chance that any external CPU get access to it.

Hmm, it looks like mpc8641d (which is the only multi-core SoC among mpc8xx/mpc83xx/mpc86xx) does not have this watchdog, even though mpc8610 does.

So pretend I said "what if you get preempted?". :-)

> >> +		mpc8xxx_wdt_keepalive();
> >> +		/* We're pinging it twice faster than needed, to be sure. */
> >> +		mod_timer(&wdt_timer, jiffies + HZ * hw_timo_sec / 2);
> >> +	}
> >> +}
> >> +
> >> +static void mpc8xxx_wdt_sw_keepalive(void)
> >> +{
> >> +	wdt_last_ping = jiffies;
> >> +	mpc8xxx_wdt_timer_ping(0);
> >>   }
> > This isn't new with this patch, but it looks like
> > mpc8xxx_wdt_keepalive() can be called either from timer context, or with
> > interrupts enabled... yet it uses a bare spin_lock() rather than an
> > irq-safe version.  This should be fixed.
> Ok, I'll propose another patch for that. Indeed, is the spin_lock needed 
> at all ? If we get two writes interleaved, it will make it anyway.

I suppose...  I don't like relying on things like that, though.

-Scott



