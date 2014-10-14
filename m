Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbaJNJW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 05:22:59 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:52755 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaJNJW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 05:22:58 -0400
X-IronPort-AV: E=Sophos;i="5.04,716,1406592000"; 
   d="scan'208";a="182235944"
Message-ID: <543CEB56.3080009@citrix.com>
Date: Tue, 14 Oct 2014 10:22:30 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Martin Kelly <martin@martingkelly.com>, <xen-devel@lists.xenproject.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
CC: <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>,
        Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH] xen/setup: add paranoid index check and warning
References: <1413249548-26415-1-git-send-email-martin@martingkelly.com>
In-Reply-To: <1413249548-26415-1-git-send-email-martin@martingkelly.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/14 02:19, Martin Kelly wrote:
> In a call to set_phys_range_identity, i-1 is used without checking that
> i is non-zero. Although unlikely, a bug in the code before it could
> cause the value to be 0, leading to erroneous behavior. This patch adds
> a check against 0 value and a corresponding warning.

This can only happen if the toolstack supplies a memory map with zero
entries.  I could see justification for adding a panic at the top of
this function in this case, but I can't see the usefulness of this warning.

> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -671,7 +671,10 @@ char * __init xen_memory_setup(void)
>  	 * PFNs above MAX_P2M_PFN are considered identity mapped as
>  	 * well.
>  	 */
> -	set_phys_range_identity(map[i-1].addr / PAGE_SIZE, ~0ul);
> +	if (i > 0)
> +		set_phys_range_identity(map[i-1].addr / PAGE_SIZE, ~0ul);
> +	else
> +		WARN(1, "Something went wrong clamping memory to a factor of EXTRA_MEM_RATIO!");
>  
>  	/*
>  	 * In domU, the ISA region is normal, usable memory, but we
> 

