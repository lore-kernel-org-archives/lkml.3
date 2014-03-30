Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaC3XZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:25:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36401 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602AbaC3XZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Colin Cross" <ccross@android.com>,
        "John Stultz" <john.stultz@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.717778186@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 185/200] timekeeping: fix 32-bit overflow in
 get_monotonic_boottime
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Cross <ccross@android.com>

fixed upstream in v3.6 by ec145babe754f9ea1079034a108104b6001e001c

get_monotonic_boottime adds three nanonsecond values stored
in longs, followed by an s64.  If the long values are all
close to 1e9 the first three additions can overflow and
become negative when added to the s64.  Cast the first
value to s64 so that all additions are 64 bit.

Signed-off-by: Colin Cross <ccross@android.com>
[jstultz: Fished this out of the AOSP commong.git tree. This was
fixed upstream in v3.6 by ec145babe754f9ea1079034a108104b6001e001c]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/time/timekeeping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1161,7 +1161,7 @@ void get_monotonic_boottime(struct times
 	} while (read_seqretry(&xtime_lock, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec + sleep.tv_sec,
-			ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec + nsecs);
+		(s64)ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec + nsecs);
 }
 EXPORT_SYMBOL_GPL(get_monotonic_boottime);
 

