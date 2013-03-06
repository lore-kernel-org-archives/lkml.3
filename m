Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab3CFUri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 15:47:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab3CFUrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 15:47:36 -0500
Subject: [RFC][PATCH 0/4] UAPI: Fix up endianness conditionals
To: torvalds@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, sfr@canb.auug.org.au,
        Joakim.Tjernlund@transmode.se, arnd@arndb.de,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Date: Wed, 06 Mar 2013 20:47:25 +0000
Message-ID: <20130306204724.31327.43118.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here are four patches to fix some of the problems with endianness-related
preprocessor conditionals I have found in the UAPI header files.

The problem is that the way that preprocessor conditionals are used to
determine endianness when building for Linux userspace (as defined by the
predominant use of glibc) is not compatible with the way that the kernel build
does things.  The problem revolves around how __BIG_ENDIAN and __LITTLE_ENDIAN
are defined in each environment.

When building for Linux userspace, __BIG_ENDIAN and __LITTLE_ENDIAN are always
defined - so the kernel's preferred:

	if defined(__xxx_ENDIAN)

is always true in userspace builds, no matter which endianness your check
employs - whereas only one is defined in the kernel builds - meaning

	#if __BYTE_ORDER == __xxx_ENDIAN

gives a warning with -Wundef if you select the undefined endianness for your
check.


Unfortunately, the UAPI header files _must_ employ the userspace variant of
these conditionals outside of __KERNEL__-conditionalised regions as these
conditionals get exposed to userspace and userspace _cannot_ be changed.

These can be fixed in the UAPI headers by changing:

	#if defined(__BIG_ENDIAN)
	#define foo 1234
	#elif defined(__LITTLE_ENDIAN)
	#define foo 4321
	#else
	#error endianness unspecified
	#endif

to:

	#if defined(__BYTE_ORDER) ? __BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
	#define foo 1234
	#elif defined(__BYTE_ORDER) ? __BYTE_ORDER == __LITTLE_ENDIAN : defined(__LITTLE_ENDIAN)
	#define foo 4321
	#else
	#error endianness unspecified
	#endif

as it appears gcc's cpp doesn't complain about macros that aren't evaluated.

[!!!] NOTE [!!!]  These patches may adversely change the userspace API.  Since
the userspace API appears to be wrong under some circumstances due to incorrect
conditionals, it may be necessary to make an alternate fix whereby the we
select the first variant unconditionally in all cases as we would otherwise be
changing the actual userspace API.

David
---
David Howells (4):
      UAPI: Fix endianness conditionals in linux/aio_abi.h
      UAPI: Fix endianness conditionals in linux/acct.h
      UAPI: Fix endianness conditionals in linux/raid/md_p.h
      UAPI: Fix endianness conditionals in M32R's asm/stat.h


 arch/m32r/include/uapi/asm/stat.h |    4 ++--
 include/uapi/linux/acct.h         |    6 ++++--
 include/uapi/linux/aio_abi.h      |    4 ++--
 include/uapi/linux/raid/md_p.h    |    6 ++++--
 4 files changed, 12 insertions(+), 8 deletions(-)

