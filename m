Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123AbaCSNic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:38:32 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51896 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934091AbaCSNi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:38:29 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Daniel <amit.daniel@samsung.com>
Subject: Re: [RFC V2] cpufreq: make sure frequency transitions are serialized
Date: Wed, 19 Mar 2014 14:53:59 +0100
Message-ID: <10055939.1CZiP7vyp7@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohpomr1s3SLs-K8+-BKguX4PyfHvSjyzd5PFjM4mJeyTj3-A@mail.gmail.com>
References: <2efc621827cbd96a05a3d34075154974b4816ecd.1394782795.git.viresh.kumar@linaro.org> <53296870.5010505@linux.vnet.ibm.com> <CAKohpomr1s3SLs-K8+-BKguX4PyfHvSjyzd5PFjM4mJeyTj3-A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 19, 2014 03:39:16 PM Viresh Kumar wrote:
> On 19 March 2014 15:20, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> > No, its not about burden. Its about the elegance of the design. We should
> > not be overly "smart" in the cpufreq core. Hiding the synchronization inside
> > the cpufreq core only encourages people to write buggy code in their drivers.
> 
> What kind of buggy code can be there? They are supposed to call notifiers
> in the order mentioned and so it shouldn't be a problem at all.. Don't know..
> 
> > Why don't we go with what Rafael suggested? We can have dedicated
> > begin_transition() and end_transition() calls to demarcate the frequency
> > transitions. That way, it makes it very clear how the synchronization is
> > done. Of course, these functions would be provided (exported) by the cpufreq
> > core, by implementing them using locks/counters/whatever.
> >
> > Basically what I'm arguing against, is the idea of having the cpufreq
> > core figure out what the driver _intended_ to do, from inside the
> > cpufreq_notify_transition() call.
> >
> > What I would prefer instead is to have the cpufreq driver do something
> > like this:
> >
> > cpufreq_freq_transition_begin();
> >
> > cpufreq_notify_transition(CPUFREQ_PRECHANGE);
> 
> Why do we need two routines then? What about doing notification from
> inside cpufreq_freq_transition_begin()?

We can do that in my opinion.

> This is a burden for driver writers, who don't normally understand the
> relevance of these calls in detail and may think, only the first one is
> enough or the second one is..
> 
> Its better if they simply let the core that they are starting to do transitions,
> i.e. cpufreq_freq_transition_begin() and then the core should send
> notifications.
> 
> > //perform the frequency change
> >
> > cpufreq_notify_transition(CPUFREQ_POSTCHANGE);
> >
> > cpufreq_freq_transition_end();
> >
> > [ASYNC_NOTIFICATION drivers will invoke the last two functions in a
> > separate context/thread.]
> 
> Same for the last two routines and yes they would be called from
> separate thread for ASYNC_NOTIFICATION drivers..

That'd be fine by me in principle.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
