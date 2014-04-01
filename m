Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaDALSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:18:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42691 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaDALSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Hunt <joshhunt00@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 119/144] printk: fix syslog() overflowing user buffer
Date: Tue,  1 Apr 2014 12:15:23 +0100
Message-Id: <1396350948-29910-120-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit e4178d809fdaee32a56833fff1f5056c99e90a1a upstream.

This is not a buffer overflow in the traditional sense: we don't
overflow any *kernel* buffers, but we do mis-count the amount of data we
copy back to user space for the SYSLOG_ACTION_READ_ALL case.

In particular, if the user buffer is too small to hold everything, and
*if* there is a continuation line at just the right place, we can end up
giving the user more data than he asked for.

The reason is that we first count up the number of bytes all the log
records contains, then we walk the records again until we've skipped the
records at the beginning that won't fit, and then we walk the rest of
the records and copy them to the user space buffer.

And in between that "skip the initial records that won't fit" and the
"copy the records that *will* fit to user space", we reset the 'prev'
variable that contained the record information for the last record not
copied.  That meant that when we started copying to user space, we now
had a different character count than what we had originally calculated
in the first record walk-through.

The fix is to simply not clear the 'prev' flags value (in both cases
where we had the same logic: syslog_print_all and kmsg_dump_get_buffer:
the latter is used for pstore-like dumping)

Reported-and-tested-by: Debabrata Banerjee <dbanerje@akamai.com>
Acked-by: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Hunt <joshhunt00@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/printk/printk.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 5b5a708..41832ed 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1080,7 +1080,6 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		next_seq = log_next_seq;
 
 		len = 0;
-		prev = 0;
 		while (len >= 0 && seq < next_seq) {
 			struct printk_log *msg = log_from_idx(idx);
 			int textlen;
@@ -2783,7 +2782,6 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	next_idx = idx;
 
 	l = 0;
-	prev = 0;
 	while (seq < dumper->next_seq) {
 		struct printk_log *msg = log_from_idx(idx);
 
-- 
1.9.1

