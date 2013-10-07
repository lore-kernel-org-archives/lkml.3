Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab3JGSbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:31:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58699 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab3JGSbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:31:21 -0400
Message-ID: <5252FDCA.2080300@zytor.com>
Date: Mon, 07 Oct 2013 11:30:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86: Clean up cap_user_time* setting
References: <tip-nmgn0j0muo1r4c94vlfh23xy@git.kernel.org> <524F097A.9010506@intel.com> <20131004185539.GT15690@laptop.programming.kicks-ass.net> <20131006091054.GA4342@gmail.com> <5252EDBE.7030805@zytor.com> <20131007174037.GI3081@twins.programming.kicks-ass.net>
In-Reply-To: <20131007174037.GI3081@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 10:40 AM, Peter Zijlstra wrote:
> On Mon, Oct 07, 2013 at 10:22:06AM -0700, H. Peter Anvin wrote:
>> CONFIG_X86_TSC is a baseline control option; we shouldn't key
>> functionality off of it.  It's fine to say notsc -> no tracing, but
>> making it a compile-time key makes me a bit uphappy.  We cut off 386,
>> but cutting of 486 at this point makes me nervous.
> 
> The thing that annoys me about notsc is that it disables usage even if
> its present.

That is *exactly* what it is supposed to do.  It seems to do so poorly
at this point.  It should behave exactly as if the TSC isn't there (and
thus any feature which depends on the TSC is not available, either.)

> I've no problem with 486 which simply doesn't have TSC and thus
> cpu_has_tsc will be false and other stuff will happen -- and I don't
> think my proposition would actually change anything there.

Except it will be a lot harder to test it.

> What is completely insane is people using notsc on say a haswell chip
> and expecting something sane to happen.
>
> So I'm not proposing we remove !cap_has_tsc support; all I'm proposing
> is we remove the notsc knob that avoids using the TSC on perfectly good
> hardware.

Uh, no, that's broken.

There seem to be a couple of issues here:

1. We have keyed functionality off CONFIG_X86_TSC, which is a baseline
control option -- this is basically a no-no.

2. With CONFIG_X86_TSC turned on, notsc is meaningless: it means running
in a configuration that the kernel compile doesn't support

3. Functionality that depends on the TSC should be disabled at runtime
if !CONFIG_X86_TSC.

4. Does CONFIG_X86_TSC even make sense?  It isn't listed in
required-features.h and is only present in a handful of places in the
kernel, and the trace-clock bits seem just plain wrong.  It isn't
valuable to unload TSC support (which isn't what CONFIG_X86_TSC does as
it is currently configured) even on embedded (non-TSC hardware is rare
today)... so why do we even bother?

	-hpa

