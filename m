Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab3IPL7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 07:59:31 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:34053 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab3IPL7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 07:59:30 -0400
MIME-Version: 1.0
In-Reply-To: <87ioy11k8s.fsf@rustcorp.com.au>
References: <87ioy11k8s.fsf@rustcorp.com.au>
Date: Mon, 16 Sep 2013 07:59:29 -0400
X-Google-Sender-Auth: 1xILhoNFgyWDzr45mTccTibF3HU
Message-ID: <CA+55aFxtibZsDJQ0_tueWCtfLahAJTk3wYxFpgYqiaqbx097zA@mail.gmail.com>
Subject: Re: Why does test_bit() take a volatile addr?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 12:08 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Predates git, does anyone remember the rationale?
>
> ie:
>         int test_bit(int nr, const volatile unsigned long *addr)

Both of Stephen Rothwell's guesses are correct.

One reason is that we used to use "volatile" a lot more than we do
now, and "const volatile *" is the most permissive pointer that allows
any use without warnings.

We've largely stopped using "volatile" in favor of explicit barriers
and locks (ie "cpu_relax()" and "barrier()") and explicit volatility
in code (ACCESS_ONCE() and "rcu_access_pointer()" etc).

The other reasons is for fear of having some old code that does effectively

   while (condition) /* nothing */

using "test_bit()", and forcing a reload. They used to happen. They
were rare even before, and I'd hope they are nonexistent now, but they
were real.

We could try to see what happens if we remove "volatile" from the
bitops these days. But the scary part is all the random drivers
potentially doing that second thing. So it's not exactly easily
testable. It would need to be worth it to bother.

                Linus
