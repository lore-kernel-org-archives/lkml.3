Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaBLVc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:32:57 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:33367 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbaBLVc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:32:56 -0500
MIME-Version: 1.0
In-Reply-To: <20140212211421.GP18016@ZenIV.linux.org.uk>
References: <52FA9ADA.9040803@sandeen.net>
	<20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212113928.GO18016@ZenIV.linux.org.uk>
	<CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
	<20140212211421.GP18016@ZenIV.linux.org.uk>
Date: Wed, 12 Feb 2014 13:32:55 -0800
X-Google-Sender-Auth: jJkWM1SIUIsU6ptTziwb_jI9EkQ
Message-ID: <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Dave Jones <davej@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 1:14 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Umm...  What if we delay __sigqueue_free()?  After all, that's where the
> fat sucker normally comes from.  That way we might get away with much
> smaller structure on stack...

Sounds like the RightThing(tm) to do to me, and I don't see why it
wouldn't work.

We'd have to teach each user of "dequeue_signal()" to free the siginfo
thing. Which shouldn't be too bad - I think we've collected all of
that into generic code, and there isn't the mass or architecture code
that knows about these things any more. But there are a few odd
drivers etc and signalfd. I didn't look at what the lifetimes were.

Adding Oleg to the cc, since any time we touch any of that code, he
should be involved. Oleg - the issue is the biggish size of 'struct
ksignal' on stack, brought on by the silly "put a whole siginfo_t in
it".

            Linus
