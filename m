Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaLRG3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:29:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58552 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaLRG3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:29:12 -0500
Date: Wed, 17 Dec 2014 22:28:06 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-8qope8lxb898narnq5kmu2gf@git.kernel.org>
Cc: mingo@kernel.org, paulus@samba.org, dsahern@gmail.com, namhyung@kernel.org,
        dzickus@redhat.com, acme@redhat.com, eranian@google.com, hpa@zytor.com,
        efault@gmx.de, jolsa@redhat.com, peterz@infradead.org,
        adrian.hunter@intel.com, bp@suse.de, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com
Reply-To: mingo@kernel.org, paulus@samba.org, dsahern@gmail.com,
        namhyung@kernel.org, acme@redhat.com, dzickus@redhat.com,
        eranian@google.com, hpa@zytor.com, jolsa@redhat.com, efault@gmx.de,
        adrian.hunter@intel.com, peterz@infradead.org, bp@suse.de,
        tglx@linutronix.de, fweisbec@gmail.com, linux-kernel@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist: Fixup brown paper bag on "hint"
  for --mmap-pages cmdline arg
Git-Commit-ID: 0a2138b28fd56eeb3852133691c881409885ee3f
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

Commit-ID:  0a2138b28fd56eeb3852133691c881409885ee3f
Gitweb:     http://git.kernel.org/tip/0a2138b28fd56eeb3852133691c881409885ee3f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 12 Dec 2014 16:07:47 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 16 Dec 2014 13:38:26 -0300

perf evlist: Fixup brown paper bag on "hint" for --mmap-pages cmdline arg

When failing due to asking for a number of mmap pages that is more than
the max, it was suggesting that an even bigger number of mmap pages
should be specified, doh, au contraire!

Before:

  [acme@ssdandy linux]$ trace -m 128 usleep 1
  Error:	Operation not permitted.
  Hint:	Check /proc/sys/kernel/perf_event_mlock_kb (516 kB) setting.
  Hint:	Tried using 516 kB.
  Hint:	Try using a bigger -m/--mmap-pages value.
  [acme@ssdandy linux]$

After:

  [acme@ssdandy linux]$ trace -m 128 usleep 1
  Error:	Operation not permitted.
  Hint:	Check /proc/sys/kernel/perf_event_mlock_kb (516 kB) setting.
  Hint:	Tried using 516 kB.
  Hint:	Try using a smaller -m/--mmap-pages value.
  [acme@ssdandy linux]$

And to (really) clarify what happens above, when what the user requests
is <= max and even then it fails, a changeset is being made to tell that
this is a per user limit, not per process (in the above example there
was another 'perf trace' running for this user, which was using all the
pages it could use).

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8qope8lxb898narnq5kmu2gf@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index bb5dfc5..de7515d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1495,7 +1495,7 @@ int perf_evlist__strerror_mmap(struct perf_evlist *evlist, int err, char *buf, s
 		scnprintf(buf, size, "Error:\t%s.\n"
 				     "Hint:\tCheck /proc/sys/kernel/perf_event_mlock_kb (%d kB) setting.\n"
 				     "Hint:\tTried using %zd kB.\n"
-				     "Hint:\tTry using a bigger -m/--mmap-pages value.",
+				     "Hint:\tTry using a smaller -m/--mmap-pages value.",
 				     emsg, value, evlist->mmap_len / 1024);
 		break;
 	default:
