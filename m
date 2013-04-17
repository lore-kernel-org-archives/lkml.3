Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966483Ab3DQOAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:00:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33011 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966234Ab3DQOAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:00:44 -0400
Date: Wed, 17 Apr 2013 10:00:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH v1 2/7] xen-blkback: use balloon pages for all mappings
Message-ID: <20130417140035.GC21378@phenom.dumpdata.com>
References: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
 <1364382643-3711-3-git-send-email-roger.pau@citrix.com>
 <20130409144733.GA3158@phenom.dumpdata.com>
 <516BB4C6.8090101@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516BB4C6.8090101@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> /*
>  * No need to set unmap_seg bit, since
>  * we can not unmap this grant because
>  * the handle is invalid.
>  */
> 
> > 
> > But then that begs the question - why do we even need the bitmap_set code path anymore?
> 
> To know which grants are mapped persistenly, so we don't unmap them in
> xen_blkbk_unmap.

Aha! I missed that part.
> 
> >>               }
> >> -             if (persistent_gnts[i]) {
> >> -                     if (persistent_gnts[i]->handle ==
> >> -                         BLKBACK_INVALID_HANDLE) {
> >> +             if (persistent_gnts[i])
> >> +                     goto next;
> >> +             if (use_persistent_gnts &&
> >> +                 blkif->persistent_gnt_c <
> >> +                 max_mapped_grant_pages(blkif->blk_protocol)) {
> >> +                     /*
> >> +                      * We are using persistent grants, the grant is
> >> +                      * not mapped but we have room for it
> >> +                      */
> >> +                     persistent_gnt = kmalloc(sizeof(struct persistent_gnt),
> >> +                                              GFP_KERNEL);
> >> +                     if (!persistent_gnt) {
> >>                               /*
> >> -                              * If this is a new persistent grant
> >> -                              * save the handler
> >> +                              * If we don't have enough memory to
> >> +                              * allocate the persistent_gnt struct
> >> +                              * map this grant non-persistenly
> >>                                */
> >> -                             persistent_gnts[i]->handle = map[j++].handle;
> >> +                             j++;
> >> +                             goto next;
> > 
> > So you are doing this by assuming that get_persistent_gnt in the earlier loop
> > failed, which means you have in effect done this:
> >         map[segs_to_map++]
> > 
> > Doing the next label will set:
> >                 seg[i].offset = (req->u.rw.seg[i].first_sect << 9);
> > 
> > OK, that sounds right. Is this then:
> > 
> >         bitmap_set(pending_req->unmap_seg, i, 1);
> > 
> > even needed? The "pending_handle(pending_req, i) = map[j].handle;" had already been
> > done in the  /* This is a newly mapped grant */ if case, so we are set there.
> 
> We need to mark this grant as non-persistent, so we unmap it on
> xen_blkbk_unmap.

And then this makes sense.
> 
> > 
> > Perhaps you could update the comment from saying 'map this grant' (which
> > implies doing it NOW as opposed to have done it already), and say:
> > 
> > /*
> > .. continue using the grant non-persistently. Note that
> > we mapped it in the earlier loop and the earlier if conditional
> > sets pending_handle(pending_req, i) = map[j].handle.
> > */
> > 
> > 
> > 
> >>                       }
> >> -                     pending_handle(pending_req, i) =
> >> -                             persistent_gnts[i]->handle;
> >> -
> >> -                     if (ret)
> >> -                             continue;
> >> -             } else {
> >> -                     pending_handle(pending_req, i) = map[j++].handle;
> >> -                     bitmap_set(pending_req->unmap_seg, i, 1);
> >> -
> >> -                     if (ret)
> >> -                             continue;
> >> +                     persistent_gnt->gnt = map[j].ref;
> >> +                     persistent_gnt->handle = map[j].handle;
> >> +                     persistent_gnt->page = pages[i];
> > 
> > Oh boy, that is a confusing. i and j. Keep loosing track which one is which.
> > It lookis right.
> > 
> >> +                     if (add_persistent_gnt(&blkif->persistent_gnts,
> >> +                                            persistent_gnt)) {
> >> +                             kfree(persistent_gnt);
> > 
> > I would also say 'persisten_gnt = NULL' for extra measure of safety
> 
> Done.
> 
> > 
> > 
> >> +                             j++;
> > 
> > Perhaps the 'j' variable can be called 'map_idx' ? By this point I am pretty
> > sure I know what the 'i' and 'j' variables are used for, but if somebody new
> > is trying to grok this code they might spend some 5 minutes trying to figure
> > this out.
> 
> Yes, I agree that i and j are not the best names, I propose to call j
> new_map_idx, and i seg_idx.

Sounds good.
