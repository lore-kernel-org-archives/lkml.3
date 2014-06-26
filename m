Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964794AbaFZQLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:11:39 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:45392 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932289AbaFZQLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:11:35 -0400
X-Yandex-Uniq: 826b74e1-ebbf-489a-ac74-396b058dfdef
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, stfomichev@yandex-team.ru, namhyung@kernel.org,
        artagnon@gmail.com, jolsa@redhat.com, bp@suse.de,
        rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] perf timechart: fix rendering in Firefox
Date: Thu, 26 Jun 2014 20:11:08 +0400
Message-Id: <1403799071-1252-2-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403799071-1252-1-git-send-email-stfomichev@yandex-team.ru>
References: <1403799071-1252-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firefox doesn't correctly handle cases where we specify number in
quotes and have some padding around the number, like the following:
<rect ... height=" 3.1" ...>
In this case, it doesn't draw the figure. This patch removes 'field width'
component from fprintf strings to fix it.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/util/svghelper.c | 72 ++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 6a0a13d07a28..27caf0f45469 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -137,7 +137,7 @@ void svg_box(int Yslot, u64 start, u64 end, const char *type)
 	if (!svgfile)
 		return;
 
-	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
+	fprintf(svgfile, "<rect x=\"%.8f\" width=\"%.8f\" y=\"%.1f\" height=\"%.1f\" class=\"%s\"/>\n",
 		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT, type);
 }
 
@@ -174,7 +174,7 @@ void svg_running(int Yslot, int cpu, u64 start, u64 end, const char *backtrace)
 		cpu, time_to_string(end - start));
 	if (backtrace)
 		fprintf(svgfile, "<desc>Switched because:\n%s</desc>\n", backtrace);
-	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
+	fprintf(svgfile, "<rect x=\"%.8f\" width=\"%.8f\" y=\"%.1f\" height=\"%.1f\" class=\"%s\"/>\n",
 		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT,
 		type);
 
@@ -186,7 +186,7 @@ void svg_running(int Yslot, int cpu, u64 start, u64 end, const char *backtrace)
 	text_size = round_text_size(text_size);
 
 	if (text_size > MIN_TEXT_SIZE)
-		fprintf(svgfile, "<text x=\"%1.8f\" y=\"%1.8f\" font-size=\"%1.8fpt\">%i</text>\n",
+		fprintf(svgfile, "<text x=\"%.8f\" y=\"%.8f\" font-size=\"%.8fpt\">%i</text>\n",
 			time2pixels(start), Yslot *  SLOT_MULT + SLOT_HEIGHT - 1, text_size,  cpu + 1);
 
 	fprintf(svgfile, "</g>\n");
@@ -202,10 +202,10 @@ static char *time_to_string(u64 duration)
 		return text;
 
 	if (duration < 1000 * 1000) { /* less than 1 msec */
-		sprintf(text, "%4.1f us", duration / 1000.0);
+		sprintf(text, "%.1f us", duration / 1000.0);
 		return text;
 	}
-	sprintf(text, "%4.1f ms", duration / 1000.0 / 1000);
+	sprintf(text, "%.1f ms", duration / 1000.0 / 1000);
 
 	return text;
 }
@@ -233,14 +233,14 @@ void svg_waiting(int Yslot, int cpu, u64 start, u64 end, const char *backtrace)
 
 	font_size = round_text_size(font_size);
 
-	fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\">\n", time2pixels(start), Yslot * SLOT_MULT);
+	fprintf(svgfile, "<g transform=\"translate(%.8f,%.8f)\">\n", time2pixels(start), Yslot * SLOT_MULT);
 	fprintf(svgfile, "<title>#%d waiting %s</title>\n", cpu, time_to_string(end - start));
 	if (backtrace)
 		fprintf(svgfile, "<desc>Waiting on:\n%s</desc>\n", backtrace);
