Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaLBJc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:32:28 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53482 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaLBJc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:32:26 -0500
Date: Tue, 2 Dec 2014 01:32:28 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] time: Fix sign bug in ntp mult overflow warning
Message-ID: <20141202093228.GA8792@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	John Stultz <john.stultz@linaro.org>,
	lkml <linux-kernel@vger.kernel.org>,
	"pang.xunlei" <pang.xunlei@linaro.org>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>
References: <20141122184506.GC29361@wfg-t540p.sh.intel.com>
 <1416890145-30048-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416890145-30048-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

On Mon, Nov 24, 2014 at 08:35:45PM -0800, John Stultz wrote:
> In commit 6067dc5a8c2b ("time: Avoid possible NTP adjustment mult
> overflow") a new check was added to watch for adjustments that could
> cause a mult overflow.
> 
> Unfortunately the check compares a signed with unsigned value and
> ignored the case where the adjustment was negative, which causes
> spurious warn-ons on some systems (and seems like it would result in
> problematic time adjustments there as well, due to the early
> return).
> 
> Thus this patch adds a check to make sure the adjustment is positive
> before we check for an overflow, and resovles the issue in my
> testing.
> 
> Cc: pang.xunlei <pang.xunlei@linaro.org>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Debugged-by: pang.xunlei <pang.xunlei@linaro.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  kernel/time/timekeeping.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 29a7d67..2dc0646 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -1330,7 +1330,7 @@ static __always_inline void timekeeping_apply_adjustment(struct timekeeper *tk,
>  	 *
>  	 * XXX - TODO: Doc ntp_error calculation.
>  	 */
> -	if (tk->tkr.mult + mult_adj < mult_adj) {
> +	if ((mult_adj > 0) && (tk->tkr.mult + mult_adj < mult_adj)) {
>  		/* NTP adjustment caused clocksource mult overflow */
>  		WARN_ON_ONCE(1);
>  		return;

This change does quiet the warning but I think it does so for the wrong
reason.

mult_adj is a signed number and tk->tkr.mult is an unsigned number.
Adding the check that (mult_adj > 0) limits the test to only positive
numbers.  A positive number plus a positive number will never be less
than either of the two positive numbers.  The test is always false.

-- 
- Jeremiah Mahler
