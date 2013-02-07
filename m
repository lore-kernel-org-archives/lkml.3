Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab3BGBV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:21:57 -0500
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:49490
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757382Ab3BGBVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:21:51 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275dh8275bhz2dh2a8h668h839h944hd24he5bhf0ah1220h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
Date: Wed, 6 Feb 2013 19:19:05 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
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
Message-ID: <20130206191905.ac8eb6743e69425f30888704@freescale.com>
In-Reply-To: <1360141322.6066.4.camel@shinybook.infradead.org>
References: <20130128193033.8a0b0a871150c99247f05a95@freescale.com>
	<20130129083522.GA14302@pd.tnic>
	<1359478014.3529.157.camel@shinybook.infradead.org>
	<20130129174249.GB25415@pd.tnic>
	<1359482147.3529.161.camel@shinybook.infradead.org>
	<20130129181046.GC25415@pd.tnic>
	<1359541333.3529.186.camel@shinybook.infradead.org>
	<20130130200900.9d7cf7908caeaef4ecee1d61@freescale.com>
	<20130131092801.GV23505@n2100.arm.linux.org.uk>
	<20130131145947.f62474a0600848df86548b96@freescale.com>
	<20130201011712.GF23505@n2100.arm.linux.org.uk>
	<1359703995.23531.6.camel@shinybook.infradead.org>
	<20130205210436.670c62e26d2121330e87af35@freescale.com>
	<1360141322.6066.4.camel@shinybook.infradead.org>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2013 09:02:04 +0000
"Woodhouse, David" <david.woodhouse@intel.com> wrote:

> On Tue, 2013-02-05 at 21:04 -0600, Kim Phillips wrote:
> > gcc -Os emits calls to __bswapsi2 on those platforms to save space
> > because they don't have the single rev byte swap instruction.
> 
> Is that the right thing for GCC to do in that situation?

if it saves space, why wouldn't it be?

"Many of these functions are only optimized in certain cases; if they
are not optimized in a particular case, a call to the library
function is emitted." [1]

I see "(arm_arch6 || !optimize_size)" in gcc's define_expand
"bswapsi2" source, so GCC considers size optimization as a
legitimate one of those cases.

> If so, perhaps we should be *providing* __bswap[sd]i2 functions for it
> to use?

either that, or link with libgcc - why does arch/arm64 do this and
arch/arm not?  It's not obvious from git log.

> If not, perhaps there should be a PR filed?
> 
> Or is our use case justifiably different to the general case of '-Os'?
> If so, why?

shouldn't be - a patch, such as this, that claims to reduce code
size, and that only turns on the new built-in when
CC_OPTIMIZE_FOR_SIZE is off, is generally not good :)

OTOH, the target here is armv6+ performance - not armv4,5 code
density - the OPTIMIZE_FOR_SIZE protection prevents armv4,5 build
breakage.

Kim

[1] http://gcc.gnu.org/onlinedocs/gcc/Other-Builtins.html#Other-Builtins

