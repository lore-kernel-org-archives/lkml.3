Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaHGVse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 17:48:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbaHGVsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 17:48:31 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Joshua Morris <josh.h.morris@us.ibm.com>, kernel-janitors@vger.kernel.org,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] block: fix error return code
References: <1407445067-4044-1-git-send-email-Julia.Lawall@lip6.fr>
	<1407445067-4044-4-git-send-email-Julia.Lawall@lip6.fr>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 07 Aug 2014 17:48:24 -0400
In-Reply-To: <1407445067-4044-4-git-send-email-Julia.Lawall@lip6.fr> (Julia
	Lawall's message of "Thu, 7 Aug 2014 22:57:46 +0200")
Message-ID: <x49sil89djr.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <Julia.Lawall@lip6.fr> writes:

> diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
> index a8de2ee..fa8077a 100644
> --- a/drivers/block/rsxx/core.c
> +++ b/drivers/block/rsxx/core.c
> @@ -942,6 +942,7 @@ static int rsxx_pci_probe(struct pci_dev *dev,
>  	card->event_wq = create_singlethread_workqueue(DRIVER_NAME"_event");
>  	if (!card->event_wq) {
>  		dev_err(CARD_TO_DEV(card), "Failed card event setup.\n");
> +		st = -ENOMEM;
>  		goto failed_event_handler;
>  	}

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

BTW, just above this there is questionable code:

        st = rsxx_get_num_targets(card, &card->n_targets);
        if (st)
                dev_info(CARD_TO_DEV(card),
                        "Failed reading the number of DMA targets\n");

        card->ctrl = kzalloc(card->n_targets * sizeof(*card->ctrl), GFP_KERNEL);
        if (!card->ctrl) {
                st = -ENOMEM;
                goto failed_dma_setup;
        }

>From my reading of the kzalloc code, ZERO_SIZE_PTR (which is 16 cast to
a void *) would be returned from that kzalloc call if the
rsxx_get_num_targets call failed (since you'd be kzalloc-ing 0 bytes).
That would lead to the !card->ctrl check not working, right?

I'd suggest not continuing after rsxx_get_num_targets fails.

Cheers,
Jeff
