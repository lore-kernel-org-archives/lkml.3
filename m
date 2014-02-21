Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688AbaBUNV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:21:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47658 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069AbaBUNCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 21/60] timekeeping: fix 32-bit overflow in get_monotonic_boottime
Date: Fri, 21 Feb 2014 13:00:48 +0000
Message-Id: <1392987687-15367-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Cross <ccross@android.com>

get_monotonic_boottime adds three nanonsecond values stored
in longs, followed by an s64.  If the long values are all
close to 1e9 the first three additions can overflow and
become negative when added to the s64.  Cast the first
value to s64 so that all additions are 64 bit.

Signed-off-by: Colin Cross <ccross@android.com>
[jstultz: Fished this out of the AOSP commong.git tree. This was
fixed upstream in v3.6 by ec145babe754f9ea1079034a108104b6001e001c]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/time/timekeeping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index a9ae4bd..3988562 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1196,7 +1196,7 @@ void get_monotonic_boottime(struct timespec *ts)
 	} while (read_seqretry(&timekeeper.lock, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec + sleep.tv_sec,
-			ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec + nsecs);
+		(s64)ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec + nsecs);
 }
 EXPORT_SYMBOL_GPL(get_monotonic_boottime);
 
-- 
1.9.0

