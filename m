Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbbATMtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:49:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbbATMtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:49:36 -0500
Date: Tue, 20 Jan 2015 13:49:26 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf ui/tui: Show fatal error message only if exists
Message-ID: <20150120124926.GB15315@krava.brq.redhat.com>
References: <1421736050-5283-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421736050-5283-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 03:40:50PM +0900, Namhyung Kim wrote:
> When perf exits with some error it shows the error message with
> ui__error() or ui__warning() and then calls ui__exit() during
> exit_browser().
> 
> On TUI, it then shows a window titled "Fatal Error" to inform user a
> last message which might be related with this condition.  However it
> sometimes contains no message and just annoyes users.
> 
> The usual case for this is running perf top as normal user.  (And
> /proc/sys/kernel/perf_event_paranoid being 1).

cool, I couldn't recreate the 'no message' box but I recall seeing it

> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/ui/tui/helpline.c | 3 +++
>  tools/perf/ui/tui/setup.c    | 3 ++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/ui/tui/helpline.c b/tools/perf/ui/tui/helpline.c
> index 1c8b9afd5d6e..88f5143a5981 100644
> --- a/tools/perf/ui/tui/helpline.c
> +++ b/tools/perf/ui/tui/helpline.c
> @@ -9,6 +9,7 @@
>  #include "../libslang.h"
>  
>  char ui_helpline__last_msg[1024];
> +bool tui_helpline__set;
>  
>  static void tui_helpline__pop(void)
>  {
> @@ -35,6 +36,8 @@ static int tui_helpline__show(const char *format, va_list ap)
>  			sizeof(ui_helpline__last_msg) - backlog, format, ap);
>  	backlog += ret;
>  
> +	tui_helpline__set = true;
> +
>  	if (ui_helpline__last_msg[backlog - 1] == '\n') {
>  		ui_helpline__puts(ui_helpline__last_msg);
>  		SLsmg_refresh();
> diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
> index 3c38f25b1695..b77e1d771363 100644
> --- a/tools/perf/ui/tui/setup.c
> +++ b/tools/perf/ui/tui/setup.c
> @@ -17,6 +17,7 @@
>  static volatile int ui__need_resize;
>  
>  extern struct perf_error_ops perf_tui_eops;
> +extern bool tui_helpline__set;
>  
>  extern void hist_browser__init_hpp(void);
>  
> @@ -159,7 +160,7 @@ int ui__init(void)
>  
>  void ui__exit(bool wait_for_ok)
>  {
> -	if (wait_for_ok)
> +	if (wait_for_ok && tui_helpline__set)
>  		ui__question_window("Fatal Error",
>  				    ui_helpline__last_msg,
>  				    "Press any key...", 0);

looks like we display ui_helpline__last_msg also in ui/browsers/annotate.c

do we want to have some common function that unsets tui_helpline__set
so we're sure we dont get the message twice?

jirka
