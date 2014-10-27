Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaJ0Qqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:46:39 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35353 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaJ0Qqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:46:37 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-f4-544e76ea496b
Message-id: <544E76E9.3090909@samsung.com>
Date: Mon, 27 Oct 2014 19:46:33 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, David Miller <davem@davemloft.net>
Cc: pablo@netfilter.org, mschmidt@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netlink: don't copy over empty attribute data
References: <54471438.1040907@oracle.com>
 <20141022.021508.2011745433893496421.davem@davemloft.net>
 <544D849A.4040304@oracle.com>
 <20141026.220350.2098346782596904995.davem@davemloft.net>
 <544E59DC.3060906@oracle.com>
In-reply-to: <544E59DC.3060906@oracle.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xK7qvyvxCDLZ81rSYs34Nm8Wc8y0s
	Fpd3zWGzWLh0GrPFsQViFtPfXGW2WHzkNrMDu8eWlTeZPE7M+M3i8fb3CSaPj09vsXi833eV
	zePzJrkAtigum5TUnMyy1CJ9uwSujFm3JjAXzOSvmP2kn6WB8RN3FyMnh4SAicSqNy2sELaY
	xIV769lAbCGBpYwSizcLQtjNTBKrj5mD2LwCWhJNbZfZQWwWAVWJHYs3MIPYbAJ6Ev9mbQfr
	FRWIkLiyZg4jRL2gxI/J91hAbBEBH4llj9vAapgF6iVOzNkJViMs4CSxZmsHUA0X0K6HjBIf
	HlwDG8oJtGz/lv9ARRxADXoS9y9qQfTKS2xe85Z5AqPALCQrZiFUzUJStYCReRWjaGppckFx
	UnqukV5xYm5xaV66XnJ+7iZGSKB/3cG49JjVIUYBDkYlHt4Jxb4hQqyJZcWVuYcYJTiYlUR4
	D6T5hQjxpiRWVqUW5ccXleakFh9iZOLglGpgFA7Q/RS2bbOgdN1sxtNKU44GTuMXLQi3Lil0
	Si+d4a2ZNJvr3N35d9Q9zQxCmy6XbO+8UfOp3vTizg+rnouaqNW0TznNFPX7oLuVkNRVv2M8
	d26ENzuuCA/hOPN5o9/EqLyzdhkyMvKOf+r0b+R/STg3dSnfX9v7cyv7ONYKuXTtvKAlv/iC
	EktxRqKhFnNRcSIA20ogqFICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 05:42 PM, Sasha Levin wrote:
> On 10/26/2014 10:03 PM, David Miller wrote:
>> From: Sasha Levin <sasha.levin@oracle.com>
>> Date: Sun, 26 Oct 2014 19:32:42 -0400
>>
>>> How so? GCC states clearly that you should *never* pass a NULL
>>> pointer there:
>>>
>>> "The pointers passed to memmove (and similar functions in <string.h>) must
>>> be non-null even when nbytes==0" (https://gcc.gnu.org/gcc-4.9/porting_to.html).
>>>
>>> Even if it doesn't dereference it, it can break somehow in a subtle way. Leaving
>>> the kernel code assuming that gcc (or any other compiler) would always behave
>>> the same in a situation that shouldn't occur.
>>
>> Show me a legal way in which one could legally dereference the pointer
>> when length is zero, and I'll entertain this patch.
> 
> The moment you've triggered an undefined behaviour you have GCC license to
> dereference anything it wants. GCC would be well within it's rights
> dereferencing a NULL "from".
> 
> They even state it clearly in that GCC 4.9 porting guide I've linked above:
> 
> """
> Calling copy(p, NULL, 0) can therefore deference a null pointer and crash.
> 
> The example above needs to be fixed to avoid the invalid memmove call, for example:
> 
> 
>     if (nbytes != 0)
>       memmove (dest, src, nbytes);
> """
> 


In example from link null ptr deref could happen because GCC will optimize away null pointer check after
memmove():

int copy (int* dest, int* src, size_t nbytes) {
    memmove (dest, src, nbytes);
    if (src != NULL)  <---- GCC will eliminate this check because src can't be null.
      return *src; <-- NULL ptr deref
    return 0;
  }

Even though GCC and C standard treats such code ( memmove(dest, NULL, 0); ) as invalid, it probably will not crash in linux kernel case,
because that kind of optimization disabled via -fno-delete-null-pointer-checks option.


> 
> Thanks,
> Sasha
> 

