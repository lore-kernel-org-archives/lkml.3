Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaBKTWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:22:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbaBKTIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3.10 73/79] timekeeping: Fix missing timekeeping_update in suspend path
Date: Tue, 11 Feb 2014 11:06:17 -0800
Message-Id: <20140211184723.081547947@linuxfoundation.org>
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

commit 330a1617b0a6268d427aa5922c94d082b1d3e96d upstream.

Since 48cdc135d4840 (Implement a shadow timekeeper), we have to
call timekeeping_update() after any adjustment to the timekeeping
structure in order to make sure that any adjustments to the structure
persist.

In the timekeeping suspend path, we udpate the timekeeper
structure, so we should be sure to update the shadow-timekeeper
before releasing the timekeeping locks. Currently this isn't done.

In most cases, the next time related code to run would be
timekeeping_resume, which does update the shadow-timekeeper, but
in an abundence of caution, this patch adds the call to
timekeeping_update() in the suspend path.

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
@@ -1008,6 +1008,8 @@ static int timekeeping_suspend(void)
 		timekeeping_suspend_time =
 			timespec_add(timekeeping_suspend_time, delta_delta);
 	}
+
+	timekeeping_update(tk, false, true);
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 


