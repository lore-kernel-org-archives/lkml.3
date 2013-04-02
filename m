Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab3DBPwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:52:18 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:54845 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760123Ab3DBPwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:52:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130402154021.GA521@gulag1.americas.sgi.com>
References: <5159C147.70800@sgi.com>
	<1364847069-2887-1-git-send-email-nzimmer@sgi.com>
	<1364847069-2887-2-git-send-email-nzimmer@sgi.com>
	<CAKohpok7MR28trAddHRi5Lcg0bGBHBnOfJO=yu7SQqGnV5ZCRg@mail.gmail.com>
	<20130402145536.GA31757@gulag1.americas.sgi.com>
	<CAKohpokXbeRp-pHaJRAOjnF+R+wy8R9We67Yr2C2nyoVXyJd6w@mail.gmail.com>
	<20130402154021.GA521@gulag1.americas.sgi.com>
Date: Tue, 2 Apr 2013 21:22:15 +0530
Message-ID: <CAKohpo=6xeESG2DqET4WQFciHN6sX5Z7Jz9JbE6RC00BsV3bdA@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] cpufreq: split the cpufreq_driver_lock and use the rcu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 April 2013 21:10, Nathan Zimmer <nzimmer@sgi.com> wrote:
> My concern is in the cpufreq_register_driver.  Since we are only to set the
> pointer when it is null we have have to hold the lock over both operations.
>
> int cpufreq_register_driver(struct cpufreq_driver *driver_data)
> {
> ...
>         spin_lock_irqsave(&cpufreq_driver_lock, flags);
>         if (rcu_access_pointer(cpufreq_driver)) {
>                 spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
>                 return -EBUSY;
>         }
>         rcu_assign_pointer(cpufreq_driver, driver_data);
>         spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
>         synchronize_rcu();
> ...
> }

How will the lock help you here?? Lock is useful only when somebody
else who want to access it is waiting on the lock and we are updating
the pointer.

Because all other accesses to cpufreq_driver don't have any lock, this
lock is just a waste of time.
