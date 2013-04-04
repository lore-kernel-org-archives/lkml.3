Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708Ab3DDNpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 09:45:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49562 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760568Ab3DDNpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 09:45:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: posix_cpu_timer: initialize "now" variable
Date: Thu, 4 Apr 2013 13:45:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304041345.41971.arnd@arndb.de>
X-Provags-ID: V02:K0:pcNg+KnmDSzunU0N5n8Ur0XAjomv0nF6VDlbwgeh+p0
 Glp12W1dYGNJ0SgZbWKdROmPYTbkZpHF/pq6mgs8g4fGHcAQGe
 ejF9XF5c5zXCf8qeu3RsA55keomyPyEvOq5FmEtTW1RAimkkKB
 kmn9CDNaLKHHRLZxaVOvBZihVhW0xcRgJCKkhUJe8P2NSb+/PW
 3rWy9ZKl0bclGoKROaVtb1G9+Ry5IgvEybbmXHexdaKghFfSa7
 IRABbl90eiaZ/SdNMDbkBy7GfQ/k/1vQOIm2pYFZ4tL+nBPQrp
 3TfzrVNUcoDCmBUgo6dJlGPJHS7Gowhvj/ltle+h5GzScuz6VU
 x+AvMV4Ebmqj6AkMhK9Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 6d0e025 "posix_cpu_timer: consolidate expiry time type" in linux-next
introduces a new compiler warning:

kernel/posix-cpu-timers.c: In function 'posix_cpu_timer_schedule':
kernel/posix-cpu-timers.c:1127:19: warning: 'now' may be used uninitialized in this function [-Wmaybe-uninitialized]
    clear_dead_task(timer, now);

As far as I can tell, that warning is about an actual bug an not
a false positive, as that variable is clearly never initialized
when it gets used in line 1127.

Here is a patch that makes the warning go away for me, no idea if this is
the right solution or not.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index e5286b5..1828b9f 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1119,6 +1119,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			timer->it.cpu.expires = 0;
 			goto out_unlock;
 		} else if (unlikely(p->exit_state) && thread_group_empty(p)) {
+			cpu_clock_sample(timer->it_clock, p, &now);
 			/*
 			 * We've noticed that the thread is dead, but
 			 * not yet reaped.  Take this opportunity to
