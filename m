Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaGKBNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 21:13:25 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41582 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaGKBNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 21:13:24 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Jan Beulich <JBeulich@suse.com>, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Cc: Boris Ostrovsky <ostr.lkml@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/2] Revert to 32-bit 3.15-style vvar and vdso stripping
Date: Thu, 10 Jul 2014 18:13:14 -0700
Message-Id: <cover.1405040914.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fancy ideas of aggressively stripping the vdso and placing the
vvar data after the vdso have been considerably more painful than I
hoped.  This reverts to using objcopy -S to strip the vdso (thus
eliminating the whole fake section mechanism and all of its
attendent build-time fragility, I hope) and places the vvar data
before the vdso.

The latter is a bit messy: ELF wasn't really designed to have
symbols at negative virtual addresses.  I think I got all the
bitness issues and cross-compilation stuff right, but I'm not
well-equipped to test that.  The kbuild robot hasn't complained yet,
though.

I don't know whether this is 3.16 material.  I'm not aware of an
actual problem at this point, but the current state of affairs is
quite fragile.

Applies on top of tip/x86/urgent as of a few minutes ago.


Andy Lutomirski (2):
  x86,vdso: Move the vvar area before the vdso text
  x86,vdso: Get rid of the fake section mechanism

 arch/x86/include/asm/vdso.h       |  18 +--
 arch/x86/vdso/Makefile            |  16 ++-
 arch/x86/vdso/vdso-fakesections.c |  21 ----
 arch/x86/vdso/vdso-layout.lds.S   |  44 ++++----
 arch/x86/vdso/vdso2c.c            | 128 ++++++++++++++++-----
 arch/x86/vdso/vdso2c.h            | 227 +++++++-------------------------------
 arch/x86/vdso/vma.c               |  20 ++--
 7 files changed, 188 insertions(+), 286 deletions(-)
 delete mode 100644 arch/x86/vdso/vdso-fakesections.c

-- 
1.9.3

