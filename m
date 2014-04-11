Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbaDKIyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:54:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673AbaDKIyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:54:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140409100150.GO16119@n2100.arm.linux.org.uk>
References: <20140409100150.GO16119@n2100.arm.linux.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH] Remove flush_icache_user_range()
Date: Fri, 11 Apr 2014 09:53:08 +0100
Message-ID: <19350.1397206388@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> --- a/arch/frv/include/asm/cacheflush.h
> +++ b/arch/frv/include/asm/cacheflush.h
> @@ -95,7 +95,9 @@ static inline void flush_icache_page(struct vm_area_struct *vma, struct page *pa
>   */
>  #define copy_to_user_page(vma, page, vaddr, dst, src, len)	\
>  do {								\
> +	unsigned long _vaddr = vaddr;				\
>  	memcpy((dst), (src), (len));				\
> +	frv_cache_wback_inv(_vaddr, _vaddr + (len));		\
>  	flush_icache_user_range((vma), (page), (vaddr), (len));	\
>  } while(0)

FRV's flush_icache_user_range() does frv_cache_wback_inv().

If we can guarantee that vaddr is always mapped to the page, I should be able
to get rid of the kmap_atomic bits in flush_icache_user_range().

David
