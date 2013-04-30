Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505Ab3D3S7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:59:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46674 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933302Ab3D3S7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:59:32 -0400
Date: Tue, 30 Apr 2013 20:58:52 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: "carsten@schiers.de" <carsten@schiers.de>,
        "darren.s.shepherd@gmail.com" <darren.s.shepherd@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Jackson <Ian.Jackson@eu.citrix.com>,
        "james-xen@dingwall.me.uk" <james-xen@dingwall.me.uk>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        keir@xen.org, stefano.stabellini@eu.citrix.com
Subject: Re: [PATCH v2 2/2] xen/balloon: Enforce various limits on target
Message-ID: <20130430185852.GF9904@debian70-amd64.local.net-space.pl>
References: <1367235468-8360-1-git-send-email-daniel.kiper@oracle.com>
 <1367235468-8360-3-git-send-email-daniel.kiper@oracle.com>
 <1367246649.3142.316.camel@zakaz.uk.xensource.com>
 <20130430125952.GD9904@debian70-amd64.local.net-space.pl>
 <1367329458.3142.524.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367329458.3142.524.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 02:44:18PM +0100, Ian Campbell wrote:
> On Tue, 2013-04-30 at 13:59 +0100, Daniel Kiper wrote:
> > On Mon, Apr 29, 2013 at 03:44:09PM +0100, Ian Campbell wrote:
> > > On Mon, 2013-04-29 at 12:37 +0100, Daniel Kiper wrote:
> > >
> > > > This patch enforces on target limit statically defined in Linux Kernel
> > > > source and limit defined by hypervisor or host. This way the balloon
> > > > driver should not attempt to populate pages above given limits
> > > > because they may fail.
> > > >
> > > > Particularly this patch fixes bug which led to flood
> > > > of dom0 kernel log with messages similar to:
> > > >
> > > > System RAM resource [mem 0x1b8000000-0x1bfffffff] cannot be added
> > > > xen_balloon: reserve_additional_memory: add_memory() failed: -17
> > >
> > > I think it would be OK to simply tone down this message (and perhaps add
> > > the failed pages to the balloon, if that makes sense). This isn't
> > > dissimilar to increase_reservation failing.
> >
> > If add_memory() fails it is hard error. It means that we do not
> > know where new or ballooned pages should be placed.
>
> I see that add_memory() is a generic or arch level function rather than
> a ballooning specific one. Under what circumstances can it fail and how
> do they relate the the setting of the balloon target?

It is generic function with some references to arch code. It is called
when pages could not be taken from balloon any more and must be hotplugged.
It reserves memory resource (start address and size is calculated on the
base of target and max_pfn) and build some structures for new memory.
It may fail in many places. In this case it failed because placement
of new resource was incorrectly calculated because algorithm is very
simple and not cover all cases. I am going to fix this issue but
a bit later. However, first of all memory hotplug should not be
activated because memory allocation limit was reached in this case.
This patch solves this issue.

> > > > +/*
> > > > + * Extra internal memory reserved by libxl.
> > > > + * Check tools/libxl/libxl_memory.txt file in Xen source for more details.
> > > > + */
> > > > +#define LIBXL_MAXMEM_CONSTANT_PAGES	(1024 * 1024 / PAGE_SIZE)
> > >
> > > I think we need to find a way to achieve your aims which doesn't require
> > > leaking internal implementation details of libxl into the guest kernels.
> > > What happens if libxl decides to double this?
> >
> > I agree that this is not elegant solution. However, if we would like to
> > be in line with docs/misc/libxl_memory.txt (this is correct path) this
> > is a must.
>
> I'm not sure about this, that file describes the toolstacks view of the
> memory in a system. That need not necessarily correspond with the
> guest's ideas (although you would hope it would be a superset).
>
> Surely it is logically wrong to bake toolstack specific knowledge in the
> guest? If someone can describe a meaningful semantic for this number in
> a toolstack independent way then perhaps it would be appropriate to do
> something with it. I've no idea, having looked at both the document and
> the code, what this value actually is.

This was added by commit 9905ac2b90a3e7cecd9e7dfe21c252362e7080b2
(libxenlight: implement libxl_set_memory_target). It was written
by Keir and signed off by Stefano (both are CCed here). Guys,
why did you added LIBXL_MAXMEM_CONSTANT? What does it mean?

Daniel
