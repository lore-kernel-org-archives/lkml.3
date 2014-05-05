Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbaEEKzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 06:55:18 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59569 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaEEKzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 06:55:15 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-65-53676e11bfe6
Message-id: <53676D12.9040300@samsung.com>
Date: Mon, 05 May 2014 14:50:58 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: nicolas.pitre@linaro.org, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: put_user: fix possible data corruption in put_user
References: <1399270438-26181-1-git-send-email-a.ryabinin@samsung.com>
 <20140505090126.GD3693@n2100.arm.linux.org.uk>
In-reply-to: <20140505090126.GD3693@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t/xK7qCeenBBgsniFtsenyN1eLyrjls
	Frcv81p8evaP3eLlxxMsDqwea+atYfRoae5h87hzbQ+bx+Yl9R6fN8kFsEZx2aSk5mSWpRbp
	2yVwZXy7+JilYIlwxcNj95kaGDfxdzFyckgImEj0HHjCCGGLSVy4t54NxBYSWMoosXK/XBcj
	F5DdyCRx7PxlsCJeAS2J1a13mUBsFgFVia9zz7CD2GwCehL/Zm0HaxYViJC413iYFaJeUOLH
	5HssILaIgKnEtUfPmEFsZoFyiQOznoPFhQV8JP68XwpUzwG0rFzi208XkDCngLXEnw8rWSDK
	dST2t05jg7DlJTavecs8gVFgFpINs5CUzUJStoCReRWjaGppckFxUnquoV5xYm5xaV66XnJ+
	7iZGSCh/2cG4+JjVIUYBDkYlHt7AoJRgIdbEsuLK3EOMEhzMSiK82YnpwUK8KYmVValF+fFF
	pTmpxYcYmTg4pRoY6wsdr8UKZ+/pkDjw0PG5fMSbzGMd+cJ9PV3fq1ZuWxneVXwhlqVu8c35
	AcmTLRa/bW0S/Pxr41eBLQv+bHaovW5u2ZNRKbNlWdirkwsWz59g0fi5W/+a87s18QEaXl4d
	5dyTL21rdvSR3bP769ZDXHMmvXzaw7trgsmjo/ebvJuv3y//FaX2T4mlOCPRUIu5qDgRALIq
	ISJDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/14 13:01, Russell King - ARM Linux wrote:
> On Mon, May 05, 2014 at 10:13:58AM +0400, Andrey Ryabinin wrote:
>> According to arm procedure call standart r2 register is call-cloberred.
>> So after the result of x expression was put into r2 any following
>> function call in p may overwrite r2. To fix this, the result of p
>> expression must be saved to the temporary variable before the
>> assigment x expression to __r2.
> 
> This and the patch make no sense.  You talk about r2, but you're doing
> nothing with r2 in the patch.
> 

No, you didn't get it. I'll try to explain better.

Lets consider following example:

unsigned int __user *get_address(void);
...
	put_user(1, get_address());
...

Pay attention that in get_address function register r2  may be used.
In above example, without my patch, put_user macro will be expanded to the following code:

...
	register const unsigned int __r2 asm("r2") = (1);
	register const unsigned int __user *__p asm("r0") = (get_address());
...

At first we put value 1 into r2 register. After that get_address is called, and clobbers r2 register.
This means that after assignment to variable __p, register r2 may no longer contain a valid value - 1.

My patch put get_address calls befor the assignment of (x) to __r2.
With my patch, put_user macro will be expanded to the following code:

...
	const unsigned int __user *tmp_p = (get_address());
	register const unsigned int __r2 asm("r2") = (1);
	register const unsigned int __user *__p asm("r0") = tmp_p;
...

In this time get_address() call happens before loading 1 to r2, so it won't be corrupted.


Here is the full code of test, so anyone could check.

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/uaccess.h>

unsigned int x = 0;
unsigned int y = 0;

/* get_address returns address of x, and clobbers r2 register */
unsigned int __user *get_address(void)
{
	mm_segment_t oldfs;
	oldfs = get_fs();
	set_fs(get_ds());
	put_user(2, &y); /* this put_user call will put value 2 in register r2 */
	set_fs(oldfs);
	return &x;
}

static __init int test_init(void)
{
	mm_segment_t oldfs;
	oldfs = get_fs();
	set_fs(get_ds());
	put_user(1, get_address()); /* put 1 to x */
	set_fs(oldfs);

	printk("\nput_user_test: value %x\n\n", *get_address()); /* this will print "put_user_test: value 2" instead of "put_user_test: value 1"
	return 0;
}

module_init(test_init);

