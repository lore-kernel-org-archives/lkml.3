Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410AbaELNSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:18:12 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2404 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbaELNSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:18:10 -0400
Message-ID: <5370CA01.10802@xs4all.nl>
Date: Mon, 12 May 2014 15:17:53 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix _IOC_TYPECHECK sparse error
References: <536C873E.8060408@xs4all.nl> <20140509135949.feac79f3cb0ed9b13afbfeb4@linux-foundation.org>
In-Reply-To: <20140509135949.feac79f3cb0ed9b13afbfeb4@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 10:59 PM, Andrew Morton wrote:
> On Fri, 09 May 2014 09:43:58 +0200 Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> Andrew, can you merge this for 3.15 or 3.16 (you decide)? While it fixes a sparse error
>> for the media subsystem, it is not really appropriate to go through our media tree.
>>
>> Thanks,
>>
>> 	Hans
>>
>>
>> When running sparse over drivers/media/v4l2-core/v4l2-ioctl.c I get these
>> errors:
>>
>> drivers/media/v4l2-core/v4l2-ioctl.c:2043:9: error: bad integer constant expression
>> drivers/media/v4l2-core/v4l2-ioctl.c:2044:9: error: bad integer constant expression
>> drivers/media/v4l2-core/v4l2-ioctl.c:2045:9: error: bad integer constant expression
>> drivers/media/v4l2-core/v4l2-ioctl.c:2046:9: error: bad integer constant expression
>>
>> etc.
>>
>> The root cause of that turns out to be in include/asm-generic/ioctl.h:
>>
>> #include <uapi/asm-generic/ioctl.h>
>>
>> /* provoke compile error for invalid uses of size argument */
>> extern unsigned int __invalid_size_argument_for_IOC;
>> #define _IOC_TYPECHECK(t) \
>>         ((sizeof(t) == sizeof(t[1]) && \
>>           sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
>>           sizeof(t) : __invalid_size_argument_for_IOC)
>>
>> If it is defined as this (as is already done if __KERNEL__ is not defined):
>>
>> #define _IOC_TYPECHECK(t) (sizeof(t))
>>
>> then all is well with the world.
>>
>> This patch allows sparse to work correctly.
>>
>> --- a/include/asm-generic/ioctl.h
>> +++ b/include/asm-generic/ioctl.h
>> @@ -3,10 +3,15 @@
>>  
>>  #include <uapi/asm-generic/ioctl.h>
>>  
>> +#ifdef __CHECKER__
>> +#define _IOC_TYPECHECK(t) (sizeof(t))
>> +#else
>>  /* provoke compile error for invalid uses of size argument */
>>  extern unsigned int __invalid_size_argument_for_IOC;
>>  #define _IOC_TYPECHECK(t) \
>>  	((sizeof(t) == sizeof(t[1]) && \
>>  	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
>>  	  sizeof(t) : __invalid_size_argument_for_IOC)
>> +#endif
>> +
>>  #endif /* _ASM_GENERIC_IOCTL_H */
> 
> Can't we use BUILD_BUG_ON() here?  That's neater, more standard and
> BUILD_BUG_ON() already has sparse handling.  

I don't think so. BUILD_BUG_ON is not meant to be used in an expression, whereas
_IOC_TYPECHECK(t) is (it should return sizeof(t)).

This looked promising at first sight:

#define _IOC_TYPECHECK(t) \
        ({BUILD_BUG_ON(sizeof(t) == sizeof(t[1]) && sizeof(t) < (1 << _IOC_SIZEBITS)); \
         sizeof(t);})

But it leads to 'case label does not reduce to an integer constant' compile errors.

And a typical ioctl define expands to this horror:

 case (((2U) << (((0 +8)+8)+14)) | ((('M')) << (0 +8)) | (((1)) << 0) | (((({do { bool __cond = !(!(sizeof(int) == sizeof(int[1]) && sizeof(int) < (1 << 14))); extern void __compiletime_assert_1909(void) __attribute__((error("BUILD_BUG_ON failed: " "sizeof(int) == sizeof(int[1]) && sizeof(int) < (1 << _IOC_SIZEBITS)"))); if (__cond) __compiletime_assert_1909(); do { } while (0); } while (0); sizeof(int);}))) << ((0 +8)+8))):

which also explains the errors: case labels with function calls in them won't compile.

So I think my proposed patch is the best approach.

Regards,

	Hans
