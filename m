Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab3EUHQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:16:10 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:7615 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109Ab3EUHQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:16:09 -0400
Date: Tue, 21 May 2013 09:16:04 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Karel Zak <kzak@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 3/5] partitions/msdos: enumerate also AIX LVM partitions
Message-ID: <20130521071604.GA19266@frolo.macqel>
References: <1367270313-18871-1-git-send-email-phdm@macqel.be> <1367270313-18871-4-git-send-email-phdm@macqel.be> <20130520164152.9148828cc29fab3d3d02be23@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130520164152.9148828cc29fab3d3d02be23@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, May 20, 2013 at 04:41:52PM -0700, Andrew Morton wrote:
> On Mon, 29 Apr 2013 23:18:31 +0200 Philippe De Muyter <phdm@macqel.be> wrote:
> 
> > Graft AIX partitions enumeration in partitions/msdos.c
> > 
> > There is already a AIX disks detection logic in msdos.c.  When an
> > AIX disk has been found, and if configured to, call the aix partitions
> > recognizer.  This avoids removal of AIX disks protection from msdos.c,
> > avoids code duplication, and ensures that AIX partitions enumeration
> > is called before plain msdos partitions enumeration.
> > 
> > ...
> >
> > --- a/block/partitions/msdos.c
> > +++ b/block/partitions/msdos.c
> > @@ -23,6 +23,7 @@
> >  #include "check.h"
> >  #include "msdos.h"
> >  #include "efi.h"
> > +#include "aix.h"
> >  
> >  /*
> >   * Many architectures don't like unaligned accesses, while
> > @@ -462,8 +463,12 @@ int msdos_partition(struct parsed_partitions *state)
> >  	 */
> >  	if (aix_magic_present(state, data)) {
> >  		put_dev_sector(sect);
> > +#ifdef CONFIG_AIX_PARTITION
> > +		return aix_partition(state);
> > +#else
> >  		strlcat(state->pp_buf, " [AIX]", PAGE_SIZE);
> >  		return 0;
> > +#endif
> >  	}
> >  
> >  	if (!msdos_magic_present(data + 510)) {
> 
> hm, what's going on here.
> 
> Why does partitions/msdos.c know about AIX at all?  Is there something
> special about AIX partitioning which ties it in with msdos?

Well, PowerPC BIOS (PPCBUG or Open Firmware) mimics PC BIOS and requires the
first block of the disk to describe the boot partition the same way that
PC BIOS does.  Remember, the aim of IBM, Motorola and Apple was to replace
the PC's by PowerPC's :).  So, an AIX disk can erroneously be recognized as
a dos disk with two partitions (two times the same boot partition).  That's
the reason why there is already code in block/partitions/msdos.c to avoid
that.
> 
> Now that we have AIX partitioning support, can we simply remove the AIX
> code from msdos.c?  So msdos.c will say "I don't know what that is",
> and we fall through to aix.c which says "that's mine!"?

I didn't want to remove the AIX protection from msdos.c, for the likely case
that someone would compile the kernel without AIX_PARTITION support,  And, as
a part of the AIX detection was already done by 'aix_magic_present', I did
not want to duplicate it.  I can move the AIX detection logic to aix.c and
still keep the AIX protection for msdos.c with some more #ifdef's if you prefer.

Philippe
