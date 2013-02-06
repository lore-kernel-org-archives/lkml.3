Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab3BFV7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:59:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37162 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964794Ab3BFV7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:59:42 -0500
Date: Wed, 6 Feb 2013 13:58:53 -0800
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-341487ab561f3937a5283dd77c5660b1ee3b1f9e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
In-Reply-To: <1359873501-24541-1-git-send-email-feng.tang@intel.com>
References: <1359873501-24541-1-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser:
  Add option for runtime switching perf data file
Git-Commit-ID: 341487ab561f3937a5283dd77c5660b1ee3b1f9e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 13:58:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  341487ab561f3937a5283dd77c5660b1ee3b1f9e
Gitweb:     http://git.kernel.org/tip/341487ab561f3937a5283dd77c5660b1ee3b1f9e
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Sun, 3 Feb 2013 14:38:20 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 6 Feb 2013 18:09:24 -0300

perf hists browser: Add option for runtime switching perf data file

Based on perf report/top/scripts browser integration idea from acme.

This will enable user to runtime switch the data file, when this option
is selected, it will popup all the legal data files in current working
directory, and the filename selected by user is saved in the global
variable "input_name", and a new key 'K_SWITCH_INPUT_DATA' will be
passed back to the built-in command which will perform the switch.

This initial version only enables it for 'perf report'.

v2: rebase to latest 'perf/core' branch (6e1d4dd) of acme's perf tree

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1359873501-24541-1-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 112 ++++++++++++++++++++++++++++++++++++++++-
 tools/perf/ui/keysyms.h        |   1 +
 2 files changed, 112 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 20ccd57..aa22704 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1241,6 +1241,96 @@ static inline bool is_report_browser(void *timer)
 	return timer == NULL;
 }
 
+/*
+ * Only runtime switching of perf data file will make "input_name" point
+ * to a malloced buffer. So add "is_input_name_malloced" flag to decide
+ * whether we need to call free() for current "input_name" during the switch.
+ */
+static bool is_input_name_malloced = false;
+
+static int switch_data_file(void)
+{
+	char *pwd, *options[32], *abs_path[32], *tmp;
+	DIR *pwd_dir;
+	int nr_options = 0, choice = -1, ret = -1;
+	struct dirent *dent;
+
+	pwd = getenv("PWD");
+	if (!pwd)
+		return ret;
+
+	pwd_dir = opendir(pwd);
+	if (!pwd_dir)
+		return ret;
+
+	memset(options, 0, sizeof(options));
+	memset(options, 0, sizeof(abs_path));
+
+	while ((dent = readdir(pwd_dir))) {
+		char path[PATH_MAX];
+		u64 magic;
+		char *name = dent->d_name;
+		FILE *file;
+
+		if (!(dent->d_type == DT_REG))
+			continue;
+
+		snprintf(path, sizeof(path), "%s/%s", pwd, name);
+
+		file = fopen(path, "r");
+		if (!file)
+			continue;
+
+		if (fread(&magic, 1, 8, file) < 8)
+			goto close_file_and_continue;
+
+		if (is_perf_magic(magic)) {
+			options[nr_options] = strdup(name);
+			if (!options[nr_options])
+				goto close_file_and_continue;
+
+			abs_path[nr_options] = strdup(path);
+			if (!abs_path[nr_options]) {
+				free(options[nr_options]);
+				ui__warning("Can't search all data files due to memory shortage.\n");
+				fclose(file);
+				break;
+			}
+
+			nr_options++;
+		}
+
+close_file_and_continue:
+		fclose(file);
+		if (nr_options >= 32) {
+			ui__warning("Too many perf data files in PWD!\n"
+				    "Only the first 32 files will be listed.\n");
+			break;
+		}
+	}
+	closedir(pwd_dir);
+
+	if (nr_options) {
+		choice = ui__popup_menu(nr_options, options);
+		if (choice < nr_options && choice >= 0) {
+			tmp = strdup(abs_path[choice]);
+			if (tmp) {
+				if (is_input_name_malloced)
+					free((void *)input_name);
+				input_name = tmp;
+				is_input_name_malloced = true;
+				ret = 0;
+			} else
+				ui__warning("Data switch failed due to memory shortage!\n");
+		}
+	}
+
+	free_popup_options(options, nr_options);
+	free_popup_options(abs_path, nr_options);
+	return ret;
+}
+
+
 static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 				    const char *helpline, const char *ev_name,
 				    bool left_exits,
@@ -1275,7 +1365,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		int choice = 0,
 		    annotate = -2, zoom_dso = -2, zoom_thread = -2,
 		    annotate_f = -2, annotate_t = -2, browse_map = -2;
-		int scripts_comm = -2, scripts_symbol = -2, scripts_all = -2;
+		int scripts_comm = -2, scripts_symbol = -2,
+		    scripts_all = -2, switch_data = -2;
 
 		nr_options = 0;
 
@@ -1332,6 +1423,10 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			if (is_report_browser(hbt))
 				goto do_scripts;
 			continue;
+		case 's':
+			if (is_report_browser(hbt))
+				goto do_data_switch;
+			continue;
 		case K_F1:
 		case 'h':
 		case '?':
@@ -1351,6 +1446,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					"d             Zoom into current DSO\n"
 					"t             Zoom into current Thread\n"
 					"r             Run available scripts('perf report' only)\n"
+					"s             Switch to another data file in PWD ('perf report' only)\n"
 					"P             Print histograms to perf.hist.N\n"
 					"V             Verbose (DSO names in callchains, etc)\n"
 					"/             Filter symbol by name");
@@ -1458,6 +1554,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		if (asprintf(&options[nr_options], "Run scripts for all samples") > 0)
 			scripts_all = nr_options++;
 
+		if (is_report_browser(hbt) && asprintf(&options[nr_options],
+				"Switch to another data file in PWD") > 0)
+			switch_data = nr_options++;
 add_exit_option:
 		options[nr_options++] = (char *)"Exit";
 retry_popup_menu:
@@ -1568,6 +1667,16 @@ do_scripts:
 
 			script_browse(script_opt);
 		}
+		/* Switch to another data file */
+		else if (choice == switch_data) {
+do_data_switch:
+			if (!switch_data_file()) {
+				key = K_SWITCH_INPUT_DATA;
+				break;
+			} else
+				ui__warning("Won't switch the data files due to\n"
+					"no valid data file get selected!\n");
+		}
 	}
 out_free_stack:
 	pstack__delete(fstack);
@@ -1694,6 +1803,7 @@ browse_hists:
 						"Do you really want to exit?"))
 					continue;
 				/* Fall thru */
+			case K_SWITCH_INPUT_DATA:
 			case 'q':
 			case CTRL('c'):
 				goto out;
diff --git a/tools/perf/ui/keysyms.h b/tools/perf/ui/keysyms.h
index 809eca5..65092d5 100644
--- a/tools/perf/ui/keysyms.h
+++ b/tools/perf/ui/keysyms.h
@@ -23,5 +23,6 @@
 #define K_TIMER	 -1
 #define K_ERROR	 -2
 #define K_RESIZE -3
+#define K_SWITCH_INPUT_DATA -4
 
 #endif /* _PERF_KEYSYMS_H_ */
