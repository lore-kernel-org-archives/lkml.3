Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaG1N3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:29:23 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:59264 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaG1N3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:29:20 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, john.stultz@linaro.org, jack@suse.cz,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 0/7] printk: start simplifying some flags
Date: Mon, 28 Jul 2014 08:29:13 -0500
Message-Id: <1406554160-9562-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each log record has a "flags" field.  The flags keep track of, for
instance, whether the record was saved in its entirety (as opposed
to being one of multiple records that should be merged as a single
unit).  A log record's flags field alone is not currently sufficient
to know how the record should be formatted; you need to know the
previous record's flags field as well.  I found understanding the
real effect of various combinations of these flags to be very
difficult, and was moved to try to do something about that.

This series includes seven patches that begin the process of
simplifying how these flags are used and interpreted.  They include
very long, detailed explanations (as small patches often do) because
I want my reasoning to be very clear and examined very closely.  I
really don't want to break printk()...

The first patch surrounds a "*** XXX printk messages dropped ***"
message with newlines, to improve readability.

The second patch inserts a newline in msg_print_text() in the event
a LOG_PREFIX record follows a LOG_CONT record.

The third patch changes how two global variables are initialized,
allowing the second patch to assume they always hold certain values.

The fourth patch simplifies some code based on the observation that
the LOG_CONT and LOG_NEWLINE flags are mutually exclusive.

The fifth and sixth patches fix a bug in two places.  The bug is
that a LOG_PREFIX in a record should implicitly terminate its
predecessor, even if the predecessor was marked LOG_CONT.

One trivial final patch is included at the end of the series.

					-Alex

History:
v7: - No longer insert extra newline in devkmsg_read() in patch 2.
    - Rebased on top of v3.16-rc7.
v6: - Forcefully initialize console_prev to NEWLINE rather than
      preserving state after printing dropped messages message.
    - Updated "Reviewed-by" tags; Petr Mládek is now satisfied
      with the entire series.
v5: - Initialized "prev" variables to LOG_NEWLINE in two more
      spots, as suggested.
    - Preserve previous flags when re-initializing "prev"
      variables when previous log messages have been reused.
    - Insert newline in msg_print_text() outside loop.
    - Moved "insert newline" patch earlier in series.
    - Rebased on v3.16-rc6.
v4: - Fixed two things I messed up in v3:
        - Fixed a sprintf() warning I mistakenly created.
        - Re-added a hunk inadvertently dropped from patch 3.
v3: - Inserted a patch to report dropped message on a new line.
    - Dropped a hunk from the (now) third patch, as requested.
    - Now insert a newline in msg_print_text() in addition to
      devkmsg_read().
    - Added Reviewed-by tags where appropriate.
v2: - Added a patch to initialize two globals with LOG_NEWLINE.
    - Changed the (now) second patch to argue that LOG_CONT and
      LOG_NEWLINES are mutally exclusive.
    - Added a patch to insert a newline in one case in devkmsg_read().
    - Added some extra parentheses in some conditions, as requested.
    - Fixed and updated some header commentary.
    - Deleted a hunk in the typo patch, as requested.

This series, based on v3.16-rc6, is available here:
    http://git.linaro.org/landing-teams/working/broadcom/kernel.git
    Branch review/printk-flags-v7

Alex Elder (7):
  printk: report dropped messages on separate line
  printk: insert newline for truncated records
  printk: initialize syslog_prev and console_prev
  printk: LOG_CONT and LOG_NEWLINE are opposites
  printk: honor LOG_PREFIX in devkmsg_read()
  printk: honor LOG_PREFIX in msg_print_text()
  printk: correct some more typos

 kernel/printk/printk.c | 94 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 57 insertions(+), 37 deletions(-)

-- 
1.9.1

