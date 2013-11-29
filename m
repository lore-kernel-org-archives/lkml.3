Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab3K2GlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 01:41:15 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51752 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab3K2GlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 01:41:12 -0500
X-AuditID: 9c93016f-b7b6aae000005fae-af-529837066b55
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 20/29] tools lib traceevent: Remove malloc_or_die from plugin_function.c
References: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
	<1385638408-23519-21-git-send-email-jolsa@redhat.com>
Date: Fri, 29 Nov 2013 15:41:10 +0900
In-Reply-To: <1385638408-23519-21-git-send-email-jolsa@redhat.com> (Jiri
	Olsa's message of "Thu, 28 Nov 2013 12:33:19 +0100")
Message-ID: <87eh5zpv5l.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, 28 Nov 2013 12:33:19 +0100, Jiri Olsa wrote:
> Removing malloc_or_die calls from plugin_function.c,
> replacing them with standard malloc and error path.
>
> Suggested-by: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>  tools/lib/traceevent/plugin_function.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
> index 87acf9c..328d17d 100644
> --- a/tools/lib/traceevent/plugin_function.c
> +++ b/tools/lib/traceevent/plugin_function.c
> @@ -44,10 +44,16 @@ static void add_child(struct func_stack *stack, const char *child, int pos)
>  		free(stack->stack[pos]);
>  	else {
>  		if (!stack->stack)
> -			stack->stack = malloc_or_die(sizeof(char *) * STK_BLK);
> +			stack->stack = malloc(sizeof(char *) * STK_BLK);
>  		else
>  			stack->stack = realloc(stack->stack, sizeof(char *) *
>  					       (stack->size + STK_BLK));

I think single realloc() can handle both cases.  And this code has a
problem that it overwrites stack->stack to NULL in case of error so that
we cannot point original region anymore.  You'd better to use a temp
variable IMHO.

> +
> +		if (!stack->stack) {
> +			warning("could not allocate plugin memory\n");
> +			return;
> +		}
> +
>  		for (i = stack->size; i < stack->size + STK_BLK; i++)
>  			stack->stack[i] = NULL;
>  		stack->size += STK_BLK;
> @@ -67,7 +73,12 @@ static int add_and_get_index(const char *parent, const char *child, int cpu)
>  		if (fstack)
>  			fstack = realloc(fstack, sizeof(*fstack) * (cpu + 1));
>  		else
> -			fstack = malloc_or_die(sizeof(*fstack) * (cpu + 1));
> +			fstack = malloc(sizeof(*fstack) * (cpu + 1));

Ditto.

Thanks,
Namhyung

> +
> +		if (!fstack) {
> +			warning("could not allocate plugin memory\n");
> +			return 0;
> +		}
>  
>  		/* Account for holes in the cpu count */
>  		for (i = cpus + 1; i <= cpu; i++)
