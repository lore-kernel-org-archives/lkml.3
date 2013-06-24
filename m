Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab3FXDXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 23:23:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab3FXDXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 23:23:06 -0400
Message-ID: <51C7BB8C.70304@redhat.com>
Date: Mon, 24 Jun 2013 11:22:52 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org,
        Brad Hubbard <bhubbard@redhat.com>
Subject: Re: [PATCH net] tun: fix recovery from gup errors
References: <20130623141903.GA21029@redhat.com>
In-Reply-To: <20130623141903.GA21029@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2013 10:19 PM, Michael S. Tsirkin wrote:
> get user pages might fail partially in tun zero copy
> mode. To recover we need to put all pages that we got,
> but code used a wrong index resulting in double-free
> errors.
>
> Reported-by: Brad Hubbard <bhubbard@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> I haven't figured out why do we get failures,
> but recovery is clearly wrong.
>
> This is also -stable material.

Acked-by: Jason Wang <jasowang@redhat.com>
>  drivers/net/tun.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index bfa9bb4..c098b1e 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1010,8 +1010,9 @@ static int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
>  			return -EMSGSIZE;
>  		num_pages = get_user_pages_fast(base, size, 0, &page[i]);
>  		if (num_pages != size) {
> -			for (i = 0; i < num_pages; i++)
> -				put_page(page[i]);
> +			int j;
> +			for (j = 0; j < num_pages; j++)
> +				put_page(page[i + j]);
>  			return -EFAULT;
>  		}
>  		truesize = size * PAGE_SIZE;

