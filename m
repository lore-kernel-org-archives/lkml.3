Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab3AWTXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 14:23:20 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:54534 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab3AWTXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 14:23:15 -0500
Date: Wed, 23 Jan 2013 12:23:06 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Add support for S3 non-stop TSC support.
Message-ID: <20130123192306.GB4039@obsidianresearch.com>
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
 <50FD8D07.5030908@linaro.org>
 <20130122195701.GH30647@obsidianresearch.com>
 <50FEF505.60504@linaro.org>
 <20130123002610.GA814@obsidianresearch.com>
 <50FF31D6.3090304@linaro.org>
 <20130123013710.GA1046@obsidianresearch.com>
 <50FF42CD.6010203@linaro.org>
 <20130123023523.GC1590@obsidianresearch.com>
 <50FF53D8.2070503@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FF53D8.2070503@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 07:07:04PM -0800, John Stultz wrote:

> But personally, I'm less fond of adding additional state to the
> clocksources, as I'm (admittedly, very) slowly trying to go the
> other way, and make the clocksources mostly state free. This is in
> part to allow for faster timekeeping updates (see:
> https://lkml.org/lkml/2012/3/2/66) - but again, I've not made much
> progress there recently, so this probably isn't a strong enough
> argument against it.

I think there should be ways to avoid storing the suspend time in the
clocksource struct, but since the suspend time is orthogonal to
timekeeping updates maybe it doesn't matter?

> Another downside is that accessing a clocksource can be costly, so
> doing so for every clocksource could unnecessarily slow
> suspend/resume down. Reading all the clocksources avoids the
> complexity of creating the secondary selection and management of a
> suspend-time measuring clocksource, but it also feels a little
> hackish to me. And iterating over the clocksource list requires
> exposing currently private clocksource data to the timekeeping core.

I was imagining these functions would be in the clocksource code and
called from suspend (clocksource_suspend_prepare,
clocksource_suspend_delta or some such). Not sure on iteration
expense, but you only need to look at clock sources that have a
active_during_suspend function pointer, so there would be various ways
to minimize the cost of finding that list, including precomputing it
during clocksource registration.

Generally there would be 0 or 1 active_during_suspend sources, I
expect. So in practice this probably boils down to locking only one
clocksource.

> The reason I like the idea of a new persistent_clock api, is that it
> formalizes existing usage, and doesn't require changes to the
> timekeeping logic, or to architectures that don't have running

Having seen ARM go through so many iterations of removing these sorts
of non-driver APIs and moving to dynamic bindings just makes it seem
wrong to add more, especially when the API is expected to work with
hardware already handled by a dynamically bound driver.

> But don't let my naysaying stop you from submitting a patch. It
> would be interesting to see your idea fully fleshed out.

Maybe Feng will try a v2 of his patch with some of these ideas? He has
hardware to test it :) I agree it would be clearer to see with code!!
 
> I appreciate your persistence here, and apologies for my thick-headed-ness.

NP

Regards,
Jason
