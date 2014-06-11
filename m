Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbaFKODo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 10:03:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:37474 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751965AbaFKODn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 10:03:43 -0400
Date: Wed, 11 Jun 2014 10:03:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] tracing: Fix memory leak on failure path in
 ftrace_allocate_pages()
Message-ID: <20140611100340.76b61805@gandalf.local.home>
In-Reply-To: <1402474014-28655-1-git-send-email-namhyung@kernel.org>
References: <1402474014-28655-1-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014 17:06:53 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> As struct ftrace_page is managed in a single linked list, it should
> free from the start page.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/ftrace.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 5b372e3ed675..ddfda763ded7 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2398,7 +2398,8 @@ ftrace_allocate_pages(unsigned long num_to_init)
>  	return start_pg;
>  
>   free_pages:
> -	while (start_pg) {
> +	pg = start_pg;
> +	while (pg) {

It works with just the added "pg = start_page", I would keep the
while (start_pg) still.

-- Steve

>  		order = get_count_order(pg->size / ENTRIES_PER_PAGE);
>  		free_pages((unsigned long)pg->records, order);
>  		start_pg = pg->next;

