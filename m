Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbaIZJAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:00:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55710 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbaIZJAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:00:14 -0400
Date: Fri, 26 Sep 2014 10:00:11 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Feiner <pfeiner@google.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the akpm-current tree with the pci
 tree
Message-ID: <20140926090011.GH841@e106497-lin.cambridge.arm.com>
References: <20140925174730.302842e6@canb.auug.org.au>
 <20140925193000.GA26946@google.com>
 <20140925124744.b1e37bdbd5b4f4cfcfbb6505@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20140925124744.b1e37bdbd5b4f4cfcfbb6505@linux-foundation.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 26 Sep 2014 09:00:12.0407 (UTC) FILETIME=[47F49070:01CFD968]
X-MC-Unique: 114092610001213001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 08:47:44PM +0100, Andrew Morton wrote:
> On Thu, 25 Sep 2014 12:30:00 -0700 Peter Feiner <pfeiner@google.com> wrote:
> 
> > On Thu, Sep 25, 2014 at 05:47:30PM +1000, Stephen Rothwell wrote:
> > > Hi Andrew,
> > > 
> > > Today's linux-next merge of the akpm-current tree got a conflict in
> > > include/asm-generic/pgtable.h between commit b766eafe6828 ("PCI: Add
> > > pci_remap_iospace() to map bus I/O resources") from the pci tree and
> > > commit 4cc2f91f2636 ("mm: softdirty: enable write notifications on VMAs
> > > after VM_SOFTDIRTY cleared") from the akpm-current tree.
> > > 
> > > I fixed it up (see below) and can carry the fix as necessary (no action
> > > is required).
> > > 
> > > -- 
> > > Cheers,
> > > Stephen Rothwell                    sfr@canb.auug.org.au
> > > 
> > > diff --cc include/asm-generic/pgtable.h
> > > index 977e545a64c3,f6acf1195182..000000000000
> > > --- a/include/asm-generic/pgtable.h
> > > +++ b/include/asm-generic/pgtable.h
> > > @@@ -249,10 -249,18 +249,22 @@@ static inline int pmd_same(pmd_t pmd_a
> > >   #define pgprot_writecombine pgprot_noncached
> > >   #endif
> > >   
> > >  +#ifndef pgprot_device
> > >  +#define pgprot_device pgprot_noncached
> > >  +#endif
> > >  +
> > > + #ifndef pgprot_modify
> > > + #define pgprot_modify pgprot_modify
> > > + static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
> > > + {
> > > + 	if (pgprot_val(oldprot) == pgprot_val(pgprot_noncached(oldprot)))
> > > + 		newprot = pgprot_noncached(newprot);
> > > + 	if (pgprot_val(oldprot) == pgprot_val(pgprot_writecombine(oldprot)))
> > > + 		newprot = pgprot_writecombine(newprot);
> > 
> > For completeness of the arch-independent pgprot-modify,
> > 
> > 	if (pgprot_val(oldprot) == pgprot_val(pgprot_device(oldprot)))
> > 		newprot = pgprot_device(newprot);
> > 
> > should be added here.
> > 

Thanks for noticing this Peter!

> 
> Tricky.  I've moved
> mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.paqtch
> to be staged after linux-next, so I'll merge it after PCI has merged. 
> And added this:
> 
> --- a/include/asm-generic/pgtable.h~mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix
> +++ a/include/asm-generic/pgtable.h
> @@ -261,6 +261,8 @@ static inline pgprot_t pgprot_modify(pgp
>  		newprot = pgprot_noncached(newprot);
>  	if (pgprot_val(oldprot) == pgprot_val(pgprot_writecombine(oldprot)))
>  		newprot = pgprot_writecombine(newprot);
> +	if (pgprot_val(oldprot) == pgprot_val(pgprot_device(oldprot)))
> +		newprot = pgprot_device(newprot);
>  	return newprot;
>  }
>  #endif
> _
> 

Thanks for the patch Andrew!

Best regards,
Liviu

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

