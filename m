Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab3GQVnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 17:43:18 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47679 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651Ab3GQVnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 17:43:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Perches <joe@perches.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH v2] power: new trace event to print device suspend and resume time
Date: Wed, 17 Jul 2013 23:53:07 +0200
Message-ID: <1689154.aWqoy5pYBB@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1374079268.1949.102.camel@joe-AO722>
References: <1374076659-3444-1-git-send-email-shuah.kh@samsung.com> <B8EFE96D1287C24090BAD9D858E15E6173CA8D@sisaex02sj> <1374079268.1949.102.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 17, 2013 09:41:08 AM Joe Perches wrote:
> On Wed, 2013-07-17 at 16:30 +0000, Shuah Khan wrote:
> > On 07/17/2013 10:09 AM, Joe Perches wrote:
> > > On Wed, 2013-07-17 at 09:57 -0600, Shuah Khan wrote:
> > >> A new trace event is added to pm events to print time it takes to suspend and
> > >> resume a device. It generates trace message that includes device, driver,
> > >> parent information in addition to the type of pm ops invoked as well as the
> > >> pm event and error status from the pm ops. Example trace below:
> > >>
> > >> bash-2484  [001] ....   907.330148: device_pm_report_time: backlight acpi_video0 parent=0000:00:02.0 state=freeze ops=class  usecs=0 err=0
> > >>
> > >> bash-2484  [001] ....   909.906743: device_pm_report_time: backlight acpi_video0 parent=0000:00:02.0 state=restore ops=class  usecs=0 err=0
> []
> > > Given the data is in nsecs, why use usecs for the time?
> > > I think full resolution would be better.
> > 
> > My intent to was to match the time units to the original pm_print_times.
> 
> I don't think that maintaining consistency is
> useful in a new facility when you lose precision.
> 
> Also the accuracy is suspect as it's calculated with
> >>10 rather than an actual divide by 1000.

It's because that is way faster and we don't need great precision here.

> > Rafael! Do you have any preference as to usecs vs. nsecs?

The numbers in microseconds are easier to read, but I guess we can just
use nanoseconds and then process the output.

Thanks,
Rafael


> > > Why are there two spaces after "ops=class"? One would be more normal.
> 
> > This one is tough. The ops string that gets generated in conditionals in 
> > __device_suspend() and device_resume() routines, has an extra space at 
> > the end. I am not sure why that was done and the subsequent pr_* that 
> > print that string also depend on that extra space at the end. I don't 
> > have an easy way to fix it without changing lots of code where this 
> > string is generated.
> 
> I think the easiest way to "fix" it is to change
> the TP_printk format to:
> 
> 	TP_printk("%s %s parent=%s state=%s ops=%susecs=%lld err=%d",
> 
> > Hence, I chose to leave the extra space in. I also 
> > didn't want to propagate that assumption that there is an extra space 
> > into this new tracepoint.
> 
> It's a big deal, it just seemed untidy.
> 
> There are a couple of places in drivers/base/power/main.c
> where info is set to NULL.  I didn't look hard to see if
> any of those are propagated through to this point, but
> there are uses of 'info ?: ""' for some of the logging
> messages.  That _might_ an issue.
> 
> It looks like all the other logging message uses of info
> have "%s%s" so that proper word spacing is done when
> info is "" or NULL.
> 
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
