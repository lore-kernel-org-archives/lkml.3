Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaIKFhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 01:37:52 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43684 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaIKFhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 01:37:47 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-3e-54113528718d
Message-id: <5411339E.8080007@samsung.com>
Date: Thu, 11 Sep 2014 09:31:10 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.7.0
MIME-version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>, x86@kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC/PATCH v2 02/10] x86_64: add KASan support
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-3-git-send-email-a.ryabinin@samsung.com>
 <54111E99.7080309@zytor.com>
In-reply-to: <54111E99.7080309@zytor.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t/xy7qapoIhBl3XGC1+753JajFn/Ro2
	iyPXvrNbXP/2htHi08sHjBbPHz5kt5jwsI3dYtpGcYuV3c1sFtufvWWyWNn5gNXi8q45bBb3
	1vxntbh0YAGTxeIjt5kt3j2bzGyxedNUZourqw6yW/zY8JjVQdhj/s6PjB47Z91l91iwqdRj
	8Z6XTB6bVnWyeWz6NIndo+vtFSaPd+fOsXucmPGbxePJlelMHh+f3mLxeL/vKpvH501yHida
	vrAG8EVx2aSk5mSWpRbp2yVwZbR2fWcqaBCu2H1kGksD40L+LkZODgkBE4lJH/azQ9hiEhfu
	rWfrYuTiEBJYyigxZ9YmKKeZSeLQlMnMIFW8AloS6yZ9B7NZBFQlVn66AGazCehJ/Ju1nQ3E
	FhWIkPj5+Rs7RL2gxI/J91hAbBEBJ4lDR54ygwxlFnjLInHnzV6wZmEBa4mNe/exQmy7xyjx
	oWUpE0iCU0BT4unKm0BFHEAdehL3L2qBhJkF5CU2r3nLPIFRYBaSHbMQqmYhqVrAyLyKUTS1
	NLmgOCk911CvODG3uDQvXS85P3cTIyRqv+xgXHzM6hCjAAejEg9v4UX+ECHWxLLiytxDjBIc
	zEoivAkPBEKEeFMSK6tSi/Lji0pzUosPMTJxcEo1MGb9WTznwv43TS9tZTy23Lhz8vr94J6t
	nj0ThX7rmds9iQwJvXg8ZIXOl5z5NmKi5Xobb/zWdA0tLjd82DFh9yrfx88FREs6dK4nTata
	GH7yQMn+ddz/Thw/kbV467yI3KbYoCMhTKcTLA33Tjh95pzCkXULmiz9dH44Fm5kkfK4NYM3
	WWMT00MlluKMREMt5qLiRAC83+/puAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 08:01 AM, H. Peter Anvin wrote:
> On 09/10/2014 07:31 AM, Andrey Ryabinin wrote:
>> This patch add arch specific code for kernel address sanitizer.
>>
>> 16TB of virtual addressed used for shadow memory.
>> It's located in range [0xffff800000000000 - 0xffff900000000000]
>> Therefore PAGE_OFFSET has to be changed from 0xffff880000000000
>> to 0xffff900000000000.
> 
> NAK on this.
> 
> 0xffff880000000000 is the lowest usable address because we have agreed
> to leave 0xffff800000000000-0xffff880000000000 for the hypervisor or
> other non-OS uses.
> 
> Bumping PAGE_OFFSET seems needlessly messy, why not just designate a
> zone higher up in memory?
> 

I already answered to Dave why I choose to place shadow bellow PAGE_OFFSET (answer copied bellow).
In short - yes, shadow could be higher. But for some sort of kernel bugs we could have confusing oopses in kasan kernel.

On 09/11/2014 12:30 AM, Andrey Ryabinin wrote:
> 2014-09-10 19:46 GMT+04:00 Dave Hansen <dave.hansen@intel.com>:
>>
>> Is there a reason this has to be _below_ the linear map?  Couldn't we
>> just carve some space out of the vmalloc() area for the kasan area?
>>
>
> Yes, there is a reason for this. For inline instrumentation we need to
> catch access to userspace without any additional check.
> This means that we need shadow of 1 << 61 bytes and we don't have so
> many addresses available. However, we could use
> hole between userspace and kernelspace for that. For any address
> between [0 - 0xffff800000000000], shadow address will be
> in this hole, so checking shadow value will produce general protection
> fault (GPF). We may even try handle GPF in a special way
> and print more user-friendly report (this will be under CONFIG_KASAN of course).
>
> But now I realized that we even if we put shadow in vmalloc, shadow
> addresses  corresponding to userspace addresses
> still will be in between userspace - kernelspace, so we also will get GPF.
> There is the only problem I see now in such approach. Lets consider
> that because of some bug in kernel we are trying to access
> memory slightly bellow 0xffff800000000000. In this case kasan will try
> to check some shadow which in fact is not a shadow byte at all.
> It's not a big deal though, kernel will crash anyway. In only means
> that debugging of such problems could be a little more complex
> than without kasan.
>
>

