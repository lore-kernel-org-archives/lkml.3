Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab3HSXLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:11:35 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50377 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab3HSXLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:11:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH V2 07/11] cpufreq: Use cpufreq_policy_list for iterating over policies
Date: Tue, 20 Aug 2013 01:22:05 +0200
Message-ID: <6607838.UAT3ZUDseh@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohponkLac2GzZ5-PRoTzdx8EhuCWT-eafRtYhkJ6cN_WrXSA@mail.gmail.com>
References: <cover.1375809311.git.viresh.kumar@linaro.org> <1582060.zfvsylJcxu@vostro.rjw.lan> <CAKohponkLac2GzZ5-PRoTzdx8EhuCWT-eafRtYhkJ6cN_WrXSA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 19, 2013 04:57:19 PM Viresh Kumar wrote:
> On 18 August 2013 19:36, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > I noticed that the current linux-next branch of linux-pm.git caused the
> > BUG_ON() in lock_policy_rwsem_##mode() to trigger when user space tried to
> > access cpufreq sysfs attributes before system suspend and after system
> > resume.
> 
> Hmm...
> 
> > I tried to debug that and it turned out that this patch caused resume
> > to block indefinitely on one of my test machines and after reverting it the
> > BUG_ON() stopped triggering, so I've just reverted it in my tree (it is not an
> > important change).
> >
> > I don't have the time to figure out why this change breaks things
> 
> It wasn't my patch actually.. It only made it visible that's it :)
> The problem is:
> - On suspend all CPUs are removed and so governors are
> stopped.
> - On resume, handle_update() is called for the boot cpu and
> cpu_add_dev for all others.
> 
> handle_update() doesn't start governor but only plays with
> CPUFREQ_GOV_LIMITS.. when we start adding other
> CPUs and call: cpufreq_add_policy_cpu() which fails in
> following call:
> 
> __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> 
> and so cpufreq_policy_cpu never gets initialized to
> policy->cpu and stays at -1, and hence the crash.
> 
> So, there are few problems with core at this point:
> - I don't understand how does the work done in
> cpufreq_add_dev() gets done for boot cpu during
> resume ? And so how does Srivatsa's "frozen" solution
> really works (I haven't had time to investigate, its not
> that I couldn't understand it :) )..
> 
> - We need to start governor boot cpu in handle_update()
> and things would be solved...
> 
> > and I would
> > appreciate it if you tested stuff like suspend/resume on an x86 laptop or
> > similar with your patches applied before posting them for merging.
> 
> suspend/resume is broken on my ARM board and that's why
> didn't test it..
> 
> Testing anything on my thinkpad (with ubuntu) is a pain.. it takes
> more than an hour to compile/test a single image... I currently follow
> below steps for doing that, don't know if something much
> simpler/faster is available :)
> 
> https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
> 
> Whole day I was able to boot test only 4-5 kernel builds.
> Its too slow :(

Well, that's a matter of setting up a workspace, basically.

As a general rule, you should be able test the changes you're making on
hardware that they are supposed to run on.  If that's something not very
easy to acquire, like s390, you can make an excuse of not having access to
that hardware and hope that someone will test the changes for you (or ACKs
them without testing, because they are "obviously" correct).  However, if
that's ACPI-compatible x86, that excuse pretty much doesn't work, because
you can find those things everywhere.

I have no experience with building kernels on Ubuntu to be honest, as I've been
using openSUSE as my testbed distro for several years.

>From my experience, however, it is good to figure out what needs to be included
into your test kernel and configure away everything else.  Also, I'd recommend
to build as much as possible into the kernel image and avoid compiling too many
modules, because installing modules takes time too (ideally, if you can get
away without any modules at all, that's the best option timing-wise).  Just
select only the drivers that you're going to use and unset all of the options
that don't apply to your test machine.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
