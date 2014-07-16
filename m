Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaGPT2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:28:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44446 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965771AbaGPTW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:22:57 -0400
Date: Wed, 16 Jul 2014 12:21:45 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-fbe26abe118ee1262b4ab0d12fefd42647eaea35@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        luto@amacapital.net, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        namhyung@kernel.org, luto@amacapital.net, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1405353439-14211-1-git-send-email-jolsa@kernel.org>
References: <1405353439-14211-1-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Add vm_ops->
 name call for mmap event name retrieval
Git-Commit-ID: fbe26abe118ee1262b4ab0d12fefd42647eaea35
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fbe26abe118ee1262b4ab0d12fefd42647eaea35
Gitweb:     http://git.kernel.org/tip/fbe26abe118ee1262b4ab0d12fefd42647eaea35
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 14 Jul 2014 17:57:19 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 13:31:22 +0200

perf: Add vm_ops->name call for mmap event name retrieval

The following patch added another way to get mmap name: 78d683e838a6
("mm, fs: Add vm_ops->name as an alternative to arch_vma_name")

The vdso vma mapping already switch to this and we no longer get vdso
name via arch_vma_name function. Adding this way to the perf mmap
event name retrieval code.

Caught this via perf test:

  $ sudo ./perf test -v 7
   7: Validate PERF_RECORD_* events & perf_sample fields     :
  --- start ---

SNIP

  PERF_RECORD_MMAP for [vdso] missing!
  test child finished with 255
  ---- end ----
  Validate PERF_RECORD_* events & perf_sample fields: FAILED!

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1405353439-14211-1-git-send-email-jolsa@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 67e3b9c..4799676 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5266,6 +5266,12 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 
 		goto got_name;
 	} else {
+		if (vma->vm_ops && vma->vm_ops->name) {
+			name = (char *) vma->vm_ops->name(vma);
+			if (name)
+				goto cpy_name;
+		}
+
 		name = (char *)arch_vma_name(vma);
 		if (name)
 			goto cpy_name;
