Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbaJ1Jvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:51:43 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26044 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbaJ1Jvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:51:41 -0400
X-IronPort-AV: E=Sophos;i="5.04,801,1406592000"; 
   d="scan'208";a="186791634"
Message-ID: <1414489898.23883.25.camel@citrix.com>
Subject: Re: [Xen-devel] [PATCH 0/2] xen: Switch to virtual mapped linear
 p2m list
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Juergen Gross <jgross@suse.com>
CC: David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>
Date: Tue, 28 Oct 2014 09:51:38 +0000
In-Reply-To: <544F22E4.9040706@suse.com>
References: <1414421551-31555-1-git-send-email-jgross@suse.com>
	 <544E61DD.8050305@citrix.com> <544F22E4.9040706@suse.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 06:00 +0100, Juergen Gross wrote:
> On 10/27/2014 04:16 PM, David Vrabel wrote:
> > On 27/10/14 14:52, Juergen Gross wrote:
> >> Paravirtualized kernels running on Xen use a three level tree for
> >> translation of guest specific physical addresses to machine global
> >> addresses. This p2m tree is used for construction of page table
> >> entries, so the p2m tree walk is performance critical.
> >>
> >> By using a linear virtual mapped p2m list accesses to p2m elements
> >> can be sped up while even simplifying code. To achieve this goal
> >> some p2m related initializations have to be performed later in the
> >> boot process, as the final p2m list can be set up only after basic
> >> memory management functions are available.
> >
> > What impact does this have on 32-bit guests which don't have huge amount
> > of virtual address space?
> >
> > I think a 32-bit guest could have up to 64 GiB of PFNs, which would
> > require a 128 MiB p2m array, which is too large?
> 
> It is 64 MB (one entry on 32 bit is 32 bits :-) ).
> 
> With a m2p array of only 16 MB size I doubt a 32 bit guest can be larger
> than 16 GB, or am I wrong here?

I think they can be bigger, the compat r/o m2p is 168MB, since Xen
doesn't need to be in the hole as well (like it was with a real 32-bit
Xen). There is also some scope for dynamic sizing of the hole (queried
via XENMEM_machphys_mapping), I'm not sure if pvops makes use of that
though.

In practice a 32-bit kernel starts to get pretty unhappy somewhere
between 32 and 64GB because it runs out of low memory for various
structures which are sized according to the amount of RAM. Or it did,
it's been years since I've tried, maybe things are more able to use
highmem now. In any case if you have such large amounts of RAM using a
64-bit kernel would be advisable.

Ian.

