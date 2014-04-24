Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbaDXNnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:43:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbaDXNnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:43:35 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCH] cpupower, add option to display frequencies and latencies without rounding off values
Date: Thu, 24 Apr 2014 09:43:23 -0400
Message-Id: <1398347003-18322-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The command "cpupower frequency-info" can be used when using cpupower to
monitor and test processor behaviour to determine if the processor is
behaving as expected.  This data can be compared to the output of
/proc/cpuinfo or the output of
/sys/devices/system/cpu/cpuX/cpufreq/scaling_available_frequencies
to determine if the cpu is in an expected state.

When doing this I noticed comparison test failures due to the way the
data is displayed in cpupower.  For example,

[root@intel-s3e37-02 cpupower]# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
2262000 2261000 2128000 1995000 1862000 1729000 1596000 1463000 1330000
1197000 1064000

compared to

[root@intel-s3e37-02 cpupower]# cpupower frequency-info
analyzing CPU 0:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0
  CPUs which need to have their frequency coordinated by software: 0
  maximum transition latency: 10.0 us.
  hardware limits: 1.06 GHz - 2.26 GHz
  available frequency steps: 2.26 GHz, 2.26 GHz, 2.13 GHz, 2.00 GHz, 1.86 GHz, 1.73 GHz, 1.60 GHz, 1.46 GHz, 1.33 GHz, 1.20 GHz, 1.06 GHz
  available cpufreq governors: conservative, userspace, powersave, ondemand, performance
  current policy: frequency should be within 1.06 GHz and 2.26 GHz.
                  The governor "performance" may decide which speed to use
                  within this range.
  current CPU frequency is 2.26 GHz (asserted by call to hardware).
  boost state support:
    Supported: yes
    Active: yes

shows very different values for the available frequency steps.  The cpupower
output rounds off values at 2 decimal points and this causes problems with
test scripts.  For example, with the data above,

1.064 is 1.06
1.197 is 1.20
1.596 is 1.60
1.995 is 2.00
2.128 is 2.13

and most confusingly,

2.261 is 2.26
2.262 is 2.26

Truncating these values serves no real purpose other than making the output
pretty.  Since the default has been to round off these values I am adding
a -n/--no-rounding option to the cpupower utility that will display the
data without rounding off the still significant digits.

After patch,

analyzing CPU 0:
  driver: acpi-cpufreq
  CPUs which run at the same hardware frequency: 0
  CPUs which need to have their frequency coordinated by software: 0
  maximum transition latency: 10.000 us.
  hardware limits: 1.064000 GHz - 2.262000 GHz
  available frequency steps: 2.262000 GHz, 2.261000 GHz, 2.128000 GHz, 1.995000 GHz, 1.862000 GHz, 1.729000 GHz, 1.596000 GHz, 1.463000 GHz, 1.330000 GHz, 1.197000 GHz, 1.064000 GHz
  available cpufreq governors: conservative, userspace, powersave, ondemand, performance
  current policy: frequency should be within 1.064000 GHz and 2.262000 GHz.
                  The governor "performance" may decide which speed to use
                  within this range.
  current CPU frequency is 2.262000 GHz (asserted by call to hardware).
  boost state support:
    Supported: yes
    Active: yes

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 tools/power/cpupower/man/cpupower-frequency-info.1 |    3 +
 tools/power/cpupower/utils/cpufreq-info.c          |  110 +++++++++++++-------
 2 files changed, 73 insertions(+), 40 deletions(-)

diff --git a/tools/power/cpupower/man/cpupower-frequency-info.1 b/tools/power/cpupower/man/cpupower-frequency-info.1
index 4a1918e..9c85a38 100644
--- a/tools/power/cpupower/man/cpupower-frequency-info.1
+++ b/tools/power/cpupower/man/cpupower-frequency-info.1
@@ -50,6 +50,9 @@ Prints out information like provided by the /proc/cpufreq interface in 2.4. and
 \fB\-m\fR \fB\-\-human\fR
 human\-readable output for the \-f, \-w, \-s and \-y parameters.
 .TP  
+\fB\-n\fR \fB\-\-no-rounding\fR
+Output frequencies and latencies without rounding off values.
+.TP  
 .SH "REMARKS"
 .LP 
 By default only values of core zero are displayed. How to display settings of
diff --git a/tools/power/cpupower/utils/cpufreq-info.c b/tools/power/cpupower/utils/cpufreq-info.c
index 28953c9..b4b90a9 100644
--- a/tools/power/cpupower/utils/cpufreq-info.c
+++ b/tools/power/cpupower/utils/cpufreq-info.c
@@ -82,29 +82,42 @@ static void proc_cpufreq_output(void)
 	}
 }
 
+static int no_rounding;
 static void print_speed(unsigned long speed)
 {
 	unsigned long tmp;
 
-	if (speed > 1000000) {
-		tmp = speed % 10000;
-		if (tmp >= 5000)
-			speed += 10000;
-		printf("%u.%02u GHz", ((unsigned int) speed/1000000),
-			((unsigned int) (speed%1000000)/10000));
-	} else if (speed > 100000) {
-		tmp = speed % 1000;
-		if (tmp >= 500)
-			speed += 1000;
-		printf("%u MHz", ((unsigned int) speed / 1000));
-	} else if (speed > 1000) {
-		tmp = speed % 100;
-		if (tmp >= 50)
-			speed += 100;
-		printf("%u.%01u MHz", ((unsigned int) speed/1000),
-			((unsigned int) (speed%1000)/100));
-	} else
-		printf("%lu kHz", speed);
+	if (no_rounding) {
+		if (speed > 1000000)
+			printf("%u.%06u GHz", ((unsigned int) speed/1000000),
+				((unsigned int) speed%1000000));
+		else if (speed > 100000)
+			printf("%u MHz", (unsigned int) speed);
+		else if (speed > 1000)
+			printf("%u.%03u MHz", ((unsigned int) speed/1000),
+				(unsigned int) (speed%1000));
+		else
+			printf("%lu kHz", speed);
+	} else {
+		if (speed > 1000000) {
+			tmp = speed%10000;
+			if (tmp >= 5000)
+				speed += 10000;
+			printf("%u.%02u GHz", ((unsigned int) speed/1000000),
+				((unsigned int) (speed%1000000)/10000));
+		} else if (speed > 100000) {
+			tmp = speed%1000;
+			if (tmp >= 500)
+				speed += 1000;
+			printf("%u MHz", ((unsigned int) speed/1000));
+		} else if (speed > 1000) {
+			tmp = speed%100;
+			if (tmp >= 50)
+				speed += 100;
+			printf("%u.%01u MHz", ((unsigned int) speed/1000),
+				((unsigned int) (speed%1000)/100));
+		}
+	}
 
 	return;
 }
@@ -113,26 +126,38 @@ static void print_duration(unsigned long duration)
 {
 	unsigned long tmp;
 
-	if (duration > 1000000) {
-		tmp = duration % 10000;
-		if (tmp >= 5000)
-			duration += 10000;
-		printf("%u.%02u ms", ((unsigned int) duration/1000000),
-			((unsigned int) (duration%1000000)/10000));
-	} else if (duration > 100000) {
-		tmp = duration % 1000;
-		if (tmp >= 500)
-			duration += 1000;
-		printf("%u us", ((unsigned int) duration / 1000));
-	} else if (duration > 1000) {
-		tmp = duration % 100;
-		if (tmp >= 50)
-			duration += 100;
-		printf("%u.%01u us", ((unsigned int) duration/1000),
-			((unsigned int) (duration%1000)/100));
-	} else
-		printf("%lu ns", duration);
-
+	if (no_rounding) {
+		if (duration > 1000000)
+			printf("%u.%06u ms", ((unsigned int) duration/1000000),
+				((unsigned int) duration%1000000));
+		else if (duration > 100000)
+			printf("%u us", ((unsigned int) duration/1000));
+		else if (duration > 1000)
+			printf("%u.%03u us", ((unsigned int) duration/1000),
+				((unsigned int) duration%1000));
+		else
+			printf("%lu ns", duration);
+	} else {
+		if (duration > 1000000) {
+			tmp = duration%10000;
+			if (tmp >= 5000)
+				duration += 10000;
+			printf("%u.%02u ms", ((unsigned int) duration/1000000),
+				((unsigned int) (duration%1000000)/10000));
+		} else if (duration > 100000) {
+			tmp = duration%1000;
+			if (tmp >= 500)
+				duration += 1000;
+			printf("%u us", ((unsigned int) duration / 1000));
+		} else if (duration > 1000) {
+			tmp = duration%100;
+			if (tmp >= 50)
+				duration += 100;
+			printf("%u.%01u us", ((unsigned int) duration/1000),
+				((unsigned int) (duration%1000)/100));
+		} else
+			printf("%lu ns", duration);
+	}
 	return;
 }
 
@@ -525,6 +550,7 @@ static struct option info_opts[] = {
 	{ .name = "latency",	.has_arg = no_argument,		.flag = NULL,	.val = 'y'},
 	{ .name = "proc",	.has_arg = no_argument,		.flag = NULL,	.val = 'o'},
 	{ .name = "human",	.has_arg = no_argument,		.flag = NULL,	.val = 'm'},
+	{ .name = "no-rounding", .has_arg = no_argument,	.flag = NULL,	.val = 'n'},
 	{ },
 };
 
@@ -538,7 +564,8 @@ int cmd_freq_info(int argc, char **argv)
 	int output_param = 0;
 
 	do {
-		ret = getopt_long(argc, argv, "oefwldpgrasmyb", info_opts, NULL);
+		ret = getopt_long(argc, argv, "oefwldpgrasmybn", info_opts,
+				  NULL);
 		switch (ret) {
 		case '?':
 			output_param = '?';
@@ -575,6 +602,9 @@ int cmd_freq_info(int argc, char **argv)
 			}
 			human = 1;
 			break;
+		case 'n':
+			no_rounding = 1;
+			break;
 		default:
 			fprintf(stderr, "invalid or unknown argument\n");
 			return EXIT_FAILURE;
-- 
1.7.9.3

