Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbaDKPPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 11:15:18 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:53586 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbaDKPPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 11:15:16 -0400
Message-ID: <53480702.3080100@tilera.com>
Date: Fri, 11 Apr 2014 11:15:14 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, <mingo@kernel.org>,
        <tglx@linutronix.de>, <luto@amacapital.net>,
        <nicolas.pitre@linaro.org>, <daniel.lezcano@linaro.org>,
        <umgwanakikbuti@gmail.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/8] sched,idle,tile: Switch from TS_POLLING to TIF_POLLING_NRFLAG
References: <20140411134243.160989490@infradead.org> <20140411135218.242750053@infradead.org>
In-Reply-To: <20140411135218.242750053@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/2014 9:42 AM, Peter Zijlstra wrote:
> Standardize the idle polling indicator to TIF_POLLING_NRFLAG such that
> both TIF_NEED_RESCHED and TIF_POLLING_NRFLAG are in the same word.
> This will allow us, using fetch_or(), to both set NEED_RESCHED and
> check for POLLING_NRFLAG in a single operation and avoid pointless
> wakeups.
>
> Changing from the non-atomic thread_info::status flags to the atomic
> thread_info::flags shouldn't be a big issue since most polling state
> changes were followed/preceded by a full memory barrier anyway.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/tile/include/asm/thread_info.h |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

It's unfortunate that you're rolling the fetch_or() unconditionally out of cmpxchg(), since some architectures (like tilegx) do have support for "fetchor" as a primitive atomic operation.  Currently the tilegx fetchor is only exposed to architecture-independent code via set_bit() and test_and_set_bit(), but perhaps it's worth having an atomic_or() in atomic.h so architectures can choose to optimize it?

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

