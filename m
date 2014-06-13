Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaFMIny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:43:54 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:43804 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaFMInu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:43:50 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1406130111280.1551@tomh.mtv.corp.google.com>
References: <alpine.DEB.2.02.1406130111280.1551@tomh.mtv.corp.google.com>
Date: Fri, 13 Jun 2014 10:43:47 +0200
X-Google-Sender-Auth: Npb1rtJ7yrjjhKwYRbHVkDMEQ70
Message-ID: <CAMuHMdW4kYeqEby3iABzdbjyAkPKq=x4dyopokFbHWT0Q4fjcw@mail.gmail.com>
Subject: Re: [-next] Regression: ssh log in slowdown
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tom Herbert <therbert@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux-Next <linux-next@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

On Fri, Jun 13, 2014 at 10:21 AM, Tom Herbert <therbert@google.com> wrote:
>> I assume this is the series "[PATCH 0/4] Checksum fixes"
>> (marc.info/?l=linux-netdev&m=140261417832399&w=2)?
>>
> Yes.
>
>> As I'm not subscribed to netdev, I cannot reply to that thread.
>>
>> "[PATCH 1/4] net: Fix save software checksum complete" fixes the issue
>> for me.
>> However, "[PATCH 2/4] udp: call __skb_checksum_complete when doing full
>> checksum" reintroduces the exact same bad behavior :-(
>>
> This implies the problem is happening in UDP path. AFAICT skb->csum is
> correct, and I don't seem to be able to reproduce the issue on my setup.
> It is possible that an skb copy is happening in which case we don't copy
> csum_valid so that checksum_unnecessary would fail in this case.
>
> Can you try with the patch below. Thanks!
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index bf92824..9cd5344 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -689,6 +689,9 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
>         new->ooo_okay           = old->ooo_okay;
>         new->no_fcs             = old->no_fcs;
>         new->encapsulation      = old->encapsulation;
> +       new->encap_hdr_csum     = old->encap_hdr_csum;
> +       new->csum_valid         = old->csum_valid;
> +       new->csum_complete_sw   = old->csum_complete_sw;
>  #ifdef CONFIG_XFRM
>         new->sp                 = secpath_get(old->sp);
>  #endif

Thanks, I applied the series "[PATCH 0/4] Checksum fixes", and the fix
above, but it doesn't help.

Note that I'm also using NFS root, which doesn't seem to be affected.
I can happily run "ls -R /" on the serial console during the 10 s delay in ssh.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
