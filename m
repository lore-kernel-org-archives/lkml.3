Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964939AbaCSMza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:55:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933482AbaCSMz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:55:28 -0400
Date: Wed, 19 Mar 2014 13:54:56 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, bp@suse.de, paul.gortmaker@windriver.com,
        JBeulich@suse.com, drjones@redhat.com, toshi.kani@hp.com,
        x86@kernel.org, riel@redhat.com, gong.chen@linux.intel.com
Subject: Re: [PATCH 0/3] x86: fix hang when AP bringup is too slow
Message-ID: <20140319135456.4a74a2ea@nial.usersys.redhat.com>
In-Reply-To: <532984A9.8080001@redhat.com>
References: <1394720720-8484-1-git-send-email-imammedo@redhat.com>
	<53283A3F.6040302@redhat.com>
	<20140318194951.17fd61ea@thinkpad>
	<532984A9.8080001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2014 07:51:05 -0400
Prarit Bhargava <prarit@redhat.com> wrote:

> 
> 
> On 03/18/2014 02:49 PM, Igor Mammedov wrote:
> > On Tue, 18 Mar 2014 08:21:19 -0400
> > Prarit Bhargava <prarit@redhat.com> wrote:
> > 
> >>
> >>
> >> On 03/13/2014 10:25 AM, Igor Mammedov wrote:
> >>> Hang is observed on virtual machines during CPU hotplug,
> >>> especially in big guests with many CPUs. (It happens more
> >>> often if host is over-committed).
> >>>
> >>
> >> Hey Igor, I like this better than the previous version.  Thanks for taking into
> >> account the possible races in this code.
> >>
> >> A quick question on system behaviour.  As you know I've been more concerned
> >> lately with error handling, etc., through the cpu hotplug code as we've seen
> >> several customer reports of silent failures or cascading failures in the cpu
> >> hotplug code when users have been attempting to perform physical hotplug.
> >>
> >> After your patches have been applied, in theory the following can happen:
> >>
> >> The master CPU is completing the AP cpu's bring up.  The AP cpu is doing (sorry
> >> for the cut-and-paste),
> >>
> >> void cpu_init(void)
> >> {
> >>         int cpu = smp_processor_id();
> >>         struct task_struct *curr = current;
> >>         struct tss_struct *t = &per_cpu(init_tss, cpu);
> >>         struct thread_struct *thread = &curr->thread;
> >>
> >>         /*
> >>          * wait till the master CPU completes it's STARTUP sequence,
> >>          * and decides to wait till this AP boots
> >>          */
> >>         while (!cpumask_test_cpu(cpu, cpu_callout_mask)) {
> >>                 cpu_relax();
> >>                 if (per_cpu(x86_cpu_to_apicid, cpu) == BAD_APICID)
> >>                         halt();
> >>         }
> >>
> >> and is spinning on cpu_relax().  Suppose something goes wrong and the softlockup
> >> watchdog fires on the AP cpu:
> >>
> >> 1.  Can it? :) ie) will the softlockup fire at this point of the AP init?  Okay,
> >> I'm being really lazy and not looking at the code ;)
> > It shouldn't, CPU is in pristine state and just came from boot trampoline at
> > this point without interrupts configured yet.
> 
> Okay, not a big problem.
> 
> > 
> >>
> >> 2.  Is there anything we can do in this code to notify the user of a problem?
> >> Even a pr_crit() here I think would help to indicate what went wrong; it might
> >> be useful for future debugging in this area to have some sort of output.  I
> >> think a WARN() or BUG() is necessary here as there are several calls to cpu_init().
> > Do you mean something like this:
> > 
> > +		if (per_cpu(x86_cpu_to_apicid, cpu) == BAD_APICID) {
> > +                       WARN(1);
> > +			halt();
> > +               }
> 
> Yeah, maybe WARN_ON(1, "some comment") though.
printk at so early stage might be cause issues, since it is quite complex.
Its' disabling/enabling irqs, calls *_delay_*() functions and takes locks.
The last is especially dangerous because if AP is shot down by another
INIT/SIPI, system will hang on next printk if locks were acquired by AP
at that time.
That case is possible if master CPU has got errors during wakeup_ap() and
failed cpu_up() then it was unplugged + plugged via ACPI and attempted
to be onlined again. 

It's much safer not to do anything complex at AP start-up so early.

BTW:
when AP reaches halt() line, failure is not silent. the master CPU might
print error message if debug level logging is active:
see arch/x86/kernel/smpboot.c:native_cpu_up()
...
        if (err) {
                pr_debug("do_boot_cpu failed %d\n", err);
                return -EIO;
        }
...

perhaps we should change pr_debug to pr_crit here to make it more visible.
something like:

@@ -858,7 +858,7 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 
        err = do_boot_cpu(apicid, cpu, tidle);
        if (err) {
-               pr_debug("do_boot_cpu failed %d\n", err);
+               pr_crit("do_boot_cpu failed(%d) to wakeup CPU#%u\n", err, cpu);
                return -EIO;
        }


> 
> > 
> >>
> >> 3.  Change this comment:
> >>
> >>          * wait till the master CPU completes it's STARTUP sequence,
> >>          * and decides to wait till this AP boots
> >>
> >> to
> >>
> >> 	/* wait for the master CPU to complete this cpu's STARTUP. */ ?
> > well, that is not quite the same as above, comment should underline that
> > AP waits for ACK from master CPU before continuing with this AP initialization.
> > 
> > How about:
> > /* wait for ACK from master CPU before continuing with AP initialization */
> 
> Awesome :)
> 
> P.
> 
> > 
> >>
> >> Apologies for the late review,
> >>
> >> P.
> > 
> > 

