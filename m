Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab3IZGYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:24:11 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:50865 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3IZGYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:24:10 -0400
MIME-Version: 1.0
In-Reply-To: <524365FA.4090108@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
	<acd1cc837f969a50582d2b25a73c5e247f40f843.1379779777.git.viresh.kumar@linaro.org>
	<524365FA.4090108@linaro.org>
Date: Thu, 26 Sep 2013 11:54:09 +0530
Message-ID: <CAKohpong15qzFg_sZVB77wVm4gu-4Se1E=eqvJOv96fgnyMXDA@mail.gmail.com>
Subject: Re: [PATCH 20/21] cpuidle: don't calculate time-diff if entered_state
 == 0
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2013 04:08, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> On 09/22/2013 03:21 AM, Viresh Kumar wrote:
>> If entered_state == 0, we don't need to set dev->last_residency to 'diff' as we
>> will be setting it to zero without using its new value.
>
> I don't get it, can you elaborate.

Sure.. We have following code in cpuidle_enter_state():

---------
        diff = ktime_to_us(ktime_sub(time_end, time_start));
        if (diff > INT_MAX)
                diff = INT_MAX;

        dev->last_residency = (int) diff;

        if (entered_state >= 0) {
                /* Update cpuidle counters */
                /* This can be moved to within driver enter routine
                 * but that results in multiple copies of same code.
                 */
                dev->states_usage[entered_state].time += dev->last_residency;
                dev->states_usage[entered_state].usage++;
        } else {
                dev->last_residency = 0;
        }
-------

We are setting last_residency to 0 when (entered_state < 0) and aren't using
the value of "diff". So, we can actually skip calculations of time_end, diff and
last_residency when (entered_state < 0).. Makes sense?


> We can be a long time in this state
> (eg. if the prediction is false).

Okay.. I didn't get it :)
