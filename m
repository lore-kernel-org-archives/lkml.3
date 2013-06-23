Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab3FWPg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 11:36:28 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:59691 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3FWPgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 11:36:25 -0400
Message-ID: <51C715F5.2050300@cogentembedded.com>
Date: Sun, 23 Jun 2013 19:36:21 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <edumazet@google.com>,
        Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org,
        Brad Hubbard <bhubbard@redhat.com>
Subject: Re: [PATCH net] tun: fix recovery from gup errors
References: <20130623141903.GA21029@redhat.com>
In-Reply-To: <20130623141903.GA21029@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 23-06-2013 18:19, Michael S. Tsirkin wrote:

> get user pages might fail partially in tun zero copy
> mode. To recover we need to put all pages that we got,
> but code used a wrong index resulting in double-free
> errors.

> Reported-by: Brad Hubbard <bhubbard@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---

> I haven't figured out why do we get failures,
> but recovery is clearly wrong.

> This is also -stable material.

>   drivers/net/tun.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)

> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index bfa9bb4..c098b1e 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1010,8 +1010,9 @@ static int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
>   			return -EMSGSIZE;
>   		num_pages = get_user_pages_fast(base, size, 0, &page[i]);
>   		if (num_pages != size) {
> -			for (i = 0; i < num_pages; i++)
> -				put_page(page[i]);
> +			int j;

   Empty line wouldn't hurt here, after declaration.

> +			for (j = 0; j < num_pages; j++)
> +				put_page(page[i + j]);

