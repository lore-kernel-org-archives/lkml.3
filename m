Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbaE2TS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:18:28 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44276 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbaE2TS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:18:26 -0400
MIME-Version: 1.0
In-Reply-To: <tip-6f121e548f83674ab4920a4e60afb58d4f61b829@git.kernel.org>
References: <2c4fcf45524162a34d87fdda1eb046b2a5cecee7.1399317206.git.luto@amacapital.net>
 <tip-6f121e548f83674ab4920a4e60afb58d4f61b829@git.kernel.org>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 29 May 2014 15:17:54 -0400
X-Google-Sender-Auth: Tj5FKh14fbUWYCWb7qyHQctpcVU
Message-ID: <CAP=VYLrzMP23B9NVnu4N3NYsoU+ai1K9HpAE_eXQzXESUUZ-Lg@mail.gmail.com>
Subject: Re: [tip:x86/vdso] x86, vdso: Reimplement vdso.so preparation in
 build-time C
To: mingo@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, luto@amacapital.net,
        LKML <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 6:25 PM, tip-bot for Andy Lutomirski
<tipbot@zytor.com> wrote:
> Commit-ID:  6f121e548f83674ab4920a4e60afb58d4f61b829
> Gitweb:     http://git.kernel.org/tip/6f121e548f83674ab4920a4e60afb58d4f61b829
> Author:     Andy Lutomirski <luto@amacapital.net>
> AuthorDate: Mon, 5 May 2014 12:19:34 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Mon, 5 May 2014 13:18:51 -0700
>
> x86, vdso: Reimplement vdso.so preparation in build-time C

Just a heads up in case it hasn't been mentioned already;
the x86 builds in linux-next which IIRC are done as cross
compile on a powerpc box are failing as follows:

  VDSO2C  arch/x86/vdso/vdso-image-64.c
/bin/sh: line 1: 15995 Segmentation fault      arch/x86/vdso/vdso2c
arch/x86/vdso/vdso64.so.dbg arch/x86/vdso/vdso-image-64.c
make[3]: *** [arch/x86/vdso/vdso-image-64.c] Error 139

http://kisskb.ellerman.id.au/kisskb/buildresult/11265454/

Paul.
--

>
> Currently, vdso.so files are prepared and analyzed by a combination
> of objcopy, nm, some linker script tricks, and some simple ELF
> parsers in the kernel.  Replace all of that with plain C code that
> runs at build time.
>
> All five vdso images now generate .c files that are compiled and
> linked in to the kernel image.
>
> This should cause only one userspace-visible change: the loaded vDSO
> images are stripped more heavily than they used to be.  Everything
> outside the loadable segment is dropped.  In particular, this causes
> the section table and section name strings to be missing.  This
> should be fine: real dynamic loaders don't load or inspect these
> tables anyway.  The result is roughly equivalent to eu-strip's
> --strip-sections option.
>
> The purpose of this change is to enable the vvar and hpet mappings
> to be moved to the page following the vDSO load segment.  Currently,
> it is possible for the section table to extend into the page after
> the load segment, so, if we map it, it risks overlapping the vvar or
> hpet page.  This happens whenever the load segment is just under a
> multiple of PAGE_SIZE.
>
> The only real subtlety here is that the old code had a C file with
> inline assembler that did 'call VDSO32_vsyscall' and a linker script
> that defined 'VDSO32_vsyscall = __kernel_vsyscall'.  This most
> likely worked by accident: the linker script entry defines a symbol
> associated with an address as opposed to an alias for the real
> dynamic symbol __kernel_vsyscall.  That caused ld to relocate the
> reference at link time instead of leaving an interposable dynamic
> relocation.  Since the VDSO32_vsyscall hack is no longer needed, I
> now use 'call __kernel_vsyscall', and I added -Bsymbolic to make it
> work.  vdso2c will generate an error and abort the build if the
> resulting image contains any dynamic relocations, so we won't
> silently generate bad vdso images.
>
> (Dynamic relocations are a problem because nothing will even attempt
> to relocate the vdso.)
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> Link: http://lkml.kernel.org/r/2c4fcf45524162a34d87fdda1eb046b2a5cecee7.1399317206.git.luto@amacapital.net
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
