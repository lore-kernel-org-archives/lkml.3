Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3JNOKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:10:31 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:58873 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3JNOK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:10:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@infradead.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] kernel-doc: improve "no structured comments found" error
Date: Mon, 14 Oct 2013 16:10:22 +0200
Message-Id: <1381759822-1218-1-git-send-email-johannes@sipsolutions.net>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

When using '!Ffile function' in a docbook template, and the function
no longer exists, you get a "no structured comments found" error from
the kernel-doc processing script. It's useful to know which functions
it was looking for, so print them out in this case. Also do the same
for '!Pfile doc-section'

The same error also happens when using '!Efile' when some exported
functions aren't documented (in the same file.) There's a very large
number of such functions though, so don't print the message in this
case -- right now it would give ~850 messages.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Just needed this patch again, Rob previously said he had no objection
but also didn't want to merge the patch.

Andrew, I'm thus sending it to you as a last resort. If you know a
better maintainer, I'm all ears.
---
 scripts/docproc.c  | 14 +++++++++-----
 scripts/kernel-doc |  6 ++++++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/scripts/docproc.c b/scripts/docproc.c
index 4cfdc17..2b69eaf 100644
--- a/scripts/docproc.c
+++ b/scripts/docproc.c
@@ -72,6 +72,7 @@ FILELINE * docsection;
 #define FUNCTION      "-function"
 #define NOFUNCTION    "-nofunction"
 #define NODOCSECTIONS "-no-doc-sections"
+#define SHOWNOTFOUND  "-show-not-found"
 
 static char *srctree, *kernsrctree;
 
@@ -294,6 +295,7 @@ static void singfunc(char * filename, char * line)
         int startofsym = 1;
 	vec[idx++] = KERNELDOC;
 	vec[idx++] = DOCBOOK;
+	vec[idx++] = SHOWNOTFOUND;
 
         /* Split line up in individual parameters preceded by FUNCTION */
         for (i=0; line[i]; i++) {
@@ -325,7 +327,8 @@ static void singfunc(char * filename, char * line)
  */
 static void docsect(char *filename, char *line)
 {
-	char *vec[6]; /* kerneldoc -docbook -function "section" file NULL */
+	/* kerneldoc -docbook -show-not-found -function "section" file NULL */
+	char *vec[7];
 	char *s;
 
 	for (s = line; *s; s++)
@@ -341,10 +344,11 @@ static void docsect(char *filename, char *line)
 
 	vec[0] = KERNELDOC;
 	vec[1] = DOCBOOK;
-	vec[2] = FUNCTION;
-	vec[3] = line;
-	vec[4] = filename;
-	vec[5] = NULL;
+	vec[2] = SHOWNOTFOUND;
+	vec[3] = FUNCTION;
+	vec[4] = line;
+	vec[5] = filename;
+	vec[6] = NULL;
 	exec_kernel_doc(vec);
 }
 
diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 4305b2f..dbd3e1e 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -257,6 +257,7 @@ my $man_date = ('January', 'February', 'March', 'April', 'May', 'June',
 		'July', 'August', 'September', 'October',
 		'November', 'December')[(localtime)[4]] .
   " " . ((localtime)[5]+1900);
+my $show_not_found = 0;
 
 # Essentially these are globals.
 # They probably want to be tidied up, made more localised or something.
@@ -369,6 +370,8 @@ while ($ARGV[0] =~ m/^-(.*)/) {
 	usage();
     } elsif ($cmd eq '-no-doc-sections') {
 	    $no_doc_sections = 1;
+    } elsif ($cmd eq '-show-not-found') {
+	$show_not_found = 1;
     }
 }
 
@@ -2536,6 +2539,9 @@ sub process_file($) {
     }
     if ($initial_section_counter == $section_counter) {
 	print STDERR "Warning(${file}): no structured comments found\n";
+	if (($function_only == 1) && ($show_not_found == 1)) {
+	    print STDERR "    Was looking for '$_'.\n" for keys %function_table;
+	}
 	if ($output_mode eq "xml") {
 	    # The template wants at least one RefEntry here; make one.
 	    print "<refentry>\n";
-- 
1.8.4.rc3

