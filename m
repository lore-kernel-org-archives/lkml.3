Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161280AbaDQMql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 08:46:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbaDQMqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 08:46:38 -0400
Date: Thu, 17 Apr 2014 14:00:46 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/3] perf top/tui: Fixes for percentage filter behavior
Message-ID: <20140417120046.GC7422@krava.brq.redhat.com>
References: <1397721206-15393-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397721206-15393-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 04:53:23PM +0900, Namhyung Kim wrote:
> Hi,
> 
> This is a small fixes for a bug in perf top I found during some tests.
> It gets segfault if symbol filter found no entries - accessing NULL
> pointer in that case.

yep, I hit that yesterday as well, but I ended up just with
the patch below, your changes seems more comprehensive ;-)
going to review..

thanks,
jirka


> 
> The patches are also available at perf/percentage-v9 branch on my tree
> for your convenience.  I'm sorry for causing this bug..
> 
> Thanks,
> Namhyung
> 
> 
> Namhyung Kim (3):
>   perf hists: Add missing updates on nr_non_filtered_entries
>   perf ui/tui: Fix off-by-one in hist_browser__update_nr_entries()
>   perf top/tui: Update nr_entries properly after filter is applied
> 
>  tools/perf/ui/browsers/hists.c | 34 +++++++++++++++++++---------------
>  tools/perf/util/hist.c         |  8 +++++++-
>  tools/perf/util/hist.h         |  6 ++++++
>  3 files changed, 32 insertions(+), 16 deletions(-)
> 
> -- 
> 1.9.2
> 

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 4d41698..89c3ba0 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -866,6 +866,10 @@ static void ui_browser__hists_seek(struct ui_browser *browser,
 		return;
 	}
 
+	/* Nowhere to start from. */
+	if (!nd)
+		return;
+
 	/*
 	 * Moves not relative to the first visible entry invalidates its
 	 * row_offset:
