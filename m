Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaJVAKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 20:10:41 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45475 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaJVAKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 20:10:39 -0400
Date: Tue, 21 Oct 2014 17:09:58 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Anton Blanchard <anton@au1.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/powerpc: Cache the DWARF debug info
Message-ID: <20141022000958.GB2228@us.ibm.com>
References: <20141021185610.GA18366@us.ibm.com>
 <20141021190839.GA4160@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021190839.GA4160@kernel.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102200-0029-0000-0000-000000D3F57F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo [acme@kernel.org] wrote:
| Em Tue, Oct 21, 2014 at 11:56:10AM -0700, Sukadev Bhattiprolu escreveu:
| > >From 773a3608a0cd2daf02e244cb9ffbf5bb6a0e724e Mon Sep 17 00:00:00 2001
| > From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| > Date: Tue, 21 Oct 2014 13:20:22 -0500
| > Subject: [PATCH 1/1] perf/powerpc: Cache DWARF debug info
| 
| Jiri, isn't his related to that dsos caching thing you created?
| 
| Anyway, there is a per machine struct (struct machine) where things like
| this should be put, please do not add globals or static variables in
| functions.

Good point. How about something like this:
---

Cache the DWARF debug info for DSO so we don't have to rebuild it for
each address in the DSO.

Note that dso__new() uses calloc() so don't need to set dso->dwfl
to NULL.

	$ /tmp/perf.orig --version
	perf version 3.18.rc1.gc2661b8
	$ /tmp/perf.new --version
	perf version 3.18.rc1.g402d62
	$ perf stat -e cycles,instructions /tmp/perf.orig report -g > orig

	 Performance counter stats for '/tmp/perf.orig report -g':

	     6,428,177,183 cycles                    #    0.000 GHz
	     4,176,288,391 instructions              #    0.65  insns per cycle

	       1.840666132 seconds time elapsed

	$ perf stat -e cycles,instructions /tmp/perf.new report -g > new

	 Performance counter stats for '/tmp/perf.new report -g':

	       305,773,142 cycles                    #    0.000 GHz
	       276,048,272 instructions              #    0.90  insns per cycle

	       0.087693543 seconds time elapsed
	$ diff orig new
	$

Changelog[v2]:
	[Arnaldo Carvalho] Cache in existing global objects rather than create
		new static/globals in functions.

Reported-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/arch/powerpc/util/skip-callchain-idx.c | 33 +++++++++++++++--------
 tools/perf/util/dso.h                             |  1 +
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/tools/perf/arch/powerpc/util/skip-callchain-idx.c b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
index d73ef8b..9892b0f 100644
--- a/tools/perf/arch/powerpc/util/skip-callchain-idx.c
+++ b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
@@ -145,7 +145,7 @@ static Dwarf_Frame *get_dwarf_frame(Dwfl_Module *mod, Dwarf_Addr pc)
  *		yet used)
  *	-1 in case of errors
  */
-static int check_return_addr(const char *exec_file, Dwarf_Addr pc)
+static int check_return_addr(struct dso *dso, Dwarf_Addr pc)
 {
 	int		rc = -1;
 	Dwfl		*dwfl;
@@ -156,15 +156,27 @@ static int check_return_addr(const char *exec_file, Dwarf_Addr pc)
 	Dwarf_Addr	end = pc;
 	bool		signalp;
 
-	dwfl = dwfl_begin(&offline_callbacks);
-	if (!dwfl) {
-		pr_debug("dwfl_begin() failed: %s\n", dwarf_errmsg(-1));
-		return -1;
-	}
+	dwfl = dso->dwfl;
 
-	if (dwfl_report_offline(dwfl, "",  exec_file, -1) == NULL) {
-		pr_debug("dwfl_report_offline() failed %s\n", dwarf_errmsg(-1));
-		goto out;
+	if (!dwfl) {
+		dwfl = dwfl_begin(&offline_callbacks);
+		if (!dwfl) {
+			pr_debug("dwfl_begin() failed: %s\n", dwarf_errmsg(-1));
+			return -1;
+		}
+
+		if (dwfl_report_offline(dwfl, "", dso->long_name, -1) == NULL) {
+			pr_debug("dwfl_report_offline() failed %s\n",
+						dwarf_errmsg(-1));
+			/*
+			 * We normally cache the DWARF debug info and never
+			 * call dwfl_end(). But to prevent fd leak, free in
+			 * case of error.
+			 */
+			dwfl_end(dwfl);
+			goto out;
+		}
+		dso->dwfl = dwfl;
 	}
 
 	mod = dwfl_addrmodule(dwfl, pc);
@@ -194,7 +206,6 @@ static int check_return_addr(const char *exec_file, Dwarf_Addr pc)
 	rc = check_return_reg(ra_regno, frame);
 
 out:
-	dwfl_end(dwfl);
 	return rc;
 }
 
@@ -246,7 +257,7 @@ int arch_skip_callchain_idx(struct machine *machine, struct thread *thread,
 		return skip_slot;
 	}
 
-	rc = check_return_addr(dso->long_name, ip);
+	rc = check_return_addr(dso, ip);
 
 	pr_debug("DSO %s, nr %" PRIx64 ", ip 0x%" PRIx64 "rc %d\n",
 				dso->long_name, chain->nr, ip, rc);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index acb651a..3c9b391 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -127,6 +127,7 @@ struct dso {
 	const char	 *long_name;
 	u16		 long_name_len;
 	u16		 short_name_len;
+	void		*dwfl;			/* DWARF debug info */
 
 	/* dso data file */
 	struct {

