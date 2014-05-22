Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893AbaEVMXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:23:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51010 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964844AbaEVMXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:23:00 -0400
Date: Thu, 22 May 2014 05:22:49 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-c0f1527b7e004f9a91e488f05c251213d16ad7ac@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1400480762-22852-14-git-send-email-namhyung@kernel.org>
References: <1400480762-22852-14-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report/tui: Fix a bug when --fields/
 sort is given
Git-Commit-ID: c0f1527b7e004f9a91e488f05c251213d16ad7ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0f1527b7e004f9a91e488f05c251213d16ad7ac
Gitweb:     http://git.kernel.org/tip/c0f1527b7e004f9a91e488f05c251213d16ad7ac
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 16 Apr 2014 11:16:33 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 21 May 2014 11:45:36 +0200

perf report/tui: Fix a bug when --fields/sort is given

The hists__filter_entries() function is called when down arrow key is
pressed for navigating through the entries in TUI.  It has a check for
filtering out entries that have very small overhead (under min_pcnt).

However it just assumed the entries are sorted by the overhead so when
it saw such a small overheaded entry, it just stopped navigating as an
optimization.  But it's not true anymore due to new --fields and
--sort optoin behavior and this case users cannot go down to a next
entry if ther's an entry with small overhead in-between.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1400480762-22852-14-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 92d128f..169224c 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -812,10 +812,7 @@ static struct rb_node *hists__filter_entries(struct rb_node *nd,
 		if (total)
 			percent = h->stat.period * 100.0 / total;
 
-		if (percent < min_pcnt)
-			return NULL;
-
-		if (!h->filtered)
+		if (!h->filtered && percent >= min_pcnt)
 			return nd;
 
 		nd = rb_next(nd);
