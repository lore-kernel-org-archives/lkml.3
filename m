Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaKECz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 21:55:58 -0500
Received: from exprod7og105.obsmtp.com ([64.18.2.163]:39076 "HELO
	exprod7og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752470AbaKECz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 21:55:56 -0500
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2014 21:55:56 EST
Message-ID: <5459902C.1010102@miraclelinux.com>
Date: Wed, 05 Nov 2014 11:49:16 +0900
From: YOSHIFUJI Hideaki <hideaki.yoshifuji@miraclelinux.com>
Organization: MIRACLE LINUX CORPORATION
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin LaHaise <bcrl@kvack.org>
CC: hideaki.yoshifuji@miraclelinux.com
Subject: Re: [PATCH 2/4] tun: Use iovec iterators
References: <20141104033818.GA11149@gondor.apana.org.au> <E1XlZWY-0003Hk-Qu@gondolin.me.apana.org.au> <20141104083721.GA12691@gondor.apana.org.au>
In-Reply-To: <20141104083721.GA12691@gondor.apana.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Herbert Xu wrote:
> Oops, this patch had a left-over skb_pull which made it broken.
> Here is a fixed version.
>
> tun: Use iovec iterators
>
> This patch removes the use of skb_copy_datagram_const_iovec in
> favour of the iovec iterator-based skb_copy_datagram_iter.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 9dd3746..ff955cdb 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
:
> @@ -1244,23 +1245,25 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>   	if (tun->flags & TUN_VNET_HDR)
>   		vnet_hdr_sz = tun->vnet_hdr_sz;
>
> +	total = skb->len + vlan_hlen + vnet_hdr_sz;
> +
>   	if (!(tun->flags & TUN_NO_PI)) {
> -		if ((len -= sizeof(pi)) < 0)
> +		if (iov_iter_count(iter) < sizeof(pi))
>   			return -EINVAL;
>
> -		if (len < skb->len + vlan_hlen + vnet_hdr_sz) {
> +		if (iov_iter_count(iter) < total) {

I guess this should be: sizeof(pi) + total

-- 
Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Technical Division, MIRACLE LINUX CORPORATION
