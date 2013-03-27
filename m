Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab3C0D3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 23:29:45 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10598 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab3C0D3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 23:29:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 26 Mar 2013 20:29:19 -0700
Message-ID: <1364355211.22943.8.camel@bilhuang-vm1>
Subject: Re: [PATCH 1/5] clk: allow reentrant calls into the clk framework
From: Bill Huang <bilhuang@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        David Brown <davidb@codeaurora.org>
Date: Tue, 26 Mar 2013 20:33:31 -0700
In-Reply-To: <1362026969-11457-2-git-send-email-mturquette@linaro.org>
References: <1362026969-11457-1-git-send-email-mturquette@linaro.org>
	 <1362026969-11457-2-git-send-email-mturquette@linaro.org>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 12:49 +0800, Mike Turquette wrote:
> Reentrancy into the clock framework from the clk.h api is highly
> desirable.  This feature is necessary for clocks that are prepared and
> unprepared via i2c_transfer (which includes many PMICs and discrete
> audio chips) and it is also necessary for performing dynamic voltage &
> frequency scaling via clock rate-change notifiers.
> 
> This patch implements reentrancy by adding a global atomic_t which
> tracks the context of the current caller.  Context in this case is the
> return value from get_current().  The clk.h api implementations are
> modified to first see if the relevant global lock is already held and if
> so compare the global context (set by whoever is holding the lock)
> against their own context (via a call to get_current()).  If the two
> match then this function is a nested call from the one already holding
> the lock and we procede.  If the context does not match then procede to
> call mutex_lock and busy-wait for the existing task to complete.
> 
> Thus this patch set does not increase concurrency for unrelated calls
> into the clock framework.  Instead it simply allows reentrancy by the
> single task which is currently holding the global clock framework lock.
> 
> Thanks to Rajagoapl Venkat for the original idea to use get_current()
> and to David Brown for the suggestion to replace my previous rwlock
> scheme with atomic operations during code review at ELC 2013.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> Cc: David Brown <davidb@codeaurora.org>
> ---
Hi Mike,

Will this single patch be accepted? I guess you might not merge the
whole series but I think this one is useful, is it possible that you can
send out this single patch (or just merge this one) as an improvement of
CCF? Or you think otherwise?

Thanks,
Bill


