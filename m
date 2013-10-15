Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933705Ab3JOTZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:25:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37326 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633Ab3JOTZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:25:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1381859307-11932-1-git-send-email-geert@linux-m68k.org>
	<1381859307-11932-2-git-send-email-geert@linux-m68k.org>
Date: Tue, 15 Oct 2013 12:25:16 -0700
In-Reply-To: <1381859307-11932-2-git-send-email-geert@linux-m68k.org> (Geert
	Uytterhoeven's message of "Tue, 15 Oct 2013 19:48:25 +0200")
Message-ID: <8761sy1gmb.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18MM72Y5ywtkv7+gyBvXvmsKw8X76u9ByY=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1156]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Geert Uytterhoeven <geert@linux-m68k.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/3] kexec: Add debug printing of kimage table entries
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> Print a list of pages to be copied if debugging is enabled.
> Consecutive entries are merged to reduce screen clutter.

Why is this desirable?

I can understand this as debugging code to understand what is happening,
but why would we want to maintain this print statement long term?

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Eric Biederman <ebiederm@xmission.com>
> ---
>  kernel/kexec.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 76 insertions(+)
>
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 490afc03627e..e25022ac229e 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1073,6 +1073,80 @@ asmlinkage long compat_sys_kexec_load(unsigned long entry,
>  }
>  #endif
>  
> +#ifdef DEBUG
> +struct kimage_block {
> +	unsigned long dst, src, len;
> +};
> +
> +static void kimage_print_block(const struct kimage_block *block)
> +{
> +	pr_info("Copy from 0x%lx-0x%lx to 0x%lx-0x%lx (0x%lx bytes)\n",
> +		block->src, block->src + block->len - 1, block->dst,
> +		block->dst + block->len - 1, block->len);
> +}
> +
> +static void kimage_print(const struct kimage *image)
> +{
> +	void *control_code_page;
> +	const kimage_entry_t *ptr;
> +	kimage_entry_t entry;
> +	struct kimage_block block;
> +	unsigned long dnext = KIMAGE_NO_DEST, snext = KIMAGE_NO_DEST;
> +	unsigned long total = 0;
> +
> +	control_code_page = page_address(image->control_code_page);
> +	pr_info("Control code page 0x%p (phys 0x%lx)\n",
> +		control_code_page, virt_to_phys(control_code_page));
> +
> +	ptr = &image->head;
> +	block.dst = KIMAGE_NO_DEST;
> +	block.src = KIMAGE_NO_DEST;
> +	block.len = 0;
> +	while ((entry = *ptr)) {
> +		if (entry & IND_DONE)
> +			break;
> +
> +		if (entry & IND_DESTINATION) {
> +			if (block.len > 0) {
> +				kimage_print_block(&block);
> +				total += block.len;
> +			}
> +			dnext = block.dst = entry & PAGE_MASK;
> +			block.src = KIMAGE_NO_DEST;
> +			block.len = 0;
> +		}
> +
> +		if (entry & IND_SOURCE) {
> +			if (!block.len) {
> +				snext = block.src = entry & PAGE_MASK;
> +			} else if ((entry & PAGE_MASK) != snext) {
> +				kimage_print_block(&block);
> +				total += block.len;
> +				block.dst = dnext;
> +				snext = block.src = entry & PAGE_MASK;
> +				block.len = 0;
> +			}
> +			dnext += PAGE_SIZE;
> +			snext += PAGE_SIZE;
> +			block.len += PAGE_SIZE;
> +		}
> +
> +		if (entry & IND_INDIRECTION) {
> +			pr_info("Indirection page 0x%lx\n", entry & PAGE_MASK);
> +			ptr = phys_to_virt(entry & PAGE_MASK);
> +		} else
> +			ptr++;
> +	}
> +	if (block.len) {
> +		kimage_print_block(&block);
> +		total += block.len;
> +	}
> +	pr_info("Total: 0x%lx/%ld bytes\n", total, total);
> +}
> +#else
> +static inline void kimage_print(const struct kimage *image) {}
> +#endif
> +
>  void crash_kexec(struct pt_regs *regs)
>  {
>  	/* Take the kexec_mutex here to prevent sys_kexec_load
> @@ -1090,6 +1164,7 @@ void crash_kexec(struct pt_regs *regs)
>  			crash_setup_regs(&fixed_regs, regs);
>  			crash_save_vmcoreinfo();
>  			machine_crash_shutdown(&fixed_regs);
> +			kimage_print(kexec_crash_image);
>  			machine_kexec(kexec_crash_image);
>  		}
>  		mutex_unlock(&kexec_mutex);
> @@ -1680,6 +1755,7 @@ int kernel_kexec(void)
>  		machine_shutdown();
>  	}
>  
> +	kimage_print(kexec_image);
>  	machine_kexec(kexec_image);
>  
>  #ifdef CONFIG_KEXEC_JUMP
