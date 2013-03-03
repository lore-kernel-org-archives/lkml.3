Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab3CCWeD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 17:34:03 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:33195 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab3CCWeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 17:34:01 -0500
MIME-Version: 1.0
In-Reply-To: <20130303184736.GM4503@ZenIV.linux.org.uk>
References: <20130303184736.GM4503@ZenIV.linux.org.uk>
Date: Sun, 3 Mar 2013 14:34:00 -0800
X-Google-Sender-Auth: AbthzgqQpZ8TZ7COUJYqkOSqTLQ
Message-ID: <CA+55aFzxNKDdJsjT-xtv_XEWkCstFxN4hhhPz078p4LJZuHD2Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] making vfree() safe from interrupt contexts
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 3, 2013 at 10:47 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>         To bring back the thing discussed back in, IIRC, December: we have
> a bunch of places where inability to do vfree() from interrupt contexts
> (the most common case is doing that from RCU callback) leads to very
> ugly open-coded schemes that delay it one way or another.  We can let vfree()
> itself do that instead.  AFAICS, it works; the diff below covers several
> obvious cases found just by grep.  I'm fairly sure that there's more code
> that could benefit from that...

I have nothing against the patch, but I hate seeing it just before I
am getting ready to close the merge window.

And I'm not willing to apply it, since I think it's buggy: the whole
point of deferred_vfree() is that it is for irq context, yet it's not
using an irq-safe lock. So nested interrupts can deadlock.

So I think the concept is fine, the patch is probably fine after just
changing the spinlock to be irq-safe, but the timing is horrible. It
doesn't seem to be *that* urgent, so maybe you could just put it in
your queue for 3.10 after fixing the irq locking?

            Linus
