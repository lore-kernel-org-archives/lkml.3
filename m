Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaK0Bhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 20:37:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:28418 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaK0Bhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 20:37:37 -0500
Message-ID: <54768059.1080406@oracle.com>
Date: Wed, 26 Nov 2014 20:37:29 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/2] compiler: use compiler to detect integer overflows
References: <1417046282-31825-1-git-send-email-sasha.levin@oracle.com> <CA+55aFwjTTcGFbbEPWckxZHya5PFWo+MFbK9zMzoqZorXV21nQ@mail.gmail.com>
In-Reply-To: <CA+55aFwjTTcGFbbEPWckxZHya5PFWo+MFbK9zMzoqZorXV21nQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 07:33 PM, Linus Torvalds wrote:
> On Wed, Nov 26, 2014 at 3:58 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> > We've used to detect integer overflows by causing an overflow and testing the
>> > result. For example, to test for addition overflow we would:
> So I don't like this, for a very simple reason: it doesn't work for
> older gcc versions.
> 
> Your "check_add_overflow()" doesn't actually do it. It just
> perpetuates any bugs you find. For unsigned additions, it's pointless,
> and for signed additions it remains as buggy as it was before.

I understand your point. It doesn't fix bugs but rather hides them on
newer compilers.

Since the way to fix this is by properly checking for overflow rather than
the old broken (a + b > a) conditional, how about something like the following
for the non-gcc5 case:

#define IS_UNSIGNED(A) (((typeof(A))-1) >= 0)
#define TYPE_MAX(A) ((typeof(A))(~0U>>1))
#define TYPE_MIN(A) (-TYPE_MAX(A) - 1)
#define check_add_overflow(A, B)                                        \
({                                                                      \
        typeof(A) __a = (A);                                            \
        typeof(B) __b = (B);                                            \
        typeof(sizeof(__a) > sizeof(__b) ? __a : __b) __min, __max;     \
        if (IS_UNSIGNED(__a) || IS_UNSIGNED(__b))                       \
                0;                                                      \
        __min = TYPE_MIN(__min);                                        \
        __max = TYPE_MAX(__max);                                        \
        (((__a > 0) && (typeof(__max))__b > (__max - ((typeof(__max))__a)))  ||\
                ((__a < 0) && (typeof(__max))__b < (__min - ((typeof(__max))__a))));\
})

> Also, your commit message is still *very*wrong*. You can't claim that
> integer addition overflow is undefined. It's undefined onyl for
> _signed_ integer types, and that's a big big difference.

Understood. I'll be specific it's only for signed integer overflows.


Thanks,
Sasha
