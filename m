Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaFGVz7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 17:55:59 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:58081 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaFGVz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 17:55:57 -0400
Message-ID: <53938A4A.9010105@cogentembedded.com>
Date: Sun, 08 Jun 2014 01:55:22 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dmitry Popov <ixaphire@qrator.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ip_vti: Fix 'ip tunnel add' with 'key' parameters
References: <20140608012518.39affaff049874520ae5a0cc@qrator.net>
In-Reply-To: <20140608012518.39affaff049874520ae5a0cc@qrator.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello.

On 06/08/2014 01:25 AM, Dmitry Popov wrote:

> ip tunnel add remote 10.2.2.1 local 10.2.2.2 mode vti ikey 1 okey 2
> translates to p->iflags = VTI_ISVTI|GRE_KEY and p->i_key = 1, but GRE_KEY !=
> TUNNEL_KEY, so ip_tunnel_ioctl would set i_key to 0 (same story with o_key)
> making us unable to create vti tunnels with [io]key via ip tunnel.

> We cannot simply translate GRE_KEY to TUNNEL_KEY (as GRE module does) because
> vti_tunnels with same local/remote addresses but different ikeys will be treated
> as different then. So, imo the best option here is to move p->i_flags&*_KEY
> check for vti tunnels from ip_tunnel.c to ip_vti.c and to think about [io]_mark
> field for ip_tunnel_parm in the future.

> Signed-off-by: Dmitry Popov <ixaphire@qrator.net>
> ---
>   net/ipv4/ip_tunnel.c | 10 ++++++----
>   net/ipv4/ip_vti.c    |  8 +++++++-
>   2 files changed, 13 insertions(+), 5 deletions(-)

> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> index 2acc233..0a03ad1 100644
> --- a/net/ipv4/ip_tunnel.c
> +++ b/net/ipv4/ip_tunnel.c
> @@ -747,10 +747,12 @@ int ip_tunnel_ioctl(struct net_device *dev, struct ip_tunnel_parm *p, int cmd)
>   			goto done;
>   		if (p->iph.ttl)
>   			p->iph.frag_off |= htons(IP_DF);
> -		if (!(p->i_flags&TUNNEL_KEY))
> -			p->i_key = 0;
> -		if (!(p->o_flags&TUNNEL_KEY))
> -			p->o_key = 0;
> +		if (!(p->i_flags&VTI_ISVTI)) {
> +			if (!(p->i_flags&TUNNEL_KEY))
> +				p->i_key = 0;
> +			if (!(p->o_flags&TUNNEL_KEY))

    Please surround & with spaces for consistency; this also would follow the 
general kernel coding style.

[...]

WBR, Sergei

