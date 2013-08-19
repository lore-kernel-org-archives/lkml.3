Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab3HSUZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:25:13 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:60014 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3HSUZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:25:11 -0400
MIME-Version: 1.0
In-Reply-To: <CA+i8gKKzt3Uf7Bt88=AFyKbdHuqaTqy96nCHTtO=t+4+dhQ0Pw@mail.gmail.com>
References: <CA+i8gKKzt3Uf7Bt88=AFyKbdHuqaTqy96nCHTtO=t+4+dhQ0Pw@mail.gmail.com>
Date: Mon, 19 Aug 2013 13:25:10 -0700
X-Google-Sender-Auth: p2drkHXUV0g1EZqjs51N5X5EHog
Message-ID: <CA+55aFzH7DH0d+DXgQ6T3Us6job8OvVmCJXMp2z3xit86d0ZrA@mail.gmail.com>
Subject: Re: commit 94fc5d9: chromium-sandbox core dumped
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Genoud <richard.genoud@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 11:48 AM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>
> The following commit breaks chromium on my machine ("proc:
> return on proc_readdir error")
>
> Chromium breaks with:
>
> [269:269:0819/203839:FATAL:zygote_host_impl_linux.cc(195)] Check
> failed: pid_0. Did not find zygote process (using sandbox binary
> /usr/lib/chromium/chromium-sandbox)
> Aborted (core dumped)

Hmm. I think that Richard's patch is correct, but looking at all this,
it looks like the return value of proc_readdir() is broken.

The comment above proc_readdir_de() says

 * This returns non-zero if at EOF, so that the /proc
 * root directory can use this and check if it should
 * continue with the <pid> entries..

which is exactly what it should do. But the *code* does no such thing,
and instead always returns 0, breaking Richards patch.

I suspect that last "return 0" at the end should be "return 1". Does
that fix things for you? Untested.

Al? It looks to me like commit f0c3b5093add ("[readdir] convert
procfs") messed up when it changed proc_readdir_de() to not have all
those "goto out" things any more...

               Linus
