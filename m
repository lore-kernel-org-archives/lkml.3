Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030754AbaGROOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:14:21 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:56513 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934714AbaGROOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:14:19 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/7] printk: start simplifying some flags
Date: Fri, 18 Jul 2014 09:14:12 -0500
Message-Id: <1405692859-32500-1-git-send-email-elder@linaro.org>
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

This series includes three patches that begin the process of
simplifying how these flags are used and interpreted.  They include
very long, detailed explanations (as small patches often do) because
I want my reasoning to be very clear and examined very closely.  I
really don't want to break printk()...

The first patch surrounds a "*** XXX printk messages dropped ***"
message with newlines, to improve readability.

The second patch changes how two global variables are initialized,
allowing the second patch to assume they always hold certain values.

The third patch simplifies some code based on the observation that
the LOG_CONT and LOG_NEWLINE flags are mutually exclusive.

The fourth and fifth patch fix a bug in two places.  The bug is
that a LOG_PREFIX in a record should implicitly terminate its
predecessor, even if the predecessor was marked LOG_CONT.

The sixth patch inserts a newline in /dev/kmsg output in the
event a LOG_PREFIX record follows a LOG_CONT record.

One trivial final patch is included at the end of the series.

					-Alex

History:
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

This series, based on v3.16-rc5, is available here:
    http://git.linaro.org/landing-teams/working/broadcom/kernel.git
    Branch review/printk-flags-v3

Alex Elder (7):
  printk: report dropped messages on separate line
  printk: initialize syslog_prev and console_prev
  printk: LOG_CONT and LOG_NEWLINE are opposites
  printk: honor LOG_PREFIX in devkmsg_read()
  printk: honor LOG_PREFIX in msg_print_text()
  printk: insert newline in devkmsg_read()
  printk: correct some more typos

 kernel/printk/printk.c | 75 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 30 deletions(-)

-- 
1.9.1

