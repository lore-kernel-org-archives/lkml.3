Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaJPP4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:56:08 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:3835 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbaJPP4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:56:04 -0400
X-IronPort-AV: E=Sophos;i="5.04,733,1406592000"; 
   d="scan'208";a="183210969"
Message-ID: <543FE940.60901@citrix.com>
Date: Thu, 16 Oct 2014 16:50:24 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>
Subject: Re: [PATCH] xen: avoid race in p2m handling
References: <1413439997-32344-1-git-send-email-jgross@suse.com>
In-Reply-To: <1413439997-32344-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/10/14 07:13, Juergen Gross wrote:
> When a new p2m leaf is allocated this leaf is linked into the p2m tree
> via cmpxchg. Unfortunately the compare value for checking the success
> of the update is read after checking for the need of a new leaf. It is
> possible that a new leaf has been linked into the tree concurrently
> in between. This could lead to a leaked memory page and to the loss of
> some p2m entries.
> 
> Avoid the race by using the read compare value for checking the need
> of a new p2m leaf.
[...]
> @@ -579,11 +580,10 @@ static bool alloc_p2m(unsigned long pfn)
>  		}
>  	}
>  
> -	if (p2m_top[topidx][mididx] == p2m_identity ||
> -	    p2m_top[topidx][mididx] == p2m_missing) {
> +	p2m_orig = p2m_top[topidx][mididx];

Do you need to use ACCESS_ONCE() here?

David

