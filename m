Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab3AKUn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:43:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab3AKUnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:43:25 -0500
Date: Sat, 12 Jan 2013 02:13:17 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, riel@redhat.com,
        aquini@redhat.com, mst@redhat.com, agl@us.ibm.com
Subject: Re: [RFC 2/2] virtio_balloon: add auto-ballooning support
Message-ID: <20130111204317.GB11436@amit.redhat.com>
References: <1355861850-2702-1-git-send-email-lcapitulino@redhat.com>
 <1355861850-2702-3-git-send-email-lcapitulino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355861850-2702-3-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 18 Dec 2012 [18:17:30], Luiz Capitulino wrote:
> The auto-ballooning feature automatically performs balloon inflate or
> deflate based on host and guest memory pressure. This can help to
> avoid swapping or worse in both, host and guest.
> 
> Auto-ballooning has a host and a guest part. The host performs
> automatic inflate by requesting the guest to inflate its balloon
> when the host is facing memory pressure. The guest performs
> automatic deflate when it's facing memory pressure itself. It's
> expected that auto-inflate and auto-deflate will balance each
> other over time.
> 
> This commit implements the guest side of auto-ballooning.
> 
> To perform automatic deflate, the virtio_balloon driver registers
> a shrinker callback, which will try to deflate the guest's balloon
> on guest memory pressure just like if it were a cache. The shrinker
> callback is only registered if the host supports the
> VIRTIO_BALLOON_F_AUTO_BALLOON feature bit.

I'm wondering if guest should auto-deflate even when the AUTO_BALLOON
feature isn't supported by the host: if a guest is under pressure,
there's no way for it to tell the host and wait for the host to
deflate the balloon, so it may be beneficial to just go ahead and
deflate the balloon for all hosts.

Similarly, on the host side, management can configure a VM to either
enable or disable auto-balloon (the auto-inflate part).  So even the
host can do away with the feature advertisement and negotiation.

Is there some use-case I'm missing where doing these actions after
feature negotiation is beneficial?

> FIXMEs
> 
>  o the guest kernel seems to spin when the host is performing a long
>    auto-inflate

Is this introduced by the current patches?  I'd assume it happens even
without it -- these patches just introduce some heuristics, the
mechanism has stayed the same.

> Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
> ---
>  drivers/virtio/virtio_balloon.c     | 54 +++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/virtio_balloon.h |  1 +
>  2 files changed, 55 insertions(+)

Patch looks good, just one thing:

> +	/*
> +	 * If the current balloon size is greater than the number of
> +	 * pages being reclaimed by the kernel, deflate only the needed
> +	 * amount. Otherwise deflate everything we have.
> +	 */
> +	if (nr_pages > sc->nr_to_scan) {
> +		new_target = nr_pages - sc->nr_to_scan;
> +	} else {
> +		new_target = 0;
> +	}

This looks better:

	new_target = 0;
	if (nr_pages > sc->nr_to_scan) {
		new_target = nr_pages - sc->nr_to_scan;
	}


Thanks,
		Amit
