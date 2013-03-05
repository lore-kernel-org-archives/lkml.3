Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963Ab3CEFxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 00:53:36 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55270 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab3CEFxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 00:53:35 -0500
X-AuditID: 9c930197-b7cc2ae000000eb7-53-5135885c1255
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 00/12] perf annotate: Add support for event group view (v2)
Date: Tue,  5 Mar 2013 14:53:20 +0900
Message-Id: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patchset implements event group view on perf annotate.  It's
basically a rebased version and major difference to prior version is
the GTK annotation browser support.

Here goes an example:

 $ perf annotate --group --stdio

  Percent                 |      Source code & Disassembly of libpthread-2.15.so
 --------------------------------------------------------------------------------
                          :
                          :
                          :
                          :      Disassembly of section .text:
                          :
                          :      000000387dc0aa50 <__pthread_mutex_unlock_usercnt>:
  crtstuff.c:0
     8.08    2.40    5.29 :        387dc0aa50:   mov    %rdi,%rdx
     0.00    0.00    0.00 :        387dc0aa53:   mov    0x10(%rdi),%edi
     0.00    0.00    0.00 :        387dc0aa56:   mov    %edi,%eax
  crtstuff.c:0
     0.00    0.80    0.00 :        387dc0aa58:   and    $0x7f,%eax
     3.03    2.40    3.53 :        387dc0aa5b:   test   $0x7c,%dil
     0.00    0.00    0.00 :        387dc0aa5f:   jne    387dc0aaa9 <__pthread_mutex_unlock_use
     0.00    0.00    0.00 :        387dc0aa61:   test   %eax,%eax
     0.00    0.00    0.00 :        387dc0aa63:   jne    387dc0aa85 <__pthread_mutex_unlock_use
     0.00    0.00    0.00 :        387dc0aa65:   and    $0x80,%edi
     0.00    0.00    0.00 :        387dc0aa6b:   test   %esi,%esi
  crtstuff.c:0
     3.03    5.60    7.06 :        387dc0aa6d:   movl   $0x0,0x8(%rdx)
  crtstuff.c:0
     0.00    0.00    0.59 :        387dc0aa74:   je     387dc0aa7a <__pthread_mutex_unlock_use
     0.00    0.00    0.00 :        387dc0aa76:   subl   $0x1,0xc(%rdx)
  crtstuff.c:0
     2.02    5.60    1.18 :        387dc0aa7a:   mov    %edi,%esi
     0.00    0.00    0.00 :        387dc0aa7c:   lock decl (%rdx)
    83.84   83.20   82.35 :        387dc0aa7f:   jne    387dc0aada <_L_unlock_586>
     0.00    0.00    0.00 :        387dc0aa81:   nop
     0.00    0.00    0.00 :        387dc0aa82:   xor    %eax,%eax
     0.00    0.00    0.00 :        387dc0aa84:   retq   
 ...


You can access it via perf/annotate-group-v2 branch on my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome, thanks
Namhyung


Namhyung Kim (12):
  perf annotate: Pass evsel instead of evidx on annotation functions
  perf annotate: Add a comment on the symbol__parse_objdump_line()
  perf annotate: Factor out disasm__calc_percent()
  perf annotate: Cleanup disasm__calc_percent()
  perf annotate: Add basic support to event group view
  perf evsel: Introduce perf_evsel__is_group_event() helper
  perf annotate: Factor out struct source_line_percent
  perf annotate: Support event group view for --print-line
  perf annotate browser: Make browser_disasm_line->percent an array
  perf annotate browser: Use disasm__calc_percent()
  perf annotate browser: Support event group view on TUI
  perf annotate/gtk: Support event group view on GTK

 tools/perf/Documentation/perf-annotate.txt |   3 +
 tools/perf/builtin-annotate.c              |  23 ++-
 tools/perf/builtin-report.c                |   2 +-
 tools/perf/builtin-top.c                   |   2 +-
 tools/perf/ui/browsers/annotate.c          | 139 +++++++++------
 tools/perf/ui/browsers/hists.c             |   6 +-
 tools/perf/ui/gtk/annotate.c               |  26 ++-
 tools/perf/ui/gtk/hists.c                  |   7 +-
 tools/perf/ui/hist.c                       |   7 +-
 tools/perf/util/annotate.c                 | 262 ++++++++++++++++++++++-------
 tools/perf/util/annotate.h                 |  49 +++---
 tools/perf/util/evsel.h                    |  24 +++
 tools/perf/util/hist.h                     |   5 +-
 13 files changed, 389 insertions(+), 166 deletions(-)

-- 
1.7.11.7

