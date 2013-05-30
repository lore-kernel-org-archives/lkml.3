Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947Ab3E3Thl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:37:41 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55076 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759827Ab3E3Thh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:37:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>
Subject: Re: System slow down from udev
Date: Thu, 30 May 2013 21:46:31 +0200
Message-ID: <6588324.67kEAqTjyb@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQU=kC7J2Ocqy-Bq8rN-pO_2gDOrngwev_be70j=LLSpUg@mail.gmail.com>
References: <CAE9FiQUbSeCGTsukX3zfVYBhFKgWfVd8WDDvpix==wSXzc=RVQ@mail.gmail.com> <4462684.QmYxzGRhx8@vostro.rjw.lan> <CAE9FiQU=kC7J2Ocqy-Bq8rN-pO_2gDOrngwev_be70j=LLSpUg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 30, 2013 10:42:09 AM Yinghai Lu wrote:
> On Thu, May 30, 2013 at 9:36 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, May 30, 2013 04:45:35 PM Rafael J. Wysocki wrote:
> >> On Thursday, May 30, 2013 04:34:51 PM Rafael J. Wysocki wrote:
> > [...]
> >> >
> >> > I'll try to dig deeper locally in the meantime.
> >>
> >> Actually, I think I know what the problem is, but I need some more time to
> >> debug it.  Fortunately, I'm able to see some symptoms. :-)
> >
> > OK, one fix is appended, but there still is one more bug I need to investigate.
> >
> > Please check if this one helps, though.
> 
> yes, that fix the problem.

Great!

> > ---
> >  drivers/acpi/acpi_processor.c   |    5 +++++
> >  drivers/acpi/processor_driver.c |    3 ---
> >  2 files changed, 5 insertions(+), 3 deletions(-)
> >
> > Index: linux-pm/drivers/acpi/processor_driver.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/processor_driver.c
> > +++ linux-pm/drivers/acpi/processor_driver.c
> > @@ -78,9 +78,6 @@ static struct device_driver acpi_process
> >         .remove = acpi_processor_stop,
> >  };
> >
> > -DEFINE_PER_CPU(struct acpi_processor *, processors);
> > -EXPORT_PER_CPU_SYMBOL(processors);
> > -
> >  static void acpi_processor_notify(acpi_handle handle, u32 event, void *data)
> >  {
> >         struct acpi_device *device = data;
> > Index: linux-pm/drivers/acpi/acpi_processor.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/acpi_processor.c
> > +++ linux-pm/drivers/acpi/acpi_processor.c
> > @@ -29,6 +29,9 @@
> >
> >  ACPI_MODULE_NAME("processor");
> >
> > +DEFINE_PER_CPU(struct acpi_processor *, processors);
> > +EXPORT_PER_CPU_SYMBOL(processors);
> > +
> >  /* --------------------------------------------------------------------------
> >                                  Errata Handling
> >     -------------------------------------------------------------------------- */
> > @@ -387,6 +390,7 @@ static int __cpuinit acpi_processor_add(
> >          * checks.
> >          */
> >         per_cpu(processor_device_array, pr->id) = device;
> > +       per_cpu(processors, pr->id) = pr;
> >
> >         dev = get_cpu_device(pr->id);
> >         result = acpi_bind_one(dev, pr->handle);
> > @@ -406,6 +410,7 @@ static int __cpuinit acpi_processor_add(
> >   err:
> >         free_cpumask_var(pr->throttling.shared_cpu_map);
> >         device->driver_data = NULL;
> > +       per_cpu(processors, pr->id) = NULL;
> >   err_free_pr:
> >         kfree(pr);
> >         return result;
> >
> 
> do you need to remove
>     per_cpu(processors, pr->id) = NULL;
> from processor_driver.c::acpi_processor_stop ?

Yes, thanks for noticing that!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
