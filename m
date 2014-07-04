Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbaGDUi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 16:38:26 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:53576 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759979AbaGDUiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 16:38:24 -0400
X-IronPort-AV: E=Sophos;i="5.01,603,1400018400"; 
   d="scan'208";a="83694071"
Date: Fri, 4 Jul 2014 22:38:21 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
cc: Himangi Saraogi <himangi774@gmail.com>,
        Vikas Chaudhary <vikas.chaudhary@qlogic.com>,
        "iscsi-driver@qlogic.com" <iscsi-driver@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] qla4xxx: Return -ENOMEM on memory allocation failure
In-Reply-To: <alpine.DEB.2.02.1407042235390.1984@localhost6.localdomain6>
Message-ID: <alpine.DEB.2.02.1407042237500.1984@localhost6.localdomain6>
References: <20140704182756.GA9319@himangi-Dell> <94D0CD8314A33A4D9D801C0FE68B402958B866EB@G9W0745.americas.hpqcorp.net> <alpine.DEB.2.02.1407042235390.1984@localhost6.localdomain6>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Jul 2014, Julia Lawall wrote:

> 
> 
> On Fri, 4 Jul 2014, Elliott, Robert (Server Storage) wrote:
> 
> > 
> > 
> > > -----Original Message-----
> > > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > > owner@vger.kernel.org] On Behalf Of Himangi Saraogi
> > > Sent: Friday, 04 July, 2014 1:28 PM
> > > To: Vikas Chaudhary; iscsi-driver@qlogic.com; James E.J. Bottomley; linux-
> > > scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> > > Cc: julia.lawall@lip6.fr
> > > Subject: [PATCH] qla4xxx: Return -ENOMEM on memory allocation failure
> > > 
> > > In this code, 0 is returned on memory allocation failure, even though
> > > other failures return -ENOMEM or other similar values.
> > > 
> > > A simplified version of the Coccinelle semantic match that finds this
> > > problem is as follows:
> > > 
> > > // <smpl>
> > > @@
> > > expression ret;
> > > expression x,e1,e2,e3;
> > > identifier alloc;
> > > @@
> > > 
> > > ret = 0
> > > ... when != ret = e1
> > > *x = alloc(...)
> > > ... when != ret = e2
> > > if (x == NULL) { ... when != ret = e3
> > >   return ret;
> > > }
> > > // </smpl>
> > > 
> > > Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> > > Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> > > ---
> > >  drivers/scsi/qla4xxx/ql4_os.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> > > index c5d9564..72ba671 100644
> > > --- a/drivers/scsi/qla4xxx/ql4_os.c
> > > +++ b/drivers/scsi/qla4xxx/ql4_os.c
> > > @@ -1050,6 +1050,7 @@ static int qla4xxx_get_host_stats(struct Scsi_Host
> > > *shost, char *buf, int len)
> > >  	if (!ql_iscsi_stats) {
> > >  		ql4_printk(KERN_ERR, ha,
> > >  			   "Unable to allocate memory for iscsi stats\n");
> > > +		ret = -ENOMEM;
> > >  		goto exit_host_stats;
> > >  	}
> > > 
> > 
> > Also, the only caller of this function doesn't use the return 
> > value - it's overwritten by another function call:
> > 
> > drivers/scsi/scsi_transport_iscsi.c:
> >                 err = transport->get_host_stats(shost, buf, host_stats_size);
> > 
> >                 actual_size = nlmsg_total_size(sizeof(*ev) + host_stats_size);
> >                 skb_trim(skbhost_stats, NLMSG_ALIGN(actual_size));
> >                 nlhhost_stats->nlmsg_len = actual_size;
> > 
> >                 err = iscsi_multicast_skb(skbhost_stats, ISCSI_NL_GRP_ISCSID,
> >                                           GFP_KERNEL);
> 
> Maybe that is intentional?  If get_host_stats fails, eg because of a lack 
> of memory, the worst that will happen is that a region of the buffer will 
> be 0.  If the loop is done again, there seems to be a risk of an infinite 
> loop.

Or one could jump out of the function completely, as on failure of 
alloc_skb.

julia
