Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbaHHJWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:22:16 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49602 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294AbaHHJWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:22:12 -0400
Date: Fri, 8 Aug 2014 12:21:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        kernel-janitors@vger.kernel.org,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] block: fix error return code
Message-ID: <20140808092152.GJ4856@mwanda>
References: <1407445067-4044-1-git-send-email-Julia.Lawall@lip6.fr>
 <1407445067-4044-4-git-send-email-Julia.Lawall@lip6.fr>
 <x49sil89djr.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49sil89djr.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 05:48:24PM -0400, Jeff Moyer wrote:
> BTW, just above this there is questionable code:
> 
>         st = rsxx_get_num_targets(card, &card->n_targets);
>         if (st)
>                 dev_info(CARD_TO_DEV(card),
>                         "Failed reading the number of DMA targets\n");
> 
>         card->ctrl = kzalloc(card->n_targets * sizeof(*card->ctrl), GFP_KERNEL);
>         if (!card->ctrl) {
>                 st = -ENOMEM;
>                 goto failed_dma_setup;
>         }
> 
> >From my reading of the kzalloc code, ZERO_SIZE_PTR (which is 16 cast to
> a void *) would be returned from that kzalloc call if the
> rsxx_get_num_targets call failed (since you'd be kzalloc-ing 0 bytes).
> That would lead to the !card->ctrl check not working, right?
>

ZERO_SIZE_PTR is a subtle thing.  The if (!card->ctrl) check correctly
tells you if you allocated enough space to hold zero elements.  Which is
yes so we can continue without a problem.

Of course, you'd have to look at the surrounding code to see if there is
a problem...  I think I have seen dereferencing ZERO_SIZE_PTR bugs in
the past, but they are rare.

> I'd suggest not continuing after rsxx_get_num_targets fails.

Introducing new failures is a bad thing unless you know the code very
well or you can test it.  Your instinct should always be to not do that.

regards,
dan carpenter

