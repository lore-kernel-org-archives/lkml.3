Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbaHHQWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:22:39 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:6120 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752646AbaHHQWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:22:38 -0400
X-IronPort-AV: E=Sophos;i="5.01,825,1400018400"; 
   d="scan'208";a="88743809"
Date: Fri, 8 Aug 2014 18:22:09 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Josh Morris <josh.h.morris@us.ibm.com>
cc: Jeff Moyer <jmoyer@redhat.com>, kernel-janitors@vger.kernel.org,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>, dan.carpenter@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: add abort on failure
In-Reply-To: <OF8E178B75.111E73DE-ON86257D2E.00561BEC-86257D2E.00590C0D@us.ibm.com>
Message-ID: <alpine.DEB.2.10.1408081821110.2348@hadrien>
References: <1407486050-9375-1-git-send-email-Julia.Lawall@lip6.fr> <alpine.DEB.2.10.1408081129150.2348@hadrien> <OF8E178B75.111E73DE-ON86257D2E.00561BEC-86257D2E.00590C0D@us.ibm.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1681931489-1407514929=:2348"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1681931489-1407514929=:2348
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT



On Fri, 8 Aug 2014, Josh Morris wrote:

> Howdy Julia,
>
> It is by design that we complete the probe despite failures in
> rsxx_load_config() and rsxx_get_num_targets(). The reason is that we will be
> unable to debug and fix the issue without a driver loaded.
>
> In the case that the on-card config has been corrupted we will need the
> driver loaded to reset or repair the configuration.
>
> I couldn't find a place where we were derefrencing card->ctrl outside of a
> loop that checked the index against n_targets. That should prevent the
> driver from dereferencing an 0 size array.  So I believe we still want the
> probe to complete in this case so we can debug the hardware.

OK.  I also looked for such a reference and didn't see one.

Thanks for the feedback.

julia

>
> Cheers!
>
> Josh
>
>
>
> From:        Julia Lawall <julia.lawall@lip6.fr>
> To:        Josh Morris/Houston/IBM@IBMUS,
> Cc:        Jeff Moyer <jmoyer@redhat.com>, kernel-janitors@vger.kernel.org,
> Philip Kelleher <pjk1939@linux.vnet.ibm.com>, dan.carpenter@oracle.com,
> linux-kernel@vger.kernel.org
> Date:        08/08/2014 04:31 AM
> Subject:        Re: [PATCH] block: add abort on failure
>
> ____________________________________________________________________________
>
>
>
> On Fri, 8 Aug 2014, Julia Lawall wrote:
>
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > Initializing card seems to be critical to the rest of the probe process,
> so
> > abort the probe function if the calls to rsxx_load_config and
> > rsxx_get_num_targets do not succeed.
>
> Note that this is not tested.  Nevertheless, at least the first failure
> will leave card in an unknown partially initialized state, which seems
> undesirable.
>
> julia
>
>
> > Suggested by Jeff Moyer.
> >
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > ---
> >  drivers/block/rsxx/core.c |    8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
> > index a8de2ee..ae2805b 100644
> > --- a/drivers/block/rsxx/core.c
> > +++ b/drivers/block/rsxx/core.c
> > @@ -915,15 +915,19 @@ static int rsxx_pci_probe(struct pci_dev *dev,
> >
> >                   /************* Load Card Config *************/
> >                   st = rsxx_load_config(card);
> > -                 if (st)
> > +                 if (st) {
> >                                    dev_err(CARD_TO_DEV(card),
> >                                                     "Failed loading card
> config\n");
> > +                                  goto failed_dma_setup;
> > +                 }
> >
> >                   /************* Setup DMA Engine *************/
> >                   st = rsxx_get_num_targets(card, &card->n_targets);
> > -                 if (st)
> > +                 if (st) {
> >                                    dev_info(CARD_TO_DEV(card),
> >                                                     "Failed reading the
> number of DMA targets\n");
> > +                                  goto failed_dma_setup;
> > +                 }
> >
> >                   card->ctrl = kzalloc(card->n_targets *
> sizeof(*card->ctrl), GFP_KERNEL);
> >                   if (!card->ctrl) {
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe kernel-janitors"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>
>
>
>
--8323329-1681931489-1407514929=:2348--
