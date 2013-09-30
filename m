Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab3I3KN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:13:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43871 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab3I3KNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Santos <daniel.santos@pobox.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 104/104] kernel-doc: bugfix - multi-line macros
Date: Mon, 30 Sep 2013 11:11:21 +0100
Message-Id: <1380535881-9239-105-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Santos <daniel.santos@pobox.com>

commit 654784284430bf2739985914b65e09c7c35a7273 upstream.

Prior to this patch the following code breaks:

/**
 * multiline_example - this breaks kernel-doc
 */
 #define multiline_example( \
myparam)

Producing this error:

Error(somefile.h:983): cannot understand prototype: 'multiline_example( \ '

This patch fixes the issue by appending all lines ending in a blackslash
(optionally followed by whitespace), removing the backslash and any
whitespace after it prior to appending (just like the C pre-processor
would).

This fixes a break in kerel-doc introduced by the additions to rbtree.h.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 scripts/kernel-doc | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 9b0c0b8..55ab5e4 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -2045,6 +2045,9 @@ sub process_file($) {
 
     $section_counter = 0;
     while (<IN>) {
+	while (s/\\\s*$//) {
+	    $_ .= <IN>;
+	}
 	if ($state == 0) {
 	    if (/$doc_start/o) {
 		$state = 1;		# next line is always the function name
-- 
1.8.3.2

