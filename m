Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaKJKo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:44:59 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:57109 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaKJKo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:44:57 -0500
MIME-Version: 1.0
In-Reply-To: <1415199239-19019-3-git-send-email-prarit@redhat.com>
References: <1415199239-19019-1-git-send-email-prarit@redhat.com>
	<1415199239-19019-3-git-send-email-prarit@redhat.com>
Date: Mon, 10 Nov 2014 16:14:57 +0530
Message-ID: <CAKohpomZNwZWjmi8hkZ6QXUeDTaXTwzx_fPz1_byh3xmmkPNrQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] cpufreq, fix locking around CPUFREQ_GOV_POLICY_EXIT calls
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Robert_Sch=C3=B6ne?= <robert.schoene@tu-dresden.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 November 2014 20:23, Prarit Bhargava <prarit@redhat.com> wrote:
> commit 955ef4833574636819cd269cfbae12f79cbde63a (" cpufreq: Drop rwsem
> lock around CPUFREQ_GOV_POLICY_EXIT") opens up a hole in the locking
> scheme for cpufreq.
>
> Simple tests such as rapidly switching the governor between ondemand and
> performance or attempting to read policy values while a governor switch occurs
> now fail with very NULL pointer warnings, sysfs namespace collisions, and
> system hangs.  In short, the locking that policy->rwsem is supposed to provide
> is currently broken.
>
> The identified commit attempts to resolve a lockdep warning by removing
> a lock around a section of code which does a shutdown of the
> existing policy.  The problem is that this is part of the _critical_ section of
> code that switches the governors and must be protected by the lock; without
> locking readers may access now NULL or stale data, and writes may collide with
> each other.
>
> With the previous patch, which now returns -EBUSY during times of
> contention the deadlock reported in
> 955ef4833574636819cd269cfbae12f79cbde63a (" cpufreq: Drop rwsem lock
> around CPUFREQ_GOV_POLICY_EXIT") cannot occur, so adding the locks back
> into this section of code is possible.

I still fail to understand why ? What will the _trylock() change ?
