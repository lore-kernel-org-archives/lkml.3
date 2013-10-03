Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3JCSDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:03:10 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:52118 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab3JCSDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:03:08 -0400
MIME-Version: 1.0
In-Reply-To: <20131003175824.GH13318@ZenIV.linux.org.uk>
References: <20131003163411.GA17101@www.outflux.net>
	<20131003175824.GH13318@ZenIV.linux.org.uk>
Date: Thu, 3 Oct 2013 11:03:07 -0700
X-Google-Sender-Auth: IWrdyYKBRSMOX7TTkY9isQGzLUI
Message-ID: <CAGXu5j+8sxc8vc4bwv14nGNiOhq-ey2nxAK99LgMKO+Qmh1L6A@mail.gmail.com>
Subject: Re: [PATCH] fs: make sure we do not read beyond allocation
From: Kees Cook <keescook@chromium.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 10:58 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Oct 03, 2013 at 09:34:11AM -0700, Kees Cook wrote:
>> In dentry_string_cmp (via__d_lookup_rcu), when CONFIG_DCACHE_WORD_ACCESS
>> is set, word-width memory reads are performed. However, the string
>> allocation size may not be a multiple of the word size. To avoid reading
>> past the end of such an allocation, we must allocate in multiples of
>> the word size.
>
> grep ^kmalloc /proc/slabinfo.  Observe the suffix after "kmalloc-"...
>
> IOW, kmalloc() does round its argument up.  Seeing that we allocate an
> external name only when allocation has to be longer than 32 bytes, the
> sucker is guaranteed to be at least a multiple of 32 by the time we
> pick the fitting cache (the worst case is when length is between 65
> and 96; then we use kmalloc-96).
>
> When you start a port to a 512-bit architecture, you'll have much nastier
> problems than this one...

Well, this is simply taking advantage of this particular allocator's
behavior. Instead of depending on this side-effect, why not change the
allocation so that we never risk a potentially broken read? (Even SLOB
notes that it may have as low as 2-byte granularity.)

-Kees

-- 
Kees Cook
Chrome OS Security
