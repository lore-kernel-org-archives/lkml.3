Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3LXJI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 04:08:57 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:44323 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3LXJIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 04:08:53 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwbrdgO_=LQ5=p2J=QmX_BmCvNbGGcxS0C0dKqocAkfYA@mail.gmail.com>
References: <1387820970-6949-1-git-send-email-ard.biesheuvel@linaro.org>
	<CA+55aFwbrdgO_=LQ5=p2J=QmX_BmCvNbGGcxS0C0dKqocAkfYA@mail.gmail.com>
Date: Tue, 24 Dec 2013 10:08:52 +0100
Message-ID: <CAKv+Gu8-pUrh1m+RyTCNtpaoJhN_jEfDDXq+33aZMOJDW-t3zw@mail.gmail.com>
Subject: Re: [PATCH] auxvec.h: account for AT_HWCAP2 in AT_VECTOR_SIZE_BASE
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Neuling <michael@neuling.org>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 December 2013 02:37, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> Please cc the guilty parties when sending patches like this.
>

OK.
[Added Al Viro as well as this affects fs/binfmt_elf.c]

> Also, just out of interest, please describe how this bug affected
> things. Did we overflow the saved_auxv[] array, or what?

That is the risk, yes. AT_VECTOR_SIZE_BASE is supposed to be an upper
bound for the number of generic auxv entries, and this is currently
not the case. However, I am not aware of any actual problems that have
been caused, and powerpc is indeed the only arch that defines
ELF_HWCAP2 at the moment. But I spotted this when working on a series
that adds ELF_HWCAP2 to ARM, and other archs may follow in the future.

> Also, how
> does this change affect architectures that _don't_ have that
> ELF_HWCAP2 thing, ie everything but powerpc?
>

Some wasted space (two longs) in saved_auxv[] in mm_struct.

-- 
Ard.



> Acks, people?
>
>            Linus
>
> On Mon, Dec 23, 2013 at 9:49 AM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> Commit 2171364d1a92 (powerpc: Add HWCAP2 aux entry) introduced a new
>> AT_ auxv entry type AT_HWCAP2 but failed to update AT_VECTOR_SIZE_BASE
>> accordingly.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Fixes: 2171364d1a92 (powerpc: Add HWCAP2 aux entry)
>> Cc: stable@vger.kernel.org
>> ---
>>
>>  include/linux/auxvec.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
>> index 669fef5..3e0fbe4 100644
>> --- a/include/linux/auxvec.h
>> +++ b/include/linux/auxvec.h
>> @@ -3,6 +3,6 @@
>>
>>  #include <uapi/linux/auxvec.h>
>>
>> -#define AT_VECTOR_SIZE_BASE 19 /* NEW_AUX_ENT entries in auxiliary table */
>> +#define AT_VECTOR_SIZE_BASE 20 /* NEW_AUX_ENT entries in auxiliary table */
>>    /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
>>  #endif /* _LINUX_AUXVEC_H */
>> --
>> 1.8.3.2
>
