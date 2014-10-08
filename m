Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbaJHTQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:16:36 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:51352 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaJHTQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:16:35 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA5BeRMd28CUZPj+G2VbcwT0pG7gERk65xdMLXSp_59-RA@mail.gmail.com>
References: <CA+5PVA5BeRMd28CUZPj+G2VbcwT0pG7gERk65xdMLXSp_59-RA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 8 Oct 2014 12:16:11 -0700
Message-ID: <CALCETrUDkHH-FLwq9ZJ0wFeOkQVWUjTh-cJPL4Jq28sHCqhfFA@mail.gmail.com>
Subject: Re: vdso_standalone_test_x86.c build failure on Linus' tree
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Peter Foley <pefoley2@pefoley.com>, Randy Dunlap <rdunlap@infradead.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 11:52 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> I'm seeing the following build failure on a 32-bit x86 build in Fedora
> based on Linux v3.17-2860-gef0625b70dac:
>
> Documentation/vDSO/vdso_standalone_test_x86.o: In function `to_base10':
> vdso_standalone_test_x86.c:(.text+0xcc): undefined reference to `__umoddi3'
> vdso_standalone_test_x86.c:(.text+0xea): undefined reference to `__udivdi3'
> collect2: error: ld returned 1 exit status
> scripts/Makefile.host:100: recipe for target
> 'Documentation/vDSO/vdso_standalone_test_x86' failed
> make[2]: *** [Documentation/vDSO/vdso_standalone_test_x86] Error 1
> scripts/Makefile.build:404: recipe for target 'Documentation/vDSO' failed
> make[1]: *** [Documentation/vDSO] Error 2
> make[1]: *** Waiting for unfinished jobs....
> Makefile:922: recipe for target 'vmlinux' failed
> make: *** [vmlinux] Error 2
>
> Looking at some of the git logs around this, it seems that
> vdso_standalone_test_x86.c is 64-bit specific, so I was curious why it
> was even being built on a 32-bit build.  Seems this commit:
>
> commit adb19fb66eeebac07fe37d968725bb8906dadb8e
> Author: Peter Foley <pefoley2@pefoley.com>
> Date:   Thu Sep 25 11:23:09 2014 -0700
>
>     Documentation: add makefiles for more targets
>
>     Add a bunch of previously unbuilt source files to the Documentation build
>     machinery.
>
>     Signed-off-by: Peter Foley <pefoley2@pefoley.com>
>     Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>     Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>
>
> blindly added it to the build target.
>
> So is vdso_standalone_test_x86.c really 64-bit specific?  If so,
> should that commit be reverted (or a hunk of it anyway), should there
> be some mechanism to not build it on 32-bit, or should there be some
> additional CFLAGS passed?

It should build and work on 32-bit.

Except that the makefile is totally bogus.  vdso_standalone_test isn't
a hostprog at all.  It's a target prog.  But kbuild doesn't understand
that, so I have no idea what, if anything, that makefile is supposed
to do.

I would argue that the whole documentation build system should be
fixed to cross-compile or should just be disabled for cross-builds if
glibc isn't available.

FWIW, the comment at the top of vdso_standalone_test_x86.c documents
*exactly* how to build it, and it works if you build it like that.

--Andy
