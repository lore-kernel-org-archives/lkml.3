Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab3FCNfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:35:05 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:64997 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab3FCNe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:34:59 -0400
MIME-Version: 1.0
X-Originating-IP: [95.195.149.54]
Date: Mon, 3 Jun 2013 15:34:57 +0200
Message-ID: <CAFaRD2FP0rrQstV1GszP_URO+cZZuQdyRxOYUEmA+5BvopUAvQ@mail.gmail.com>
Subject: [PATCH] timekeeping: handle epoch roll-over (2038) on 32-bit systems
From: Tobias Waldekranz <tobias@waldekranz.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ktime_get_update_offsets, calculate the current time in the same
way as in ktime_get.

On 32-bit systems, the current time is truncated via the call to
ktime_set, the following subtraction of offs_real will result in an
inaccurate time when the current number of seconds since epoch can no
longer fit in 31-bits (2038-01-19 03:14:07 UTC). This will send
hrtimer_interrupt into an infinite loop on some architectures (arm),
or emit an oops on others(x86).

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 kernel/time/timekeeping.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 98cd470..b484ab2 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1600,8 +1600,8 @@ ktime_t ktime_get_update_offsets(ktime_t
*offs_real, ktime_t *offs_boot,
  do {
  seq = read_seqcount_begin(&timekeeper_seq);

- secs = tk->xtime_sec;
- nsecs = timekeeping_get_ns(tk);
+ secs = tk->xtime_sec + tk->wall_to_monotonic.tv_sec;
+ nsecs = timekeeping_get_ns(tk) + tk->wall_to_monotonic.tv_nsec;

  *offs_real = tk->offs_real;
  *offs_boot = tk->offs_boot;
@@ -1609,7 +1609,6 @@ ktime_t ktime_get_update_offsets(ktime_t
*offs_real, ktime_t *offs_boot,
  } while (read_seqcount_retry(&timekeeper_seq, seq));

  now = ktime_add_ns(ktime_set(secs, 0), nsecs);
- now = ktime_sub(now, *offs_real);
  return now;
 }
 #endif
--
1.7.10.4
