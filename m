Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbaFYWh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:37:56 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43074 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757075AbaFYWhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:37:54 -0400
Date: Wed, 25 Jun 2014 23:37:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 9/9] ARM: kernel: add outer cache support for cacheinfo
	implementation
Message-ID: <20140625223748.GM32514@n2100.arm.linux.org.uk>
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com> <1403717444-23559-10-git-send-email-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403717444-23559-10-git-send-email-sudeep.holla@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 06:30:44PM +0100, Sudeep Holla wrote:
> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
> index efc5cab..30ca151 100644
> --- a/arch/arm/mm/cache-l2x0.c
> +++ b/arch/arm/mm/cache-l2x0.c
> @@ -105,6 +105,15 @@ static inline void l2c_unlock(void __iomem *base, unsigned num)
>  	}
>  }
>  
> +static void l2x0_getinfo(struct outer_cache_info *info)
> +{
> +	if (!info)
> +		return;

Pointless NULL test.  If someone passes NULL to this function (which
you never do in this file) then we want to know about it because _that_
is a kernel bug - it is invalid to pass NULL.  Hence the kernel should
oops.

Please, don't go around adding stupid NULL tests for conditions which
should _never_ happen, instead, rely on the kernel to oops if these
invalid conditions occur.  That's why we produce a backtrace from such
events, to allow invalid conditions to be debugged and fixed.

Having stuff silently ignore in this way does not detect these bugs so
they go by unnoticed.

Take a moment to read some of the fs/ or kernel/ code, and you'll find
a lack of NULL checks in there.  That's what gives that code performance,
because it's not spending its time doing loads of useless NULL checks.

> @@ -894,6 +903,7 @@ static void __init __l2c_init(const struct l2c_init_data *data,
>  		data->enable(l2x0_base, aux, data->num_lock);
>  
>  	outer_cache = fns;
> +	outer_cache.get_info = l2x0_getinfo;

NAK.  Think about it.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
