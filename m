Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761055AbaGRJS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:18:57 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:59090 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbaGRJSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:18:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chung-Lin Tang <cltang@codesourcery.com>
Cc: Ley Foon Tan <lftan@altera.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        lftan.linux@gmail.com, "Joseph S. Myers" <joseph@codesourcery.com>
Subject: Re: [PATCH v2 22/29] nios2: Miscellaneous header files
Date: Fri, 18 Jul 2014 11:18:44 +0200
Message-ID: <24519153.8UnNuM8InF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53C8BB6B.5050606@codesourcery.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <4477048.XUlURsz4uq@wuerfel> <53C8BB6B.5050606@codesourcery.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:uMW8q9/rl3HpvYdFxeKN1/Ni5LvWMf8U9F06f/QGlEI
 +OM1Dm+T76H62AtTmRB65vah9RElVMmq8Ib0xYgDQotkSGtu7E
 4m2sizl2EEMGkZ9lie7Zmul4hXbXRXDAJhZo9TysdgP5DBRH9G
 g96GdNc02lb30ptN3HAZyIdxFLt0PG+t2G9oO4KnoHayraPPkh
 RtYLds8FWTWyAky+RTLlIr/YEfUMJ9l9cjYSFHtgDrTb+qh9SZ
 uWWkibDxs++vldWBrjVzmbqRvir3wO1rBuPiJ3NcF0I0faB8xD
 rZ8Gkg7tPfmHNPFDH9egCMwiZFCaM/kHaxJ0pX/mP4/M1QoxUF
 ZLpGbhJONRqmS8JwoNwE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 July 2014 14:15:07 Chung-Lin Tang wrote:
> Hi Arnd,
> Considering two other kernel interface issues that appeared earlier in
> the context of nios2 glibc/kernel upstreaming:
> 
> (1) The 64-bit time_t/timespec issue.
> (2) Dropping renameat by default in favor of renameat2
> 
> What's the decision for these? Are they delayed to the next release?

For renameat2, I believe we had patches to change the generic syscall
list. It would be nice if you could include those in your patch
series as a prerequisite and base your patches on top.

Regarding time_t, I've spent much more time looking into what we
need to do for the other 32-bit architectures now. My feeling now
is that we're better off not introducing another special case for
nios2 here, as that will have the effect of making it harder to
move everyone else over later. We already have to deal with:

- 32-bit architectures using 32-bit time_t
- 64-bit architectures using 64-bit time_t
- 64-bit architectures running 32-bit tasks with 32-bit time_t
- 64-bit x86-64 and soon arm64 running x32 user space with 64-bit time_t

and we will get in the future

- 32-bit architectures providing both 32-bit time_t and 64-bit time64_t
- 64-bit architectures with compat tasks running 64-bit time64_t

Adding a 32-bit architecture that has a native 64-bit time_t will
just add another special case that we will have to live with for
a long time and that can introduce bugs for the other cases if we
get it wrong. I vote for keeping 32-bit time_t on nios2 and fixing
it along with arm32 and x86-32 and the others.

Presumably this is not a huge problem for you as I expect it's
easier for you to do another ABI change in user space when we get
there: once we have support for 64-bit time64_t in the kernel, you
can change your toolchains to default to that in user space and
rebuild everything. This is not something we can easily do in x86.

	Arnd
