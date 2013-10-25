Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab3JYKeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:34:37 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:47739 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab3JYKef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:34:35 -0400
Date: Fri, 25 Oct 2013 12:34:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Patrick Palka <patrick@parcs.ath.cx>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] perf/ui/tui: don't force a refresh during progress update
Message-ID: <20131025103432.GA4363@gmail.com>
References: <1382565562-15108-1-git-send-email-patrick@parcs.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382565562-15108-1-git-send-email-patrick@parcs.ath.cx>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Patrick Palka <patrick@parcs.ath.cx> wrote:

> Each call to tui_progress__update() would forcibly refresh the entire
> screen.  This is somewhat inefficient and causes noticable flickering
> during the startup of perf-report, especially on large/slow terminals.
> 
> It looks like the force-refresh in tui_progress__update() serves no
> purpose other than to clear the screen so that the progress bar of a
> previous operation does not subsume with that of a subsequent operation.
> But we can do just that in a much more efficient manner by clearing only
> the region that a previous progress bar may have occupied before
> repainting the new progress bar.  Then the force-refresh could be
> removed with no change in visuals.
> 
> This patch disables the slow force-refresh in tui_progress__update() and
> instead calls SLsmg_fill_region() on the entire area that the progress
> bar may occupy before repainting it.  This change makes the startup of
> perf-report much faster and appear much "smoother".
> 
> It turns out that this was a big bottleneck in the startup speed of
> perf-report -- with this patch, perf-report starts up ~1.6x faster (0.8s
> vs 0.5s) on my machines.  (These numbers were measured by running "time
> perf report" on an 8MB perf.data and pressing 'q' immediately.)
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
> ---
>  tools/perf/ui/tui/progress.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/ui/tui/progress.c b/tools/perf/ui/tui/progress.c
> index 6c2184d..641049a 100644
> --- a/tools/perf/ui/tui/progress.c
> +++ b/tools/perf/ui/tui/progress.c
> @@ -17,13 +17,14 @@ static void tui_progress__update(u64 curr, u64 total, const char *title)
>  	if (total == 0)
>  		return;
>  
> -	ui__refresh_dimensions(true);
> +	ui__refresh_dimensions(false);
>  	pthread_mutex_lock(&ui__lock);
>  	y = SLtt_Screen_Rows / 2 - 2;
>  	SLsmg_set_color(0);
>  	SLsmg_draw_box(y, 0, 3, SLtt_Screen_Cols);
>  	SLsmg_gotorc(y++, 1);
>  	SLsmg_write_string((char *)title);
> +	SLsmg_fill_region(y, 1, 1, SLtt_Screen_Cols - 2, ' ');
>  	SLsmg_set_color(HE_COLORSET_SELECTED);
>  	bar = ((SLtt_Screen_Cols - 2) * curr) / total;
>  	SLsmg_fill_region(y, 1, 1, bar, ' ');

Nice! This is something I noticed as well, never figured out the 
root cause of it.

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