-	fprintf(svgfile, "<rect x=\"0\" width=\"%4.8f\" y=\"0\" height=\"%4.1f\" class=\"%s\"/>\n",
+	fprintf(svgfile, "<rect x=\"0\" width=\"%.8f\" y=\"0\" height=\"%.1f\" class=\"%s\"/>\n",
 		time2pixels(end)-time2pixels(start), SLOT_HEIGHT, style);
 	if (font_size > MIN_TEXT_SIZE)
-		fprintf(svgfile, "<text transform=\"rotate(90)\" font-size=\"%1.8fpt\"> %s</text>\n",
+		fprintf(svgfile, "<text transform=\"rotate(90)\" font-size=\"%.8fpt\"> %s</text>\n",
 			font_size, text);
 	fprintf(svgfile, "</g>\n");
 }
@@ -289,16 +289,16 @@ void svg_cpu_box(int cpu, u64 __max_freq, u64 __turbo_freq)
 
 	fprintf(svgfile, "<g>\n");
 
-	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"cpu\"/>\n",
+	fprintf(svgfile, "<rect x=\"%.8f\" width=\"%.8f\" y=\"%.1f\" height=\"%.1f\" class=\"cpu\"/>\n",
 		time2pixels(first_time),
 		time2pixels(last_time)-time2pixels(first_time),
 		cpu2y(cpu), SLOT_MULT+SLOT_HEIGHT);
 
 	sprintf(cpu_string, "CPU %i", (int)cpu);
-	fprintf(svgfile, "<text x=\"%4.8f\" y=\"%4.8f\">%s</text>\n",
+	fprintf(svgfile, "<text x=\"%.8f\" y=\"%.8f\">%s</text>\n",
 		10+time2pixels(first_time), cpu2y(cpu) + SLOT_HEIGHT/2, cpu_string);
 
-	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\" font-size=\"1.25pt\">%s</text>\n",
+	fprintf(svgfile, "<text transform=\"translate(%.8f,%.8f)\" font-size=\"1.25pt\">%s</text>\n",
 		10+time2pixels(first_time), cpu2y(cpu) + SLOT_MULT + SLOT_HEIGHT - 4, cpu_model());
 
 	fprintf(svgfile, "</g>\n");
@@ -319,11 +319,11 @@ void svg_process(int cpu, u64 start, u64 end, int pid, const char *name, const c
 	else
 		type = "sample";
 
-	fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\">\n", time2pixels(start), cpu2y(cpu));
+	fprintf(svgfile, "<g transform=\"translate(%.8f,%.8f)\">\n", time2pixels(start), cpu2y(cpu));
 	fprintf(svgfile, "<title>%d %s running %s</title>\n", pid, name, time_to_string(end - start));
 	if (backtrace)
 		fprintf(svgfile, "<desc>Switched because:\n%s</desc>\n", backtrace);
-	fprintf(svgfile, "<rect x=\"0\" width=\"%4.8f\" y=\"0\" height=\"%4.1f\" class=\"%s\"/>\n",
+	fprintf(svgfile, "<rect x=\"0\" width=\"%.8f\" y=\"0\" height=\"%.1f\" class=\"%s\"/>\n",
 		time2pixels(end)-time2pixels(start), SLOT_MULT+SLOT_HEIGHT, type);
 	width = time2pixels(end)-time2pixels(start);
 	if (width > 6)
@@ -332,7 +332,7 @@ void svg_process(int cpu, u64 start, u64 end, int pid, const char *name, const c
 	width = round_text_size(width);
 
 	if (width > MIN_TEXT_SIZE)
-		fprintf(svgfile, "<text transform=\"rotate(90)\" font-size=\"%3.8fpt\">%s</text>\n",
+		fprintf(svgfile, "<text transform=\"rotate(90)\" font-size=\"%.8fpt\">%s</text>\n",
 			width, name);
 
 	fprintf(svgfile, "</g>\n");
@@ -353,7 +353,7 @@ void svg_cstate(int cpu, u64 start, u64 end, int type)
 		type = 6;
 	sprintf(style, "c%i", type);
 
-	fprintf(svgfile, "<rect class=\"%s\" x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\"/>\n",
+	fprintf(svgfile, "<rect class=\"%s\" x=\"%.8f\" width=\"%.8f\" y=\"%.1f\" height=\"%.1f\"/>\n",
 		style,
 		time2pixels(start), time2pixels(end)-time2pixels(start),
 		cpu2y(cpu), SLOT_MULT+SLOT_HEIGHT);
@@ -365,7 +365,7 @@ void svg_cstate(int cpu, u64 start, u64 end, int type)
 	width = round_text_size(width);
 
 	if (width > MIN_TEXT_SIZE)
-		fprintf(svgfile, "<text x=\"%4.8f\" y=\"%4.8f\" font-size=\"%3.8fpt\">C%i</text>\n",
+		fprintf(svgfile, "<text x=\"%.8f\" y=\"%.8f\" font-size=\"%.8fpt\">C%i</text>\n",
 			time2pixels(start), cpu2y(cpu)+width, width, type);
 
 	fprintf(svgfile, "</g>\n");
@@ -407,9 +407,9 @@ void svg_pstate(int cpu, u64 start, u64 end, u64 freq)
 	if (max_freq)
 		height = freq * 1.0 / max_freq * (SLOT_HEIGHT + SLOT_MULT);
 	height = 1 + cpu2y(cpu) + SLOT_MULT + SLOT_HEIGHT - height;
-	fprintf(svgfile, "<line x1=\"%4.8f\" x2=\"%4.8f\" y1=\"%4.1f\" y2=\"%4.1f\" class=\"pstate\"/>\n",
+	fprintf(svgfile, "<line x1=\"%.8f\" x2=\"%.8f\" y1=\"%.1f\" y2=\"%.1f\" class=\"pstate\"/>\n",
 		time2pixels(start), time2pixels(end), height, height);
-	fprintf(svgfile, "<text x=\"%4.8f\" y=\"%4.8f\" font-size=\"0.25pt\">%s</text>\n",
+	fprintf(svgfile, "<text x=\"%.8f\" y=\"%.8f\" font-size=\"0.25pt\">%s</text>\n",
 		time2pixels(start), height+0.9, HzToHuman(freq));
 
 	fprintf(svgfile, "</g>\n");
@@ -435,32 +435,32 @@ void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc
 
 	if (row1 < row2) {
 		if (row1) {
-			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+			fprintf(svgfile, "<line x1=\"%.8f\" y1=\"%.2f\" x2=\"%.8f\" y2=\"%.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/32);
 			if (desc2)
-				fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &gt;</text></g>\n",
+				fprintf(svgfile, "<g transform=\"translate(%.8f,%.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &gt;</text></g>\n",
 					time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT + SLOT_HEIGHT/48, desc2);
 		}
 		if (row2) {
-			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+			fprintf(svgfile, "<line x1=\"%.8f\" y1=\"%.2f\" x2=\"%.8f\" y2=\"%.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row2 * SLOT_MULT - SLOT_MULT/32,  time2pixels(start), row2 * SLOT_MULT);
 			if (desc1)
-				fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &gt;</text></g>\n",
+				fprintf(svgfile, "<g transform=\"translate(%.8f,%.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &gt;</text></g>\n",
 					time2pixels(start), row2 * SLOT_MULT - SLOT_MULT/32, desc1);
 		}
 	} else {
 		if (row2) {
-			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+			fprintf(svgfile, "<line x1=\"%.8f\" y1=\"%.2f\" x2=\"%.8f\" y2=\"%.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/32);
 			if (desc1)
-				fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &lt;</text></g>\n",
+				fprintf(svgfile, "<g transform=\"translate(%.8f,%.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &lt;</text></g>\n",
 					time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/48, desc1);
 		}
 		if (row1) {
-			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+			fprintf(svgfile, "<line x1=\"%.8f\" y1=\"%.2f\" x2=\"%.8f\" y2=\"%.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 				time2pixels(start), row1 * SLOT_MULT - SLOT_MULT/32,  time2pixels(start), row1 * SLOT_MULT);
 			if (desc2)
-				fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &lt;</text></g>\n",
+				fprintf(svgfile, "<g transform=\"translate(%.8f,%.8f)\"><text transform=\"rotate(90)\" font-size=\"0.02pt\">%s &lt;</text></g>\n",
 					time2pixels(start), row1 * SLOT_MULT - SLOT_HEIGHT/32, desc2);
 		}
 	}
@@ -468,7 +468,7 @@ void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc
 	if (row2 > row1)
 		height += SLOT_HEIGHT;
 	if (row1)
-		fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(32,255,32)\"/>\n",
+		fprintf(svgfile, "<circle  cx=\"%.8f\" cy=\"%.2f\" r = \"0.01\"  style=\"fill:rgb(32,255,32)\"/>\n",
 			time2pixels(start), height);
 
 	fprintf(svgfile, "</g>\n");
@@ -488,16 +488,16 @@ void svg_wakeline(u64 start, int row1, int row2, const char *backtrace)
 		fprintf(svgfile, "<desc>%s</desc>\n", backtrace);
 
 	if (row1 < row2)
-		fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+		fprintf(svgfile, "<line x1=\"%.8f\" y1=\"%.2f\" x2=\"%.8f\" y2=\"%.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 			time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row2 * SLOT_MULT);
 	else
-		fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+		fprintf(svgfile, "<line x1=\"%.8f\" y1=\"%.2f\" x2=\"%.8f\" y2=\"%.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
 			time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row1 * SLOT_MULT);
 
 	height = row1 * SLOT_MULT;
 	if (row2 > row1)
 		height += SLOT_HEIGHT;
-	fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(32,255,32)\"/>\n",
+	fprintf(svgfile, "<circle  cx=\"%.8f\" cy=\"%.2f\" r = \"0.01\"  style=\"fill:rgb(32,255,32)\"/>\n",
 			time2pixels(start), height);
 
 	fprintf(svgfile, "</g>\n");
@@ -515,9 +515,9 @@ void svg_interrupt(u64 start, int row, const char *backtrace)
 	if (backtrace)
 		fprintf(svgfile, "<desc>%s</desc>\n", backtrace);
 
-	fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(255,128,128)\"/>\n",
+	fprintf(svgfile, "<circle  cx=\"%.8f\" cy=\"%.2f\" r = \"0.01\"  style=\"fill:rgb(255,128,128)\"/>\n",
 			time2pixels(start), row * SLOT_MULT);
-	fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(255,128,128)\"/>\n",
+	fprintf(svgfile, "<circle  cx=\"%.8f\" cy=\"%.2f\" r = \"0.01\"  style=\"fill:rgb(255,128,128)\"/>\n",
 			time2pixels(start), row * SLOT_MULT + SLOT_HEIGHT);
 
 	fprintf(svgfile, "</g>\n");
@@ -528,7 +528,7 @@ void svg_text(int Yslot, u64 start, const char *text)
 	if (!svgfile)
 		return;
 
-	fprintf(svgfile, "<text x=\"%4.8f\" y=\"%4.8f\">%s</text>\n",
+	fprintf(svgfile, "<text x=\"%.8f\" y=\"%.8f\">%s</text>\n",
 		time2pixels(start), Yslot * SLOT_MULT+SLOT_HEIGHT/2, text);
 }
 
@@ -537,9 +537,9 @@ static void svg_legenda_box(int X, const char *text, const char *style)
 	double boxsize;
 	boxsize = SLOT_HEIGHT / 2;
 
-	fprintf(svgfile, "<rect x=\"%i\" width=\"%4.8f\" y=\"0\" height=\"%4.1f\" class=\"%s\"/>\n",
+	fprintf(svgfile, "<rect x=\"%i\" width=\"%.8f\" y=\"0\" height=\"%.1f\" class=\"%s\"/>\n",
 		X, boxsize, boxsize, style);
-	fprintf(svgfile, "<text transform=\"translate(%4.8f, %4.8f)\" font-size=\"%4.8fpt\">%s</text>\n",
+	fprintf(svgfile, "<text transform=\"translate(%.8f, %.8f)\" font-size=\"%.8fpt\">%s</text>\n",
 		X + boxsize + 5, boxsize, 0.8 * boxsize, text);
 }
 
@@ -579,7 +579,7 @@ void svg_time_grid(void)
 			color = 128;
 		}
 
-		fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%" PRIu64 "\" style=\"stroke:rgb(%i,%i,%i);stroke-width:%1.3f\"/>\n",
+		fprintf(svgfile, "<line x1=\"%.8f\" y1=\"%.2f\" x2=\"%.8f\" y2=\"%" PRIu64 "\" style=\"stroke:rgb(%i,%i,%i);stroke-width:%.3f\"/>\n",
 			time2pixels(i), SLOT_MULT/2, time2pixels(i), total_height, color, color, color, thickness);
 
 		i += 10000000;
-- 
1.9.1

