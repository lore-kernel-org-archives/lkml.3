Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaFEVfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:35:00 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:32857 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaFEVe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:34:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140605204117.GA1771@krava.redhat.com>
References: <CABPqkBTz7dBFGKGE5Ng8LwB=HQV_VQfhGRyWDC0ofnSjx2r3Vw@mail.gmail.com>
	<20140605170011.GA13372@krava.brq.redhat.com>
	<20140605202102.GE2311@infradead.org>
	<20140605204117.GA1771@krava.redhat.com>
Date: Thu, 5 Jun 2014 23:34:58 +0200
Message-ID: <CABPqkBTDLiTfBcYHadnXp+Jwk7nkLPFB22ZDy5JS5dbx-22HtA@mail.gmail.com>
Subject: Re: [PATCHv2] perf tools: Fix pipe check regression in attr event callback
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 10:41 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Thu, Jun 05, 2014 at 05:21:02PM -0300, Arnaldo Carvalho de Melo wrote:
>> Em Thu, Jun 05, 2014 at 07:00:11PM +0200, Jiri Olsa escreveu:
>> > On Thu, Jun 05, 2014 at 06:06:41PM +0200, Stephane Eranian wrote:
>> > > Hi Jiri,
>> > >
>> > > Somehow, I thought you had written a fix to avoid the problem below.
>> > > But when I try with tip.git, the problem is still there.
>> > > Could you push your fix ASAP.
>> > >
>> > > Thanks.
>> > >
>> > > $ perf record -o - noploop 2 |  perf inject -b |  perf report -i -
>> > > # To display the perf.data header info, please use
>> > > --header/--header-only options.
>> > > #
>> > > noploop for 2 seconds
>> > > 0x1bd0 [0x28]: failed to process type: 9
>> >
>> > hum, I remember fixing another issue.. this one is
>> > separated one, please try attached patch.
>> >
>> > thanks,
>> > jirka
>> >
>> >
>> > ---
>> > The file factoring in builtin-inject.c object introduced regression
>> > in attr event callback. The commit is:
>> >   3406912 perf inject: Handle output file via perf_data_file object
>> >
>> > Following hunk reversed the logic:
>> >   -       if (!inject->pipe_output)
>> >   +       if (&inject->output.is_pipe)
>>
>> Why do we need this '&'? this will always evaluate to true, as it will
>> get the address of a variable, also adding a ! before it will just it
>> eval to false always, or am I missing something? :-)
>>
>> I think this should really be:
>>
>>             if (!inject->output.is_pipe)
>>
>> No?
>
> aaarhg.. yes ;-) v2 attached
>
Had the same reaction as Arnaldo. Now, it makes more sense...

> thanks,
> jirka
>
> ---
> The file factoring in builtin-inject.c object introduced regression
> in attr event callback. The commit is:
>   3406912 perf inject: Handle output file via perf_data_file object
>
> Following hunk reversed the logic:
>   -       if (!inject->pipe_output)
>   +       if (&inject->output.is_pipe)
>
> putting it back, following example now works:
>   $ perf record -o - kill | perf inject -b | perf report -i -
>
> Plus removing extra '&' (kudos to Arnaldo)
>
> Reported-by: Stephane Eranian <eranian@google.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/builtin-inject.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
> index 6a3af00..16c7c11 100644
> --- a/tools/perf/builtin-inject.c
> +++ b/tools/perf/builtin-inject.c
> @@ -72,7 +72,7 @@ static int perf_event__repipe_attr(struct perf_tool *tool,
>         if (ret)
>                 return ret;
>
> -       if (&inject->output.is_pipe)
> +       if (!inject->output.is_pipe)
>                 return 0;
>
>         return perf_event__repipe_synth(tool, event);
> --
> 1.8.3.1
>
