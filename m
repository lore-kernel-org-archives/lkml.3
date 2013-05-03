Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448Ab3ECIPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:15:39 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:52355 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab3ECIPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:15:35 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363132800"; 
   d="scan'208";a="4193762"
Message-ID: <1367568932.28742.19.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v2 2/2] xen/balloon: Enforce various limits
 on target
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Keir (Xen.org)" <keir@xen.org>, Dave Scott <Dave.Scott@eu.citrix.com>,
        "james-xen@dingwall.me.uk" <james-xen@dingwall.me.uk>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Ian Jackson <Ian.Jackson@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jonathan Ludlam" <Jonathan.Ludlam@eu.citrix.com>,
        "darren.s.shepherd@gmail.com" <darren.s.shepherd@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "carsten@schiers.de" <carsten@schiers.de>
Date: Fri, 3 May 2013 09:15:32 +0100
In-Reply-To: <20130502180404.GA16489@phenom.dumpdata.com>
References: <1367235468-8360-1-git-send-email-daniel.kiper@oracle.com>
	 <1367235468-8360-3-git-send-email-daniel.kiper@oracle.com>
	 <1367246649.3142.316.camel@zakaz.uk.xensource.com>
	 <20130430125952.GD9904@debian70-amd64.local.net-space.pl>
	 <1367329458.3142.524.camel@zakaz.uk.xensource.com>
	 <20130430185852.GF9904@debian70-amd64.local.net-space.pl>
	 <alpine.DEB.2.02.1305021214510.5398@kaball.uk.xensource.com>
	 <20130502180404.GA16489@phenom.dumpdata.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 19:04 +0100, Konrad Rzeszutek Wilk wrote:
> On Thu, May 02, 2013 at 12:34:32PM +0100, Stefano Stabellini wrote:
> > On Tue, 30 Apr 2013, Daniel Kiper wrote:
> > > > > > > +/*
> > > > > > > + * Extra internal memory reserved by libxl.
> > > > > > > + * Check tools/libxl/libxl_memory.txt file in Xen source for more details.
> > > > > > > + */
> > > > > > > +#define LIBXL_MAXMEM_CONSTANT_PAGES	(1024 * 1024 / PAGE_SIZE)
> > > > > >
> > > > > > I think we need to find a way to achieve your aims which doesn't require
> > > > > > leaking internal implementation details of libxl into the guest kernels.
> > > > > > What happens if libxl decides to double this?
> > > > >
> > > > > I agree that this is not elegant solution. However, if we would like to
> > > > > be in line with docs/misc/libxl_memory.txt (this is correct path) this
> > > > > is a must.
> > > >
> > > > I'm not sure about this, that file describes the toolstacks view of the
> > > > memory in a system. That need not necessarily correspond with the
> > > > guest's ideas (although you would hope it would be a superset).
> > > >
> > > > Surely it is logically wrong to bake toolstack specific knowledge in the
> > > > guest? If someone can describe a meaningful semantic for this number in
> > > > a toolstack independent way then perhaps it would be appropriate to do
> > > > something with it. I've no idea, having looked at both the document and
> > > > the code, what this value actually is.
> > > 
> > > This was added by commit 9905ac2b90a3e7cecd9e7dfe21c252362e7080b2
> > > (libxenlight: implement libxl_set_memory_target). It was written
> > > by Keir and signed off by Stefano (both are CCed here). Guys,
> > > why did you added LIBXL_MAXMEM_CONSTANT? What does it mean?
> > 
> > libxl inherits the memory model from xapi.
> > LIBXL_MAXMEM_CONSTANT corresponds to "extra internal" in xapi, an amount
> > of memory that is not allocated to the domain but it is left as a slack
> > on top of the actual memory target to determine the Xen maxmem.
> > I believe it comes from empirical measurements and stress testing on the
> > platform.
> 
> What is this 'slack' used for?

Did you read Stefano's next sentence?

> > The xapi guys, CC'ed, might have more insights on what exactly is.

I think that unless someone can remember what this issue was we should
just chalk it up to a historical artefact of something xapi (or maybe
some historical guest) was doing which we have no reason to believe
needs to be carried over to libxl.

IOW I'm suggesting we set LIBXL_MAXMEM_CONSTANT to 0 early in the 4.4
cycle and see how it goes. If someone can show either empirical evidence
or (better) logically argue that a fudge is required then we can always
put it back (or it may turn out to be the caller's issue, in which case
they can deal with it, hopefully xapi-on-libxl won't apply this fudge
twice...).

Alternatively I'm also strongly considering having debug builds of the
toolstack randomise the amount of slack, that ought to shake out any
lingering issues...

> > I dislike having to pull this "hack" into Linux, but if it is actually
> > important to leave LIBXL_MAXMEM_CONSTANT unused, then it is worth doing.
> > I would add a big comment on top saying:
> > 
> > "libxl seems to think that we need to leave LIBXL_MAXMEM_CONSTANT
> > kilobytes unused, let's be gentle and do that."

It seems to me that this change in Linux is really just papering over
the underlying issue. Or at the very least no one has adequately
explained what that real issue is and why this change is relevant to it
and/or an appropriate fix for it.

The guest knows what target the toolstack has set for it is (its in the
target xenstore node), I don't see any reason for the guest to be
further second guessing that value by examining maxmem (adjusted by a
fudge factor or otherwise). If the guest is seeing failures to increase
its reservation when trying to meet that target then either the
toolstack was buggy in asking it to hit a target greater than its maxmem
or it is hitting one of the other reason for increase reservation
failures. Since it needs to deal with the latter anyway I don't see any
reason to special case maxmem as a cause for a failure.

Ian.

