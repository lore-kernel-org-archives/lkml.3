Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab3EQXmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 19:42:35 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57782 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab3EQXme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 19:42:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Olivier Doucet <webmaster@ajeux.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: Performance issue since 3.2.6
Date: Sat, 18 May 2013 01:51:11 +0200
Message-ID: <1426477.y1e3fnLN2J@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <519689F2.5070207@linux.vnet.ibm.com>
References: <CAPPqfY1-sYT8rcPoJ6BD0axq=oczq+xbGFSQj=uth4wc_cvkGw@mail.gmail.com> <CAPPqfY2ba5M27omZBwe0h26Eutyd+2KkLXht6uLN5VdjEKT_Ug@mail.gmail.com> <519689F2.5070207@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 18, 2013 01:20:10 AM Srivatsa S. Bhat wrote:
> On 05/17/2013 11:47 PM, Olivier Doucet wrote:
> > Hello,
> > 
> > This performance penalty is still present in kernel 3.9.2. And
> > CONFIG_PM cannot be deactivated anymore.
> > 
> > I was able to make a working 3.9.2 (meaning with no penalty)  with
> > following config and patch :
> > CONFIG_PM=y
> > CONFIG_PM_SLEEP=y
> > CONFIG_PM_SLEEP_SMP=y
> > CONFIG_CPU_IDLE=y
> > CONFIG_ACPI=y
> > CONFIG_ACPI_PROCESSOR=y
> > 
> > Patch : https://gist.github.com/odoucet/5600630
> > 
> > I know this patch is not perfect because it is just equivalent to
> > rollback commit f51d67a64f32cd81ea8b67ca964fb7cf7e783b2e ;
> > 
> > I really want this to be fixed in kernel, so I would be glad to test
> > any patch / config file you want.
> >
> 
> I went through your previous mails and here is what I think:
> I think this is not a regression that needs to be fixed. Instead it
> occurs to me that you started depending on the _flaw_ introduced by
> commit e8db0be124 (PM QoS: Move and rename the implementation files).
> 
> Your requirement is very simple: you don't want CPUs to go to deep
> idle states, since your benchmark is very performance critical.
> 
> Commit e8db0be124 made the mistake of returning 0 in pm_qos_request()
> when CONFIG_PM was unset. And that has the effect of disabling deeper
> idle states, which is exactly what you wanted.
> 
> But, as noted by commit d020283d (PM / QoS: CPU C-state breakage with
> PM Qos change), this is quite a bit wrong, because it makes the system
> consume a *lot* of CPU power, because the CPUs never go to idle states
> and instead keep polling.
> 
> Now, you might ask why is it wrong to set the default value to 0
> (IOW, disable deep idle states) when CONFIG_PM is unset? Again, commit
> d020283d answers that indirectly - not every power-management
> configuration falls under CONFIG_PM, like CONFIG_CPU_IDLE,
> CONFIG_INTEL_IDLE etc. So we need a sane default for pm_qos_request()
> when CONFIG_PM is unset, to prevent the power usage from shooting
> through the roof and surprising the user.
> 
> You started your comparisons with 3.2.0 which had commit e8db0be124
> included. If you had tried any previous kernel, I'm pretty sure that
> you would have found "performance penalties" too.
> 
> So, to summarize my thoughts:
>  - IMHO there is no regression here, you just depended on a bug included
>    in 3.2.0 (which made it behave like idle=poll with CONFIG_PM=n) and
>    started your comparisons from there. The later kernels (3.2.6+) got
>    that bug fixed which is why you saw "performance drops".
> 
>  - As much as we would like to do it, we can't set the value of
>    PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE to 0 when CONFIG_PM=n, because
>    CONFIG_PM doesn't encompass all power-management features (which is
>    a pity). Doing that would need a big overhaul of all the relevant
>    Kconfigs, which might or might not be worth the effort. (Because, who
>    says that CONFIG_PM=n kernels are supposed to eat power like crazy??)

I think it *is* worth the effort.  We could drop some CONFIG_PM* options in the
process which would simplify things quite a bit too.

> So here is my suggestion - use the interfaces provided by the kernel to
> fix your problem:
>    - you can give idle=poll in the kernel command line,
>    - OR you can echo 0 > /dev/cpu_dma_latency
> 
> Irrespective of your kernel configuration options (CONFIG_PM=y/n), the
> CPUs will not enter deep idle states, giving you the performance
> improvement that you are looking for.

Thanks a lot for the very clear explanation of this!

Rafael


> > 2013/2/12 Olivier Doucet <webmaster@ajeux.com>
> >>
> >> Hello,
> >>
> >> A quick update on my latest tests :
> >> I was able to compile a working 3.7.1 kernel (by 'working', I mean
> >> with no performance penalty). I'm sure 3.7.7 will be OK also (do you
> >> want me to test latest RC of 3.8 ?)
> >>
> >> I had to disable CONFIG_ACPI_PROCESSOR to disable power management.
> >> So now these two options are unset :
> >> CONFIG_CPU_IDLE
> >> CONFIG_ACPI_PROCESSOR
> >>
> >> I've posted the whole .config file here :
> >> https://gist.github.com/odoucet/4773390
> >>
> >> I'll be glad to test any patch that may help reactivate PM on my
> >> system (CPU Intel Xeon L5630)
> >>
> >> Olivier
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
