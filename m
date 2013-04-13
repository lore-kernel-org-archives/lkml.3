Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab3DMALc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 20:11:32 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:58094 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3DMALb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 20:11:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130412235352.GA16770@kroah.com>
References: <1365805938-22826-1-git-send-email-anatol.pomozov@gmail.com>
	<CA+55aFzxxGBU3AOeNg3UEicHrx3nzWRyo5DOd=hh6SHJfYvB3g@mail.gmail.com>
	<20130412235352.GA16770@kroah.com>
Date: Fri, 12 Apr 2013 17:11:30 -0700
X-Google-Sender-Auth: YXHgiQNjUJpKh_2UCR_xiQ5X2Mw
Message-ID: <CA+55aFy4SvRc_4VwV9AD8Fpc5zKPPBdbzGYFej6LHBb1prK6=g@mail.gmail.com>
Subject: Re: [PATCH] module: Fix race condition between load and unload module
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Salman Qazi <sqazi@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 4:53 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Linus, I think your patch will reduce the window the race could happen,
> but it should still be there, although testing with it would be
> interesting to see if the original problem can be triggered with it.

Well, with my patch, there's no way you'll ever look up an object with
a zero refcount, so you'll never release it twice. The atomic
operations (atomic_inc_nonzero()) do guarantee that.

The "kset->list_lock" means that the list traversal is safe too.

So one particular race is definitely gone.

Now, what people who call "kset_find_obj()" really expect when not
locked against the last kobject_put(), I don't know. But at least it's
conceptually safe now. They'll either get NULL (either because the
object doesn't exist on the list, or because it does exist but is
about to be removed), or they will get a valid object that has *not*
started to be torn down yet.

                 Linus
