Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaFPQhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:37:14 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:32859 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaFPQhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:37:13 -0400
X-IronPort-AV: E=Sophos;i="5.01,487,1400025600"; 
   d="scan'208";a="143816767"
Message-ID: <539F1D36.5040008@citrix.com>
Date: Mon, 16 Jun 2014 17:37:10 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: <xen-devel@lists.xenproject.org>, Andrew Jones <drjones@redhat.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v2] xenpv: don't BUG when failing to setup
 NMI callback
References: <1402916820-27500-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1402916820-27500-1-git-send-email-vkuznets@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/06/14 12:07, Vitaly Kuznetsov wrote:
> 
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -746,12 +746,13 @@ static int cvt_gate_to_trap(int vector, const gate_desc *val,
>  		 */
>  		;
>  #endif
> -	} else if (addr == (unsigned long)nmi)
> +	} else if (addr == (unsigned long)nmi) {
>  		/*
> -		 * Use the native version as well.
> +		 * Use the native version as well but require Xen >= 3.2
>  		 */
> -		;
> -	else {
> +		if (!xen_running_on_version_or_later(3, 2))
> +			return 0;
> +	} else {

The end result of this looked odd so I played around with it a bit and
it turns out that the register_callback for the NMI is entirely unneeded
(since we set the NMI callback via the write_idt pv-op and it's also
broken since it only sets the callback on the current VCPU.

I'm preparing an alternate patch, but I do not have a Xen 3.1 install I
can test with.

David
