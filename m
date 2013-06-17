Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3FQIzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:55:46 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62849 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab3FQIzp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:55:45 -0400
X-AuditID: 9c930179-b7c30ae0000047e1-92-51becf0f8958
From: Namhyung Kim <namhyung@kernel.org>
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Cc: acme@ghostprotocols.net, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: fix bench numa compilation
References: <1371291314-20322-1-git-send-email-riccardo.magliocchetti@gmail.com>
Date: Mon, 17 Jun 2013 17:55:43 +0900
In-Reply-To: <1371291314-20322-1-git-send-email-riccardo.magliocchetti@gmail.com>
	(Riccardo Magliocchetti's message of "Sat, 15 Jun 2013 12:15:14
	+0200")
Message-ID: <8761xd2k1c.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Riccardo,

On Sat, 15 Jun 2013 12:15:14 +0200, Riccardo Magliocchetti wrote:
> bench/numa.c: In function ‘worker_thread’:
> bench/numa.c:1113:20: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
>     if (diff.tv_sec >= g->p.nr_secs) {
>                     ^
> bench/numa.c:1161:6: error: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 5 has type ‘u64’ [-Werror=format=]
>       process_nr, thread_nr, runtime_ns_max / bytes_done, val);
>       ^
>
> Signed-off-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
> ---
>  tools/perf/bench/numa.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Diffed against 3.9.6 but should apply cleanly to latest git
>
> diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
> index 30d1c32..90ef4cc 100644
> --- a/tools/perf/bench/numa.c
> +++ b/tools/perf/bench/numa.c
> @@ -1110,7 +1110,7 @@ static void *worker_thread(void *__tdata)
>  		/* Check whether our max runtime timed out: */
>  		if (g->p.nr_secs) {
>  			timersub(&stop, &start0, &diff);
> -			if (diff.tv_sec >= g->p.nr_secs) {
> +			if (diff.tv_sec >= (long int)g->p.nr_secs) {
>  				g->stop_work = true;
>  				break;
>  			}
> @@ -1157,7 +1157,7 @@ static void *worker_thread(void *__tdata)
>  			runtime_ns_max += diff.tv_usec * 1000;
>  
>  			if (details >= 0) {
> -				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016lx]\n",
> +				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016llx]\n",
>  					process_nr, thread_nr, runtime_ns_max / bytes_done, val);
>  			}
>  			fflush(stdout);

It will fail to build on 64 bit machines:

bench/numa.c: In function ‘worker_thread’:
bench/numa.c:1161:6: error: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 5 has type ‘u64’ [-Werror=format]
cc1: all warnings being treated as errors
make: *** [bench/numa.o] Error 1


You can use PRIx64 or cast val to unsigned long long type explicitly.

Thanks,
Namhyung
