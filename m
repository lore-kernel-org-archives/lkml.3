Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3DLOt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 10:49:56 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:53512 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab3DLOtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 10:49:55 -0400
Message-ID: <51681F0E.1040900@parrot.com>
Date: Fri, 12 Apr 2013 16:49:50 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] binfmt_elf: fix return value in case of interpreter load
 failure
References: <1365688389-29908-1-git-send-email-matthieu.castet@parrot.com> <20130411150401.8bf008e05f5dd2239277e2c1@linux-foundation.org>
In-Reply-To: <20130411150401.8bf008e05f5dd2239277e2c1@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

thanks for your quick review.

Andrew Morton a écrit :
> On Thu, 11 Apr 2013 15:53:09 +0200 Matthieu CASTET <matthieu.castet@parrot.com> wrote:
> 
>> The current code return the address instead of using PTR_ERR.
> 
> I don't understand what you mean here - please describe this error in
> much more detail.  Help people to identify the section of code which
> is being discussed.

I was speaking of


 elf_entry = load_elf_interp(&loc->interp_elf_ex,
                        interpreter,
                        &interp_map_addr,
                        load_bias);
[...]
        if (BAD_ADDR(elf_entry)) {
            force_sig(SIGSEGV, current);
            retval = IS_ERR((void *)elf_entry) ?
                    (int)elf_entry : -EINVAL;
            goto out_free_dentry;
        }

and was expecting we should use PTR_ERR when IS_ERR is true to match what is
done in [1].

But didn't saw that PTR_ERR((void *)elf_entry) and (int)elf_entry are equivalent.

> 
>> Also the check is done after adding e_entry. This can cause weird behaviour
>> because -errno + loc->interp_elf_ex.e_entry can produce a valid address.
> 
> Which check?

I am really confused here. Reading again the code this can't happen because if
load_elf_interp return -errno


We don't enter this condition
>         if (!IS_ERR((void *)elf_entry)) {
>             /*
>              * load_elf_interp() returns relocation
>              * adjustment
>              */
>             interp_load_addr = elf_entry;
>             elf_entry += loc->interp_elf_ex.e_entry;
>         }
we still have -errno here
>         if (BAD_ADDR(elf_entry)) {
>             force_sig(SIGSEGV, current);
>             retval = IS_ERR((void *)elf_entry) ?
>                     (int)elf_entry : -EINVAL;
>             goto out_free_dentry;
>         }


Sorry for my mistake.

The only valid remaining part of my patch is to return SIGKILL when
load_elf_interp fail (IS_ERR((void *)elf_entry) is true) (for example load
address of linker is bad) instead of SIGSEGV. This will follow what is done when
loading binary.

But is it even worth doing?


> 
>> Add a check to test load error before adding entry address. Also in this
>> case send SIGKILL instead of SIGSEGV to match what is done when loading binary.
>>
>> ...
>>
>> --- a/fs/binfmt_elf.c
>> +++ b/fs/binfmt_elf.c
>> @@ -900,18 +900,21 @@ static int load_elf_binary(struct linux_binprm *bprm)
>>  					    interpreter,
>>  					    &interp_map_addr,
>>  					    load_bias);
>> -		if (!IS_ERR((void *)elf_entry)) {
>> -			/*
>> -			 * load_elf_interp() returns relocation
>> -			 * adjustment
>> -			 */
>> -			interp_load_addr = elf_entry;
>> -			elf_entry += loc->interp_elf_ex.e_entry;
>> +		if (BAD_ADDR(elf_entry)) {
>> +			force_sig(SIGKILL, current);
>> +			retval = IS_ERR((void *)elf_entry) ?
>> +					PTR_ERR((void *)elf_entry) : -EINVAL;
> 
> Thats's a bit verbose - "PTR_ERR((void *)elf_entry)" is equivalent to
> "elf_entry".  I suppose we can do it this way to document the intent or
> something.
Ok, I see.
Note that [1] use PTR_ERR but elf_map already return unsigned long like
load_elf_interp.



Matthieu



[1]
        error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
                elf_prot, elf_flags, 0);
        if (BAD_ADDR(error)) {
            send_sig(SIGKILL, current, 0);
            retval = IS_ERR((void *)error) ?
                PTR_ERR((void*)error) : -EINVAL;
            goto out_free_dentry;
        }
