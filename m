Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaENHMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:12:13 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:54400 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaENHMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:12:08 -0400
Message-ID: <537316DB.4060701@linux.vnet.ibm.com>
Date: Wed, 14 May 2014 12:40:19 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Pedro Alves <palves@redhat.com>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com, suresh.b.siddha@intel.com
Subject: Re: [PATCH] ptrace: Fix PTRACE_GETREGSET/PTRACE_SETREGSET in code
 documentation
References: <1398682853-7541-1-git-send-email-khandual@linux.vnet.ibm.com> <53625681.8010905@redhat.com> <53670F35.6010502@linux.vnet.ibm.com> <53725FF6.6060004@redhat.com>
In-Reply-To: <53725FF6.6060004@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051407-5816-0000-0000-00000E004BC3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 11:39 PM, Pedro Alves wrote:
> On 05/05/14 05:10, Anshuman Khandual wrote:
>> On 05/01/2014 07:43 PM, Pedro Alves wrote:
>>> On 04/28/2014 12:00 PM, Anshuman Khandual wrote:
>>>> The current documentation is bit misleading and does not explicitly
>>>> specify that iov.len need to be initialized failing which kernel
>>>> may just ignore the ptrace request and never read from/write into
>>>> the user specified buffer. This patch fixes the documentation.
>>>
>>> Well, it kind of does, here:
>>>
>>> *      struct iovec iov = { buf, len};
>>
>> :) Thats not explicit enough.
>>
>>>
>>>> @@ -43,8 +43,12 @@
>>>>   *
>>>>   *	ret = ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid, NT_XXX_TYPE, &iov);
>>>>   *
>>>> - * On the successful completion, iov.len will be updated by the kernel,
>>>> - * specifying how much the kernel has written/read to/from the user's iov.buf.
>>>> + * A non-zero value upto the max size of data expected to be written/read by the
>>>> + * kernel in response to any NT_XXX_TYPE request type must be assigned to iov.len
>>>> + * before initiating the ptrace call. If iov.len is 0, then kernel will neither
>>>> + * read from or write into the user buffer specified. On successful completion,
>>>> + * iov.len will be updated by the kernel, specifying how much the kernel has
>>>> + * written/read to/from the user's iov.buf.
>>>
>>> I really appreciate that you're trying to make this clearer, but I
>>> find the new sentence very hard to read/reason.  :-/
>>>
>>> I suggest:
>>>
>>>  * This interface usage is as follows:
>>> - *      struct iovec iov = { buf, len};
>>> + *      struct iovec iov = { buf, len };
>>>  *
>>>  *      ret = ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid, NT_XXX_TYPE, &iov);
>>>  *
>>> - * On the successful completion, iov.len will be updated by the kernel,
>>> - * specifying how much the kernel has written/read to/from the user's iov.buf.
>>> + * On entry, iov describes the buffer's address and length.  The buffer's
>>> + * length must be equal to or shorter than the size of the NT_XXX_TYPE regset.
>>> + * On successful completion, iov.len is updated by the kernel, specifying how
>>> + * much the kernel has written/read to/from the user's iov.buf.
>>>
>>
>> Yeah, sounds better. I may add "If the length is zero, the kernel will neither read
>> from or write into the buffer"
> 
> Well, I think that much should be obvious.  What's not obvious is
> whether that is considered success or error (what is the return code?)
> I suspect and expect success return if the regset type is known, and
> error otherwise.  So that could be used as a way to probe for support
> for a given regset without using stack or heap space, if it ever matters.
> The kernel never reads/writes beyond iov.len, so better say that, and
> then it automatically gets the 0 case handled too, right?
> 
>>> I'm not sure I understood what you're saying correctly, though.  Specifically,
>>> I don't know whether the buffer's length must really be shorter than the
>>> size of the NT_XXX_TYPE regset.
>>
>> No, it does not have to. From the code snippet below (ptrace_regset function)
>> the buffer length has to be multiple of regset->size for the given NT_XXX_TYPE
>> upto the max regset size for the user to see any valid data.
> 
> Ah, I guess one could call it a bug.  If the passed in
> len is bigger than the whole register set size, then there seems
> to be no point in validating whether the length is multiple of
> a single register's size.  That unnecessarily prevents coming up
> with a register set in the future that has registers of
> different sizes...
> 
> But given that that's how things are today, I suppose we should
> document it...
> 
>  The problem what I
>> faced was when you use any iovec structure with the length parameter uninitialized,
>> the kernel simply ignores and does not return anything.
> 
> Ah.  Well, saying "does not return anything" is quite confusing.  It does
> return something -- -EINVAL.
> 
>>
>>         if (!regset || (kiov->iov_len % regset->size) != 0)
>>                 return -EINVAL;
> 
>>  
>>>
>>>> The current documentation is bit misleading and does not explicitly
>>>> specify that iov.len need to be initialized failing which kernel
>>>> may just ignore the ptrace request and never read from/write into
>>>> the user specified buffer.
>>>
>>> You're saying that if iov.len is larger than the NT_XXX_TYPE regset,
>>> then the kernel returns _success_, but actually doesn't fill the
>>> buffer?  That sounds like a bug to me.
>>
>> No, I am not saying that. The kernel takes care of that situation by capping
>> the length to regset size of the NT_XXX_TYPE.
>>
>>  kiov->iov_len = min(kiov->iov_len,
>>                             (__kernel_size_t) (regset->n * regset->size));
>>
>>
> 
> OK, then this is what I suggest instead:
> 
>    * This interface usage is as follows:
>  - *      struct iovec iov = { buf, len};
>  + *      struct iovec iov = { buf, len };
>    *
>    *      ret = ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid, NT_XXX_TYPE, &iov);
>    *
>    * On the successful completion, iov.len will be updated by the kernel,
>  - * specifying how much the kernel has written/read to/from the user's iov.buf.
>  + * On entry, iov describes the buffer's address and length.  The buffer's
>  + * length must be a multiple of the size of a single register in the register set.
>  + * The kernel never reads or writes more than iov.len, and caps the buffer
>  + * length to the register set's size.  In other words, the kernel reads or
>  + * writes min(iov.len, regset size).
>  + * On successful completion, iov.len is updated by the kernel, specifying how
>  + * much the kernel has read from / written to the user's iov.buf.
> 
>> Shall I resend the patch with the your proposed changes and your "Signed-off-by" and
>> moving myself as "Reported-by" ?
> 
> No idea of the actual policy to follow.  Feel free to do that if that's the
> standard procedure.

Even I am not sure about this, so to preserve the correct authorship, would you
mind sending this patch ?

