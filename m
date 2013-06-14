Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab3FNFqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:46:05 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:53741 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3FNFqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:46:03 -0400
MIME-Version: 1.0
In-Reply-To: <1371172023-16004-1-git-send-email-ddaney.cavm@gmail.com>
References: <1371172023-16004-1-git-send-email-ddaney.cavm@gmail.com>
Date: Thu, 13 Jun 2013 22:46:02 -0700
X-Google-Sender-Auth: tWEb3uaffCgVTxnwnpixhXtPFjE
Message-ID: <CA+55aFziBGnSgLimDe7WBRPQ+f3RVAsrdbo212oj85c-XSz4oA@mail.gmail.com>
Subject: Re: [PATCH] smp.h: Use local_irq_{save,restore}() in !SMP version of on_each_cpu().
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mips <linux-mips@linux-mips.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 6:07 PM, David Daney <ddaney.cavm@gmail.com> wrote:
>
> Suggested fix: Do what we already do in the SMP version of
> on_each_cpu(), and use local_irq_save/local_irq_restore.

I was going to apply this, but started looking a bit more.

Using "flags" as a variable name inside a macro like this is a
*really* bad idea.

Lookie here:

    [torvalds@pixel linux]$ git grep on_each_cpu.*flags
    arch/s390/kernel/perf_cpum_cf.c:        on_each_cpu(setup_pmc_cpu,
&flags, 1);
    arch/s390/kernel/perf_cpum_cf.c:        on_each_cpu(setup_pmc_cpu,
&flags, 1);

and ask yourself what happens when the "info" argument expands to
"&flags", and it all compiles perfectly fine, but the "&flags" takes
the address of the new _inner_ variable called "flags" from the macro
expansion. Not the one that the caller actually intends..

Oops.

Not a good idea.

So I would suggest trivially renaming "flags" as "__flags" or
something, or perhaps even just making it a real function and avoiding
the whole namespace issue.

And rather than doing that blindly by editing the patch at after -rc5,
I'm just going to ask you to re-send a tested patch. Ok?

                    Linus
