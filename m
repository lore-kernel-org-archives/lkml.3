Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbaICUxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:53:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51797 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaICUxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:53:21 -0400
Date: Wed, 3 Sep 2014 13:53:13 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: <boris.ostrovsky@oracle.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [V2 PATCH 1/1] PVH: set EFER.NX and EFER.SCE
Message-ID: <20140903135313.04535452@mantra.us.oracle.com>
In-Reply-To: <54071E6C.4080901@citrix.com>
References: <1409707176-16487-1-git-send-email-mukesh.rathor@oracle.com>
	<1409707176-16487-2-git-send-email-mukesh.rathor@oracle.com>
	<54071E6C.4080901@citrix.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2014 14:58:04 +0100
David Vrabel <david.vrabel@citrix.com> wrote:

> On 03/09/14 02:19, Mukesh Rathor wrote:
> > This patch addresses two things for a pvh boot vcpu:
> > 
> >   - NX bug on intel: It was recenlty discovered that NX is not being
> >     honored in PVH on intel since EFER.NX is not being set.
> > 
> >   - PVH boot hang on newer xen:  Following c/s on xen
> > 
> >         c/s 7645640:  x86/PVH: don't set EFER_SCE for pvh guest
> > 
> >     removes setting of EFER.SCE for PVH guests. As such, existing
> > intel pvh guest will no longer boot on xen after that c/s.
> > 
> > Both above changes will be applicable to AMD also when xen support
> > of AMD pvh is added.
> > 
> > Also, we create a new glue assembly entry point for secondary vcpus
> > because they come up on kernel page tables that have pte.NX
> > bits set. As such, before anything is touched in DS/SS, EFER.NX
> > must be set.
> [...]
> > --- a/arch/x86/xen/xen-head.S
> > +++ b/arch/x86/xen/xen-head.S
> > @@ -47,6 +47,35 @@ ENTRY(startup_xen)
> >  
> >  	__FINIT
> >  
> > +#ifdef CONFIG_XEN_PVH
> > +#ifdef CONFIG_X86_64
> > +.macro PVH_EARLY_SET_EFER
> 
> I don't think a macro is the right way to do this.  We can instead
> pass a parameter to say whether it is a boot or secondary CPU.
> 
> Something like this (untested) patch?

That's fine too. But, since vcpu 0 is always primary vcpu, we can
just use that and not worry about passing another parameter.

-Mukesh

