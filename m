Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab3KVWez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:34:55 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:44517
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755798Ab3KVWey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:34:54 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(z579ehz98dI936eI146fI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h1155h)
Message-ID: <1385159644.1403.532.camel@snotra.buserror.net>
Subject: Re: [PATCH 1/6] powerpc: fix exception clearing in e500 SPE float
 emulation
From: Scott Wood <scottwood@freescale.com>
To: "Joseph S. Myers" <joseph@codesourcery.com>
CC: <linuxppc-dev@lists.ozlabs.org>, Liu Yu <yu.liu@freescale.com>,
        <linux-kernel@vger.kernel.org>, Shan Hai <shan.hai@windriver.com>
Date: Fri, 22 Nov 2013 16:34:04 -0600
In-Reply-To: <Pine.LNX.4.64.1311041651390.4290@digraph.polyomino.org.uk>
References: <Pine.LNX.4.64.1311041649250.4290@digraph.polyomino.org.uk>
	 <Pine.LNX.4.64.1311041651390.4290@digraph.polyomino.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-04 at 16:52 +0000, Joseph S. Myers wrote:
> From: Joseph Myers <joseph@codesourcery.com>
> 
> The e500 SPE floating-point emulation code clears existing exceptions
> (__FPU_FPSCR &= ~FP_EX_MASK;) before ORing in the exceptions from the
> emulated operation.  However, these exception bits are the "sticky",
> cumulative exception bits, and should only be cleared by the user
> program setting SPEFSCR, not implicitly by any floating-point
> instruction (whether executed purely by the hardware or emulated).
> The spurious clearing of these bits shows up as missing exceptions in
> glibc testing.
> 
> Fixing this, however, is not as simple as just not clearing the bits,
> because while the bits may be from previous floating-point operations
> (in which case they should not be cleared), the processor can also set
> the sticky bits itself before the interrupt for an exception occurs,
> and this can happen in cases when IEEE 754 semantics are that the
> sticky bit should not be set.  Specifically, the "invalid" sticky bit
> is set in various cases with non-finite operands, where IEEE 754
> semantics do not involve raising such an exception, and the
> "underflow" sticky bit is set in cases of exact underflow, whereas
> IEEE 754 semantics are that this flag is set only for inexact
> underflow.  Thus, for correct emulation the kernel needs to know the
> setting of these two sticky bits before the instruction being
> emulated.
> 
> When a floating-point operation raises an exception, the kernel can
> note the state of the sticky bits immediately afterwards.  Some
> <fenv.h> functions that affect the state of these bits, such as
> fesetenv and feholdexcept, need to use prctl with PR_GET_FPEXC and
> PR_SET_FPEXC anyway, and so it is natural to record the state of those
> bits during that call into the kernel and so avoid any need for a
> separate call into the kernel to inform it of a change to those bits.
> Thus, the interface I chose to use (in this patch and the glibc port)
> is that one of those prctl calls must be made after any userspace
> change to those sticky bits, other than through a floating-point
> operation that traps into the kernel anyway.

This sounds like an incompatible change to userspace API.  What about
older glibc?  What about user code that directly manipulates these bits
rather than going through libc, or uses a libc other than glibc?  Where
is this API requirement documented?

I think the impact of this could be reduced by using this mechanism only
to clear bits, rather than set them.  That is, if the exception bit is
unset, don't set it just because it's set in spefscr_last -- but if it's
not set in spefscr_last, and the emulation code doesn't want to set it,
then clear it.

Are there any cases where the exception bit can be set without the
kernel taking a trap, or is userspace manipulation limited to clearing
the bits?

-Scott



