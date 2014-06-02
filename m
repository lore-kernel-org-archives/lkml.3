Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaFBHBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:01:55 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:41122 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaFBHBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:01:54 -0400
From: Alexei Starovoitov <ast@plumgrid.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 0/2] split BPF out of core networking
Date: Mon,  2 Jun 2014 00:01:44 -0700
Message-Id: <1401692506-7796-1-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set splits BPF out of core networking into generic component

patch #1 splits filter.c into two logical pieces: generic BPF core and socket
filters. It only moves functions around. No real changes.

patch #2 adds hidden CONFIG_BPF that seccomp/tracing can select

The main value of the patch is not a NET separation, but rather logical boundary
between generic BPF core and socket filtering. All socket specific code stays in
net/core/filter.c and kernel/bpf/core.c is for generic BPF infrastructure (both
classic and internal).

Note that CONFIG_BPF_JIT is still under NET, so NET-less configs cannot use
BPF JITs yet. This can be cleaned up in the future. Also it seems to makes sense
to split up filter.h into generic and socket specific as well to cleanup the
boundary further.

Tested with several NET and NET-less configs on arm and x86

V1->V2:
rebase on top of net-next
split filter.c into kernel/bpf/core.c instead of net/bpf/core.c

Alexei Starovoitov (2):
  net: filter: split filter.c into two files
  net: filter: split BPF out of core networking

 arch/Kconfig           |    6 +-
 include/linux/filter.h |    2 +
 kernel/Makefile        |    1 +
 kernel/bpf/Makefile    |    5 +
 kernel/bpf/core.c      | 1063 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/Kconfig            |    1 +
 net/core/filter.c      | 1023 +---------------------------------------------
 7 files changed, 1079 insertions(+), 1022 deletions(-)
 create mode 100644 kernel/bpf/Makefile
 create mode 100644 kernel/bpf/core.c

-- 
1.7.9.5

