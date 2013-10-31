Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab3JaLFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 07:05:18 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:63440 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3JaLFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 07:05:16 -0400
MIME-Version: 1.0
In-Reply-To: <1383215313-23651-1-git-send-email-jasowang@redhat.com>
References: <1383215313-23651-1-git-send-email-jasowang@redhat.com>
Date: Thu, 31 Oct 2013 19:05:14 +0800
Message-ID: <CAOjA20XtG80ePVKKiTHWvy7m99wo5sYC+64RTJN2tWNEopRiSQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: introduce skb_coalesce_rx_frag()
From: Kmindg G <kmindg@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, edumazet@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, mst@redhat.com, rusty@rustcorp.com.au,
        mwdalton@google.com, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 6:28 PM, Jason Wang <jasowang@redhat.com> wrote:
> Sometimes we need to coalesce the rx frags to avoid frag list. One example is
> virtio-net driver which tries to use small frags for both MTU sized packet and
> GSO packet. So this patch introduce skb_coalesce_rx_frag() to do this.
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Michael Dalton <mwdalton@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  include/linux/skbuff.h |  3 +++
>  net/core/skbuff.c      | 13 +++++++++++++
>  2 files changed, 16 insertions(+)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 2c15497..e34652b 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1372,6 +1372,9 @@ static inline void skb_fill_page_desc(struct sk_buff *skb, int i,
>  void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
>                      int size, unsigned int truesize);
>
> +void skb_coalesce_rx_frag(struct sk_buff *skb, int i, int off, int size,
> +                         unsigned int truesize);
> +
>  #define SKB_PAGE_ASSERT(skb)   BUG_ON(skb_shinfo(skb)->nr_frags)
>  #define SKB_FRAG_ASSERT(skb)   BUG_ON(skb_has_frag_list(skb))
>  #define SKB_LINEAR_ASSERT(skb)  BUG_ON(skb_is_nonlinear(skb))
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 0ab32fa..fdef994 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -476,6 +476,19 @@ void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
>  }
>  EXPORT_SYMBOL(skb_add_rx_frag);
>
> +void skb_coalesce_rx_frag(struct sk_buff *skb, int i, int off, int size,
> +                         unsigned int truesize)
> +{
> +       skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
> +
> +       skb_frag_size_add(frag, size);
> +       skb->len += size;
> +       skb->data_len += size;
> +       skb->truesize += truesize;
> +       skb_frag_unref(skb, i);
> +}

I didn't see  you use "off" in skb_coalesce_rx_frag.

> +EXPORT_SYMBOL(skb_coalesce_rx_frag);
> +
>  static void skb_drop_list(struct sk_buff **listp)
>  {
>         kfree_skb_list(*listp);
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
