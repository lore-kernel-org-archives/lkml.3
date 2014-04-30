Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946110AbaD3XOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 19:14:17 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:50636 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbaD3XOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 19:14:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzekh6peA627B1e3NwcL06DqErWX6whJGm4w0WDRTn1gA@mail.gmail.com>
References: <20140430160345.GP18016@ZenIV.linux.org.uk>
	<CAJfpegu+q3sT=8==9K5t4=qeJH2azFcBGeMXUtK3LVSEEzXTUA@mail.gmail.com>
	<20140430183650.GQ18016@ZenIV.linux.org.uk>
	<CAJfpegu+=zidycJwcBPjuDLP-ZnGisOGQpD8GKhD-Wz6eNzd9g@mail.gmail.com>
	<20140430190227.GR18016@ZenIV.linux.org.uk>
	<20140430195918.GS18016@ZenIV.linux.org.uk>
	<CA+55aFxe4HKHiWbarfwtww9=WUgfAmk+Cf3G7tdBB19uMdjbEg@mail.gmail.com>
	<20140430203823.GT18016@ZenIV.linux.org.uk>
	<CA+55aFyqqwrtv7ifTYVK943qm2OJOF8aF1y6apMSwjG93T=ztA@mail.gmail.com>
	<20140430211206.GU18016@ZenIV.linux.org.uk>
	<20140430221238.GV18016@ZenIV.linux.org.uk>
	<CA+55aFzekh6peA627B1e3NwcL06DqErWX6whJGm4w0WDRTn1gA@mail.gmail.com>
Date: Wed, 30 Apr 2014 16:14:14 -0700
X-Google-Sender-Auth: 5hZwzOgmjRsKRB0zJpZx1JBqSDw
Message-ID: <CA+55aFwafZjeCEjaiAxCxQ1L9f6wBYXFsJQoSgr3681Y7=ER5w@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 4:04 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Let me go talk to the paravirt people. Maybe they don't need this, and
> I don't know exactly *how* they use that lock pointer after the unlock
> in the "kick waiters" part. Maybe it's all good.

.. looking at current users (xen and kvm) it does in fact look all
good. Yes, we "kick" possible waiters after the unlock, but the lock
itself is not touched by that, it just uses the pointer to the lock as
a way to figure out who to kick.

In fact, I kind of knew that, but had forgotten. We very much depend
on spin_unlock being safe wrt immediate deleton already: the
"completion" code very much depends on it. It does a "spin_unlock()"
to release the completion, and it can get reused immediately (it might
be on the stack, it might be in some data structure that gets freed).

So I'd suggest removing that whole RCU thing, because it should be
safe to unlock something that can go away immediately. We'd have huge
problems elsewhere if it wasn't safe.

               Linus
