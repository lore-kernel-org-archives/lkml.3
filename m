Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3I2T2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:28:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab3I2T2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:28:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Chuck Anderson <chuck.anderson@oracle.com>,
        Dan Duval <dan.duval@oracle.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 40/49] audit: fix endless wait in audit_log_start()
Date: Sun, 29 Sep 2013 12:27:14 -0700
Message-Id: <20130929191605.721016878@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191603.008825488@linuxfoundation.org>
References: <20130929191603.008825488@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

commit 8ac1c8d5deba65513b6a82c35e89e73996c8e0d6 upstream.

After commit 829199197a43 ("kernel/audit.c: avoid negative sleep
durations") audit emitters will block forever if userspace daemon cannot
handle backlog.

After the timeout the waiting loop turns into busy loop and runs until
daemon dies or returns back to work.  This is a minimal patch for that
bug.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Chuck Anderson <chuck.anderson@oracle.com>
Cc: Dan Duval <dan.duval@oracle.com>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/audit.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1117,9 +1117,10 @@ struct audit_buffer *audit_log_start(str
 
 			sleep_time = timeout_start + audit_backlog_wait_time -
 					jiffies;
-			if ((long)sleep_time > 0)
+			if ((long)sleep_time > 0) {
 				wait_for_auditd(sleep_time);
-			continue;
+				continue;
+			}
 		}
 		if (audit_rate_check() && printk_ratelimit())
 			printk(KERN_WARNING


