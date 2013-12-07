Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab3LGAdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 19:33:04 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:57402
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753756Ab3LGAdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:33:02 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(z579ehz98dI936eI154dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
Message-ID: <1386376365.7375.209.camel@snotra.buserror.net>
Subject: Re: [PATCH 1/6] powerpc: fix exception clearing in e500 SPE float
 emulation
From: Scott Wood <scottwood@freescale.com>
To: "Joseph S. Myers" <joseph@codesourcery.com>
CC: <linuxppc-dev@lists.ozlabs.org>, Liu Yu <yu.liu@freescale.com>,
        <linux-kernel@vger.kernel.org>, Shan Hai <shan.hai@windriver.com>
Date: Fri, 6 Dec 2013 18:32:45 -0600
In-Reply-To: <Pine.LNX.4.64.1311230053360.12354@digraph.polyomino.org.uk>
References: <Pine.LNX.4.64.1311041649250.4290@digraph.polyomino.org.uk>
	 <Pine.LNX.4.64.1311041651390.4290@digraph.polyomino.org.uk>
	 <1385159644.1403.532.camel@snotra.buserror.net>
	 <Pine.LNX.4.64.1311230053360.12354@digraph.polyomino.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-11-23 at 01:22 +0000, Joseph S. Myers wrote:
> On Fri, 22 Nov 2013, Scott Wood wrote:
> 
> > This sounds like an incompatible change to userspace API.  What about
> > older glibc?  What about user code that directly manipulates these bits
> > rather than going through libc, or uses a libc other than glibc?  Where
> > is this API requirement documented?
> 
> The previous EGLIBC port, and the uClibc code copied from it, is 
> fundamentally broken as regards any use of prctl for floating-point 
> exceptions because it didn't use the PR_FP_EXC_SW_ENABLE bit in its prctl 
> calls (and did various worse things, such as passing a pointer when prctl 
> expected an integer).  If you avoid anything where prctl is used, the 
> clearing of sticky bits still means it will never give anything 
> approximating correct exception semantics with existing kernels.  I don't 
> believe the patch makes things any worse for existing code that doesn't 
> try to inform the kernel of changes to sticky bits - such code may get 
> incorrect exceptions in some cases, but it would have done so anyway in 
> other cases.

OK -- please mention this in the changelog.

> This is the best API I could come up with to fix the fundamentally broken 
> nature of what came before, taking into account that in many cases a prctl 
> call is already needed along with userspace manipulation of exception 
> bits.  I'm not aware of any kernel documentation where this sort of 
> subarchitecture-specific API detail is documented.  (The API also includes 
> such things as needing to leave the spefscr trap-enable bits set and use 
> prctl to control whether SIGFPE results from exceptions.)

I don't know of a formal place for it, but there should at least be a
code comment somewhere.

> > I think the impact of this could be reduced by using this mechanism only
> > to clear bits, rather than set them.  That is, if the exception bit is
> > unset, don't set it just because it's set in spefscr_last -- but if it's
> > not set in spefscr_last, and the emulation code doesn't want to set it,
> > then clear it.
> 
> It should already be the case in this patch that if a bit is clear in 
> spefscr, and set in spefscr_last (i.e. userspace did not inform the kernel 
> of clearing the bit, and no traps since then have resulted in the kernel 
> noticing it was cleared), it won't get set unless the emulation code wants 
> to set it.  The sole place spefscr_last is read is in the statement 
> "__FPU_FPSCR &= ~(FP_EX_INVALID | FP_EX_UNDERFLOW) | 
> current->thread.spefscr_last;" - if the bit is already clear in spefscr, 
> this statement has no effect on it.

OK -- I must have misread it before.

-Scott



