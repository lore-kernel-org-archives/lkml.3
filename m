Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaHLXFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 19:05:54 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:50324 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaHLXFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 19:05:53 -0400
MIME-Version: 1.0
In-Reply-To: <1407831366-28892-1-git-send-email-namhyung@kernel.org>
References: <1407831366-28892-1-git-send-email-namhyung@kernel.org>
Date: Wed, 13 Aug 2014 01:05:52 +0200
Message-ID: <CABPqkBRo8fNmv+XXTUQspW_A9MaHOZ1NN=BRA_BiN7SU9f2ijg@mail.gmail.com>
Subject: Re: [RFC/PATCH 1/2] perf top: Fix -z option behavior
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 10:16 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> The current -z option does almost nothing.  It doesn't zero the
> existing samples so that we can see profiles of exited process after
> last refresh.  It seems it only affects annotation.
>
> This patch clears existing entries before processing if -z option is
> given.  For this original decaying logic also moved before processing.
>
Works for me now in TUI and stdio modes. Thanks for fixing this quickly.

Tested-by: Stephane Eranian <eranian@google.com>

> Reported-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-top.c | 23 +++++++++++++++++------
>  tools/perf/util/hist.c   | 22 ++++++++++++++++++++++
>  tools/perf/util/hist.h   |  1 +
>  3 files changed, 40 insertions(+), 6 deletions(-)
>
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 4fb6f726271c..e486501b2067 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -276,11 +276,17 @@ static void perf_top__print_sym_table(struct perf_top *top)
>                 return;
>         }
>
> +       if (top->zero) {
> +               hists__delete_entries(&top->sym_evsel->hists);
> +       } else {
> +               hists__decay_entries(&top->sym_evsel->hists,
> +                                    top->hide_user_symbols,
> +                                    top->hide_kernel_symbols);
> +       }
> +
>         hists__collapse_resort(&top->sym_evsel->hists, NULL);
>         hists__output_resort(&top->sym_evsel->hists);
> -       hists__decay_entries(&top->sym_evsel->hists,
> -                            top->hide_user_symbols,
> -                            top->hide_kernel_symbols);
> +
>         hists__output_recalc_col_len(&top->sym_evsel->hists,
>                                      top->print_entries - printed);
>         putchar('\n');
> @@ -542,11 +548,16 @@ static void perf_top__sort_new_samples(void *arg)
>         if (t->evlist->selected != NULL)
>                 t->sym_evsel = t->evlist->selected;
>
> +       if (t->zero) {
> +               hists__delete_entries(&t->sym_evsel->hists);
> +       } else {
> +               hists__decay_entries(&t->sym_evsel->hists,
> +                                    t->hide_user_symbols,
> +                                    t->hide_kernel_symbols);
> +       }
> +
>         hists__collapse_resort(&t->sym_evsel->hists, NULL);
>         hists__output_resort(&t->sym_evsel->hists);
> -       hists__decay_entries(&t->sym_evsel->hists,
> -                            t->hide_user_symbols,
> -                            t->hide_kernel_symbols);
>  }
>
>  static void *display_thread_tui(void *arg)
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 30df6187ee02..86569fa3651d 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -277,6 +277,28 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
>         }
>  }
>
> +void hists__delete_entries(struct hists *hists)
> +{
> +       struct rb_node *next = rb_first(&hists->entries);
> +       struct hist_entry *n;
> +
> +       while (next) {
> +               n = rb_entry(next, struct hist_entry, rb_node);
> +               next = rb_next(&n->rb_node);
> +
> +               rb_erase(&n->rb_node, &hists->entries);
> +
> +               if (sort__need_collapse)
> +                       rb_erase(&n->rb_node_in, &hists->entries_collapsed);
> +
> +               --hists->nr_entries;
> +               if (!n->filtered)
> +                       --hists->nr_non_filtered_entries;
> +
> +               hist_entry__free(n);
> +       }
> +}
> +
>  /*
>   * histogram, sorted on item, collects periods
>   */
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index 95405a8fbd95..8c9c70e18cbb 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -152,6 +152,7 @@ void hists__output_resort(struct hists *hists);
>  void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
>
>  void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
> +void hists__delete_entries(struct hists *hists);
>  void hists__output_recalc_col_len(struct hists *hists, int max_rows);
>
>  u64 hists__total_period(struct hists *hists);
> --
> 2.0.0
>
