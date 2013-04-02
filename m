Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab3DBPk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:40:27 -0400
Received: from relay2.sgi.com ([192.48.179.30]:49236 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932491Ab3DBPkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:40:23 -0400
Date: Tue, 2 Apr 2013 10:40:22 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Nathan Zimmer <nzimmer@sgi.com>, rjw@sisk.pl, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/2] cpufreq: split the cpufreq_driver_lock and use
	the rcu
Message-ID: <20130402154021.GA521@gulag1.americas.sgi.com>
References: <5159C147.70800@sgi.com> <1364847069-2887-1-git-send-email-nzimmer@sgi.com> <1364847069-2887-2-git-send-email-nzimmer@sgi.com> <CAKohpok7MR28trAddHRi5Lcg0bGBHBnOfJO=yu7SQqGnV5ZCRg@mail.gmail.com> <20130402145536.GA31757@gulag1.americas.sgi.com> <CAKohpokXbeRp-pHaJRAOjnF+R+wy8R9We67Yr2C2nyoVXyJd6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpokXbeRp-pHaJRAOjnF+R+wy8R9We67Yr2C2nyoVXyJd6w@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 08:29:12PM +0530, Viresh Kumar wrote:
> On 2 April 2013 20:25, Nathan Zimmer <nzimmer@sgi.com> wrote:
> > The lock is unneeded if we expect register and unregister driver to not be
> > called from muliple threads at once.  I didn't make that assumption.
> 
> Hmm.. But doesn't rcu part take care of that too?? Two writers
> updating stuff simultaneously?

My concern is in the cpufreq_register_driver.  Since we are only to set the
pointer when it is null we have have to hold the lock over both operations.

int cpufreq_register_driver(struct cpufreq_driver *driver_data)
{
...
        spin_lock_irqsave(&cpufreq_driver_lock, flags);
        if (rcu_access_pointer(cpufreq_driver)) {
                spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
                return -EBUSY;
        }
        rcu_assign_pointer(cpufreq_driver, driver_data);
        spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
        synchronize_rcu();
...
}


