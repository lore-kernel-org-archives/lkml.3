Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab3JZAZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 20:25:59 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:50917 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab3JZAZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 20:25:57 -0400
From: Patrick Palka <patrick@parcs.ath.cx>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH rebase] perf/ui/tui: don't force a refresh during progress update
Date: Fri, 25 Oct 2013 20:25:49 -0400
Message-Id: <1382747149-9716-1-git-send-email-patrick@parcs.ath.cx>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382565562-15108-1-git-send-email-patrick@parcs.ath.cx>
References: <1382565562-15108-1-git-send-email-patrick@parcs.ath.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each call to tui_progress__update() would forcibly refresh the entire
screen.  This is somewhat inefficient and causes noticable flickering
during the startup of perf-report, especially on large/slow terminals.

It looks like the force-refresh in tui_progress__update() serves no
purpose other than to clear the screen so that the progress bar of a
previous operation does not subsume that of a subsequent operation.
But we can do just that in a much more efficient manner by clearing only
the region that a previous progress bar may have occupied before
repainting the new progress bar.  Then the force-refresh could be
removed with no change in visuals.

This patch disables the slow force-refresh in tui_progress__update() and
instead calls SLsmg_fill_region() on the entire area that the progress
bar may occupy before repainting it.  This change makes the startup of
perf-report much faster and appear much "smoother".

It turns out that this was a big bottleneck in the startup speed of
perf-report -- with this patch, perf-report starts up ~2x faster (1.1s
vs 0.55s) on my machines.  (These numbers were measured by running
"time perf report" on an 8MB perf.data and pressing 'q' immediately.)

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
---
Rebased against
  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git perf/core

And also CC'd two more relevant persons.

 tools/perf/ui/tui/progress.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/tui/progress.c b/tools/perf/ui/tui/progress.c
index 3e2d936..c61d14b 100644
--- a/tools/perf/ui/tui/progress.c
+++ b/tools/perf/ui/tui/progress.c
@@ -18,13 +18,14 @@ static void tui_progress__update(struct ui_progress *p)
 	if (p->total == 0)
 		return;
 
-	ui__refresh_dimensions(true);
+	ui__refresh_dimensions(false);
 	pthread_mutex_lock(&ui__lock);
 	y = SLtt_Screen_Rows / 2 - 2;
 	SLsmg_set_color(0);
 	SLsmg_draw_box(y, 0, 3, SLtt_Screen_Cols);
 	SLsmg_gotorc(y++, 1);
 	SLsmg_write_string((char *)p->title);
+	SLsmg_fill_region(y, 1, 1, SLtt_Screen_Cols - 2, ' ');
 	SLsmg_set_color(HE_COLORSET_SELECTED);
 	bar = ((SLtt_Screen_Cols - 2) * p->curr) / p->total;
 	SLsmg_fill_region(y, 1, 1, bar, ' ');
-- 
1.8.4.rc3

