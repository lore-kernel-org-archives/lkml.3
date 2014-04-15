Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaDOTdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:33:51 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:35476 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbaDOTdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:33:49 -0400
Date: Tue, 15 Apr 2014 15:37:03 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Christoph Lameter <cl@linux.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, srivasta@debian.org
Subject: Re: [bisected] broken make-kpkg kernel build in 3.15-rc1
In-Reply-To: <alpine.DEB.2.10.1404151530050.15528@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1404151535530.15528@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1404150940250.14106@vincent-weaver-1.um.maine.edu> <534D4A59.6080401@suse.cz> <alpine.DEB.2.10.1404151146530.26562@gentwo.org> <534D6510.3070509@suse.cz> <alpine.DEB.2.10.1404151221360.26992@gentwo.org> <20140415182653.GR24070@n2100.arm.linux.org.uk>
 <alpine.DEB.2.10.1404151507290.15528@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404151530050.15528@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Vince Weaver wrote:

> On Tue, 15 Apr 2014, Vince Weaver wrote:
> 
> > On Tue, 15 Apr 2014, Russell King - ARM Linux wrote:
> > 
> > > Right, so the thing to do is to run a build with the commit applied,
> > > without any -j arguments and V=1, logging the output (so that predictable
> > > output can be generated).
> > > 
> > > Then run the same thing with the commit reverted, again logging it.  Then
> > > diff the two and see what's different.
> > 
> > OK, I captured the output.  No diffs, as of course reverting things
> > means one kernel was called 3.15-rc1 and one 3.15-rc1+ which meant more or 
> > less every line changed.
> > 
> > It seems that on stock 3.15-rc1 (which fails to build) after running 
> > depmod it kicks into
> > 
> > 	restore_upstream_debianization
> > 
> > which goes down a path which causes the file permission failures
> > 
> > Wheras 3.15-rc1 with the problem commit reverted this doesn't happen.
> > 
> > This is a really weird bug, I've tried reverting individual hunks of the 
> > problem commit manually and it is not clear at all to me what is 
> > triggering this.
> 
> OK, in debian/image.mk we have this:
> 
>   ifeq ($(strip $(HAVE_INST_PATH)),)
>         test ! -f System.map ||  cp System.map                         \
>                         $(TMPTOP)/$(IMAGEDIR)/System.map-$(KERNELRELEASE);
>         test ! -f System.map ||  chmod 644                             \
>                         $(TMPTOP)/$(IMAGEDIR)/System.map-$(KERNELRELEASE);
>         cp $(kimagesrc) $(kimagedest)
>   else
>         $(restore_upstream_debianization)
>         $(MAKE) $(EXTRAV_ARG) INSTALL_MOD_PATH=$(INSTALL_MOD_PATH)           \
>                 INSTALL_FW_PATH=$(INSTALL_MOD_PATH)/lib/firmware/$(KERNELRELEASE)  \
>                 INSTALL_PATH=$(INT_IMAGE_DESTDIR) $(CROSS_ARG) $(KPKG_KBUILD_INSTALL_TARGET)
>   endif
> 
> 
> So in the good case it goes down the if, in the bad case down the else.
> 
> 
> I'm assuming that the ($(strip $(HAVE_INST_PATH)),) is being confused by
> the INSTALL_DTBS_PATH introduced by the changeset.
> 
> So I guess that makes this a debian bug?

And it looks like this was reported to the list earlier and I somehow 
missed it :(

https://lkml.org/lkml/2014/4/3/333

Vince
