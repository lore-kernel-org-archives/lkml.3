Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab3EFMbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 08:31:08 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:33383 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3EFMbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 08:31:06 -0400
MIME-Version: 1.0
Date: Mon, 6 May 2013 14:31:06 +0200
X-Google-Sender-Auth: A5adz8HDooEiumB1FeAijAZsNnw
Message-ID: <CAMuHMdXBk0oZUufY3KoFaZiawRHdm9juMqHPMTftqcjQDXnUgw@mail.gmail.com>
Subject: h8300 SYMBOL_NAME() breakage
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rusty Russell <rusty@rustcorp.com.au>, Al Viro <viro@zeniv.linux.org.uk>,
        James Hogan <james.hogan@imgtec.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://kisskb.ellerman.id.au/kisskb/buildresult/8674258/

arch/h8300/kernel/syscalls.S:6: Error: junk at end of line, first
unrecognized character is `('
arch/h8300/kernel/syscalls.S:17: Error: junk at end of line, first
unrecognized character is `('
arch/h8300/kernel/syscalls.S:18: Error: junk at end of line, first
unrecognized character is `('

Commit e1b5bb6d1236d4ad2084c53aa83dde7cdf6f8eea ("consolidate cond_syscall
and SYSCALL_ALIAS declarations") broke the h8300 build because it removed
the duplicate SYMBOL_NAME from arch/h8300/include/asm/linkage.h, and all
the h8300 asm files include <asm/linkage.h> instead of <linux/linkage.h>.
(yes, this was in -next).

Commit 126de6b20bfb82cc19012d5048f11f339ae5a021 ("linkage.h: fix build
breakage due to symbol prefix handling") broke it even more, by removing
SYMBOL_NAME() and replacing it by __SYMBOL_NAME().

Commit f8ce1faf55955de62e0a12e330c6d9a526071f65 ("Merge tag
'modules-next-for-linus' of
git://git.kernel.org/pub/scm/linuxkernel/git/rusty/linux")
also removed __SYMBOL_NAME(). hidden in a merge conflict resolution.

Interestingly, commit b92021b09df70c1609e3547f3d6128dd560be97f
("CONFIG_SYMBOL_PREFIX: cleanup.") mentions
"arch/h8300/include/asm/linkage.h defines SYMBOL_NAME(), too", so (some)
people should have been aware of the issue?

BTW, arch/h8300/include/asm/linkage.h still has

    #undef SYMBOL_NAME_LABEL
    #define SYMBOL_NAME_LABEL(_name_) _##_name_##:
    #endif

How should this be fixed?
  - Re-add SYMBOL_NAME() to arch/h8300/include/asm/linkage.h?
  - Kill SYMBOL_NAME() and SYMBOL_NAME_LABEL(), and hardcode the
underscores in the h8300 asm sources?
  - Anything else?
I didn't follow the whole symbol prefix discussion that closely.

Thaks for your suggestions?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
