Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbbANRhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:37:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbbANRhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:37:09 -0500
Date: Wed, 14 Jan 2015 19:36:18 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        davem@davemloft.net, deller@gmx.de, egtvedt@samfundet.no,
        geert@linux-m68k.org, james.hogan@imgtec.com, jcmvbkbc@gmail.com,
        mst@redhat.com, realmz6@gmail.com, sam@ravnborg.org,
        tglx@linutronix.de, will.deacon@arm.com
Subject: [PULL] uaccess: fix sparse warning on get/put_user for bitwise types
Message-ID: <20150114173618.GA12436@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Arnd,
As you asked, here's a pull request.
This has been in linux-next apparently with no ill effects.

The following changes since commit 99975cc6ada0d5f2675e83abecae05aba5f437d2:

  vhost/net: length miscalculation (2015-01-07 12:22:00 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/uaccess_for_upstream

for you to fetch changes up to 0795cb1b46e7938ed679ccd48f933e75272b30e3:

  sparc32: nocheck uaccess coding style tweaks (2015-01-13 15:24:14 +0200)

----------------------------------------------------------------
uaccess: fix sparse warning on get/put_user for bitwise types

At the moment, if p and x are both tagged as bitwise types,
some of get_user(x, p), put_user(x, p), __get_user(x, p), __put_user(x, p)
might produce a sparse warning on many architectures.
This is a false positive: *p on these architectures is loaded into long
(typically using asm), then cast back to typeof(*p).

When typeof(*p) is a bitwise type (which is uncommon), such a cast needs
__force, otherwise sparse produces a warning.

Some architectures already have the __force tag, add it
where it's missing.

I verified that adding these __force casts does not supress any useful warnings.

Specifically, vhost wants to read/write bitwise types in userspace memory
using get_user/put_user.
At the moment this triggers sparse errors, since the value is passed through an
integer.

For example:
    __le32 __user *p;
    __u32 x;

both
    put_user(x, p);
and
    get_user(x, p);
should be safe, but produce warnings on some architectures.

While there, I noticed that a bunch of architectures violated
coding style rules within uaccess macros.
Included patches to fix them up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Michael S. Tsirkin (37):
      x86/uaccess: fix sparse errors
      alpha/uaccess: fix sparse errors
      arm64/uaccess: fix sparse errors
      avr32/uaccess: fix sparse errors
      blackfin/uaccess: fix sparse errors
      cris/uaccess: fix sparse errors
      ia64/uaccess: fix sparse errors
      m32r/uaccess: fix sparse errors
      metag/uaccess: fix sparse errors
      openrisc/uaccess: fix sparse errors
      parisc/uaccess: fix sparse errors
      sh/uaccess: fix sparse errors
      sparc32/uaccess: fix sparse errors
      sparc64/uaccess: fix sparse errors
      m68k/uaccess: fix sparse errors
      arm: fix put_user sparse errors
      blackfin: fix put_user sparse errors
      ia64: fix put_user sparse errors
      metag: fix put_user sparse errors
      sh: fix put_user sparse errors
      avr32: whitespace fix
      sparc32: uaccess_32 macro whitespace fixes
      sparc64: uaccess_64 macro whitespace fixes
      blackfin: macro whitespace fixes
      alpha: macro whitespace fixes
      arm: macro whitespace fixes
      arm64: macro whitespace fixes
      avr32: macro whitespace fixes
      cris: macro whitespace fixes
      frv: macro whitespace fixes
      m32r: macro whitespace fixes
      m68k: macro whitespace fixes
      parisc: macro whitespace fixes
      sh: macro whitespace fixes
      xtensa: macro whitespace fixes
      sparc64: nocheck uaccess coding style tweaks
      sparc32: nocheck uaccess coding style tweaks

 arch/alpha/include/asm/uaccess.h    |  86 ++++-----
 arch/arm/include/asm/uaccess.h      |  96 +++++-----
 arch/arm64/include/asm/uaccess.h    |   4 +-
 arch/avr32/include/asm/uaccess.h    |  24 +--
 arch/blackfin/include/asm/uaccess.h |  32 ++--
 arch/cris/include/asm/uaccess.h     | 117 +++++++------
 arch/frv/include/asm/segment.h      |   2 +-
 arch/ia64/include/asm/uaccess.h     |  11 +-
 arch/m32r/include/asm/uaccess.h     |  88 +++++-----
 arch/m68k/include/asm/segment.h     |   2 +-
 arch/m68k/include/asm/uaccess_mm.h  |  40 ++---
 arch/metag/include/asm/uaccess.h    |  25 +--
 arch/openrisc/include/asm/uaccess.h |   4 +-
 arch/parisc/include/asm/uaccess.h   | 116 ++++++------
 arch/sh/include/asm/segment.h       |   2 +-
 arch/sh/include/asm/uaccess.h       |   4 +-
 arch/sh/include/asm/uaccess_64.h    |   8 +-
 arch/sparc/include/asm/uaccess_32.h | 339 +++++++++++++++++++++---------------
 arch/sparc/include/asm/uaccess_64.h | 222 ++++++++++++-----------
 arch/x86/include/asm/uaccess.h      |   2 +-
 arch/xtensa/include/asm/uaccess.h   |  90 +++++-----
 21 files changed, 700 insertions(+), 614 deletions(-)
