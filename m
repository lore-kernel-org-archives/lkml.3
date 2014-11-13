Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934661AbaKMXT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:19:58 -0500
Received: from mga03.intel.com ([134.134.136.65]:28312 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934216AbaKMXTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:19:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,380,1413270000"; 
   d="scan'208";a="607539367"
From: Andi Kleen <andi@firstfloor.org>
To: lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] turbostat: Add support for uncore frequency band monitoring
Date: Thu, 13 Nov 2014 15:19:50 -0800
Message-Id: <1415920790-23163-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415920790-23163-1-git-send-email-andi@firstfloor.org>
References: <1415920790-23163-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Note: needs bug fixes in uncore kernel driver.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/power/x86/turbostat/turbostat.8 |  3 +++
 tools/power/x86/turbostat/turbostat.c | 36 +++++++++++++++++++++++++++++++----
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index e91d837..3f75053 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -47,6 +47,9 @@ The \fB-x GROUP\fP option enables PCU event group monitoring. Valid groups are
 5 for frequency transitions statistics. Requires the kernel
 to support the perf uncore driver for this platform.
 .PP
+The \fB-0 FREQ\fP, \fB-1 FREQ\fB, \fB-2 FREQ\fB options set the frequency bands to moitor
+with -x0. The unit is 100Mhz (10 = 1Ghz).
+.PP
 The \fBcommand\fP parameter forks \fBcommand\fP and upon its exit,
 displays the statistics gathered since it was forked.
 .PP
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 5c23f00..04335d1 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -933,7 +933,11 @@ static unsigned long long rdtsc(void)
    FORCECPU=cpu ucevent.py --resolve EVENT-NAME */
 
 static char *pcu_groups[][5] = {
-	/* Runs into problems with the uncore driver with the filters for now. */
+	[0] = { "uncore_pcu/event=0x0/", /* PCU.CLOCKTICKS */
+		"uncore_pcu/event=0xb,filter_band0=BANDBAND/",
+		"uncore_pcu/event=0xc,filter_band1=BANDBAND/",
+		"uncore_pcu/event=0xd,filter_band2=BANDBAND/",
+		NULL },
 	[0] = { NULL },
 	/* group 1 is covered already */
 	[1] = { NULL },
@@ -958,8 +962,12 @@ static char *pcu_groups[][5] = {
 		NULL },
 };
 
+char band0_title[13];
+char band1_title[13];
+char band2_title[13];
+
 static char *pcu_group_titles[][3] = {
-	[0] = { "", "", "" },
+	[0] = { band0_title, band1_title, band2_title },
 	[1] = { "", "", "" },
 	[2] = { "ProcHot-ext%", "ProcHot-int%", "Therm-Lim%" },
 	[3] = { "Therm-Lim%", "Power-Lim%", "Current-Lim%" },
@@ -967,6 +975,8 @@ static char *pcu_group_titles[][3] = {
 	[5] = { "Num-Freq-Trans", "Freq-Trans%", "" }
 };
 
+int freq_band[3] = { 12, 20, 30 };
+
 #define NUM_COUNTER 4
 
 static void pcu_fixup_tables(void)
@@ -981,6 +991,9 @@ static void pcu_fixup_tables(void)
 		pcu_groups[5][1] = "uncore_pcu/event=0x200000,edge=1/"; /* PCU.FREQ_TRANS_CYCLES */
 		pcu_groups[5][2] = "uncore_pcu/event=0x200000/";
 	}
+	sprintf(band0_title, ">=%4.2fGhz", (100. * freq_band[0]) / 1000.);
+	sprintf(band1_title, ">=%4.2fGhz", (100. * freq_band[1]) / 1000.);
+	sprintf(band2_title, ">=%4.2fGhz", (100. * freq_band[2]) / 1000.);
 }
 
 static int pcu_perf_init(int group, int cpu, int *pcu_fd)
@@ -993,6 +1006,16 @@ static int pcu_perf_init(int group, int cpu, int *pcu_fd)
 		struct perf_event_attr attr;
 		char *ev = evnames[i];
 
+		if (strstr(ev, "BANDBAND")) {
+			char band[20];
+
+			ev = strdup(ev);
+			if (!ev)
+				err(1, "no memory");
+			snprintf(band, sizeof band, "%-8d", freq_band[i - 1]);
+			memcpy(strstr(ev, "BANDBAND"), band, strlen(band));
+		}
+
 		if (tjevent_name_to_attr(ev, &attr) < 0) {
 			fprintf(stderr, "Cannot resolve %s\n", ev);
 			goto fallback;
@@ -2271,7 +2294,7 @@ void check_cpuid()
 
 void usage()
 {
-	errx(1, "%s: [-v][-R][-T][-p|-P|-S][-c MSR#][-C MSR#][-m MSR#][-M MSR#] [-xPCUGROUP] [-i interval_sec | command ...]\n",
+	errx(1, "%s: [-v][-R][-T][-p|-P|-S][-c MSR#][-C MSR#][-m MSR#][-M MSR#] [-xPCUGROUP] [-0/1/2 FREQ] [-i interval_sec | command ...]\n",
 	     progname);
 }
 
@@ -2581,7 +2604,7 @@ void cmdline(int argc, char **argv)
 
 	progname = argv[0];
 
-	while ((opt = getopt(argc, argv, "+pPsSvi:c:C:m:M:RJT:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "+pPsSvi:c:C:m:M:RJT:x:0:1:2:")) != -1) {
 		switch (opt) {
 		case 'p':
 			show_core_only++;
@@ -2627,6 +2650,11 @@ void cmdline(int argc, char **argv)
 			if (do_pcu_group < 0 || do_pcu_group > 5)
 				usage();
 			break;
+		case '0':
+		case '1':
+		case '2':
+			sscanf(optarg, "%d", &freq_band[opt - '0']);
+			break;
 
 		default:
 			usage();
-- 
1.9.3

