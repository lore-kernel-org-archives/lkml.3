Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966842Ab3DQV2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 17:28:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53170 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965687Ab3DQV2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 17:28:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Device driver memory 'mmap()' function helper cleanup
Date: Wed, 17 Apr 2013 23:28:00 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
References: <CA+55aFyK2EEPuBPrqu3AGRbW+8TdP=kLLz4opvynNRcrSWC2ww@mail.gmail.com> <201304171115.51509.arnd@arndb.de> <CA+55aFxuLZ5Y2qLtn5=MXNF7oiuTK3ZuQhAjWPPb1wrd6D7sZw@mail.gmail.com>
In-Reply-To: <CA+55aFxuLZ5Y2qLtn5=MXNF7oiuTK3ZuQhAjWPPb1wrd6D7sZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304172328.01071.arnd@arndb.de>
X-Provags-ID: V02:K0:ll1XB73Bthim4a7KFbl6zcikHT9xo/DCK3NNOTHt9D5
 A7ap1LATcSiN7J4qKMjvcawPIwqrR/AIEFT+yMiJpOTHMLaDtV
 ZIfIUFSP/HbeRmCzfHk2/qRNb1Ne+0mNRewFUKgSM7I/xeH7uG
 XLIgQPaB1vWFb3/ifC3V3H3jPbHasoPP+/+LhTcH0k0YTzhr7e
 NxQ/5TjKYiv5tOIXrYuSSTG6zBXLSHW7cTQnHcnBYwoPBcJo5i
 I5US9ehO8iePgfo/yqCeaaFT/UgWoLx4UH7oKa0bpJRBNpEGiV
 ink3UDQmZeJ4bO179gbLmsi1T/xZMscGhR9Zh/JUnNF82+Ns58
 4MlyO0PXQkweewaWErjA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 April 2013, Linus Torvalds wrote:
> Not the way things are now.
> 
> vm_iomap_memory() actually allows non-page-aligned things to be
> mapped, with the assumption that the user will then know about the
> internal offsets.
>
> The reason for that is questionable, but that's how pretty much
> every single user I've seen has worked, throwing the low bits of the
> physical away (after adding them to the length of the area).

There is a separate check for the physical address that gets
mapped in hpet_mmap:

        if (addr & (PAGE_SIZE - 1))
                return -ENOSYS;

We cannot remove that without changing the semantics of this function,
but the check that I mentioned:

        if (((vma->vm_end - vma->vm_start) != PAGE_SIZE) || vma->vm_pgoff)
                return -EINVAL;

is for the virtual address. All of vm_start, vm_end and vm_pgoff
are guaranteed to be page-aligned through previous checks or
shifts, and we have also checked that the size is non-zero.

Since we pass a hardcoded len=PAGE_SIZE into vm_iomap_memory, that will
return -EINVAL for any non-zero vma->vm_pgoff. Testing ((vma->vm_end - 
vma->vm_start) != PAGE_SIZE) is redundant as well, because we know it
is a positive multiple of PAGE_SIZE because of the call chain leading
up to this function, and vm_iomap_memory() ensures that it can not
be more than len, which leaves PAGE_SIZE as the only possible value
not resulting in -EINVAL without the extra check.

> It may be that I should have done things differently: make the normal
> helper function verify page alignment, and warn if it's missing. Then,
> we could have a "vm_unaligned_iomap_memory()" that would just do the
> "extend to aligned pages" that people could convert any odd users for.
> That would probably be a good thing to do, but it would be separate
> "phase two" from the "let's start using the sane helper".

Makes sense, but I think this is independent of the observation I made
regarding the checks for the vma.

	Arnd
