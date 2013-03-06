Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab3CFPUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 10:20:22 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:54478 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab3CFPUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 10:20:18 -0500
MIME-Version: 1.0
In-Reply-To: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
References: <1362155689-13719-1-git-send-email-jolsa@redhat.com>
Date: Wed, 6 Mar 2013 16:20:15 +0100
Message-ID: <CAFTL4hyBN=pBao_AnrXsAj06t534hyO=3mpc=1_yM0feO0=gRw@mail.gmail.com>
Subject: Re: [PATCHv2] perf: Fix vmalloc ring buffer free function
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/1 Jiri Olsa <jolsa@redhat.com>:
> If we allocate perf ring buffer with the size of single page,
> we will get memory corruption when releasing it. It's caused
> by rb_free_work function (CONFIG_PERF_USE_VMALLOC option).
>
> For single page sized ring buffer the page_order is -1 (because
> nr_pages is 0). This needs to be recognized in the rb_free_work
> function to release proper amount of pages.
>
> Introducing page_nr function (CONFIG_PERF_USE_VMALLOC only)
> that returns number of allocated pages. Using it in rb_free_work
> and perf_mmap_to_page functions.
>
> Also setting rb->nr_pages to 0 in case we have only user page
> allocated, which will fail perf_output_begin function and
> prevents sample storage.
>
> v2 changes:
>  - fixed the perf_output_begin handling of single page buffer
>
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  kernel/events/ring_buffer.c | 40 +++++++++++++++++++++++++++++++++-------
>  1 file changed, 33 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> index 23cb34f..a802151 100644
> --- a/kernel/events/ring_buffer.c
> +++ b/kernel/events/ring_buffer.c
> @@ -154,7 +154,8 @@ int perf_output_begin(struct perf_output_handle *handle,
>         if (head - local_read(&rb->wakeup) > rb->watermark)
>                 local_add(rb->watermark, &rb->wakeup);
>
> -       handle->page = offset >> (PAGE_SHIFT + page_order(rb));
> +       /* page is allways 0 for CONFIG_PERF_USE_VMALLOC option */
> +       handle->page = offset >> PAGE_SHIFT;
>         handle->page &= rb->nr_pages - 1;
>         handle->size = offset & ((PAGE_SIZE << page_order(rb)) - 1);
>         handle->addr = rb->data_pages[handle->page];
> @@ -312,11 +313,21 @@ void rb_free(struct ring_buffer *rb)
>  }
>
>  #else
> +/*
> + * Returns the total number of pages allocated
> + * by ring buffer including the user page.
> + */
> +static int page_nr(struct ring_buffer *rb)
> +{
> +       return page_order(rb) == -1 ?
> +               1 :                        /* no data, just user page */
> +               1 + (1 << page_order(rb)); /* user page + data pages */
> +}

Could be simply rb->nr_page + 1 ?

Patch looks good in any case. Thanks.
