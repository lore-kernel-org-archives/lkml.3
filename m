Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab3BUGzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 01:55:44 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:27807
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689Ab3BUGzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 01:55:42 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275ch8275dhz2dh2a8h668h839h944hd24he5bhf0ah1220h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
Date: Thu, 21 Feb 2013 00:52:21 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Nicolas Pitre <nico@fluxnic.net>
CC: "Woodhouse, David" <david.woodhouse@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [RFC] arm: use built-in byte swap function
Message-ID: <20130221005221.15279b1372501af12c1e4f32@freescale.com>
In-Reply-To: <alpine.LFD.2.03.1302202327370.6419@syhkavp.arg>
References: <20130129181046.GC25415@pd.tnic>
	<20130206191905.ac8eb6743e69425f30888704@freescale.com>
	<20130207181315.GM17833@n2100.arm.linux.org.uk>
	<1360344301.6066.263.camel@shinybook.infradead.org>
	<alpine.LFD.2.02.1302081503430.6300@xanadu.home>
	<1360363233.6066.283.camel@shinybook.infradead.org>
	<alpine.LFD.2.02.1302081745500.6300@xanadu.home>
	<20130208191208.2ef3d78bda71aa7b44d00d7b@freescale.com>
	<alpine.LFD.2.02.1302082102380.6300@xanadu.home>
	<20130219203115.114eab79e8d2099c6306d921@freescale.com>
	<alpine.LFD.2.03.1302192151280.6419@syhkavp.arg>
	<1361356696.13482.269.camel@i7.infradead.org>
	<alpine.LFD.2.03.1302200835380.6419@syhkavp.arg>
	<1361367842.13482.279.camel@i7.infradead.org>
	<alpine.LFD.2.03.1302200905300.6419@syhkavp.arg>
	<1361372008.13482.280.camel@i7.infradead.org>
	<alpine.LFD.2.03.1302201040460.6419@syhkavp.arg>
	<20130220214943.9b28a5b208da9f081387c55e@freescale.com>
	<alpine.LFD.2.03.1302202327370.6419@syhkavp.arg>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013 23:29:58 -0500
Nicolas Pitre <nico@fluxnic.net> wrote:

> On Wed, 20 Feb 2013, Kim Phillips wrote:
> 
> > On Wed, 20 Feb 2013 10:43:18 -0500
> > Nicolas Pitre <nico@fluxnic.net> wrote:
> > 
> > > On Wed, 20 Feb 2013, Woodhouse, David wrote:
> > > > On Wed, 2013-02-20 at 09:06 -0500, Nicolas Pitre wrote:
> > > > > ... in which case there is no harm shipping a .c file and trivially 
> > > > > enforcing -O2, the rest being equal.
> > > > 
> > > > For today's compilers, unless the wind changes.
> > > 
> > > We'll adapt if necessary.  Going with -O2 should remain pretty safe anyway.
> > 
> > Alas, not so for gcc 4.4 - I had forgotten I had tested
> > Ubuntu/Linaro 4.4.7-1ubuntu2 here:
> > 
> > https://patchwork.kernel.org/patch/2101491/
> > 
> > add -O2 to that test script and gcc 4.4 *always* emits calls to
> > __bswap[sd]i2, even with -march=armv6k+.

argh, sorry - that script was testing support for 
__builtin_bswap{16,32,64} directly, which isn't the same as testing
code generation of a byte swap pattern in C.

> Crap.  OK, assembly code is the way to go then.
> 
> > I'll try working on an assembly version given it probably
> > makes more sense, future-gcc-immunity-wise.
> 
> Agreed.

I'll still try the assembly approach - gcc 4.4's armv6 output looks
worse than both the pre-armv6 and post-armv6 __arch_swab32
implementations currently in use:

mov     ip, sp
push    {fp, ip, lr, pc}
sub     fp, ip, #4
and     r2, r0, #65280  ; 0xff00
lsl     ip, r0, #24
orr     r1, ip, r0, lsr #24
and     r0, r0, #16711680       ; 0xff0000
orr     r3, r1, r2, lsl #8
orr     r0, r3, r0, lsr #8
ldm     sp, {fp, sp, pc}

Kim

