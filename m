Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab3FCMSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:18:03 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:56441 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab3FCMSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:18:00 -0400
Message-ID: <51AC8974.4010102@intel.com>
Date: Mon, 03 Jun 2013 13:17:56 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: rja@sgi.com, mingo@kernel.org, torvalds@linux-foundation.org, bp@alien8.de,
        jkosina@suse.cz, jlee@suse.com, linux-efi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH] Modify UEFI anti-bricking code
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/13 21:06, Matthew Garrett wrote:
> This patch reworks the UEFI anti-bricking code, including an effective
> reversion of cc5a080c and 31ff2f20. It turns out that calling
> QueryVariableInfo() from boot services results in some firmware
> implementations jumping to physical addresses even after entering virtual
> mode, so until we have 1:1 mappings for UEFI runtime space this isn't
> going to work so well.
> 
> Reverting these gets us back to the situation where we'd refuse to create
> variables on some systems because they classify deleted variables as "used"
> until the firmware triggers a garbage collection run, which they won't do
> until they reach a lower threshold. This results in it being impossible to
> install a bootloader, which is unhelpful.
> 
> Feedback from Samsung indicates that the firmware doesn't need more than
> 5KB of storage space for its own purposes, so that seems like a reasonable
> threshold. However, there's still no guarantee that a platform will attempt
> garbage collection merely because it drops below this threshold. It seems
> that this is often only triggered if an attempt to write generates a
> genuine EFI_OUT_OF_RESOURCES error. We can force that by attempting to
> create a variable larger than the remaining space. This should fail, but if
> it somehow succeeds we can then immediately delete it.
> 
> I've tested this on the UEFI machines I have available, but I don't have
> a Samsung and so can't verify that it avoids the bricking problem.
 
This patch works on my ASUS machine, which suffers from the "you need to
write more than 50% to initiate garbage collection" issue. So that's
good news. I'm trying to find someone with one of the vulnerable Samsung
laptops, but this patch does look like a step in the right direction,
seeing as it solves Russ' boot issue.

[...]

> @@ -1141,28 +1037,53 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
>  	if (status != EFI_SUCCESS)
>  		return status;
>  
> -	if (!max_size && remaining_size > size)
> -		printk_once(KERN_ERR FW_BUG "Broken EFI implementation"
> -			    " is returning MaxVariableSize=0\n");

Do we really want to drop this hunk? The point of this code was to
inform firmware vendors that their implementation is returning funky
results, and that they should look into why it's doing that.

>  	/*
>  	 * Some firmware implementations refuse to boot if there's insufficient
>  	 * space in the variable store. We account for that by refusing the
>  	 * write if permitting it would reduce the available space to under
> -	 * 50%. However, some firmware won't reclaim variable space until
> -	 * after the used (not merely the actively used) space drops below
> -	 * a threshold. We can approximate that case with the value calculated
> -	 * above. If both the firmware and our calculations indicate that the
> -	 * available space would drop below 50%, refuse the write.
> +	 * 5KB. This figure was provided by Samsung, so should be safe.
>  	 */
> +	if ((remaining_size - size < 5120) && !efi_no_storage_paranoia) {
> +		/*
> +		 * Triggering garbage collection may require that the firmware
> +		 * generate a real EFI_OUT_OF_RESOURCES error. We can force
> +		 * that by attempting to use more space than is available.
> +		 */
> +		unsigned long dummy_size = remaining_size + 1024;
> +		void *dummy = kmalloc(dummy_size, GFP_ATOMIC);
> +		efi_char16_t efi_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
> +		efi_guid_t guid = EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e,
> +					   0x97, 0xed, 0x50, 0xf0, 0x9f, 0x92,
> +					   0xa9);

What's the origin of this guid? And should we be adding it to
include/linux/efi.h?
