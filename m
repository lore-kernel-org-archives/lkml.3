Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaJHSwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:52:41 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:48785 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaJHSwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:52:40 -0400
MIME-Version: 1.0
Date: Wed, 8 Oct 2014 14:52:39 -0400
X-Google-Sender-Auth: AROEeO6u-KZVBeHBFZn44dwEosQ
Message-ID: <CA+5PVA5BeRMd28CUZPj+G2VbcwT0pG7gERk65xdMLXSp_59-RA@mail.gmail.com>
Subject: vdso_standalone_test_x86.c build failure on Linus' tree
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Peter Foley <pefoley2@pefoley.com>, Randy Dunlap <rdunlap@infradead.org>,
        Jiri Kosina <jkosina@suse.cz>, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing the following build failure on a 32-bit x86 build in Fedora
based on Linux v3.17-2860-gef0625b70dac:

Documentation/vDSO/vdso_standalone_test_x86.o: In function `to_base10':
vdso_standalone_test_x86.c:(.text+0xcc): undefined reference to `__umoddi3'
vdso_standalone_test_x86.c:(.text+0xea): undefined reference to `__udivdi3'
collect2: error: ld returned 1 exit status
scripts/Makefile.host:100: recipe for target
'Documentation/vDSO/vdso_standalone_test_x86' failed
make[2]: *** [Documentation/vDSO/vdso_standalone_test_x86] Error 1
scripts/Makefile.build:404: recipe for target 'Documentation/vDSO' failed
make[1]: *** [Documentation/vDSO] Error 2
make[1]: *** Waiting for unfinished jobs....
Makefile:922: recipe for target 'vmlinux' failed
make: *** [vmlinux] Error 2

Looking at some of the git logs around this, it seems that
vdso_standalone_test_x86.c is 64-bit specific, so I was curious why it
was even being built on a 32-bit build.  Seems this commit:

commit adb19fb66eeebac07fe37d968725bb8906dadb8e
Author: Peter Foley <pefoley2@pefoley.com>
Date:   Thu Sep 25 11:23:09 2014 -0700

    Documentation: add makefiles for more targets

    Add a bunch of previously unbuilt source files to the Documentation build
    machinery.

    Signed-off-by: Peter Foley <pefoley2@pefoley.com>
    Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>


blindly added it to the build target.

So is vdso_standalone_test_x86.c really 64-bit specific?  If so,
should that commit be reverted (or a hunk of it anyway), should there
be some mechanism to not build it on 32-bit, or should there be some
additional CFLAGS passed?

josh

Full build log here:
http://koji.fedoraproject.org/koji/getfile?taskID=7802438&name=build.log
