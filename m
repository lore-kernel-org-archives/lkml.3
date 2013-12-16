Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3LPMTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:19:55 -0500
Received: from canardo.mork.no ([148.122.252.1]:60033 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705Ab3LPMTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:19:51 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, jinchoi@broadcom.com,
        Paul Bolle <pebolle@tiscali.nl>,
        ziegler@email.mathematik.uni-freiburg.de,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        jbarnes@virtuousgeek.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: Regression with suspend resume 5a87182aa21d6d5d306840feab9321818dd3e2a3
Organization: m
References: <52A448F2.4010208@redhat.com>
	<CAKohpomO+0q7bFWTnFRgqoRuU2WryfPpFv0WLOCKtHBrLzLRqw@mail.gmail.com>
	<87iouprrcw.fsf@nemi.mork.no>
	<CAKohpok+EqA+ujCwzQvL2C7YAyfueGAd4XUXGqvdz2tm5_A0QQ@mail.gmail.com>
Date: Mon, 16 Dec 2013 13:19:17 +0100
In-Reply-To: <CAKohpok+EqA+ujCwzQvL2C7YAyfueGAd4XUXGqvdz2tm5_A0QQ@mail.gmail.com>
	(Viresh Kumar's message of "Mon, 16 Dec 2013 16:58:03 +0530")
Message-ID: <87eh5drnsq.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh Kumar <viresh.kumar@linaro.org> writes:

> Adding Rafael, I though he was there on this mail :)
>
> On 16 December 2013 16:32, Bjørn Mork <bjorn@mork.no> wrote:
>> It's both patches in combination.  Interesting case, really :-)
>
> Completed my testing now and yes this happened after your patch
> came in. I read your chats somewhere else as well (there are so
> many mails, bug reports on this topic, can't give link now.. :))..
>
> I think I know why we are facing issues with these two patches in
> at the same time.
>
> - My patch is actually disabling governors at suspend/resume or
> hibernation..
> - Which makes __cpufreq_governor() a nops routine, which simply
> returns zero
> - Now with your patch you are disabling the frozen feature which
> actually makes cpufreq core to free/allocate policies again on suspend
> resume. And so the calls like:
>
> __cpufreq_governor(policy, CPUFREQ_GOV_POLICY_INIT)
>
> end up doing nothing at resume when CPUs start coming up. And so
> cpufreq_resume()'s calls to __cpufreq_governor(policy,
> CPUFREQ_GOV_START) would start behaving badly.. Which is quite
> obvious..
>
> As a summary, after my patch to suspend/resume governors we can't
> allow policies to be freed and allocated back.

How do you deal with errors on suspend/resume then?  Are you always able
to keep the policies, for all error cases?

In any case: Splitting the suspend code between a cpu hotplug hook with
special "frozen" logic and a cpufreq_suspend() called from
dpm_suspend_noirq() confuses me, and I believe many others.  This is the
reason such a bug could be caused by two "obviously fine" patches.  So
please, at least keep the suspend logic in *one* place.

Or add a BIG comment both places, explaining the dependencies. This is
never going to become obvious, and it's not going to be easier when you
have more than 2 simple patches to look at.

> Its not really a war between my patch versus yours :), but I believe the
> right thing to do at this point is to get two patches in for 3.13 as well:
>
> 5a87182 cpufreq: suspend governors on system suspend/hibernate
> and patch discussed here:
> http://www.spinics.net/lists/cpufreq/msg08720.html

Yes, that would probably work fine, at least as long as nothing goes
wrong.  I must admit that I'm in no way able to play out all the
different error scenarios in my head, but won't there still be cases
where you end up freeing policies on suspend/resume?

> To finish this problem as early as possible I tested above two
> patches and didn't saw any regressions with suspend/resume or
> Hibernation.. And obviously this fixes your issues as well :)
>
> @Rafael: I understand that it would be difficult for you to take these
> now for 3.13 but they fix some serious problems reported earlier.
> Specially the first patch which everybody thought is the culprit :)
>
> Please see if we can manage to get them in :)

I think it needs serious testing with simulated errors first.  All error
labels should be executed at least once for all combinations of inputs.

Simply trying it out and verifying that it works in the no-error case is
not enough.  Which should be quite obvious now.



Bjørn
