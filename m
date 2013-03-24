Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3CXJTC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 05:19:02 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64294 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab3CXJSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 05:18:07 -0400
Message-ID: <514EC323.7050002@gmail.com>
Date: Sun, 24 Mar 2013 10:10:59 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [RFC] fsfreeze: moving from uniterruptible to killable
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a fs is frozen, a process can hang because we wait in
uniterruptible state. We give the user the possibility to kill the process.

Not-signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

--- fs/super.c.orig	2013-03-24 09:56:33.000000000 +0100
+++ fs/super.c	2013-03-24 09:58:41.000000000 +0100
@@ -1198,7 +1198,7 @@ retry:
 	if (unlikely(sb->s_writers.frozen >= level)) {
 		if (!wait)
 			return 0;
-		wait_event(sb->s_writers.wait_unfrozen,
+		wait_event_killable(sb->s_writers.wait_unfrozen,
 			   sb->s_writers.frozen < level);
 	}
 
@@ -1248,7 +1248,7 @@ static void sb_wait_write(struct super_b
 		 * of frozen and checking of the counter
 		 */
 		prepare_to_wait(&sb->s_writers.wait, &wait,
-				TASK_UNINTERRUPTIBLE);
+				 TASK_KILLABLE);
 
 		writers = percpu_counter_sum(&sb->s_writers.counter[level-1]);
 		if (writers)
