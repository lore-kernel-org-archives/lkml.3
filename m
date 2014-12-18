Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbaLRGdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:33:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58771 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaLRGdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:33:04 -0500
Date: Wed, 17 Dec 2014 22:32:26 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-6p6l5ou6jev6o7ymc4nn1n2a@git.kernel.org>
Cc: namhyung@kernel.org, hpa@zytor.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, dzickus@redhat.com, acme@redhat.com,
        efault@gmx.de, bp@suse.de, adrian.hunter@intel.com, paulus@samba.org,
        peterz@infradead.org, jolsa@redhat.com, dsahern@gmail.com,
        eranian@google.com, tglx@linutronix.de, fweisbec@gmail.com
Reply-To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        namhyung@kernel.org, efault@gmx.de, bp@suse.de, acme@redhat.com,
        dzickus@redhat.com, adrian.hunter@intel.com, jolsa@redhat.com,
        dsahern@gmail.com, peterz@infradead.org, paulus@samba.org,
        fweisbec@gmail.com, eranian@google.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Make the mmap length autotuning more robust
Git-Commit-ID: 1be300f4cc1ddf975f158b4ab2f880854b29306b
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

Commit-ID:  1be300f4cc1ddf975f158b4ab2f880854b29306b
Gitweb:     http://git.kernel.org/tip/1be300f4cc1ddf975f158b4ab2f880854b29306b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 16 Dec 2014 12:19:00 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Dec 2014 11:58:14 -0300

perf tools: Make the mmap length autotuning more robust

If /proc/sys/kernel/perf_event_mlock_kb is not (power of 2 + PAGE_SIZE_in_kb)
and we let the perf tools do mmap length autosizing based on that, then, for
non-CAP_IPC_LOCK users when /proc/sys/kernel/perf_event_paranoid is > -1, then
we get an -EINVAL that ends up in:

  [acme@ssdandy linux]$ trace usleep 1
  Invalid argument
  [acme@ssdandy linux]$ perf record usleep 1
  failed to mmap with 22 (Invalid argument)

After this fix:

  [acme@ssdandy linux]$ trace usleep 1
  <SNIP>
   0.806 ( 0.006 ms): munmap(addr: 0x7f7e4740a000, len: 66467) = 0
   0.869 ( 0.002 ms): brk(                                   ) = 0x7bb000
   0.873 ( 0.003 ms): brk(brk: 0x7dc000                      ) = 0x7dc000
   0.877 ( 0.001 ms): brk(                                   ) = 0x7dc000
   0.953 ( 0.058 ms): nanosleep(rqtp: 0x7fff26ab9420         ) = 0
   0.959 ( 0.000 ms): exit_group(
  [acme@ssdandy linux]$ perf record usleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.017 MB perf.data (~759 samples) ]
  [acme@ssdandy linux]$

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
Link: http://lkml.kernel.org/n/tip-6p6l5ou6jev6o7ymc4nn1n2a@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 8eb92cf..7d88327 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -909,6 +909,8 @@ static size_t perf_evlist__mmap_size(unsigned long pages)
 		}
 
 		pages = (max * 1024) / page_size;
+		if (!is_power_of_2(pages))
+			pages = rounddown_pow_of_two(pages);
 	} else if (!is_power_of_2(pages))
 		return 0;
 
