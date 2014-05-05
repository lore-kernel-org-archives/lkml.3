Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaEEU1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:27:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbaEEU1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:27:08 -0400
Date: Mon, 5 May 2014 22:26:25 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, bp@suse.de,
        paul.gortmaker@windriver.com, JBeulich@suse.com, prarit@redhat.com,
        drjones@redhat.com, riel@redhat.com, gong.chen@linux.intel.com,
        andi@firstfloor.org, lenb@kernel.org, rjw@rjwysocki.net,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4 5/5] x86: initialize secondary CPU only if master CPU
 will wait for it
Message-ID: <20140505222625.56d5751b@thinkpad>
In-Reply-To: <1399042342.1789.87.camel@misato.fc.hp.com>
References: <1397488277-14865-1-git-send-email-imammedo@redhat.com>
	<1397488277-14865-6-git-send-email-imammedo@redhat.com>
	<1398985916.1789.75.camel@misato.fc.hp.com>
	<20140502102120.5415bf5b@nial.usersys.redhat.com>
	<1399042342.1789.87.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 May 2014 08:52:22 -0600
Toshi Kani <toshi.kani@hp.com> wrote:

> On Fri, 2014-05-02 at 10:21 +0200, Igor Mammedov wrote:
> > On Thu, 01 May 2014 17:11:56 -0600
> > Toshi Kani <toshi.kani@hp.com> wrote:
>  :
> > > When 10s passed, the master could set a new flag, ex.
> > > cpu_callout_error_mask, which wait_for_master_cpu() checks and call
> > > play_dead() when it is set.  This avoids AP to spin forever when 10s
> > > becomes not long enough.  But it does not have to be part of this
> > > patchset, though.
> > I'm reluctant to add another to already too many cpu_*_mask,
> > maybe we could reuse cpu_initialized_mask by clearing it on timeout.
> > This way AP spinning on cpu_callout_mask could notice it and halt itself.
> 
> I agree that there are too many cpu_* masks.  IMHO, these cpu rendezvous
> masks, initialized/callout/callin, should be combined into a per-cpu
> flag.  There is not much point of being individual masks.
> 
> Anyway, I do not think cpu_initialized_mask can be reused here.
I'll look if we could use percpu here when writing patch to halt timed-out AP.

> 
> > It would be better to make it separate patch on top of this series,
> > to reduce delay of bugfixes in this series.
> 
> Agreed.
> 
> > > 
> > > > +	if (!boot_error) {
> > > >  		/*
> > > > -		 * Wait 5s total for a response
> > > > +		 * Wait till AP completes initial initialization
> > > 
> > > We should generally avoid such wait w/o a timeout condition, but since
> > > native_cpu_up() waits till cpu_online(cpu) anyway after this point, this
> > If we don't wait here and fall through into tight loop waiting on
> > cpu_online(cpu) in native_cpu_up() or check_tsc_sync_source() then
> > stop_task for syncing MTTRs initiated from AP won't have a chance
> > to run on the master CPU.
> > 
> > > seems OK...  I wonder if we need touch_nmi_watchdog(), though.
> > There wasn't any touch_nmi_watchdog() in the original code and I don't
> > think we need it here since we are not just spinning on CPU but giving
> > control back to kernel calling schedule(), which would allow watchdog_task
> > to do the job if needed.
> 
> Agreed.
> 
> Thanks,
> -Toshi
> 


-- 
Regards,
  Igor
