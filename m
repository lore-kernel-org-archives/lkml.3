Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaIYTrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:47:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaIYTrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:47:45 -0400
Date: Thu, 25 Sep 2014 12:47:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Feiner <pfeiner@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the pci
 tree
Message-Id: <20140925124744.b1e37bdbd5b4f4cfcfbb6505@linux-foundation.org>
In-Reply-To: <20140925193000.GA26946@google.com>
References: <20140925174730.302842e6@canb.auug.org.au>
	<20140925193000.GA26946@google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014 12:30:00 -0700 Peter Feiner <pfeiner@google.com> wrote:

> On Thu, Sep 25, 2014 at 05:47:30PM +1000, Stephen Rothwell wrote:
> > Hi Andrew,
> > 
> > Today's linux-next merge of the akpm-current tree got a conflict in
> > include/asm-generic/pgtable.h between commit b766eafe6828 ("PCI: Add
> > pci_remap_iospace() to map bus I/O resources") from the pci tree and
> > commit 4cc2f91f2636 ("mm: softdirty: enable write notifications on VMAs
> > after VM_SOFTDIRTY cleared") from the akpm-current tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
> > 
> > -- 
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> > 
> > diff --cc include/asm-generic/pgtable.h
> > index 977e545a64c3,f6acf1195182..000000000000
> > --- a/include/asm-generic/pgtable.h
> > +++ b/include/asm-generic/pgtable.h
> > @@@ -249,10 -249,18 +249,22 @@@ static inline int pmd_same(pmd_t pmd_a
> >   #define pgprot_writecombine pgprot_noncached
> >   #endif
> >   
> >  +#ifndef pgprot_device
> >  +#define pgprot_device pgprot_noncached
> >  +#endif
> >  +
> > + #ifndef pgprot_modify
> > + #define pgprot_modify pgprot_modify
> > + static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
> > + {
> > + 	if (pgprot_val(oldprot) == pgprot_val(pgprot_noncached(oldprot)))
> > + 		newprot = pgprot_noncached(newprot);
> > + 	if (pgprot_val(oldprot) == pgprot_val(pgprot_writecombine(oldprot)))
> > + 		newprot = pgprot_writecombine(newprot);
> 
> For completeness of the arch-independent pgprot-modify,
> 
> 	if (pgprot_val(oldprot) == pgprot_val(pgprot_device(oldprot)))
> 		newprot = pgprot_device(newprot);
> 
> should be added here.
> 

Tricky.  I've moved
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.paqtch
to be staged after linux-next, so I'll merge it after PCI has merged. 
And added this:

--- a/include/asm-generic/pgtable.h~mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix
+++ a/include/asm-generic/pgtable.h
@@ -261,6 +261,8 @@ static inline pgprot_t pgprot_modify(pgp
 		newprot = pgprot_noncached(newprot);
 	if (pgprot_val(oldprot) == pgprot_val(pgprot_writecombine(oldprot)))
 		newprot = pgprot_writecombine(newprot);
+	if (pgprot_val(oldprot) == pgprot_val(pgprot_device(oldprot)))
+		newprot = pgprot_device(newprot);
 	return newprot;
 }
 #endif
_


