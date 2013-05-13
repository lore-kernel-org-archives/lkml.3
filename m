Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3EMH3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 03:29:22 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:18525 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3EMH3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 03:29:21 -0400
Date: Mon, 13 May 2013 09:29:04 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Imre Deak <imre.deak@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 01/11] time: add *_to_jiffies_min helpers to guarantee a
 minimum duration
Message-ID: <20130513092904.3ba12f9d@endymion.delvare>
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Imre,

On Fri, 10 May 2013 15:13:19 +0300, Imre Deak wrote:
> The *_to_jiffies(x) macros return a jiffy value, which if used as a
> delta to wait for a specific amount of time, may result in a wait-time
> that is less than x.

Are you sure? I have always considered that *_to_jiffies(x) macros
rounded up, and reading the code seems to confirm that:

	/*
	 * Generic case - multiply, round and divide. (...)
	 */
	(...)
	return (MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
		>> MSEC_TO_HZ_SHR32;

What makes you think the resulting wait time can be less that requested?

If this really is the case then the proper way to address the issue is
to fix the original macros, not introducing new ones.

> Many callers already compensate for this by adding
> one to the returned value.

This is an assumption from you, and I am afraid it is wrong in many
cases. I see that Michal Kubecek already pointed out one case where it
was indeed wrong, and I am about to make a similar reply to another
post of yours.

> To document why we need to add one and to get
> rid of some code duplication add a helper that does the same.

I'm sorry but you can't call "+ 1" code duplication.

> Later patches will convert the currently open-coded call sites to use
> the new helpers.
> 
> Also this can serve as a basis for auditing those users of *_to_jiffies
> that most likely do the wrong thing - for example set a timeout value of
> msecs_to_jiffies(1) - and converting them to use the new helpers.

You should be very, very careful before claiming that the code is wrong
and you're fixing it. It might as well be that the code is right but
you did not understand it, and you're actually breaking it. Or the code
was already wrong and you're making it worse ;)

As a summary, I don't like the idea, sorry.

-- 
Jean Delvare
