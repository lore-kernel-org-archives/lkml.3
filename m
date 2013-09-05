Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762394Ab3IECsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 22:48:16 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:60023 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab3IECsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 22:48:15 -0400
MIME-Version: 1.0
In-Reply-To: <5227E321.4090008@hp.com>
References: <1378321523-40893-1-git-send-email-Waiman.Long@hp.com>
	<20130904191104.GK13318@ZenIV.linux.org.uk>
	<CA+55aFwW+hWwQd8+NgukSidHbf2bnd6QO0yKK9NAgX+9rt0cOQ@mail.gmail.com>
	<5227E321.4090008@hp.com>
Date: Wed, 4 Sep 2013 19:48:14 -0700
X-Google-Sender-Auth: mO7J7c5FAYIY0u47cnbsDMgATPs
Message-ID: <CA+55aFyURmAMo1Hso1_2zzcNEfcqOLUyhLGrBhvtMXWMJHVMfg@mail.gmail.com>
Subject: Re: [PATCH] dcache: Translating dentry into pathname without taking rename_lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Scott J Norton <scott.norton@hp.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 6:49 PM, Waiman Long <waiman.long@hp.com> wrote:
>
> So what I am going to do is to use memchr() to locate a null
> byte within the given length. If one is found, the string must be invalid
> and there is no point in doing the copying. Instead, EINVAL will be returned
> and the code will check the sequence number then. The memchr() function can
> be fast if an architecture-specific version exists.

We don't have an architecture-specific fast version of memchr, because
nobody sane has ever cared about that abomination of a function. Also,
if rename() overwrites the pathname (switching inline names), I guess
a zero could disappear between your memchr and the copy. Although I
think we always have an ending NUL byte for the inline case, so that
should make sure that memchr would find it *eventually*.

But regardless, that's really not what you want to do.

You should do:

 - use the name length as a maximum

 - do a byte-at-a-time copy, stopping at a zero (it's going to be
faster than memchr anyway)

Then, later on, we can do one that does a word-at-a-time using the
CONFIG_DCACHE_WORD_ACCESS magic: we know dentry names are always
word-aligned, and we have an efficient "has_zero()" function for
finding zero bytes in a word.

Really.

            Linus
