Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762531Ab3ECNrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 09:47:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31642 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762035Ab3ECNrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 09:47:31 -0400
Date: Fri, 3 May 2013 15:47:04 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Keir (Xen.org)" <keir@xen.org>, Dave Scott <Dave.Scott@eu.citrix.com>,
        "james-xen@dingwall.me.uk" <james-xen@dingwall.me.uk>,
        Ian Jackson <Ian.Jackson@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Ludlam <Jonathan.Ludlam@eu.citrix.com>,
        "darren.s.shepherd@gmail.com" <darren.s.shepherd@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "carsten@schiers.de" <carsten@schiers.de>
Subject: Re: [Xen-devel] [PATCH v2 2/2] xen/balloon: Enforce various limits
 on target
Message-ID: <20130503134704.GB12463@debian70-amd64.local.net-space.pl>
References: <1367235468-8360-3-git-send-email-daniel.kiper@oracle.com>
 <1367246649.3142.316.camel@zakaz.uk.xensource.com>
 <20130430125952.GD9904@debian70-amd64.local.net-space.pl>
 <1367329458.3142.524.camel@zakaz.uk.xensource.com>
 <20130430185852.GF9904@debian70-amd64.local.net-space.pl>
 <alpine.DEB.2.02.1305021214510.5398@kaball.uk.xensource.com>
 <20130502180404.GA16489@phenom.dumpdata.com>
 <1367568932.28742.19.camel@zakaz.uk.xensource.com>
 <20130503130036.GA12463@debian70-amd64.local.net-space.pl>
 <1367587284.28742.89.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367587284.28742.89.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 02:21:24PM +0100, Ian Campbell wrote:
> On Fri, 2013-05-03 at 14:00 +0100, Daniel Kiper wrote:
> > On Fri, May 03, 2013 at 09:15:32AM +0100, Ian Campbell wrote:
> > > On Thu, 2013-05-02 at 19:04 +0100, Konrad Rzeszutek Wilk wrote:
> > > > On Thu, May 02, 2013 at 12:34:32PM +0100, Stefano Stabellini wrote:
> >
> > [...]
> >
> > > > > The xapi guys, CC'ed, might have more insights on what exactly is.
> > >
> > > I think that unless someone can remember what this issue was we should
> > > just chalk it up to a historical artefact of something xapi (or maybe
> > > some historical guest) was doing which we have no reason to believe
> > > needs to be carried over to libxl.
> > >
> > > IOW I'm suggesting we set LIBXL_MAXMEM_CONSTANT to 0 early in the 4.4
> > > cycle and see how it goes. If someone can show either empirical evidence
> > > or (better) logically argue that a fudge is required then we can always
> > > put it back (or it may turn out to be the caller's issue, in which case
> > > they can deal with it, hopefully xapi-on-libxl won't apply this fudge
> > > twice...).
> > >
> > > Alternatively I'm also strongly considering having debug builds of the
> > > toolstack randomise the amount of slack, that ought to shake out any
> > > lingering issues...
> >
> > Do you suggest to postopone this work until 4.4 merge window?
>
> 4.4 is a Xen version, this is a Linux patch so I'm not sure what you
> mean.

I thought about my libxl patches. Should I post new version without
LIBXL_MAXMEM_CONSTANT when 4.4 merge window open?

> > If yes, then I think that at least "xen/balloon: Enforce various limits on target"
> > patch (without this crazy libxl hack) should be applied.
>
> You mean this patch with only the MAX_DOMAIN_PAGES clamping? That seems
> plausible.

... and with XENMEM_maximum_reservation check but wihtout LIBXL_MAXMEM_CONSTANT_PAGES.

> > > > > I dislike having to pull this "hack" into Linux, but if it is actually
> > > > > important to leave LIBXL_MAXMEM_CONSTANT unused, then it is worth doing.
> > > > > I would add a big comment on top saying:
> > > > >
> > > > > "libxl seems to think that we need to leave LIBXL_MAXMEM_CONSTANT
> > > > > kilobytes unused, let's be gentle and do that."
> > >
> > > It seems to me that this change in Linux is really just papering over
> > > the underlying issue. Or at the very least no one has adequately
> > > explained what that real issue is and why this change is relevant to it
> > > and/or an appropriate fix for it.
> > >
> > > The guest knows what target the toolstack has set for it is (its in the
> > > target xenstore node), I don't see any reason for the guest to be
> > > further second guessing that value by examining maxmem (adjusted by a
> > > fudge factor or otherwise). If the guest is seeing failures to increase
> > > its reservation when trying to meet that target then either the
> > > toolstack was buggy in asking it to hit a target greater than its maxmem
> > > or it is hitting one of the other reason for increase reservation
> > > failures. Since it needs to deal with the latter anyway I don't see any
> > > reason to special case maxmem as a cause for a failure.
> >
> > Do not forget that guest may change target itself.
>
> Yes it can, and that can fail either due to maxmem or due to ENOMEM, and
> the kernel needs prepared to deal with that when it happens.

Sure but why we would like to fail in endless loop if maxmem case
could be easliy detected by checking XENMEM_maximum_reservation?

> > Additionally, we would like to introduce xm compatibility
> > mode which is a bit different then xl normal behavior.
>
> When then you really don't want to be baking specifics of the current
> model into the kernel, do you.

Hmmm... Little misunderstanding. As I stated a few times I do not
want bake any libxl or Xen stuff into Linux Kernel (including
LIBXL_MAXMEM_CONSTANT). I just want to check limits which I think
make sense in this case.

> > I do not mention that it is always worth check the limits.
> > It will save us a lot of trouble later.
>
> On the contrary, it seems to me that baking magic numbers into the
> kernel based on current toolstack behaviour is asking for trouble later.

Ditto...

Daniel
