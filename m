Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaBKTXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:23:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbaBKTIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3.10 71/79] timekeeping: Fix lost updates to tai adjustment
Date: Tue, 11 Feb 2014 11:06:15 -0800
Message-Id: <20140211184723.025144033@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
References: <20140211184720.928667275@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit f55c07607a38f84b5c7e6066ee1cfe433fa5643c upstream.

Since 48cdc135d4840 (Implement a shadow timekeeper), we have to
call timekeeping_update() after any adjustment to the timekeeping
structure in order to make sure that any adjustments to the structure
persist.

Unfortunately, the updates to the tai offset via adjtimex do not
trigger this update, causing adjustments to the tai offset to be
made and then over-written by the previous value at the next
update_wall_time() call.

This patch resovles the issue by calling timekeeping_update()
right after setting the tai offset.

Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/timekeeping.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -605,6 +605,7 @@ void timekeeping_set_tai_offset(s32 tai_
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);
 	__timekeeping_set_tai_offset(tk, tai_offset);
+	timekeeping_update(tk, false, true);
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 	clock_was_set();
@@ -1677,6 +1678,7 @@ int do_adjtimex(struct timex *txc)
 
 	if (tai != orig_tai) {
 		__timekeeping_set_tai_offset(tk, tai);
+		timekeeping_update(tk, false, true);
 		clock_was_set_delayed();
 	}
 	write_seqcount_end(&timekeeper_seq);


