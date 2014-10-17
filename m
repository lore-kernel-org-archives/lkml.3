Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaJQSRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 14:17:41 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:45054 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaJQSRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 14:17:40 -0400
MIME-Version: 1.0
In-Reply-To: <1413554226-12652-1-git-send-email-prarit@redhat.com>
References: <1413554226-12652-1-git-send-email-prarit@redhat.com>
Date: Fri, 17 Oct 2014 11:17:39 -0700
Message-ID: <CALAqxLWaVE2MG5HGigv-KJuOP1UgJrrLgOt+HueJx81h1dDX-w@mail.gmail.com>
Subject: Re: [PATCH] clocksource, Add warning to clocksource_delta()
 validation code
From: John Stultz <john.stultz@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 6:57 AM, Prarit Bhargava <prarit@redhat.com> wrote:
> A bug report came in against an older kernel which output "backward time"
> messages and the report noted that the upstream kernel worked.  After some
> investigation it turned out that one of the sockets was bad on the system
> and the "backward time" messages were caused by a real, but intermittent,
> hardware failure.
>
> Commit 09ec54429c6d10f87d1f084de53ae2c1c3a81108 ("clocksource: Move
> cycle_last validation to core code") modifies the x86 clocksource such that
> if a negative delta between two reads of time is calculated the
> clocksource_delta() code will return 0.  There is no warning when this
> occurs and there really should be one in order to catch not only hardware
> issues like the issue above, but potential coding issues as the code is
> modified.  This patch introduces a WARN() which will also dump a stack
> trace to the console so the exact code path can be evaluated.
>
> I tested this by booting on the broken hardware and left the system idle
> until a negative clocksource_delta() event occurred.
>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> ---
>  kernel/time/timekeeping_internal.h |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/time/timekeeping_internal.h b/kernel/time/timekeeping_internal.h
> index 4ea005a..abe6bc8 100644
> --- a/kernel/time/timekeeping_internal.h
> +++ b/kernel/time/timekeeping_internal.h
> @@ -17,7 +17,12 @@ static inline cycle_t clocksource_delta(cycle_t now, cycle_t last, cycle_t mask)
>  {
>         cycle_t ret = (now - last) & mask;
>
> -       return (s64) ret > 0 ? ret : 0;
> +       if ((s64)ret > 0)
> +               return ret;
> +
> +       WARN(1, "Clocksource calculated negative delta, %lld.  last = %llu, now = %llu, mask = %llx\n",
> +            (s64)ret, last, now, mask);
> +       return 0;


I realize you followed up that this wasn't finished, but just as some
feedback, there's a number of types of hardware where there may be a
very slight skew between cpu TSC, and this will briefly trigger right
after each timekeeping update if a system is reading the clock
frequently (think of the case where the update happens on the cpu
thats just a little bit ahead, while a timestamping loop is running on
a cpu that is a little bit behind).

So this warning would trigger quite often and be a bit alarming when
its really expected (well... more like unfortunate but handled)
behavior.

thanks
-john
