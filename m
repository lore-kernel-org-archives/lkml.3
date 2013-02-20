Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136Ab3BTRVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:21:38 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:59780 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525Ab3BTRVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:21:36 -0500
MIME-Version: 1.0
Reply-To: noloader@gmail.com
In-Reply-To: <5124F571.4060503@ladisch.de>
References: <CAH8yC8kQ1fqpaNXupkO+Rpaocw6gC3-kZuPpwD-DYds8hQ3SaQ@mail.gmail.com>
	<5124F571.4060503@ladisch.de>
Date: Wed, 20 Feb 2013 12:21:21 -0500
Message-ID: <CAH8yC8npt_=+twdRyhUQ_+d2KazdfNwHYtLjjbJnxm+8JZwZfg@mail.gmail.com>
Subject: Re: Undefined Code in .../include/linux.bitops.h
From: Jeffrey Walton <noloader@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 11:10 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Jeffrey Walton wrote:
>> http://www.tux.org/lkml/ is a tough read, and Item 4, "I think I found
>> a bug, how do I report it?" does not tell me how to report this.
>
> From that page:
> | A bug is when something (in the kernel, presumably) doesn't behave the
> | way it should
>
> So just tell us what it is that doesn't behave the way it should.
>
>> According to Section 5.8, "Shift Operators" of
>> http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2798.pdf:
>
> The kernel doesn't try to be fully standard conformant.
>
>>     return (word >> shift) | (word << (32 - shift));
>
>> "The behavior is undefined if the right operand is ... equal to the
>> length in bits of the promoted left operand."
>>
>> If I ask for a shift of 0
>
> Does the kernel ever do this?
>
>> the various ops will perform `32 - shift` (or `64 - shift`, etc). That
>> means the right operand *IS* equal to the length in bits of the
>> operand, so the code is undefined.
>
> In practice, what CPUs actually do is to shift either by zero or by the
> full 32/64 bits.  Both implementations give the correct result.
Well, a few things come to mind.

First, the language is C and the kernel needs a compiler. The compiler
might try hard to be C conforming. I could be wrong, but all that
would be needed to break exiting code in some cases is better
analysis. So the kernel is betting on a component it clearly does not
control.

Second, I know that code will not work on some older processors that
do not mask in its barrel shift as expected. I doubt they will be
encountered today, but you never know. In addition, future processors
may not offer the same [tolerant] behavior of current processors.

Third, depending on non-standard behavior is a usually bad choice over
the long run (not withstanding the comment on being non-conforming).
Fedora/Adobe/Flash and glibc/memmove comes to mind
(https://fedorahosted.org/fesco/ticket/501).

Fourth, user land programs use the header too. This is expected
because programmers are taught to reuse existing code. Unfortunately,
many user land programmers lack the knowledge and experience of a
kernel hacker, so they won't realize a potential minefield exists or
how to navigate the minefield.

Finally, I think its poor mentoring. Many junior programmers look up
to experienced kernel programmers, and I think its poor leadership to
provide them with bad habits. Obviously, this is just my opinion, and
does not warrant a response.

Jeff
