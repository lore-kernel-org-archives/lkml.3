Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbaEEEMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 00:12:17 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:57387 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaEEEMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 00:12:14 -0400
Message-ID: <53670F35.6010502@linux.vnet.ibm.com>
Date: Mon, 05 May 2014 09:40:29 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Pedro Alves <palves@redhat.com>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com, suresh.b.siddha@intel.com
Subject: Re: [PATCH] ptrace: Fix PTRACE_GETREGSET/PTRACE_SETREGSET in code
 documentation
References: <1398682853-7541-1-git-send-email-khandual@linux.vnet.ibm.com> <53625681.8010905@redhat.com>
In-Reply-To: <53625681.8010905@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050504-5816-0000-0000-00000DD668CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 07:43 PM, Pedro Alves wrote:
> On 04/28/2014 12:00 PM, Anshuman Khandual wrote:
>> The current documentation is bit misleading and does not explicitly
>> specify that iov.len need to be initialized failing which kernel
>> may just ignore the ptrace request and never read from/write into
>> the user specified buffer. This patch fixes the documentation.
> 
> Well, it kind of does, here:
> 
> *      struct iovec iov = { buf, len};

:) Thats not explicit enough.

> 
>> @@ -43,8 +43,12 @@
>>   *
>>   *	ret = ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid, NT_XXX_TYPE, &iov);
>>   *
>> - * On the successful completion, iov.len will be updated by the kernel,
>> - * specifying how much the kernel has written/read to/from the user's iov.buf.
>> + * A non-zero value upto the max size of data expected to be written/read by the
>> + * kernel in response to any NT_XXX_TYPE request type must be assigned to iov.len
>> + * before initiating the ptrace call. If iov.len is 0, then kernel will neither
>> + * read from or write into the user buffer specified. On successful completion,
>> + * iov.len will be updated by the kernel, specifying how much the kernel has
>> + * written/read to/from the user's iov.buf.
> 
> I really appreciate that you're trying to make this clearer, but I
> find the new sentence very hard to read/reason.  :-/
> 
> I suggest:
> 
>  * This interface usage is as follows:
> - *      struct iovec iov = { buf, len};
> + *      struct iovec iov = { buf, len };
>  *
>  *      ret = ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid, NT_XXX_TYPE, &iov);
>  *
> - * On the successful completion, iov.len will be updated by the kernel,
> - * specifying how much the kernel has written/read to/from the user's iov.buf.
> + * On entry, iov describes the buffer's address and length.  The buffer's
> + * length must be equal to or shorter than the size of the NT_XXX_TYPE regset.
> + * On successful completion, iov.len is updated by the kernel, specifying how
> + * much the kernel has written/read to/from the user's iov.buf.
> 

Yeah, sounds better. I may add "If the length is zero, the kernel will neither read
from or write into the buffer"

> I'm not sure I understood what you're saying correctly, though.  Specifically,
> I don't know whether the buffer's length must really be shorter than the
> size of the NT_XXX_TYPE regset.

No, it does not have to. From the code snippet below (ptrace_regset function)
the buffer length has to be multiple of regset->size for the given NT_XXX_TYPE
upto the max regset size for the user to see any valid data. The problem what I
faced was when you use any iovec structure with the length parameter uninitialized,
the kernel simply ignores and does not return anything.

        if (!regset || (kiov->iov_len % regset->size) != 0)
                return -EINVAL;
 
> 
>> The current documentation is bit misleading and does not explicitly
>> specify that iov.len need to be initialized failing which kernel
>> may just ignore the ptrace request and never read from/write into
>> the user specified buffer.
> 
> You're saying that if iov.len is larger than the NT_XXX_TYPE regset,
> then the kernel returns _success_, but actually doesn't fill the
> buffer?  That sounds like a bug to me.

No, I am not saying that. The kernel takes care of that situation by capping
the length to regset size of the NT_XXX_TYPE.

 kiov->iov_len = min(kiov->iov_len,
                            (__kernel_size_t) (regset->n * regset->size));


Shall I resend the patch with the your proposed changes and your "Signed-off-by" and
moving myself as "Reported-by" ?





