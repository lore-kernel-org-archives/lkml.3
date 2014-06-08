Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbaFHRpP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 13:45:15 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:42340 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbaFHRpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 13:45:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140608114052.GA8774@amd.pavel.ucw.cz>
References: <20140608114052.GA8774@amd.pavel.ucw.cz>
Date: Sun, 8 Jun 2014 10:45:13 -0700
X-Google-Sender-Auth: s1IZFA0s8yudsTp4Kp9rIcj270Q
Message-ID: <CA+55aFx=NErwcbOi0tm0kdJ126-AQAHTQp6i2A6Ow0tA+X_+sw@mail.gmail.com>
Subject: Re: per-thread wait_queue_t
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 8, 2014 at 4:40 AM, Pavel Machek <pavel@ucw.cz> wrote:
>
> When you proposed to put wait queues into task_struct, you were
> probably looking for less coding and more analysis?

I'm ok with coding, I find your particular patch horrible.

You add a dynamic allocator that will work *horribly* badly if people
actually start using it for more complex cases, and then you use that
for just about the least interesting case. And the way you do the
dynamic allocator, nobody can ever allocate one of the wait-queue
entries *efficiently* by just knowing that they are a leaf and there
is never any recursive allocation.

So quite frankly, I'd add *one* static wait-queue entry, and use it
unconditionally (no "allocation" wrapper) in all the cases where we
see that all that ever happens is

And then I'd make ___wait_event() use that one statically allocated
per-thread wait-queue instead of the current on-stack one.  That would
get a lot of users in one fell swoop. We might have to add some
validation code that the "event" function cannot do anything that can
in turn sleep, but that sounds fairly simple.

See?

           Linus
