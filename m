Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab3JYJyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 05:54:04 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:37724 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3JYJyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 05:54:01 -0400
MIME-Version: 1.0
In-Reply-To: <1483174.NsuFf8aJk6@vostro.rjw.lan>
References: <525BD08C.2080101@t-online.de>
	<CA+55aFyPffR=kt4njmB7oG012kayrKJPsP-u5JR+s7rERjofCg@mail.gmail.com>
	<2582195.phiuskXt0x@vostro.rjw.lan>
	<1483174.NsuFf8aJk6@vostro.rjw.lan>
Date: Fri, 25 Oct 2013 15:24:00 +0530
Message-ID: <CAKohpoma68h0mh2kqQYR5ohf=nKMtu8A7y0+9hnCE+fRRpm+Cw@mail.gmail.com>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 October 2013 15:21, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Friday, October 25, 2013 11:28:02 AM Rafael J. Wysocki wrote:
>> On Friday, October 25, 2013 10:02:22 AM Linus Torvalds wrote:

>> > This particular cpufreq issue may be triggered by the fact that
>> > acpi-cpufreq isn't actually in use (pstate is). Or it might be some
>> > generic cpufreq/sysfs bug. Rafael, Greg, ideas?
>>
>> I *think* that this indeed is related to acpi-cpufreq being unused.  That said,
>> we've been fixing sysfs-related bugs in cpufreq recently and we may have
>> overlooked something.

I agree.. Recently I have tested few other cpufreq drivers for module
insert/removal along with governors insertion/removal... So that part must
be okay..

> Well, if the ACPI cpufreq driver is not registered, the exit function of the
> module shouldn't try to unregister it, so I have the appended patch (untested)
> to fix that particular thing.
>
> Rafael
>
>
> ---
>  drivers/cpufreq/acpi-cpufreq.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> Index: linux-pm/drivers/cpufreq/acpi-cpufreq.c
> ===================================================================
> --- linux-pm.orig/drivers/cpufreq/acpi-cpufreq.c
> +++ linux-pm/drivers/cpufreq/acpi-cpufreq.c
> @@ -982,6 +982,8 @@ static void __exit acpi_cpufreq_boost_ex
>         }
>  }
>
> +static bool driver_registered;
> +
>  static int __init acpi_cpufreq_init(void)
>  {
>         int ret;
> @@ -1021,10 +1023,12 @@ static int __init acpi_cpufreq_init(void
>  #endif
>
>         ret = cpufreq_register_driver(&acpi_cpufreq_driver);
> -       if (ret)
> +       if (ret) {
>                 free_acpi_perf_data();
> -       else
> +       } else {
>                 acpi_cpufreq_boost_init();
> +               driver_registered = true;
> +       }
>
>         return ret;
>  }
> @@ -1032,6 +1036,8 @@ static int __init acpi_cpufreq_init(void
>  static void __exit acpi_cpufreq_exit(void)
>  {
>         pr_debug("acpi_cpufreq_exit\n");
> +       if (!driver_registered)
> +               return;
>
>         acpi_cpufreq_boost_exit();

Looks like the right solution here. But this kind of issues look to
be somewhat generic, doesn't they? And probably most of the
drivers would be struggling with such issues.. They are working
because we normally have something like this in core unregister
parts:

int cpufreq_unregister_driver(struct cpufreq_driver *driver)
{
...
        if (!cpufreq_driver || (driver != cpufreq_driver))
                return -EINVAL;
....

So, even in this case if we could actually check return value of
cpufreq_unregister_driver() and then do the other stuff, then we
wouldn't require this extra variable..

But the problem is the order in which things happen. Would this
be a big problem if we do unregister first and then
acpi_cpufreq_boost_exit(), based on what unregister returned?
