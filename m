Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966081Ab3DQR6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:58:50 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:38807 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965512Ab3DQR6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:58:49 -0400
MIME-Version: 1.0
In-Reply-To: <201304171115.51509.arnd@arndb.de>
References: <CA+55aFyK2EEPuBPrqu3AGRbW+8TdP=kLLz4opvynNRcrSWC2ww@mail.gmail.com>
	<201304171115.51509.arnd@arndb.de>
Date: Wed, 17 Apr 2013 10:58:47 -0700
X-Google-Sender-Auth: aretvXnORpwP4S1-bhAG_6-u_XM
Message-ID: <CA+55aFxuLZ5Y2qLtn5=MXNF7oiuTK3ZuQhAjWPPb1wrd6D7sZw@mail.gmail.com>
Subject: Re: Device driver memory 'mmap()' function helper cleanup
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 2:15 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> I took a look at the hpet_mmap function, which still contains this check:
>
>         if (((vma->vm_end - vma->vm_start) != PAGE_SIZE) || vma->vm_pgoff)
>                 return -EINVAL;
>
> As far as I can tell, this check is implied by the new code in
> vm_iomap_memory as the len argument passed here is PAGE_SIZE, so you
> can remove another three lines in hpet_mmap.

Not the way things are now.

vm_iomap_memory() actually allows non-page-aligned things to be
mapped, with the assumption that the user will then know about the
internal offsets.

The *reason* for that is questionable, but that's how pretty much
every single user I've seen has worked, throwing the low bits of the
physical away (after adding them to the length of the area).

Now, I sincerely *hope* that there are no users of "let's mmap this
non-page-aligned thing and let people access the data around it", but
I didn't want to break things that I didn't know about, and that I
couldn't test.

The HPET case was the only one (admittedly of the very limited cases I
looked at and converted) that actually checked alignment, so I left
that part in.

It may be that I should have done things differently: make the normal
helper function verify page alignment, and warn if it's missing. Then,
we could have a "vm_unaligned_iomap_memory()" that would just do the
"extend to aligned pages" that people could convert any odd users for.
That would probably be a good thing to do, but it would be separate
"phase two" from the "let's start using the sane helper".

               Linus
