Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaFCE2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 00:28:07 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36246 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaFCE2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 00:28:05 -0400
X-AuditID: 85900ec0-d452db9000001514-c8-538d4ed1e081
Subject: [PATCH ftrace/core 0/2] ftrace: Introduce the new file
 "saved_cmdlines_size"
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Date: Tue, 03 Jun 2014 13:28:00 +0900
Message-ID: <20140603042800.27308.48050.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

This patch set introduces the new file "saved_cmdlines_size" for increasing
the number of saved cmdlines. Current saved_cmdlines can store just 128 command 
names and PIDs, but process names are often lost like <...> when we read trace
data. If the process exists, we can get the name by using ps command. However,
if the process already has not existed, we cannot get the name.

To solve this issue, we introduce the new file "saved_cmdlines_size" to expand
the max number of saved command line names. This file is very simple.
If we write a number to nr_saved_cmdlines, the number of command name will be
stored. And, if we read the file, we can get current maximum number of command
name. The default number is 128 which is current default number, so this patch
does not change the usage of memory for saved_cmdlines when we boot kernel.

I found a bug for current ftrace, so I fixed the bug before introducing
saved_cmdlines_size file (2nd patch). Note that the 2nd patch depends on
the 1st patch.

Thanks!

Changes in V2:
[2/2]
- Fix a racing problem of savedcmd between saved_cmdlines I/F and
  nr_saved_cmdlines I/F. If one reads saved_cmdlines and writes a value to
  nr_saved_cmdlines at the same time, then the write returns -EBUSY.

  <How to test>
  [terminal 1] Read saved_cmdlines
  # while true; do cat saved_cmdlines > /dev/null; done;

  [terminal 2] Write 1024 to nr_saved_cmdlines
  # while true; do echo 1024 > nr_saved_cmdlines; done;
  -bash: echo: write error: Device or resource busy
  -bash: echo: write error: Device or resource busy
  -bash: echo: write error: Device or resource busy

Changes in V3:
[1/2]
- Introduce this patch
[2/2]
- Change 'nr_saved_cmdlines' to 'saved_cmdlines_size'
- Delete two helper functions(trace_init_savedcmd() and
  trace_creare_and_init_saved_cmd())
- Rebase this patch for current ftrace/core tree
- Remove reader member in saved_cmdlines_buffer structure because the racing
  problem does not occur even if we don't the member in this patch
- Fix several typos

---

Yoshihiro YUNOMAE (2):
      [BUGFIX] ftrace: Avoid panic when allocation of max_buffer is failed
      ftrace: Introduce saved_cmdlines_size file


 kernel/trace/trace.c |  205 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 179 insertions(+), 26 deletions(-)

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
