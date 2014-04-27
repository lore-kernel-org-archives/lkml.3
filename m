Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaD0RKF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:10:05 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48154 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbaD0RIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:45 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Ryan Haasken <haasken@cray.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 44/47] staging/lustre: Always clamp cdls_delay between min and max
Date: Sun, 27 Apr 2014 13:07:08 -0400
Message-Id: <1398618431-29757-45-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan Haasken <haasken@cray.com>

In libcfs_debug_vmsg2, cdls_delay is only clamped between the minimum
and the maximum when it is increased by multiplying by the backoff
factor.  It is not clamped when it is decreased by dividing by the
backoff factor.  This allows it to achieve values less than the
minimum, which allows a console message to be printed that should have
been skipped.  This patch moves the clamping outside of the else
statement, ensuring that cdls_delay is always between the min and the
max after the first time through libcfs_debug_vmsg2.

Signed-off-by: Ryan Haasken <haasken@cray.com>
Reviewed-on: http://review.whamcloud.com/9503
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4711
Reviewed-by: Chris Horn <hornc@cray.com>
Reviewed-by: Ann Koehler <amk@cray.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/libcfs/tracefile.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/tracefile.c b/drivers/staging/lustre/lustre/libcfs/tracefile.c
index 50d4218..07845e8 100644
--- a/drivers/staging/lustre/lustre/libcfs/tracefile.c
+++ b/drivers/staging/lustre/lustre/libcfs/tracefile.c
@@ -416,13 +416,13 @@ console:
 			cdls->cdls_delay /= libcfs_console_backoff * 4;
 		} else {
 			cdls->cdls_delay *= libcfs_console_backoff;
-
-			if (cdls->cdls_delay < libcfs_console_min_delay)
-				cdls->cdls_delay = libcfs_console_min_delay;
-			else if (cdls->cdls_delay > libcfs_console_max_delay)
-				cdls->cdls_delay = libcfs_console_max_delay;
 		}
 
+		if (cdls->cdls_delay < libcfs_console_min_delay)
+			cdls->cdls_delay = libcfs_console_min_delay;
+		else if (cdls->cdls_delay > libcfs_console_max_delay)
+			cdls->cdls_delay = libcfs_console_max_delay;
+
 		/* ensure cdls_next is never zero after it's been seen */
 		cdls->cdls_next = (cfs_time_current() + cdls->cdls_delay) | 1;
 	}
-- 
1.8.5.3

