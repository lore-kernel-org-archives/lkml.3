Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbbAFWoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:44:23 -0500
Received: from mail.us.es ([193.147.175.20]:34739 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbbAFWoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:44:21 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus6 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.5/19888. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-103.2/7.5):. 
 Processed in 2.371739 secs); 06 Jan 2015 22:44:19 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Tue, 6 Jan 2015 23:47:06 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Rahul Sharma <rsharma@arista.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hannes@stressinduktion.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] ipv6: Prevent ipv6_find_hdr() from returning ENOENT
 for valid non-first fragments
Message-ID: <20150106224706.GA7416@salvia>
References: <CAFB3abzYNYqtzd_n+Ym0Lo=DYbV0HPU=Tqw=stALNnu188hMKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFB3abzYNYqtzd_n+Ym0Lo=DYbV0HPU=Tqw=stALNnu188hMKQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 03:03:20AM +0530, Rahul Sharma wrote:
> ipv6_find_hdr() currently assumes that the next-header field in the
> fragment header of the non-first fragment is the "protocol number of
> the last header" (here last header excludes any extension header
> protocol numbers ) which is incorrect as per RFC2460. The next-header
> value is the first header of the fragmentable part of the original
> packet (which can be extension header as well).
> This can create reassembly problems. For example: Fragmented
> authenticated OSPFv3 packets (where AH header is inserted before the
> protocol header). For the second fragment, the next header value in
> the fragment header will be NEXTHDR_AUTH which is correct but
> ipv6_find_hdr will return ENOENT since AH is an extension header
> resulting in second fragment getting dropped. This check for the
> presence of non-extension header needs to be removed.
> 
> Signed-off-by: Rahul Sharma <rsharma@arista.com>
> ---
> --- linux-3.18.1/net/ipv6/exthdrs_core.c.orig   2015-01-06
> 10:25:36.411419863 -0800
> +++ linux-3.18.1/net/ipv6/exthdrs_core.c        2015-01-06
> 10:51:45.819364986 -0800
> @@ -171,10 +171,11 @@ EXPORT_SYMBOL_GPL(ipv6_find_tlv);
>   * If the first fragment doesn't contain the final protocol header or
>   * NEXTHDR_NONE it is considered invalid.
>   *
> - * Note that non-1st fragment is special case that "the protocol number
> - * of last header" is "next header" field in Fragment header. In this case,
> - * *offset is meaningless and fragment offset is stored in *fragoff if fragoff
> - * isn't NULL.
> + * Note that non-1st fragment is special case that "the protocol number of the
> + * first header of the fragmentable part of the original packet" is
> + * "next header" field in the Fragment header. In this case, *offset is
> + * meaningless and fragment offset is stored in *fragoff if fragoff isn't
> + * NULL.
>   *
>   * if flags is not NULL and it's a fragment, then the frag flag
>   * IP6_FH_F_FRAG will be set. If it's an AH header, the
> @@ -250,9 +251,7 @@ int ipv6_find_hdr(const struct sk_buff *
> 
>                         _frag_off = ntohs(*fp) & ~0x7;
>                         if (_frag_off) {
> -                               if (target < 0 &&
> -                                   ((!ipv6_ext_hdr(hp->nexthdr)) ||

This check assumes that the following headers cannot show up in the
fragmented part of the IPv6 packet:

 12 bool ipv6_ext_hdr(u8 nexthdr)
 13 {
 14         /*
 15          * find out if nexthdr is an extension header or a protocol
 16          */
 17         return   (nexthdr == NEXTHDR_HOP)       ||
 18                  (nexthdr == NEXTHDR_ROUTING)   ||
 19                  (nexthdr == NEXTHDR_FRAGMENT)  ||
 20                  (nexthdr == NEXTHDR_AUTH)      ||
 21                  (nexthdr == NEXTHDR_NONE)      ||
 22                  (nexthdr == NEXTHDR_DEST);

> -                                    hp->nexthdr == NEXTHDR_NONE)) {
> +                               if (target < 0) {
>                                         if (fragoff)
>                                                 *fragoff = _frag_off;
>                                         return hp->nexthdr;
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
