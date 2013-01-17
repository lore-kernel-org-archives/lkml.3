Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab3AQDWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:22:50 -0500
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:43502 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757464Ab3AQDWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 22:22:49 -0500
Message-ID: <50F76E87.6020606@linux-ipv6.org>
Date: Thu, 17 Jan 2013 12:22:47 +0900
From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Organization: USAGI Project
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Carlos O'Donell" <carlos@systemhalted.org>
CC: David Miller <davem@davemloft.net>, vapier@gentoo.org,
        libc-alpha@sourceware.org, bhutchings@solarflare.com,
        amwang@redhat.com, tmb@mageia.org, eblake@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvirt-list@redhat.com, tgraf@suug.ch, schwab@suse.de,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: Re: Redefinition of struct in6_addr in <netinet/in.h> and <linux/in6.h>
References: <50F6B761.8070106@linux-ipv6.org> <1358351232.2923.10.camel@bwh-desktop.uk.solarflarecom.com> <201301161205.04502.vapier@gentoo.org> <20130116.135744.697469565804508454.davem@davemloft.net> <50F75EA7.4060309@systemhalted.org>
In-Reply-To: <50F75EA7.4060309@systemhalted.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos O'Donell wrote:
> diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
> index f79c372..a2b16a5 100644
> --- a/include/uapi/linux/in6.h
> +++ b/include/uapi/linux/in6.h
> @@ -23,6 +23,13 @@
>  
>  #include <linux/types.h>
>  
> +/* If a glibc-based userspace has already included in.h, then we will not 
> + * define in6_addr (nor the defines), sockaddr_in6, or ipv6_mreq. The
> + * ABI used by the kernel and by glibc match exactly. Neither the kernel
> + * nor glibc should break this ABI without coordination.
> + */
> +#ifndef _NETINET_IN_H
> +
>  /*
>   *	IPv6 address structure
>   */

This should be
#if !defined(__GLIBC__) || !defined(_NETINET_IN_H)

> @@ -30,12 +37,20 @@
>  struct in6_addr {
>  	union {
>  		__u8		u6_addr8[16];
> +#if !defined(__GLIBC__) \
> +    || (defined(__GLIBC__) && (defined(__USE_MISC) || defined(__USE_GNU))) \
> +    || defined(__KERNEL__)
>  		__be16		u6_addr16[8];
>  		__be32		u6_addr32[4];
> +#endif
>  	} in6_u;
> +#if !defined(__GLIBC__) \
> +    || (defined(__GLIBC__) && (defined(__USE_MISC) || defined(__USE_GNU))) \
> +    || defined(__KERNEL__)
>  #define s6_addr			in6_u.u6_addr8
>  #define s6_addr16		in6_u.u6_addr16
>  #define s6_addr32		in6_u.u6_addr32
> +#endif
>  };

2nd "if" be after s6_addr?

--yoshfuji
