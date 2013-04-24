Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab3DXKJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:09:50 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:54463 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab3DXKJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:09:48 -0400
Subject: Re: [PATCH V6 3/3] efi: Distinguish between "remaining space" and
 actually used space
From: joeyli <jlee@suse.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Apr 2013 18:08:31 +0800
Message-ID: <1366798111.23707.293.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, 

於 一，2013-04-15 於 13:09 -0700，Matthew Garrett 提到：
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
>  arch/x86/platform/efi/efi.c | 109 +++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 102 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index e844d82..a3f03cd 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
...
> @@ -1039,8 +1122,20 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
>  	if (status != EFI_SUCCESS)
>  		return status;
>  
> -	if (!storage_size || size > remaining_size || size > max_size ||
> -	    (remaining_size - size) < (storage_size / 2))
> +	/*
> +	 * Some firmware implementations refuse to boot if there's insufficient
> +	 * space in the variable store. We account for that by refusing the
> +	 * write if permitting it would reduce the available space to under
> +	 * 50%. However, some firmware won't reclaim variable space until
> +	 * after the used (not merely the actively used) space drops below
> +	 * a threshold. We can approximate that case with the value calculated
> +	 * above. If both the firmware and our calculations indicate that the
> +	 * available space would drop below 50%, refuse the write.
> +	 */
> +
> +	if (!storage_size || size > remaining_size ||
> +	    ((active_size + size + VAR_METADATA_SIZE > storage_size / 2) &&
> +	     (remaining_size - size < storage_size / 2)))

I am afraid it could not completely avoid to brick Samsung machines when
binding active_size and remaining_size logic with AND.

I don't have machine for testing, but my concern is we can run
delete/create variables many cycles at runtime for trigger brick Samsung
machines.
It causes the garbage size increased and remaining_size decreased. But
we still can create new variable because active_size doesn't increase
due to we delete variable before create new. So, the condition
"remaining_size - size < storage_size / 2" will not really hit because
active_size condition is pass.

And, here also can not use OR for binding active_size and remaining_size
logic, that causes many machines will not trigger garbage collection
because remaining_size will never tight.

Please let me know if I lost any other conditions or background
information.


Thanks a lot!
Joey Lee

