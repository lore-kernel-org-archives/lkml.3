Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3DKWEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 18:04:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3DKWED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 18:04:03 -0400
Date: Thu, 11 Apr 2013 15:04:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] binfmt_elf: fix return value in case of interpreter
 load failure
Message-Id: <20130411150401.8bf008e05f5dd2239277e2c1@linux-foundation.org>
In-Reply-To: <1365688389-29908-1-git-send-email-matthieu.castet@parrot.com>
References: <1365688389-29908-1-git-send-email-matthieu.castet@parrot.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Apr 2013 15:53:09 +0200 Matthieu CASTET <matthieu.castet@parrot.com> wrote:

> The current code return the address instead of using PTR_ERR.

I don't understand what you mean here - please describe this error in
much more detail.  Help people to identify the section of code which
is being discussed.

> Also the check is done after adding e_entry. This can cause weird behaviour
> because -errno + loc->interp_elf_ex.e_entry can produce a valid address.

Which check?

> Add a check to test load error before adding entry address. Also in this
> case send SIGKILL instead of SIGSEGV to match what is done when loading binary.
> 
> ...
>
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -900,18 +900,21 @@ static int load_elf_binary(struct linux_binprm *bprm)
>  					    interpreter,
>  					    &interp_map_addr,
>  					    load_bias);
> -		if (!IS_ERR((void *)elf_entry)) {
> -			/*
> -			 * load_elf_interp() returns relocation
> -			 * adjustment
> -			 */
> -			interp_load_addr = elf_entry;
> -			elf_entry += loc->interp_elf_ex.e_entry;
> +		if (BAD_ADDR(elf_entry)) {
> +			force_sig(SIGKILL, current);
> +			retval = IS_ERR((void *)elf_entry) ?
> +					PTR_ERR((void *)elf_entry) : -EINVAL;

Thats's a bit verbose - "PTR_ERR((void *)elf_entry)" is equivalent to
"elf_entry".  I suppose we can do it this way to document the intent or
something.

It would be helpful if load_elf_interp() had some documentation
describing its return value btw.


> +			goto out_free_dentry;
>  		}
> +		/*
> +		 * load_elf_interp() returns relocation
> +		 * adjustment

This can now be converted to a single-line comment.

> +		 */
> +		interp_load_addr = elf_entry;
> +		elf_entry += loc->interp_elf_ex.e_entry;
>  		if (BAD_ADDR(elf_entry)) {
>  			force_sig(SIGSEGV, current);
> -			retval = IS_ERR((void *)elf_entry) ?
> -					(int)elf_entry : -EINVAL;
> +			retval = -EINVAL;
>  			goto out_free_dentry;
>  		}
>  		reloc_func_desc = interp_load_addr;

