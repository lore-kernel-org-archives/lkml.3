Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967904Ab3HIOLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:11:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758045Ab3HIOLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:11:10 -0400
Message-ID: <1376057413.12443.91.camel@t520.redhat.com>
Subject: Re: [PATCH 12/17] Add proper definitions for some EFI function
 pointers.
From: Mark Salter <msalter@redhat.com>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org, dave.martin@arm.com
Date: Fri, 09 Aug 2013 10:10:13 -0400
In-Reply-To: <1375847113-24884-13-git-send-email-roy.franz@linaro.org>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
	 <1375847113-24884-13-git-send-email-roy.franz@linaro.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 20:45 -0700, Roy Franz wrote:
> The x86/AMD64 EFI stubs must us a call wrapper to convert between
> the Linux and EFI ABIs, so void pointers are sufficient.  For ARM,
> the ABIs are compatible, so we can directly invoke the function
> pointers.  The functions that are used by the ARM stub are updated
> to match the EFI definitions.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  include/linux/efi.h |   42 +++++++++++++++++++++++++-----------------
>  1 file changed, 25 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 51f5641..96bb866 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -39,6 +39,8 @@
>  typedef unsigned long efi_status_t;
>  typedef u8 efi_bool_t;
>  typedef u16 efi_char16_t;		/* UNICODE character */
> +typedef u64 efi_physical_addr_t;
> +typedef void *efi_handle_t;
>  
> 
>  typedef struct {
> @@ -96,6 +98,7 @@ typedef	struct {
>  #define EFI_MEMORY_DESCRIPTOR_VERSION	1
>  
>  #define EFI_PAGE_SHIFT		12
> +#define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
>  
>  typedef struct {
>  	u32 type;
> @@ -157,11 +160,12 @@ typedef struct {
>  	efi_table_hdr_t hdr;
>  	void *raise_tpl;
>  	void *restore_tpl;
> -	void *allocate_pages;
> -	void *free_pages;
> -	void *get_memory_map;
> -	void *allocate_pool;
> -	void *free_pool;
> +	int (*allocate_pages)(int, int, unsigned long, efi_physical_addr_t *);
> +	int (*free_pages)(efi_physical_addr_t, unsigned long);

All of the actual function pointers that were added should return an
efi_status_t instead of int. On arm64, I was seeing an unrecognizable
error status because the truncation from 64 to 32 bits.

--Mark


