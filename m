Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3C0DYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 23:24:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755996Ab3C0DYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 23:24:01 -0400
Message-ID: <1364354635.24132.743.camel@bling.home>
Subject: Re: [PATCH 1/2] vfio-pci: Use byte granularity in config map
From: Alex Williamson <alex.williamson@redhat.com>
To: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date: Tue, 26 Mar 2013 21:23:55 -0600
In-Reply-To: <20130327023525.GA19001@shangw.(null)>
References: <20130326180454.27467.7011.stgit@bling.home>
	 <20130326181703.27467.45144.stgit@bling.home>
	 <20130327023525.GA19001@shangw.(null)>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 10:35 +0800, Gavin Shan wrote:
> On Tue, Mar 26, 2013 at 12:17:03PM -0600, Alex Williamson wrote:
> >The config map previously used a byte per dword to map regions of
> >config space to capabilities.  Modulo a bug where we round the length
> >of capabilities down instead of up, this theoretically works well and
> >saves space so long as devices don't try to hide registers in the gaps
> >between capabilities.  Unfortunately they do exactly that so we need
> >byte granularity on our config space map.  Increase the allocation of
> >the config map and split accesses at capability region boundaries.
> >
> 
> Alex, one question that isn't related to the patch: With current implementation,
> (pdev->cfg_size) bytes are used for capability bits. That's really waste of
> memory because the memory for specific capability will be reserved even though
> that capability can't be supported by the device. I'm not sure the following scheme
> is workable in order to save more memory for that?
> 
> Organize the config space using RB-tree by following struct. The benefit would be
> we won't reserve memory for those unsupported capabilities.
> 
> struct pci_cap_map {
>         struct rb_node rb_node;
> 	unsigned short start;	/* Start position */
> 	unsigned short end;	/* End position   */
> 	unsigned short cap_id;	/* Capability ID  */
> };

I would definitely like to see some kind of data structure make this
more efficient.  The map obviously gives us direct indexing and if we
just look at legacy config space, it's often tightly packed.  256 bytes
vs (30 bytes * num_capability_regions) is nearly even on overall size.
The extended config space is where space efficiency falls apart.  We
don't actually have that many elements to track either, maybe up to a
dozen.  A sorted list would make the structure size half that of the
tree.  We could even use two lists to split legacy vs extended.
Interested in working on it?  Thanks,

Alex

