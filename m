Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbaDBVbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 17:31:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933117AbaDBVbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 17:31:12 -0400
Date: Wed, 2 Apr 2014 23:29:56 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, bp@suse.de,
        paul.gortmaker@windriver.com, JBeulich@suse.com, prarit@redhat.com,
        drjones@redhat.com, toshi.kani@hp.com, riel@redhat.com,
        gong.chen@linux.intel.com
Subject: Re: [PATCH v2 1/5] x86: replace timeouts when booting secondary CPU
 with infinite wait loop
Message-ID: <20140402232956.54848fbe@thinkpad>
In-Reply-To: <87ppkzk5zi.fsf@tassilo.jf.intel.com>
References: <1396296565-19709-1-git-send-email-imammedo@redhat.com>
	<1396296565-19709-2-git-send-email-imammedo@redhat.com>
	<87ppkzk5zi.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Apr 2014 10:15:29 -0700
Andi Kleen <andi@firstfloor.org> wrote:

> Igor Mammedov <imammedo@redhat.com> writes:
> 
> > Hang is observed on virtual machines during CPU hotplug,
> > especially in big guests with many CPUs. (It reproducible
> > more often if host is over-committed).
> >
> > It happens because master CPU gives up waiting on
> > secondary CPU and allows it to run wild. As result
> > AP causes locking or crashing system. For example
> > as described here: https://lkml.org/lkml/2014/3/6/257
> >
> > If master CPU have sent STARTUP IPI successfully,
> > make it wait indefinitely till AP boots.
> 
> 
> But what happens on a real machine when the other CPU is dead?
One possible way to boot such machine would be to disable dead CPU
in kernel parameters.

> I've seen that. Kernel still boots. With your patch it would
> hang.
> 
> I don't think you can do that. It needs to have some timeout.
> Maybe a longer or configurable one?
there were patch that tried to keep timeouts and 'gracefully'
cancel AP boot if master timed out on it.
https://lkml.org/lkml/2014/3/6/257

It's possible to keep timeouts in do_boot_cpu(), is setting
trampoline_status sufficient indication that AP is not dead
and worth waiting for?

than it could be rewritten like this:
  if (!boot_error) {
      boot_error = 1;
      for (timeout = 0; timeout < 50000; timeout++) {
          /* Wait till AP signals that it's ready to start initialization */
          if (*trampoline_status == 0xA5A5A5A5) {
              boot_error = 0;
              /* allow AP to start initializing. */
              cpumask_set_cpu(cpu, cpu_callout_mask);

              /* wait till AP boots till cpu_callin_mask point */
              while (cpumask_test_cpu(cpu, cpu_callin_mask))
                   schedule();

              break;  /* It has booted */
          }
          udelay(100);
      }
  }
                   
it will provide timeout if AP is dead and still keep AP from running wild
if master CPU timed out on it. 


> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only


-- 
Regards,
  Igor
