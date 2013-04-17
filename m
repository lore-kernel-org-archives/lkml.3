Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438Ab3DQKt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 06:49:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757496Ab3DQKtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 06:49:25 -0400
Message-ID: <516E7E2C.3000408@redhat.com>
Date: Wed, 17 Apr 2013 18:49:16 +0800
From: Lingzhu Xiang <lxiang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V6 3/3] efi: Distinguish between "remaining space" and
 actually used space
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com> <1366056587-24414-1-git-send-email-matthew.garrett@nebula.com> <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 04:09 AM, Matthew Garrett wrote:
> EFI implementations distinguish between space that is actively used by a
> variable and space that merely hasn't been garbage collected yet. Space
> that hasn't yet been garbage collected isn't available for use and so isn't
> counted in the remaining_space field returned by QueryVariableInfo().
>
> Combined with commit 68d9298 this can cause problems. Some implementations
> don't garbage collect until the remaining space is smaller than the maximum
> variable size, and as a result check_var_size() will always fail once more
> than 50% of the variable store has been used even if most of that space is
> marked as available for garbage collection. The user is unable to create
> new variables, and deleting variables doesn't increase the remaining space.
>
> The problem that 68d9298 was attempting to avoid was one where certain
> platforms fail if the actively used space is greater than 50% of the
> available storage space. We should be able to calculate that by simply
> summing the size of each available variable and subtracting that from
> the total storage space. With luck this will fix the problem described in
> https://bugzilla.kernel.org/show_bug.cgi?id=55471 without permitting
> damage to occur to the machines 68d9298 was attempting to fix.
>
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>   arch/x86/platform/efi/efi.c | 109 +++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 102 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index e844d82..a3f03cd 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -41,6 +41,7 @@
>   #include <linux/io.h>
>   #include <linux/reboot.h>
>   #include <linux/bcd.h>
> +#include <linux/ucs2_string.h>
>
>   #include <asm/setup.h>
>   #include <asm/efi.h>
> @@ -51,6 +52,13 @@
>
>   #define EFI_DEBUG	1
>
> +/*
> + * There's some additional metadata associated with each
> + * variable. Intel's reference implementation is 60 bytes - bump that
> + * to account for potential alignment constraints
> + */
> +#define VAR_METADATA_SIZE 64
> +
>   struct efi __read_mostly efi = {
>   	.mps        = EFI_INVALID_TABLE_ADDR,
>   	.acpi       = EFI_INVALID_TABLE_ADDR,
> @@ -72,6 +80,9 @@ static efi_system_table_t efi_systab __initdata;
>   static u64 efi_var_store_size;
>   static u64 efi_var_remaining_size;
>   static u64 efi_var_max_var_size;
> +static u64 boot_used_size;
> +static u64 boot_var_size;
> +static u64 active_size;
>
>   unsigned long x86_efi_facility;
>
> @@ -166,8 +177,53 @@ static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
>   					       efi_char16_t *name,
>   					       efi_guid_t *vendor)
>   {
> -	return efi_call_virt3(get_next_variable,
> -			      name_size, name, vendor);
> +	efi_status_t status;
> +	static bool finished = false;
> +	static u64 var_size;
> +
> +	status = efi_call_virt3(get_next_variable,
> +				name_size, name, vendor);
> +
> +	if (status == EFI_NOT_FOUND) {
> +		finished = true;
> +		if (var_size < boot_used_size) {
> +			boot_var_size = boot_used_size - var_size;
> +			active_size += boot_var_size;

Doesn't work sometimes. Here, if garbage is not collected, then
boot_used_size will contain the size of garbage, and get added into
active_size. This defeats the purpose of active_size.

I added a big printk before "return EFI_OUT_OF_RESOURCES", here are the 
results (Dell XPS 8500, Secure Boot capable):

Failed to create variables in efivarfs, printk:
size=22
storage_size=131072
remaining_size=5230
max_size=5204
efi_var_store_size=131072
efi_var_remaining_size=5378
efi_var_max_var_size=5352
boot_used_size=125694
boot_var_size=125694
active_size=125694

After a few reboots,

EFI shell, QueryVariableInfo.efi:
MaximumVariableStorageSize=131072
RemainingVariableStorageSize=102113
MaximumVariableSize=65509

After several more pstore crash dumps, printk:
size=22
storage_size=131072
remaining_size=53064
max_size=53038
efi_var_store_size=131072
efi_var_remaining_size=53212
efi_var_max_var_size=53186
boot_used_size=77860
boot_var_size=77860
active_size=77860

After reboot, EFI shell, QueryVariableInfo.efi:
MaximumVariableStorageSize=131072
RemainingVariableStorageSize=50456
MaximumVariableSize=50430
-> reset ...
RemainingVariableStorageSize=47922
MaximumVariableSize=47896
-> reset ...
RemainingVariableStorageSize=45462
MaximumVariableSize=45436
-> reset ...
RemainingVariableStorageSize=43002
MaximumVariableSize=42976
-> reset ...
RemainingVariableStorageSize=40542
MaximumVariableSize=40516

Each reboot will consume some nvram? This is consistent with
http://article.gmane.org/gmane.linux.kernel.stable/47156
