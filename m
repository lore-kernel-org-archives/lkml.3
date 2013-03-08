Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab3CHFhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:37:00 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58628 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3CHFg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 00:36:59 -0500
Date: Thu, 7 Mar 2013 21:36:53 -0800
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 03/14] x86, ACPI: store override acpi tables phys addr
Message-ID: <20130308053653.GE14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
 <1362718720-27048-4-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362718720-27048-4-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 08:58:29PM -0800, Yinghai Lu wrote:
> As later 32bit only find table with phys address during 32bit flat mode
> in head_32.S.
> 
> To keep 32bit and 64 bit consistent, use phys_addr for all.
> 
> Use early_ioremap to access during copying.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Thomas Renninger <trenn@suse.de>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
> ---
> @@ -654,10 +654,13 @@ void __init acpi_initrd_override_copy(void)
>  	arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
>  
>  	for (no = 0; no < table_nr; no++) {
> -		size_t size = early_initrd_files[no].size;
> +		unsigned long size = early_initrd_files[no].size;
>  
>  		p = early_ioremap(acpi_tables_addr + total_offset, size);
> -		memcpy(p, early_initrd_files[no].data, size);
> +		q = early_ioremap((unsigned long)early_initrd_files[no].data,
> +					 size);
> +		memcpy(p, q, size);
> +		early_iounmap(q, size);

Ah, okay, so the loop change in the previous patch was for this, I
suppose?  That chunk probably should either be a separate patch or
rolled into this one.

Thanks.

-- 
tejun
