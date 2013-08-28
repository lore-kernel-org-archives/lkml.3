Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab3H1QQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 12:16:51 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:61574 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab3H1QQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 12:16:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130828103732.GB2348@localhost>
References: <1377358532-23802-1-git-send-email-ezequiel.garcia@free-electrons.com>
	<1377358532-23802-2-git-send-email-ezequiel.garcia@free-electrons.com>
	<20130828103732.GB2348@localhost>
Date: Wed, 28 Aug 2013 09:16:48 -0700
X-Google-Sender-Auth: sm1KudiY9KUPJeMbNHU0y6-CDVY
Message-ID: <CA+55aFzbSKH+N2Yt2zoth6tmbTp6GpxHP8KuT7jzgQD58T6yHQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] lib: Introduce atomic MMIO modify
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Baruch Siach <baruch@tkos.co.il>,
        Will Deacon <will.deacon@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 3:37 AM, Ezequiel Garcia
<ezequiel.garcia@free-electrons.com> wrote:
> Linus,
>
> Andrew suggested you might have opinions on this, so I'm cc'ing you.
> Since you'll probably want some better context, here it is:
>
> http://lwn.net/Articles/564709/
>
> On Sat, Aug 24, 2013 at 12:35:29PM -0300, Ezequiel Garcia wrote:
>> Some platforms have MMIO regions that are shared across orthogonal
>> subsystems. This commit implements a possible solution for the
>> thread-safe access of such regions through a spinlock-protected API.
>>
>> Concurrent access is protected with a single spinlock for the
>> entire MMIO address space. While this protects shared-registers,
>> it also serializes access to unrelated/unshared registers.

I have nothing against this, except that
"__HAVE_ARCH_ATOMIC_IO_MODIFY" needs to die, along with the #ifdef.

It should be a CONFIG_xyz option that gets set by the architectures
that have it, and then instead of an #ifdef in code, the Makefile
should make the generic target be conditional.

So add a generic

    bool GENERIC_ATOMIC_MMIO_MODIFY
        depends on !ARCH_ATOMIC_MMIO_MODIFY
        default y

to the lib/Kconfig file, and then lib/Makefile just does

    obj-$(CONFIG_GENERIC_ATOMIC_MMIO_MODIFY) += atomic_io.o

After that, ARM can then implement some architecture-optimized
version, and in its own Kconfig file just do "select
ARCH_ATOMIC_MMIO_MODIFY" to let the generic code know that it should
disable that generic version.

                 Linus
