Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaBKTJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:09:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbaBKTIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3.4 30/30] 3.4.y: timekeeping: fix 32-bit overflow in get_monotonic_boottime
Date: Tue, 11 Feb 2014 11:06:30 -0800
Message-Id: <20140211184648.002786693@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184647.149512538@linuxfoundation.org>
References: <20140211184647.149512538@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
---
 kernel/time/timekeeping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1197,7 +1197,7 @@ void get_monotonic_boottime(struct times
 	} while (read_seqretry(&timekeeper.lock, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec + sleep.tv_sec,
-			ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec + nsecs);
+		(s64)ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec + nsecs);
 }
 EXPORT_SYMBOL_GPL(get_monotonic_boottime);
 


