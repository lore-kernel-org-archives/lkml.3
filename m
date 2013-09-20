Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab3ITQhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:37:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab3ITQhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:37:47 -0400
Date: Fri, 20 Sep 2013 12:37:33 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: oleg@redhat.com, roland@hack.frob.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: do_wait: Add missing tasklist unlocking in error paths.
Message-ID: <20130920163733.GA24958@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, oleg@redhat.com,
	roland@hack.frob.com,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like both 64a16caf5, and 98abed020 both introduced error paths to do_wait
where we miss unlocking the tasklist. 

Spotted with coverity.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/kernel/exit.c b/kernel/exit.c
index a949819..27004a6 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1526,13 +1526,15 @@ repeat:
 	tsk = current;
 	do {
 		retval = do_wait_thread(wo, tsk);
-		if (retval)
+		if (retval) {
+			read_unlock(&tasklist_lock);
 			goto end;
-
+		}
 		retval = ptrace_do_wait(wo, tsk);
-		if (retval)
+		if (retval) {
+			read_unlock(&tasklist_lock);
 			goto end;
-
+		}
 		if (wo->wo_flags & __WNOTHREAD)
 			break;
 	} while_each_thread(current, tsk);
