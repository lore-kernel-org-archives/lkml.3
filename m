Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab3LMLfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:35:00 -0500
Received: from smtp.citrix.com ([66.165.176.89]:56302 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab3LMLe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:34:59 -0500
X-IronPort-AV: E=Sophos;i="4.95,478,1384300800"; 
   d="scan'208";a="84237550"
Message-ID: <52AAF0DE.9030607@citrix.com>
Date: Fri, 13 Dec 2013 11:34:54 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <george.dunlap@eu.citrix.com>, <ian.jackson@eu.citrix.com>,
        <mukesh.rathor@oracle.com>, <tim@xen.org>, <jbeulich@suse.com>,
        <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH V10 14/14] xen/pvh: vcpu info placement, load CS selector,
 and remove debug printk.
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com> <1386900621-27528-15-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1386900621-27528-15-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/13 02:10, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> This patch addresses 3 things:
>    - Resolve vcpu info placement fixme.
>    - Load CS selector for PVH after switching to new gdt.
>    - Remove printk in case of failure to map pnfs in p2m. This because qemu
>      has lot of expected failures when mapping HVM pages.
[...]
> @@ -1423,7 +1425,20 @@ static void __init xen_setup_stackprotector(void)
>  {
>  	/* PVH TBD/FIXME: investigate setup_stack_canary_segment */
>  	if (xen_feature(XENFEAT_auto_translated_physmap)) {
> +		unsigned long dummy;
> +
>  		switch_to_new_gdt(0);
> +#ifdef CONFIG_X86_64
> +		asm volatile ("pushq %0\n"
> +			      "leaq 1f(%%rip),%0\n"
> +			      "pushq %0\n"
> +			      "lretq\n"
> +			      "1:\n"
> +			      : "=&r" (dummy) : "0" (__KERNEL_CS));

Why does CS need to be reloaded here?

David
