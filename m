Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaILJ0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:26:19 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:42366 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbaILJ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:26:15 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 0/6] Small seqfile-use improvements
Date: Fri, 12 Sep 2014 11:25:48 +0200
Message-Id: <1410513954-28909-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches 1-3 are semantic patches for replacing certain seq_* calls
with simpler equivalents, e.g. seq_printf(m, "literal") -> seq_puts(m,
"literal"). 1 and 3 are guaranteed to preserve the semantics of the
code. 2 may change it slightly, since if the seq_file overflows midway
through a series of seq_puts calls, some of the strings have been
printed; after applying 2, it is all-or-nothing. However, consecutive
seq_puts calls with literal strings is mostly used to print long
headers, so overflow is very unlikely.

As an example, I applied these coccinelle scripts to kernel/trace/.
The net result is a nice round, but admittedly tiny, 256 byte .text
reduction.

Rasmus Villemoes (6):
  Coccinelle: Semantic patch for replacing puts with putc
  Coccinelle: Semantic patch for joining seq_puts calls
  Coccinelle: Semantic patch for replacing seq_printf calls with
    equivalent but simpler functions
  trace: Replace seq_printf by simpler equivalents
  trace: Merge consecutive seq_puts calls
  trace: Replace single-character seq_puts with seq_putc

 kernel/trace/ftrace.c                        |  30 +++---
 kernel/trace/trace.c                         |  86 ++++++++-------
 kernel/trace/trace_branch.c                  |  31 +++---
 kernel/trace/trace_events.c                  |   4 +-
 kernel/trace/trace_events_trigger.c          |   6 +-
 kernel/trace/trace_functions.c               |   2 +-
 kernel/trace/trace_functions_graph.c         |  28 ++---
 kernel/trace/trace_kprobe.c                  |  12 +--
 kernel/trace/trace_printk.c                  |   2 +-
 kernel/trace/trace_uprobe.c                  |   4 +-
 scripts/coccinelle/api/seq_printf.cocci      | 156 +++++++++++++++++++++++++++
 scripts/coccinelle/api/seq_puts_concat.cocci |  71 ++++++++++++
 scripts/coccinelle/api/seq_putsc.cocci       |  61 +++++++++++
 13 files changed, 393 insertions(+), 100 deletions(-)
 create mode 100644 scripts/coccinelle/api/seq_printf.cocci
 create mode 100644 scripts/coccinelle/api/seq_puts_concat.cocci
 create mode 100644 scripts/coccinelle/api/seq_putsc.cocci

-- 
2.0.4

