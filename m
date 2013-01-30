Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab3A3Qxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 11:53:32 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53644 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753737Ab3A3Qxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 11:53:30 -0500
Message-ID: <1359564809.32305.23.camel@joe-AO722>
Subject: Re: coccinelle and bitmask arithmetic
From: Joe Perches <joe@perches.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Julia Lawall <julia.lawall@lip6.fr>, walter harms <wharms@bfs.de>,
        Mike Rapoport <mike@compulab.co.il>, Valdis.Kletnieks@vt.edu,
        cocci@systeme.lip6.fr, Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Fulghum <paulkf@microgate.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Wed, 30 Jan 2013 08:53:29 -0800
In-Reply-To: <20130130113533.GI23505@n2100.arm.linux.org.uk>
References: <20130127194039.GA18787@elgon.mountain>
	 <1359317078.14406.12.camel@joe-AO722> <20130127201947.GO16282@mwanda>
	 <9561.1359474916@turing-police.cc.vt.edu>
	 <1359475998.4196.26.camel@joe-AO722>
	 <alpine.DEB.2.02.1301291847070.3339@hadrien>
	 <1359482637.15135.7.camel@joe-AO722> <5108D808.6010405@bfs.de>
	 <20130130111420.GG23505@n2100.arm.linux.org.uk>
	 <alpine.DEB.2.02.1301301220290.1990@hadrien>
	 <20130130113533.GI23505@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-30 at 11:35 +0000, Russell King - ARM Linux wrote:
> On Wed, Jan 30, 2013 at 12:21:21PM +0100, Julia Lawall wrote:
> > On Wed, 30 Jan 2013, Russell King - ARM Linux wrote:
> > > So, _either_ logical OR or addition works.
> > >
> > > If we _did_ end up with a PHYS_OFFSET with bits less than bit 26 set
> > > here, we'd have bigger problems - because the base of RAM in PCI space
> > > will not correspond with PHYS_OFFSET and all the DMA mapping stuff breaks.
> > 
> > The "problem" is that the computation is done inconsistently within the
> > same file.  Sometimes with + and sometimes with |.
> 
> And I say that is not a problem; if it _does_ become a problem, there are
> bigger problems that would also need solving, which given a multi-subarch
> kernel become a lot lot harder.
> 
> Sure, we can just change them to all be a bitwise OR (sorry, not logical)
> but that's really only half the story.

As far as I can tell, there'd be a lot of +'s to
change in arch/arm and only 2 uses of | in it8152.c

$ git grep -P "\(?\s*SZ_\d+[A-Z]\s*-\s*1\s*\)?\s*\|" arch/arm
arch/arm/common/it8152.c:                       *dev->dma_mask = (SZ_64M - 1) | PHYS_OFFSET;
arch/arm/common/it8152.c:               dev->coherent_dma_mask = (SZ_64M - 1) | PHYS_OFFSET;

$ git grep -P "\+\s*\(?\s*SZ_\d+[A-Z]\b\s*-\s*1\s*\)?" arch/arm | wc -l
460

I think consistently using + would make it simpler
for some possible future conversion.

