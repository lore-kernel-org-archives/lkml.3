Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab3APQOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:14:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36940 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084Ab3APQLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:11:24 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roland Dreier <roland@purestorage.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Sylvain Munaut <s.munaut@whatever-company.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 213/222] printk: fix incorrect length from print_time() when seconds > 99999
Date: Wed, 16 Jan 2013 13:56:53 -0200
Message-Id: <1358351822-7675-214-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 35dac27cedd14c3b6fcd4ba7bc3c31738cfd1831 upstream.

print_prefix() passes a NULL buf to print_time() to get the length of
the time prefix; when printk times are enabled, the current code just
returns the constant 15, which matches the format "[%5lu.%06lu] " used
to print the time value.  However, this is obviously incorrect when the
whole seconds part of the time gets beyond 5 digits (100000 seconds is a
bit more than a day of uptime).

The simple fix is to use snprintf(NULL, 0, ...) to calculate the actual
length of the time prefix.  This could be micro-optimized but it seems
better to have simpler, more readable code here.

The bug leads to the syslog system call miscomputing which messages fit
into the userspace buffer.  If there are enough messages to fill
log_buf_len and some have a timestamp >= 100000, dmesg may fail with:

    # dmesg
    klogctl: Bad address

When this happens, strace shows that the failure is indeed EFAULT due to
the kernel mistakenly accessing past the end of dmesg's buffer, since
dmesg asks the kernel how big a buffer it needs, allocates a bit more,
and then gets an error when it asks the kernel to fill it:

    syslog(0xa, 0, 0)                       = 1048576
    mmap(NULL, 1052672, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fa4d25d2000
    syslog(0x3, 0x7fa4d25d2010, 0x100008)   = -1 EFAULT (Bad address)

As far as I can see, the bug has been there as long as print_time(),
which comes from commit 084681d14e42 ("printk: flush continuation lines
immediately to console") in 3.5-rc5.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Sylvain Munaut <s.munaut@whatever-company.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/printk.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 146827f..46f0c2c 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -812,10 +812,11 @@ static size_t print_time(u64 ts, char *buf)
 	if (!printk_time)
 		return 0;
 
+	rem_nsec = do_div(ts, 1000000000);
+
 	if (!buf)
-		return 15;
+		return snprintf(NULL, 0, "[%5lu.000000] ", (unsigned long)ts);
 
-	rem_nsec = do_div(ts, 1000000000);
 	return sprintf(buf, "[%5lu.%06lu] ",
 		       (unsigned long)ts, rem_nsec / 1000);
 }
-- 
1.7.9.5

