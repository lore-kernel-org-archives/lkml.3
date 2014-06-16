Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaFPXoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 19:44:09 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:47600 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaFPXoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 19:44:06 -0400
Date: Mon, 16 Jun 2014 16:44:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Steve Wise <swise@opengridcomputing.com>
cc: Nicholas Krause <xerofoify@gmail.com>, swise@chelsio.com,
        roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] infiniband: Fixes memory leak in send_flowc
In-Reply-To: <539F34E8.3000501@opengridcomputing.com>
Message-ID: <alpine.DEB.2.02.1406161638360.21018@chino.kir.corp.google.com>
References: <1402940957-6381-1-git-send-email-xerofoify@gmail.com> <539F34E8.3000501@opengridcomputing.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Steve Wise wrote:

> On 6/16/2014 12:49 PM, Nicholas Krause wrote:
> > Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> > ---
> >   drivers/infiniband/hw/cxgb4/cm.c | 5 ++++-
> >   1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/infiniband/hw/cxgb4/cm.c
> > b/drivers/infiniband/hw/cxgb4/cm.c
> > index 5e153f6..867e664 100644
> > --- a/drivers/infiniband/hw/cxgb4/cm.c
> > +++ b/drivers/infiniband/hw/cxgb4/cm.c
> > @@ -455,8 +455,11 @@ static void send_flowc(struct c4iw_ep *ep, struct
> > sk_buff *skb)
> >   	unsigned int flowclen = 80;
> >   	struct fw_flowc_wr *flowc;
> >   	int i;
> > -
> 
> Please add back the above blank line.
> 
> >   	skb = get_skb(skb, flowclen, GFP_KERNEL);
> > +	if (!skb) {
> > +		kfree_skb(skb);
> 
> Let's do a pr_warn() here;
> 
>         pr_warn(MOD "%s failed to allocate skb.\n", __func__);
> 

No need, if the allocation from skbuff_head_cache fails in the slab 
allocator, the page allocator will loop forever for orders less than 
PAGE_ALLOC_COSTLY_ORDER or spew a page allocation failure warning with a 
stack trace that indicated the high order page allocation failed in this 
path.

> 
> > +		return;
> > +	}
> >   	flowc = (struct fw_flowc_wr *)__skb_put(skb, flowclen);
> >     	flowc->op_to_nparams = cpu_to_be32(FW_WR_OP(FW_FLOWC_WR) |
