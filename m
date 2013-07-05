Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650Ab3GECeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 22:34:17 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57917 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab3GECeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 22:34:16 -0400
X-AuditID: 9c930179-b7b12ae000007e1d-f0-51d630a53760
From: Namhyung Kim <namhyung@kernel.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 2/2] perf: squelch warnings from perl.h to compile-pass
References: <1372945246-21605-1-git-send-email-artagnon@gmail.com>
	<1372945246-21605-3-git-send-email-artagnon@gmail.com>
Date: Fri, 05 Jul 2013 11:34:12 +0900
In-Reply-To: <1372945246-21605-3-git-send-email-artagnon@gmail.com> (Ramkumar
	Ramachandra's message of "Thu, 4 Jul 2013 19:10:46 +0530")
Message-ID: <878v1lzqe3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ramkumar,

On Thu,  4 Jul 2013 19:10:46 +0530, Ramkumar Ramachandra wrote:
> Currently, a simple
>
>   $ make
>
> errors out because we compile with -Werror by default, turning all
> warnings into errors.  Although no warnings are emitted by our code
> itself, two kinds of warnings are emitted by perl.h (perl 5.18.0):
>
>   -Wundef and -Wswitch-default

IIRC there's a floating patch for this, but I cannot find it now.

>
> Use #pragma statements to squelch exactly those warnings, and get perf
> to compile-pass by default.
>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Namhyung Kim <namhyung.kim@lge.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  tools/perf/config/feature-tests.mak                  |  5 +++++
>  tools/perf/scripts/perl/Perf-Trace-Util/Context.c    | 10 ++++++++--
>  tools/perf/scripts/perl/Perf-Trace-Util/Context.xs   | 10 ++++++++--
>  tools/perf/util/scripting-engines/trace-event-perl.c |  5 +++++
>  4 files changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
> index 708fb8e..91fa083 100644
> --- a/tools/perf/config/feature-tests.mak
> +++ b/tools/perf/config/feature-tests.mak
> @@ -103,7 +103,12 @@ endif
>  ifndef NO_LIBPERL
>  define SOURCE_PERL_EMBED
>  #include <EXTERN.h>
> +
> +#pragma GCC diagnostic ignored \"-Wundef\"
> +#pragma GCC diagnostic ignored \"-Wswitch-default\"
>  #include <perl.h>
> +#pragma GCC diagnostic error \"-Wundef\"
> +#pragma GCC diagnostic error \"-Wswitch-default\"

It seems that this kind of duplication is not a good solution.  You'd better
making an wraping header like ui/gtk/gtk.h.

Thanks,
Namhyung

>  
>  int main(void)
>  {
> diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
> index 790ceba..0807294 100644
> --- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
> +++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
> @@ -28,8 +28,14 @@
>   *
>   */
>  
> -#include "EXTERN.h"
> -#include "perl.h"
> +#include <EXTERN.h>
> +
> +#pragma GCC diagnostic ignored "-Wundef"
> +#pragma GCC diagnostic ignored "-Wswitch-default"
> +#include <perl.h>
> +#pragma GCC diagnostic error "-Wundef"
> +#pragma GCC diagnostic error "-Wswitch-default"
> +
>  #include "XSUB.h"
>  #include "../../../perf.h"
>  #include "../../../util/trace-event.h"
> diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
> index c1e2ed1..cd46e01 100644
> --- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
> +++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
> @@ -19,8 +19,14 @@
>   *
>   */
>  
> -#include "EXTERN.h"
> -#include "perl.h"
> +#include <EXTERN.h>
> +
> +#pragma GCC diagnostic ignored "-Wundef"
> +#pragma GCC diagnostic ignored "-Wswitch-default"
> +#include <perl.h>
> +#pragma GCC diagnostic error "-Wundef"
> +#pragma GCC diagnostic error "-Wswitch-default"
> +
>  #include "XSUB.h"
>  #include "../../../perf.h"
>  #include "../../../util/script-event.h"
> diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
> index eacec85..aa3c11e 100644
> --- a/tools/perf/util/scripting-engines/trace-event-perl.c
> +++ b/tools/perf/util/scripting-engines/trace-event-perl.c
> @@ -27,7 +27,12 @@
>  
>  #include "../util.h"
>  #include <EXTERN.h>
> +
> +#pragma GCC diagnostic ignored "-Wundef"
> +#pragma GCC diagnostic ignored "-Wswitch-default"
>  #include <perl.h>
> +#pragma GCC diagnostic error "-Wundef"
> +#pragma GCC diagnostic error "-Wswitch-default"
>  
>  #include "../../perf.h"
>  #include "../thread.h"
