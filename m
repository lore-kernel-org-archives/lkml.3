Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbbAESnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:43:25 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:39770 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbbAESnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:43:23 -0500
Date: Mon, 5 Jan 2015 19:43:22 +0100
From: Andreas Mohr <andi@lisas.de>
To: Scott Wood <scottwood@freescale.com>
Cc: Andreas Mohr <andi@lisas.de>, Purcareata Bogdan <b43198@freescale.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
Subject: Re: [RFC] PPC: MPIC: necessary readback after EOI?
Message-ID: <20150105184322.GA30255@rhlx01.hs-esslingen.de>
References: <20150105174616.GA3159@rhlx01.hs-esslingen.de>
 <1420481454.4961.16.camel@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420481454.4961.16.camel@freescale.com>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC related ppl]

On Mon, Jan 05, 2015 at 12:10:54PM -0600, Scott Wood wrote:
> On Mon, 2015-01-05 at 18:46 +0100, Andreas Mohr wrote:
> > Hi,
> > 
> > > I was curious why the mpic_cpu_read(MPIC_INFO(CPU_WHOAMI)) was there in
> > > the first place and if it's still needed. If it's still required, I
> > > guess a better approach is to eliminate the call only if the kernel is
> > > running on the KVM guest side, where the MPIC is emulated and no longer
> > > requires a readback.
> > 
> > "Why not?"
> > 
> > A mechanism being "emulated"/"virtual" or not
> > may not necessarily be much of a distinction (if at all!).
> > The readback might be required
> > to properly fulfill all requirements
> > of a full state change protocol specification,
> > which might easily be the case for both RS(*) and virtual hardware.
> > And especially for virtual hardware
> > such a "readback" event
> > might be an extremely important "end of transaction" marker
> > which may often be needed for freeing of temporary resources etc.
> 
> I'm not convinced that it's required in real silicon (though there are
> many MPIC implementations which have their own quirks...), and I'm 100%
> sure that it's not required in the QEMU/KVM implementation of MPIC.
> 
> It would have been nice if a code comment explained why it was doing the
> readback...  I don't see any particular need to wait for EOI completion
> here (unlike when masking).

Hmm, yeah.

git clone git://git.kernel.org/pub/scm/linux/kernel/git/history/history.git
git checkout v2.6.11
git blame ./ppc64/kernel/mpic.c
git show 378193eb
    [PATCH] ppc64: Rewrite the openpic driver

+/* Send an EOI */
+static inline void mpic_eoi(struct mpic *mpic)
+{
+       mpic_cpu_write(MPIC_CPU_EOI, 0);
+       (void)mpic_cpu_read(MPIC_CPU_WHOAMI);
+}


-static void openpic_eoi(void)
-{
-       DECL_THIS_CPU;
-
-       CHECK_THIS_CPU;
-       openpic_write(&OpenPIC->THIS_CPU.EOI, 0);
-       /* Handle PCI write posting */
-       (void)openpic_read(&OpenPIC->THIS_CPU.EOI);
-}


So, this does seem to be about PCI posted writes after all.
Which begs the question whether all PIC hardware is connected via PCI bus,
which... is not the case for emulated hardware at least, I'd think.

And it's somewhat unfortunate
that the comment in fact was removed in that commit
(perhaps reinstate this comment in all of the various mpic.c life forms?).

Andreas Mohr
