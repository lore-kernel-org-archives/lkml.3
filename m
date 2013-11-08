Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab3KHFGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 00:06:22 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:50455 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab3KHFGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 00:06:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAFgnuDe3xF4W6jpFO+aGuyKaYjj-4swGQcR3fE-OVHyeVhsG5g@mail.gmail.com>
References: <1383791330-8289-1-git-send-email-chenxg@marvell.com>
	<CAKohpo=2xjR=nr5hyMg9bve5_uVbV79R2FTxks0bLmL7kNV9Mg@mail.gmail.com>
	<CADmjqpNWYVxrXuo106rBuZeZ2BrkGFkmbMJ8jxi39c8kLiQ+iw@mail.gmail.com>
	<CAKohpon6DhiWMuszuznK4ZNCBTpy0_r3gGvTXCDMcktXpN3HEw@mail.gmail.com>
	<CAFgnuDe3xF4W6jpFO+aGuyKaYjj-4swGQcR3fE-OVHyeVhsG5g@mail.gmail.com>
Date: Fri, 8 Nov 2013 10:36:19 +0530
Message-ID: <CAKohpo=-mTWo+tsKy7smeC4kvY6d8_t2ciTECrRu4rLTA+-hJg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: conservative: fix requested_freq reduction issue
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Xiaoguang Chen <chenxg.marvell@gmail.com>
Cc: Stratos Karafotis <skarafotis@gmail.com>,
        Xiaoguang Chen <chenxg@marvell.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2013 10:31, Xiaoguang Chen <chenxg.marvell@gmail.com> wrote:
> Hi, Viresh, Sorry for the late reply.

That's fine :)

> I'll prepare the patch.

Thanks.

> BTW, do you think we should set requeste_freq to policy->max when such
> condition happens?

I thought about that earlier, but then thought this would be a cleaner solution.
And guess what, I was wrong.. There is one scenario for which we need to
set requested_freq correctly..

Suppose we have requested_freq currently greater than policy->max and load
decreases. We will start decreasing requested_freq but it will take
one iteration
to make it equal to max, which is not we want.. So we actually need to set
it to max when it gets over it.

So, don't do the change I asked for, i.e. replacing == with >=. But
update existing
code:

dbs_info->requested_freq += get_freq_target(cs_tuners, policy);

this way:

dbs_info->requested_freq += get_freq_target(cs_tuners, policy);
if (dbs_info->requested_freq > policy->max)
    dbs_info->requested_freq = policy->max;
