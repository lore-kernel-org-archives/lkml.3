Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaJGIpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:45:31 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:62337 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbaJGIpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:45:15 -0400
MIME-Version: 1.0
In-Reply-To: <20141006212606.GF14113@kernel.org>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
	<20141006212606.GF14113@kernel.org>
Date: Tue, 7 Oct 2014 10:45:14 +0200
Message-ID: <CAFrcx1=swP-3E_pxWEcozFJhL+5YaUBPavQX=OfMtc8h4e=bDg@mail.gmail.com>
Subject: Re: [PATCH 1/1] rasd: Use perf_evlist__open() instead of open coded
From: Jean Pihet <jean.pihet@linaro.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On 6 October 2014 23:26, Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> Heya, please check if this is OK.
>
> This was while looking the set of methods used by rasd, trying to reduce
> it to the bare minimum.
>
> Perhaps even that cpu_map__new() one can be ditched, leaving to use the
> default of a NULL cpumap that will end up being one with -1, i.e. all
> cpus.
>
> - Arnaldo
>
> From 8dc34bd2824c7843182f4fc6deabaf573e42e806 Mon Sep 17 00:00:00 2001
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date: Mon, 6 Oct 2014 15:43:42 -0300
> Subject: [PATCH] rasd: Use perf_evlist__open() instead of open coded
>  equivalent
>
> Cc: Borislav Petkov <bp@suse.de>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  src/rasd.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/src/rasd.c b/src/rasd.c
> index 06ccdcdd9d56..fb33fca131fa 100644
> --- a/src/rasd.c
> +++ b/src/rasd.c
> @@ -241,7 +241,6 @@ static void daemonize(void)
>
>  int main()
>  {
> -       struct perf_evsel *c;
>         struct thread_map *threads;
>         struct cpu_map *cpus;
>         int i;
> @@ -278,12 +277,9 @@ int main()
>         perf_evlist__set_maps(evlist, cpus, threads);
>
>         /* Open events */
> -       evlist__for_each(evlist, c) {
> -               /* On all online cpus by default, system wide tracing */
> -               if (perf_evsel__open(c, evlist->cpus, NULL) < 0)
> -                       err("opening tracepoint, are you root?");
> -       }
> -       perf_evlist__set_id_pos(evlist);
> +       /* On all online cpus by default, system wide tracing */
> +       if (perf_evlist__open(evlist) < 0)
> +               err("opening tracepoint, are you root?");

That way the system wide tracing does not work. perf_evlist__open uses
a non-NULL thread mapping and so it only traces the events generated
by the daemon itself.

perf top uses a similar approach but uses a lot of code in machine.c
(machine__synthesize_threads) and util/event.c
(perf_event__synthesize_threads) to synthesize the threads etc., which
we want to avoid in the minimalistic approach of rasd.

Maybe I missed something about the system wide tracing, any suggestion
is welcome.

Thanks for looking!

Jean

>
>         /* mmap buffers */
>         if (perf_evlist__mmap(evlist, 4 /* opts->mmap_pages */, false) < 0)
> --
> 1.9.3
>
