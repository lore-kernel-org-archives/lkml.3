Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbaGATqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:46:10 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41832 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbaGATqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:46:08 -0400
Date: Tue, 1 Jul 2014 20:46:05 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com,
        bhe@redhat.com, akpm@linux-foundation.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 15/15] kexec: Support kexec/kdump on EFI systems
Message-ID: <20140701194605.GJ7539@console-pimps.org>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <1403814824-7587-16-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403814824-7587-16-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun, at 04:33:44PM, Vivek Goyal wrote:
> This patch does two thigns. It passes EFI run time mappings to second
> kernel in bootparams efi_info. Second kernel parse this info and create
> new mappings in second kernel. That means mappings in first and second
> kernel will be same. This paves the way to enable EFI in kexec kernel.
> 
> This patch also prepares and passes EFI setup data through bootparams.
> This contains bunch of information about various tables and their
> addresses.
> 
> These information gathering and passing has been written along the lines
> of what current kexec-tools is doing to make kexec work with UEFI.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> CC: linux-efi@vger.kernel.org
> ---
>  arch/x86/kernel/kexec-bzimage64.c  | 146 ++++++++++++++++++++++++++++++++++---
>  drivers/firmware/efi/runtime-map.c |  21 ++++++
>  include/linux/efi.h                |  19 +++++
>  3 files changed, 174 insertions(+), 12 deletions(-)

[...]

> diff --git a/drivers/firmware/efi/runtime-map.c b/drivers/firmware/efi/runtime-map.c
> index 97cdd16..40f2213 100644
> --- a/drivers/firmware/efi/runtime-map.c
> +++ b/drivers/firmware/efi/runtime-map.c
> @@ -138,6 +138,27 @@ add_sysfs_runtime_map_entry(struct kobject *kobj, int nr)
>  	return entry;
>  }
>  
> +int get_efi_runtime_map_size(void)
> +{
> +	return nr_efi_runtime_map * efi_memdesc_size;
> +}
> +
> +int get_efi_runtime_map_desc_size(void)
> +{
> +	return efi_memdesc_size;
> +}
> +
> +int efi_runtime_map_copy(void *buf, size_t bufsz)
> +{
> +	size_t sz = get_efi_runtime_map_size();
> +
> +	if (sz > bufsz)
> +		sz = bufsz;
> +
> +	memcpy(buf, efi_runtime_map, sz);
> +	return 0;
> +}

Could we prefix these with efi_, e.g. efi_get_runtime_map_size() ?

-- 
Matt Fleming, Intel Open Source Technology Center
