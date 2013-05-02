Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab3EBSEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:04:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27701 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759009Ab3EBSEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:04:36 -0400
Date: Thu, 2 May 2013 14:04:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>, Ian Campbell <ijc@hellion.org.uk>,
        "carsten@schiers.de" <carsten@schiers.de>,
        "darren.s.shepherd@gmail.com" <darren.s.shepherd@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Jackson <Ian.Jackson@eu.citrix.com>,
        "james-xen@dingwall.me.uk" <james-xen@dingwall.me.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Keir (Xen.org)" <keir@xen.org>, Dave.Scott@eu.citrix.com,
        Jonathan Ludlam <jonathan.ludlam@eu.citrix.com>
Subject: Re: [PATCH v2 2/2] xen/balloon: Enforce various limits on target
Message-ID: <20130502180404.GA16489@phenom.dumpdata.com>
References: <1367235468-8360-1-git-send-email-daniel.kiper@oracle.com>
 <1367235468-8360-3-git-send-email-daniel.kiper@oracle.com>
 <1367246649.3142.316.camel@zakaz.uk.xensource.com>
 <20130430125952.GD9904@debian70-amd64.local.net-space.pl>
 <1367329458.3142.524.camel@zakaz.uk.xensource.com>
 <20130430185852.GF9904@debian70-amd64.local.net-space.pl>
 <alpine.DEB.2.02.1305021214510.5398@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305021214510.5398@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 12:34:32PM +0100, Stefano Stabellini wrote:
> On Tue, 30 Apr 2013, Daniel Kiper wrote:
> > > > > > +/*
> > > > > > + * Extra internal memory reserved by libxl.
> > > > > > + * Check tools/libxl/libxl_memory.txt file in Xen source for more details.
> > > > > > + */
> > > > > > +#define LIBXL_MAXMEM_CONSTANT_PAGES	(1024 * 1024 / PAGE_SIZE)
> > > > >
> > > > > I think we need to find a way to achieve your aims which doesn't require
> > > > > leaking internal implementation details of libxl into the guest kernels.
> > > > > What happens if libxl decides to double this?
> > > >
> > > > I agree that this is not elegant solution. However, if we would like to
> > > > be in line with docs/misc/libxl_memory.txt (this is correct path) this
> > > > is a must.
> > >
> > > I'm not sure about this, that file describes the toolstacks view of the
> > > memory in a system. That need not necessarily correspond with the
> > > guest's ideas (although you would hope it would be a superset).
> > >
> > > Surely it is logically wrong to bake toolstack specific knowledge in the
> > > guest? If someone can describe a meaningful semantic for this number in
> > > a toolstack independent way then perhaps it would be appropriate to do
> > > something with it. I've no idea, having looked at both the document and
> > > the code, what this value actually is.
> > 
> > This was added by commit 9905ac2b90a3e7cecd9e7dfe21c252362e7080b2
> > (libxenlight: implement libxl_set_memory_target). It was written
> > by Keir and signed off by Stefano (both are CCed here). Guys,
> > why did you added LIBXL_MAXMEM_CONSTANT? What does it mean?
> 
> libxl inherits the memory model from xapi.
> LIBXL_MAXMEM_CONSTANT corresponds to "extra internal" in xapi, an amount
> of memory that is not allocated to the domain but it is left as a slack
> on top of the actual memory target to determine the Xen maxmem.
> I believe it comes from empirical measurements and stress testing on the
> platform.

What is this 'slack' used for?

> The xapi guys, CC'ed, might have more insights on what exactly is.
> 
> 
> I dislike having to pull this "hack" into Linux, but if it is actually
> important to leave LIBXL_MAXMEM_CONSTANT unused, then it is worth doing.
> I would add a big comment on top saying:
> 
> "libxl seems to think that we need to leave LIBXL_MAXMEM_CONSTANT
> kilobytes unused, let's be gentle and do that."
