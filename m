Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161534AbaJaA5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 20:57:47 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:51393 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161391AbaJaA5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 20:57:45 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
References: <4e8f7a1abcf5e0527ef8968143b2d0fcae48f5f4.1414658968.git.e@nanocritical.com>
 <5452B241.5010603@amacapital.net> <CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
 <CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
From: Eric Rannaud <e@nanocritical.com>
Date: Thu, 30 Oct 2014 17:57:24 -0700
Message-ID: <CAH_=xoa-3D+S22wnmxA5N4Z6V+GUPF_9KG0LkvGdTAzcdy2Lcg@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 3:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Oct 30, 2014 at 3:48 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Agreed. Will apply and add the stable cc.
>
> Ho humm. Thinking about this some more, I'm starting to wonder. Not
> about this patch per se (open on a newly created file should indeed
> succeed regardless), but about the horrible glibc behavior of screwing
> up the third argument.
>
> If you want to do O_TMPFILE + linkat() (or some eventual future
> flink()), the mode really matters. So this idiotic glibc behavior of
> only forwarding the third argument if O_CREAT is set seems to be a
> bug.

Yes, there definitely is a glibc bug: a fix is being worked on and it
looks like it will go in. The change replaces the test for O_CREAT by
a test for either O_CREAT or O_TMPFILE.

> Why the hell does glibc think it's a good idea to intersect system
> call semantics? It's not a good idea - it's just stupid in the
> extreme. And in this case it seems to actively breaks things.

What Andy said: it's the most portable, because of the optional last
argument, if you have a bunch of wrappers for open and openat written
in C, which they do.

Some of these wrappers are for statically checking that the mode
argument is present when necessary (using __builtin_constant_p,
__builtin_va_arg_pack, and friends), and to "fortify" the code against
a malicious (?) injection of O_CREAT in a code path that didn't have
it at compile time (where flags was a build constant). Other wrappers
add O_LARGEFILE. One wrapper for openat checks that dirfd is a
directory (no idea why, as the kernel does the same check -- without a
race; maybe to try to guarantee ENOTDIR on some old kernel version?
It's been here since 2005, when openat was added to glibc).

-- 
Eric Rannaud <e@nanocritical.com>
Nanocritical, CEO
