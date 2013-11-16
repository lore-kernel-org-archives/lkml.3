Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3KPORJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 09:17:09 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63203 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751914Ab3KPORE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 09:17:04 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, tianyu.lan@intel.com, nm@ti.com,
        jinchoi@broadcom.com, sebastian.capella@linaro.org
Subject: Re: [PATCH] cpufreq: suspend/resume governors with PM notifiers
Date: Sat, 16 Nov 2013 15:29:36 +0100
Message-ID: <2235672.LLJc6e6dny@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5286F536.70403@linaro.org>
References: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org> <5020664.HldDXMO8cr@vostro.rjw.lan> <5286F536.70403@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 16, 2013 10:01:50 AM viresh kumar wrote:
> On Saturday 16 November 2013 05:54 AM, Rafael J. Wysocki wrote:
> > Will cpufreq work during system-wide power transitions (suspend/resume etc.)
> > after this?  In particular, what about hibernation?
> 
> I am disabling governors as soon as we start suspend. So No, cpufreq wouldn't
> work during suspend/resume. But once system is resumed we are starting it back
> again.

Well, disabling it for the whole duration of suspend/resume and/or hibernation
may not be the right approach entirely, unless we force the pax perf of the
boot CPU at least in addition to that.  Otherwise the latency of suspend and
the subsequent resume will depend on what perf level the CPUs where before
disabling the governors, which is not desirable at al.

> Hibernation is probably not supported by my code yet.. I just went through
> hibernation code quickly and it looks we don't send PM_SUSPEND_PREPARE or
> PM_POST_SUSPEND notifications in case of hibernation. Correct?

Yes, that's correct.

> And these are the notifications that we send:
> - PM_HIBERNATION_PREPARE
> - PM_POST_HIBERNATION
> - PM_RESTORE_PREPARE
> - PM_POST_RESTORE
> 
> If I am not wrong I need to stop governors on PM_HIBERNATION_PREPARE and need to
> start them back on: PM_POST_HIBERNATION (I am a bit confused with this one. Does
> this POST_HIBERNATION one happens at the end of going into hibernation? or after
> booting back? I need a notifier at the end of restore)..

You'd need both PM_POST_HIBERNATION and PM_POST_RESTORE, but I wouldn't really
like cpufreq governors to be disabled throughout the whole hibernation.

Actually, we use CPU offline/online during system suspend/resume to avoid
having to do stuff like this from PM notifiers.  So I'd like the original
problem to be addressed in a different way.

Thanks!

PS
The sisk.pl address will start bouncing shortly, so please replace it with
rjw@rjwysocki.net in your address book.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
