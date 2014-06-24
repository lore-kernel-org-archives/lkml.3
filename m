Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaFXMnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:43:13 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:50295 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaFXMnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:43:12 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tools: power: cpupower: bench: parse.c:  Fix several minor errors
Date: Tue, 24 Jun 2014 14:44:07 +0200
Message-Id: <1403613847-14171-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resolved several minor errors in prepare_config() and made some additional improvements.
Earlier, the risk of file stream that was not closed. Misuse of strncpy, and the use of strncmp with strlen that makes it pointless.
I also check that sscanf has been successful, otherwise continue to the next line. And minimized the use of magic numbers.

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/power/cpupower/bench/parse.c |   39 +++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/tools/power/cpupower/bench/parse.c b/tools/power/cpupower/bench/parse.c
index 543bba1..f503fb5 100644
--- a/tools/power/cpupower/bench/parse.c
+++ b/tools/power/cpupower/bench/parse.c
@@ -158,14 +158,15 @@ struct config *prepare_default_config()
 int prepare_config(const char *path, struct config *config)
 {
 	size_t len = 0;
-	char *opt, *val, *line = NULL;
-	FILE *configfile = fopen(path, "r");
+	char opt[16], val[32], *line = NULL;
+	FILE *configfile;
 
 	if (config == NULL) {
 		fprintf(stderr, "error: config is NULL\n");
 		return 1;
 	}
 
+	configfile = fopen(path, "r");
 	if (configfile == NULL) {
 		perror("fopen");
 		fprintf(stderr, "error: unable to read configfile\n");
@@ -174,52 +175,54 @@ int prepare_config(const char *path, struct config *config)
 	}
 
 	while (getline(&line, &len, configfile) != -1) {
-		if (line[0] == '#' || line[0] == ' ')
+		if (line[0] == '#' || line[0] == ' ' || line[0] == '\n')
 			continue;
 
-		sscanf(line, "%as = %as", &opt, &val);
+		if (sscanf(line, "%14s = %30s", opt, val) < 2)
+			continue;
 
 		dprintf("parsing: %s -> %s\n", opt, val);
 
-		if (strncmp("sleep", opt, strlen(opt)) == 0)
+		if (strcmp("sleep", opt) == 0)
 			sscanf(val, "%li", &config->sleep);
 
-		else if (strncmp("load", opt, strlen(opt)) == 0)
+		else if (strcmp("load", opt) == 0)
 			sscanf(val, "%li", &config->load);
 
-		else if (strncmp("load_step", opt, strlen(opt)) == 0)
+		else if (strcmp("load_step", opt) == 0)
 			sscanf(val, "%li", &config->load_step);
 
-		else if (strncmp("sleep_step", opt, strlen(opt)) == 0)
+		else if (strcmp("sleep_step", opt) == 0)
 			sscanf(val, "%li", &config->sleep_step);
 
-		else if (strncmp("cycles", opt, strlen(opt)) == 0)
+		else if (strcmp("cycles", opt) == 0)
 			sscanf(val, "%u", &config->cycles);
 
-		else if (strncmp("rounds", opt, strlen(opt)) == 0)
+		else if (strcmp("rounds", opt) == 0)
 			sscanf(val, "%u", &config->rounds);
 
-		else if (strncmp("verbose", opt, strlen(opt)) == 0)
+		else if (strcmp("verbose", opt) == 0)
 			sscanf(val, "%u", &config->verbose);
 
-		else if (strncmp("output", opt, strlen(opt)) == 0)
+		else if (strcmp("output", opt) == 0)
 			config->output = prepare_output(val); 
 
-		else if (strncmp("cpu", opt, strlen(opt)) == 0)
+		else if (strcmp("cpu", opt) == 0)
 			sscanf(val, "%u", &config->cpu);
 
-		else if (strncmp("governor", opt, 14) == 0)
-			strncpy(config->governor, val, 14);
+		else if (strcmp("governor", opt) == 0) {
+			strncpy(config->governor, val,
+					sizeof(config->governor));
+			config->governor[sizeof(config->governor) - 1] = '\0';
+		}
 
-		else if (strncmp("priority", opt, strlen(opt)) == 0) {
+		else if (strcmp("priority", opt) == 0) {
 			if (string_to_prio(val) != SCHED_ERR)
 				config->prio = string_to_prio(val);
 		}
 	}
 
 	free(line);
-	free(opt);
-	free(val);
 
 	return 0;
 }
-- 
1.7.10.4

