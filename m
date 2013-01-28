Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab3A1Ro2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:44:28 -0500
Received: from smtp.citrix.com ([66.165.176.89]:40591 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576Ab3A1RoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:44:25 -0500
X-IronPort-AV: E=Sophos;i="4.84,553,1355097600"; 
   d="scan'208";a="5348031"
Date: Mon, 28 Jan 2013 17:44:22 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: KY Srinivasan <kys@microsoft.com>
CC: Olaf Hering <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jan Beulich (JBeulich@suse.com)" <JBeulich@suse.com>
Subject: RE: [PATCH] x86: Hyper-V: register clocksource only if its
 advertised
In-Reply-To: <542f1d12e3ee46f48a85a143361c113d@SN2PR03MB061.namprd03.prod.outlook.com>
Message-ID: <alpine.DEB.2.02.1301281737210.10432@kaball.uk.xensource.com>
References: <1359121036-16309-1-git-send-email-olaf@aepfle.de> <761b736ff1854810bfe272961248e6d2@BLUPR03MB050.namprd03.prod.outlook.com> <20130125165443.GA15833@aepfle.de> <500ca90f5d3e4d4f80c7fb62c34d36f0@BLUPR03MB050.namprd03.prod.outlook.com>
 <20130125171923.GA19306@aepfle.de> <542f1d12e3ee46f48a85a143361c113d@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2013, KY Srinivasan wrote:
> > -----Original Message-----
> > From: Olaf Hering [mailto:olaf@aepfle.de]
> > Sent: Friday, January 25, 2013 12:19 PM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; Greg KH; Jan Beulich (JBeulich@suse.com)
> > Subject: Re: [PATCH] x86: Hyper-V: register clocksource only if its advertised
> > 
> > On Fri, Jan 25, KY Srinivasan wrote:
> > 
> > > My fear is that there is no guarantee that Xen would not emulate this
> > > feature in the spirit of making Hyper-V emulation "more" complete.
> > > Since all this problem is because Xen thinks it is running a viridian
> > > domain (when in fact it is running Linux), I felt we should explore
> > > why the viridian tag got set for a Linux VM. If we can fix that we
> > > would have a solution that does not depend upon assuming that Xen
> > > would not emulate a particular Hyper-V feature.
> > 
> > In my opinion this logic is backwards. A host provides a set of
> > functionality/features to a given guest, no matter what runs inside the
> > guest. And the guest can query the feature list and configure itself
> > accordingly. In this specific case the guest finds feature A (the cpuid
> > result) and expects that feature B (a clock source) is present as well,
> > even if feature B has its very own availability flag.
> 
> I would agree with you in the abstract but not in this specific case. First,
> the current Hyper-V code in Linux verifies that the underlying hypervisor is
> Hyper-V and proceeds to setup state that is needed to run Linux on Hyper-V.
> If Xen were not emulating Hyper-V, we would not have any issue here. However,
> Xen does emulate Hyper-V and it is emulating Hyper-V not to run Linux, but to run
> enlightened Windows (making Windows think it is running on Hyper-V). We have a 
> mechanism in place for controlling this Hyper-V emulation in Xen - the viridian flag.
> In my view, ensuring that this flag is not set for a non -Windows guest is the only safe
> approach to dealing with this issue. Your current approach of using the "Partition Reference
> Counter" feature bit is very fragile. Let us assume that future Windows guests depend on this
> feature; Xen would certainly emulate this to have a "good" emulation of Hyper-V and we are
> back to square one.

I think that Olaf made his point very clear: a feature A should only be
enabled if the corresponding flag A is set.
In fact it seems to me that this patch is correct on its own merits,
regardless of Xen does or does not.

The Xen tools might or might not know whether a guest is going to be
Linux, Windows, FreeBSD or whatever else people use nowadays.  Setting
viridian=1 is the safe choice, given that it shouldn't create any
issues: after all guests are supposed to check for feature flags before
using them.

If Xen is going to implement "Partition Reference Counter", it is also
going to set the corresponding flag, so the guest OS (Windows, Linux,
my pet OS) can check whether the feature is available and decide whether
it wants to use it.
