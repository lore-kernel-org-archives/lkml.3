Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaHEWmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 18:42:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbaHEWmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 18:42:09 -0400
Message-ID: <53E15DBB.7080800@redhat.com>
Date: Tue, 05 Aug 2014 18:42:03 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem
 to be held for duration of changing governors [v2]
References: <1406634362-811-1-git-send-email-prarit@redhat.com> <2066166.pXm4lKLOID@vostro.rjw.lan> <53DA8389.80804@redhat.com> <1917362.abr2Y4p7vh@vostro.rjw.lan> <53DA8A41.2030601@redhat.com> <53DAA60B.6040802@codeaurora.org> <53DAA749.5080506@redhat.com> <53DAA95B.2040505@codeaurora.org> <53DAB038.3050007@redhat.com> <53DABFA6.6090503@codeaurora.org> <53DACA26.1000908@redhat.com> <53DAE592.2030909@codeaurora.org> <53DB6B81.6050400@redhat.com> <53DBCBE8.6010809@codeaurora.org> <53DBE764.8050109@redhat.com> <53DBEC27.7050803@codeaurora.org> <CAKohpombG3Gj4mbm02vPNnAxzaRvQP7rb=iQ14dCFH4_+71H3w@mail.gmail.com> <53E0B657.4070007@redhat.com> <CAKohponxBdYEgY2oYuzmdaqfSRS8Uq8bZOzcb1QDmKO-z5ZBFQ@mail.gmail.com> <53E1556B.5070304@codeaurora.org>
In-Reply-To: <53E1556B.5070304@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So back to the original problem, which in short, revolves around these two
functions (with comments included by me):

/* called with kernfs rwsem for this kobj held */
static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
{
        struct cpufreq_policy *policy = to_policy(kobj);
        struct freq_attr *fattr = to_attr(attr);
        ssize_t ret;

        if (!down_read_trylock(&cpufreq_rwsem))
                return -EINVAL;

        down_read(&policy->rwsem);


and

static ssize_t store(struct kobject *kobj, struct attribute *attr,
                     const char *buf, size_t count)
{
        struct cpufreq_policy *policy = to_policy(kobj);
        struct freq_attr *fattr = to_attr(attr);
        ssize_t ret = -EINVAL;

        get_online_cpus();

        if (!cpu_online(policy->cpu))
                goto unlock;

        if (!down_read_trylock(&cpufreq_rwsem))
                goto unlock;

        down_write(&policy->rwsem);

        /* if governor switch, calls sysfs_remove_group
         * and acquires kernfs rwsem for this kobj */

There's another bug here which I haven't had a chance to discuss.  There's the
possibility that we have multiple threads waiting at the store's
down_write(&policy->rwsem) when another thread does a governor switch.  When
the policy->rwsem is released by the governor switch thread, all the other
threads will enter this code path and race through while looking at stale data.

We hit some NULL pointers (very similar to the ones originally reported in this
thread) and, of course, the system dies.

I wonder if the show() down_read(&policy->rwsem) needs to be a
down_read_trylock(), and similarily in the store the down_write(&policy->rwsem)
needs to be a down_write_trylock() ?

We would also have to do a check on policy->governor_enabled to verify that
the data was still valid after taking the lock.

*If* we were to make this change, does that also happen to fix the risk of a
deadlock in this code?

That might be too hacky ... gotta be a better way :/ ...

Anyway, just a thought.

P.
