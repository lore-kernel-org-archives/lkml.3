Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab3GBBNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 21:13:24 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:6128 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab3GBBNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 21:13:23 -0400
Message-ID: <51D22931.1080008@hp.com>
Date: Mon, 01 Jul 2013 18:13:21 -0700
From: Chegu Vinod <chegu_vinod@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: prarit@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>
Subject: Re: kvm_intel: Could not allocate 42 bytes percpu data
References: <51C897A7.50302@hp.com> <87ehbisstv.fsf@rustcorp.com.au>
In-Reply-To: <87ehbisstv.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/30/2013 11:22 PM, Rusty Russell wrote:
> Chegu Vinod <chegu_vinod@hp.com> writes:
>> Hello,
>>
>> Lots (~700+) of the following messages are showing up in the dmesg of a
>> 3.10-rc1 based kernel (Host OS is running on a large socket count box
>> with HT-on).
>>
>> [   82.270682] PERCPU: allocation failed, size=42 align=16, alloc from
>> reserved chunk failed
>> [   82.272633] kvm_intel: Could not allocate 42 bytes percpu data
> Woah, weird....
>
> Oh.  Shit.  Um, this is embarrassing.
>
> Thanks,
> Rusty.


Thanks for your response!

> ===
> module: do percpu allocation after uniqueness check.  No, really!
>
> v3.8-rc1-5-g1fb9341 was supposed to stop parallel kvm loads exhausting
> percpu memory on large machines:
>
>      Now we have a new state MODULE_STATE_UNFORMED, we can insert the
>      module into the list (and thus guarantee its uniqueness) before we
>      allocate the per-cpu region.
>
> In my defence, it didn't actually say the patch did this.  Just that
> we "can".
>
> This patch actually *does* it.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Tested-by: Noone it seems.

Your following "updated" fix seems to be working fine on the larger 
socket count machine with HT-on.

Thx
Vinod
>
> diff --git a/kernel/module.c b/kernel/module.c
> index cab4bce..fa53db8 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2927,7 +2927,6 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
>   {
>   	/* Module within temporary copy. */
>   	struct module *mod;
> -	Elf_Shdr *pcpusec;
>   	int err;
>   
>   	mod = setup_load_info(info, flags);
> @@ -2942,17 +2941,10 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
>   	err = module_frob_arch_sections(info->hdr, info->sechdrs,
>   					info->secstrings, mod);
>   	if (err < 0)
> -		goto out;
> +		return ERR_PTR(err);
>   
> -	pcpusec = &info->sechdrs[info->index.pcpu];
> -	if (pcpusec->sh_size) {
> -		/* We have a special allocation for this section. */
> -		err = percpu_modalloc(mod,
> -				      pcpusec->sh_size, pcpusec->sh_addralign);
> -		if (err)
> -			goto out;
> -		pcpusec->sh_flags &= ~(unsigned long)SHF_ALLOC;
> -	}
> +	/* We will do a special allocation for per-cpu sections later. */
> +	info->sechdrs[info->index.pcpu].sh_flags &= ~(unsigned long)SHF_ALLOC;
>   
>   	/* Determine total sizes, and put offsets in sh_entsize.  For now
>   	   this is done generically; there doesn't appear to be any
> @@ -2963,17 +2955,22 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
>   	/* Allocate and move to the final place */
>   	err = move_module(mod, info);
>   	if (err)
> -		goto free_percpu;
> +		return ERR_PTR(err);
>   
>   	/* Module has been copied to its final place now: return it. */
>   	mod = (void *)info->sechdrs[info->index.mod].sh_addr;
>   	kmemleak_load_module(mod, info);
>   	return mod;
> +}
>   
> -free_percpu:
> -	percpu_modfree(mod);
> -out:
> -	return ERR_PTR(err);
> +static int alloc_module_percpu(struct module *mod, struct load_info *info)
> +{
> +	Elf_Shdr *pcpusec = &info->sechdrs[info->index.pcpu];
> +	if (!pcpusec->sh_size)
> +		return 0;
> +
> +	/* We have a special allocation for this section. */
> +	return percpu_modalloc(mod, pcpusec->sh_size, pcpusec->sh_addralign);
>   }
>   
>   /* mod is no longer valid after this! */
> @@ -3237,6 +3234,11 @@ static int load_module(struct load_info *info, const char __user *uargs,
>   	}
>   #endif
>   
> +	/* To avoid stressing percpu allocator, do this once we're unique. */
> +	err = alloc_module_percpu(mod, info);
> +	if (err)
> +		goto unlink_mod;
> +
>   	/* Now module is in final location, initialize linked lists, etc. */
>   	err = module_unload_init(mod);
>   	if (err)
> .
>

