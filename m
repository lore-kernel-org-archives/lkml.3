Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3KUWCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 17:02:01 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57044 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754338Ab3KUWB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 17:01:58 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpufreq: suspend/resume governors with PM notifiers
Date: Thu, 21 Nov 2013 23:14:39 +0100
Message-ID: <2642790.BqNcqy9aCb@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpo=e+0cpq5XfWpM6Jm0VrnzzAu-xybpucEG6sRL0ydBmLQ@mail.gmail.com>
References: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org> <1531674.UoqyyWSbOg@vostro.rjw.lan> <CAKohpo=e+0cpq5XfWpM6Jm0VrnzzAu-xybpucEG6sRL0ydBmLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 21, 2013 09:47:20 PM Viresh Kumar wrote:
> On 21 November 2013 20:08, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Wednesday, November 20, 2013 11:04:28 AM Viresh Kumar wrote:
> >> On 18 November 2013 11:09, viresh kumar <viresh.kumar@linaro.org> wrote:

[...]

> Replying here to the other mail as well:
> 
> On 21 November 2013 20:09, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Monday, November 18, 2013 09:37:39 PM Lan Tianyu wrote:
> >> Another point, I just see cpuidle_resume() and cpuidle_pause() are
> >> called in the dpm_resume_noirq and dpm_suspend_noirq(). Not sure whether
> >> this can be applied to cpufreq.
> >
> > I don't see why not.
> 
> Interesting. So you would be happy if I add such calls after freezing userspace
> and before restoring it back for cpufreq?

Short-term.  To be precise, governors may be stopped at the beginning of
dpm_suspend_noirq() (that is, where cpuidle_pause() is called).  Analogously,
they may be started again in dpm_resume_noirq(), where cpuidle_resume() is
called.  That at least would be consistent with what cpuidle already does.

That said in my opinion the appropriate long-term approach would be to split
CPU offline and online each into two parts, the "core" part and the "extras"
part, such that the "core" parts would only do the offline/online of the
cores themselves.  The rest, such as cpufreq/cpuidle "offline/online" would
be done in the "extras" part.

Then, system suspend/resume will only use the "core" parts of CPU offline/online
and the handling of the things belonging to "extras" would be carried out
through CPU device suspend/resume callbacks.  In turn, the "runtime" CPU offline
and online would carry out both the "extras" and "core" parts as it does today.

Makes sense?

Rafael

