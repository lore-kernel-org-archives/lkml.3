Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbaCZM4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 08:56:33 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34702 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438AbaCZM4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:56:31 -0400
Date: Wed, 26 Mar 2014 12:56:23 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: linux-efi@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, eshelton@pobox.com, fenghua.yu@intel.com,
        hpa@zytor.com, ian.campbell@citrix.com, jbeulich@suse.com,
        jeremy@goop.org, konrad.wilk@oracle.com, matt.fleming@intel.com,
        mingo@redhat.com, stefano.stabellini@eu.citrix.com, tglx@linutronix.de,
        tony.luck@intel.com, Tang Liang <liang.tang@oracle.com>
Subject: Re: [PATCH v3 1/5] efi: Add efi_init_ops variable
Message-ID: <20140326125623.GA24856@console-pimps.org>
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
 <1395781076-12000-2-git-send-email-daniel.kiper@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395781076-12000-2-git-send-email-daniel.kiper@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar, at 09:57:52PM, Daniel Kiper wrote:
> Add efi_init_ops variable which allows us to replace
> EFI init functions on Xen with its specific stuff.
> 
> This patch is based on Jan Beulich and Tang Liang work.
> 
> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> Signed-off-by: Tang Liang <liang.tang@oracle.com>
> ---
>  arch/ia64/kernel/efi.c      |   30 +++++++++++++++++++++---------
>  arch/x86/platform/efi/efi.c |   18 +++++++++++++-----
>  drivers/firmware/efi/efi.c  |   26 ++++++++++++++++++++++++++
>  include/linux/efi.h         |    8 ++++++++
>  4 files changed, 68 insertions(+), 14 deletions(-)

[...]

> @@ -1118,6 +1118,14 @@ u64 efi_mem_attributes(unsigned long phys_addr)
>  	return 0;
>  }
>  
> +struct efi_init_ops efi_init_ops = {
> +	.efi_init = efi_init_generic,
> +	.efi_reserve_boot_services = efi_reserve_boot_services_generic,
> +	.efi_enter_virtual_mode = efi_enter_virtual_mode_generic,
> +	.efi_mem_type = efi_mem_type_generic,
> +	.efi_mem_attributes = efi_mem_attributes_generic
> +};

Please don't create another struct of EFI function pointers.

After this we'll have 3 global efi structures defintions and 4 global
efi objects on x86,

  - struct efi_early [in the boot stub]
  - struct efi ['efi_phys' before/'efi' after SetVirtualAddressMap()]
  - struct efi_init_ops [for the benefit of xen]

I have a big problem with exposing .efi_reserve_boot_services as an API.

Also, the fact that in later patches you're copying chunks of the x86
virt_*() funtions suggests to me that this has been implemented at the
wrong layer, because it actively discourages sharing code between x86
and Xen.

-- 
Matt Fleming, Intel Open Source Technology Center
