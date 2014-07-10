Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbaGJQqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:46:15 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56053 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaGJQqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:46:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140708223126.GA12035@himangi-Dell>
References: <20140708223126.GA12035@himangi-Dell>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Thu, 10 Jul 2014 18:45:49 +0200
Message-ID: <CAMxnaaX6tOobPBDVbG7v-kJTvNMLYSybZWuzTqbgMdMkP50swQ@mail.gmail.com>
Subject: Re: [PATCH v3] thunderbolt: Use kcalloc and correct the argument to sizeof
To: Himangi Saraogi <himangi774@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        julia.lawall@lip6.fr
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 12:31 AM, Himangi Saraogi <himangi774@gmail.com> wrote:
> nhi->rx_rings does not have type as struct tb_ring *, as it is a double
> pointer. So, the elements of the array should have pointer type, not
> structure type. The advantage of kcalloc is, that will prevent integer
> overflows which could result from the multiplication of number of
> elements and size and it is also a bit nicer to read.
>
> The Coccinelle semantic patch that makes the first change is as follows:
>
> // <smpl>
> @disable sizeof_type_expr@
> type T;
> T **x;
> @@
>
>   x =
>   <+...sizeof(
> - T
> + *x
>   )...+>
> // </smpl>
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> v2: Use kcalloc
> v3: Add maintainer in To
>  drivers/thunderbolt/nhi.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
> index 2054fbf..c68fe12 100644
> --- a/drivers/thunderbolt/nhi.c
> +++ b/drivers/thunderbolt/nhi.c
> @@ -569,12 +569,10 @@ static int nhi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>                          nhi->hop_count);
>         INIT_WORK(&nhi->interrupt_work, nhi_interrupt_work);
>
> -       nhi->tx_rings = devm_kzalloc(&pdev->dev,
> -                                    nhi->hop_count * sizeof(struct tb_ring),
> -                                    GFP_KERNEL);
> -       nhi->rx_rings = devm_kzalloc(&pdev->dev,
> -                                    nhi->hop_count * sizeof(struct tb_ring),
> -                                    GFP_KERNEL);
> +       nhi->tx_rings = devm_kcalloc(&pdev->dev, nhi->hop_count,
> +                                    sizeof(*nhi->tx_rings), GFP_KERNEL);
> +       nhi->rx_rings = devm_kcalloc(&pdev->dev, nhi->hop_count,
> +                                    sizeof(*nhi->rx_rings), GFP_KERNEL);
>         if (!nhi->tx_rings || !nhi->rx_rings)
>                 return -ENOMEM;
>
> --
> 1.9.1
>

Thanks for catching this.
Acked-by: Andreas Noever <andreas.noever@gmail.com>
