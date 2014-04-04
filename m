Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaDDOvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:51:07 -0400
Received: from smtp.citrix.com ([66.165.176.89]:11143 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbaDDOvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:51:03 -0400
X-IronPort-AV: E=Sophos;i="4.97,795,1389744000"; 
   d="scan'208";a="118036947"
Message-ID: <1396623059.4211.255.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] grant-table, xen-netback: Introduce helper
 functions for grant copy operations
From: Ian Campbell <Ian.Campbell@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
CC: Paul Durrant <Paul.Durrant@citrix.com>,
        Zoltan Kiss <zoltan.kiss@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Davies <Jonathan.Davies@citrix.com>
Date: Fri, 4 Apr 2014 15:50:59 +0100
In-Reply-To: <533D2E8A.90101@citrix.com>
References: <1396458349-30112-1-git-send-email-zoltan.kiss@citrix.com>
	 <9AAE0902D5BC7E449B7C8E4E778ABCD02BB106@AMSPEX01CL01.citrite.net>
	 <533D2E8A.90101@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-03 at 10:48 +0100, David Vrabel wrote:
> On 03/04/14 09:12, Paul Durrant wrote:
> > Zoltan Kiss wrote:
> >>
> >> Create helper functions for grant copy operations and use them in netback.
> >>
> [...]
> >> --- a/drivers/net/xen-netback/netback.c
> >> +++ b/drivers/net/xen-netback/netback.c
> >> @@ -275,23 +275,29 @@ static void xenvif_gop_frag_copy(struct xenvif *vif,
> >> struct sk_buff *skb,
> >>  			bytes = MAX_BUFFER_OFFSET - npo->copy_off;
> >>
> >>  		copy_gop = npo->copy + npo->copy_prod++;
> >> -		copy_gop->flags = GNTCOPY_dest_gref;
> >> -		copy_gop->len = bytes;
> >>
> >>  		if (foreign_vif) {
> >> -			copy_gop->source.domid = foreign_vif->domid;
> >> -			copy_gop->source.u.ref = foreign_gref;
> >> -			copy_gop->flags |= GNTCOPY_source_gref;
> >> +			gnttab_set_copy_op_ref_to_ref(copy_gop,
> >> +						      foreign_gref,
> >> +						      npo->copy_gref,
> >> +						      foreign_vif->domid,
> >> +						      offset,
> >> +						      vif->domid,
> >> +						      npo->copy_off,
> >> +						      bytes,
> >> +						      GNTCOPY_dest_gref |
> >> +						      GNTCOPY_source_gref);
> > 
> > Can't you lose the flags here (and in the other variants)? Since
> > they are implied by the variant of the function they could just be hardcoded
> > there, couldn't they?
> 
> Even with that change these are still functions with 7 or 8 parameters
> with no obvious order.  That's just awful.  The open-coded struct
> initialization is better.

Yes, I think this was a failed experiment.

The original code would likely still be improvable by using a temporary
variable to hold "vif->tx_copy_ops[*copy_ops]", basically the way the
mapping ops are via mop->.

Ian.

