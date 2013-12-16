Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3LPL2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:28:06 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:41513 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab3LPL2F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:28:05 -0500
MIME-Version: 1.0
In-Reply-To: <87iouprrcw.fsf@nemi.mork.no>
References: <52A448F2.4010208@redhat.com>
	<CAKohpomO+0q7bFWTnFRgqoRuU2WryfPpFv0WLOCKtHBrLzLRqw@mail.gmail.com>
	<87iouprrcw.fsf@nemi.mork.no>
Date: Mon, 16 Dec 2013 16:58:03 +0530
Message-ID: <CAKohpok+EqA+ujCwzQvL2C7YAyfueGAd4XUXGqvdz2tm5_A0QQ@mail.gmail.com>
Subject: Re: Regression with suspend resume 5a87182aa21d6d5d306840feab9321818dd3e2a3
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, jinchoi@broadcom.com,
        Paul Bolle <pebolle@tiscali.nl>,
        ziegler@email.mathematik.uni-freiburg.de,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        jbarnes@virtuousgeek.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Rafael, I though he was there on this mail :)

On 16 December 2013 16:32, Bjørn Mork <bjorn@mork.no> wrote:
> It's both patches in combination.  Interesting case, really :-)

Completed my testing now and yes this happened after your patch
came in. I read your chats somewhere else as well (there are so
many mails, bug reports on this topic, can't give link now.. :))..

I think I know why we are facing issues with these two patches in
at the same time.

- My patch is actually disabling governors at suspend/resume or
hibernation..
- Which makes __cpufreq_governor() a nops routine, which simply
returns zero
- Now with your patch you are disabling the frozen feature which
actually makes cpufreq core to free/allocate policies again on suspend
resume. And so the calls like:

__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_INIT)

end up doing nothing at resume when CPUs start coming up. And so
cpufreq_resume()'s calls to __cpufreq_governor(policy,
CPUFREQ_GOV_START) would start behaving badly.. Which is quite
obvious..

As a summary, after my patch to suspend/resume governors we can't
allow policies to be freed and allocated back.

Its not really a war between my patch versus yours :), but I believe the
right thing to do at this point is to get two patches in for 3.13 as well:

5a87182 cpufreq: suspend governors on system suspend/hibernate
and patch discussed here:
http://www.spinics.net/lists/cpufreq/msg08720.html

To finish this problem as early as possible I tested above two
patches and didn't saw any regressions with suspend/resume or
Hibernation.. And obviously this fixes your issues as well :)

@Rafael: I understand that it would be difficult for you to take these
now for 3.13 but they fix some serious problems reported earlier.
Specially the first patch which everybody thought is the culprit :)

Please see if we can manage to get them in :)

--
viresh
