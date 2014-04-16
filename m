Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbaDPUmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:42:11 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:37534 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756439AbaDPUmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:42:08 -0400
Date: Wed, 16 Apr 2014 21:41:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Pavel Machek <pavel@ucw.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH RFC] PM / Hibernate: no kernel_power_off when
	pm_power_off NULL
Message-ID: <20140416204119.GJ24070@n2100.arm.linux.org.uk>
References: <1395348795-8554-1-git-send-email-sebastian.capella@linaro.org> <1395348795-8554-2-git-send-email-sebastian.capella@linaro.org> <20140320212336.GA17368@amd.pavel.ucw.cz> <20140320213502.795a5d3c@alan.etchedpixels.co.uk> <CADHgK6uXg0CXZC5s5Z5Kpy6dYH58UChL-p9ozCCcoUU=-0KJYw@mail.gmail.com> <CADHgK6sh6TUc4jBQFQHTQuhze9=r2FBzF6aULUc_c+bbWYjp5w@mail.gmail.com> <CADHgK6sCmPVZ--eyEnqnjfs_4C_PfHTgAUQ_Nb4oJP0mBDnQUw@mail.gmail.com> <20140415205453.GX24070@n2100.arm.linux.org.uk> <20140415211832.GA32213@amd.pavel.ucw.cz> <CADHgK6vzagyELYGnVoHvfnK9G57-NSycOaKsNQ53rnU1pOwn=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADHgK6vzagyELYGnVoHvfnK9G57-NSycOaKsNQ53rnU1pOwn=Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 09:28:28AM -0700, Sebastian Capella wrote:
> On 15 April 2014 14:18, Pavel Machek <pavel@ucw.cz> wrote:
> > On Tue 2014-04-15 21:54:53, Russell King - ARM Linux wrote:
> >> What I'm basically saying is that I see no reason for ARM to do something
> >> different to what x86 does.
> >>
> >> What is pretty clear to me is that ARM is compatible with x86, which is
> >> compatible with kernel/reboot.c, and it's the hibernate code which is
> >> the odd one out.
> >
> > I'm pretty sure the original code did not return. Anyway, the best
> > solution, given how many platforms are out there, would be to
> >
> > a) document that it should not return
> >
> > b) fix hibernation to handle the returning case, anyway.
> 
> Thanks Russell and Pavel!
> 
> This sounds fine to me.  Any objections?

Here is the i386 code from 2.2.20:

void machine_halt(void)
{
}

void machine_power_off(void)
{
        if (acpi_power_off)
                acpi_power_off();
}

Both can return.  On the other hand, machine_restart() can never return as
the final attempt to perform that action in machine_real_restart is a jump
to 16-bit code.

2.4 kernels then modified it to this:

void machine_halt(void)
{
}

void machine_power_off(void)
{
        if (pm_power_off)
                pm_power_off();
}

with machine_restart() doing similar to v2.2.

2.6.0 also did the same as 2.4 kernels.  2.6.16 then changed to this:

void machine_restart(char * __unused)
{
        machine_shutdown();
        machine_emergency_restart();
}

void machine_halt(void)
{
}

void machine_power_off(void)
{
        if (pm_power_off) {
                machine_shutdown();
                pm_power_off();
        }
}

which starts adding some extra stuff into the power off hook - but
again, it's a no-op unless the pm_power_off function pointer is
initialised.

Today, it's:

void machine_power_off(void)
{
        machine_ops.power_off();
}

which calls native_power_off():

static void native_machine_power_off(void)
{
        if (pm_power_off) {
                if (!reboot_force)
                        machine_shutdown();
                pm_power_off();
        }
        /* A fallback in case there is no PM info available */
        tboot_shutdown(TB_SHUTDOWN_HALT);
}

and tboot_shutdown():

void tboot_shutdown(u32 shutdown_type)
{
        void (*shutdown)(void);

        if (!tboot_enabled())
                return;

so it's entirely possible today for machine_power_off() on x86 to return.

So... the i386 code has had this "machine_power_off() can return"
behaviour for a significant number of years and persists to this day.

I'd say scrap (a) _unless_ we're going to add while (1) loops to all
the architectures.  Alternatively, we could just accept that
machine_power_off() may return and deal with that case (iow, not
crash) in generic code.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
