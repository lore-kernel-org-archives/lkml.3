Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaGLOoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 10:44:17 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40336 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaGLOoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 10:44:13 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH v2 0/8] Mark literal strings in __init / __exit code
Date: Sat, 12 Jul 2014 16:43:24 +0200
Message-Id: <1405176212-12175-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of the patch series initially posted here:

  https://lkml.org/lkml/2014/6/22/149

I've integrated Joe's idea of also providing printk_init() /
printk_exit() wrappers for code that cannot (or doesn't want to) be
converted to the pi_*() / pe_*() wrappers.

Patches 4 and 5 are cleanup patches I stumbled over while changing the
corresponding code to make use of the new pi_*() helpers.

This version addresses the symbol filtering issue, by filtering the
pseudo symbols in kallsyms (patch 8). This removes them even in the
KALLSYMS_ALL case.

I've changed a few more files, pushing up the memory moved from .rodata
to .init.rodata to ~3 kB. This should free up a page after init for
almost any x86 system.

Comments?


Mathias Krause (8):
  init.h: Add __init_str / __exit_str macros
  printk: Provide pi_<level> / pe_<level> macros for __init / __exit
    code
  x86, acpi: Mark __init strings as such
  x86, mm: Make x86_init.memory_setup() return a const char *
  x86, mm: early_panic() - pass on the message as string
  x86, mm: e820 - mark __init strings as such
  x86: setup - mark __init strings as such
  kallsyms: exclude pseudo symbols for __init / __exit strings

 arch/x86/include/asm/e820.h     |    4 +-
 arch/x86/include/asm/x86_init.h |    2 +-
 arch/x86/kernel/acpi/boot.c     |  162 ++++++++++++++++++---------------------
 arch/x86/kernel/acpi/sleep.c    |   17 ++--
 arch/x86/kernel/e820.c          |   95 +++++++++++------------
 arch/x86/kernel/setup.c         |   70 ++++++++---------
 arch/x86/lguest/boot.c          |    2 +-
 arch/x86/xen/setup.c            |    4 +-
 arch/x86/xen/xen-ops.h          |    4 +-
 include/linux/init.h            |   23 ++++++
 include/linux/printk.h          |   59 ++++++++++++++
 scripts/kallsyms.c              |   13 ++++
 12 files changed, 267 insertions(+), 188 deletions(-)

-- 
1.7.10.4

