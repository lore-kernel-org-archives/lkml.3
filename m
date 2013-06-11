Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3FKNyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:54:22 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38727 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764Ab3FKNyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:54:20 -0400
Message-ID: <1370958858.2286.5.camel@dabdike>
Subject: Re: [PATCH] dma-mapping: Add BUG_ON for uninitialized dma_ops
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Linux-Arch <linux-arch@vger.kernel.org>
Date: Tue, 11 Jun 2013 06:54:18 -0700
In-Reply-To: <51B703D7.8050804@samsung.com>
References: <f35c5051a207b0a117f2fff27365d0ea892d1610.1370263476.git.michal.simek@xilinx.com>
	 <CAErSpo6kss-v0w_1ker__vPqNCRNLx+z8nk+0r=D-40D3TuDCA@mail.gmail.com>
	 <51B703D7.8050804@samsung.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 13:02 +0200, Marek Szyprowski wrote:
> Hello,
> 
> On 6/11/2013 4:34 AM, Bjorn Helgaas wrote:
> > [+cc Marek]
> >
> > On Mon, Jun 3, 2013 at 6:44 AM, Michal Simek <michal.simek@xilinx.com> wrote:
> > > Check that dma_ops are initialized correctly.
> > >
> > > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > > ---
> > > Functions dma_mmap_attrs(), dma_get_sgtable_attrs()
> > > already have this checking.
> > >
> > > ---
> > >  include/asm-generic/dma-mapping-common.h | 12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > >
> > > diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
> > > index de8bf89..d430cab 100644
> > > --- a/include/asm-generic/dma-mapping-common.h
> > > +++ b/include/asm-generic/dma-mapping-common.h
> > > @@ -16,6 +16,7 @@ static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
> > >         dma_addr_t addr;
> > >
> > >         kmemcheck_mark_initialized(ptr, size);
> > > +       BUG_ON(!ops);
> >
> > Does this actually help anything?  I expected that if "ops" is NULL,
> > we would just oops anyway when we attempted to call "ops->map_page()"
> > because we already trap null pointer dereferences.  At least, when I
> > tried leaving a pci_bus.ops pointer NULL, I got a nice panic and
> > backtrace even without adding an explicit BUG_ON().
> >
> > I cc'd Marek, who added the similar BUG_ON()s in dma_mmap_attrs() and
> > dma_get_sgtable_attrs() with d2b7428eb0 and 64ccc9c033.
> 
> I think that I've copied it from dma_alloc_coherent() in microblaze. You 
> are right that lack
> of this check will also trigger oops in ops==NULL case, but I think that 
> adding explicit check
> in all functions, which use it, is a good idea. It serves as a kind of 
> documentation and
> emphasizes that missing ops is really an issue.

Really, no, it's not a good idea at all.  It invites tons of patches
littering the code with BUG_ONs where we might possibly get a NULL
dereference.  All it does is add extra instructions to a code path for
no actual benefit.

If you can answer the question: what more information does the BUG_ON
give you than the NULL deref Oops would not? then it might be
reasonable.

James


