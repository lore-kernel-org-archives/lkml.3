Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaKQXiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:38:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:36255 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaKQXiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:38:24 -0500
Date: Tue, 18 Nov 2014 00:38:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: Stephane Eranian <eranian@google.com>, x86-ml <x86@kernel.org>,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, kan.liang@intel.com,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v3 13/13] perf/x86: add syfs entry to disable HT bug
 workaround
In-Reply-To: <20141117230232.GC25157@pd.tnic>
Message-ID: <alpine.DEB.2.11.1411180025270.3909@nanos>
References: <1416251225-17721-1-git-send-email-eranian@google.com> <1416251225-17721-14-git-send-email-eranian@google.com> <20141117230232.GC25157@pd.tnic>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Borislav Petkov wrote:
> On Mon, Nov 17, 2014 at 08:07:05PM +0100, Stephane Eranian wrote:
> > From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
> > 
> > This patch adds a sysfs entry:
> > 
> > 	/sys/devices/cpu/ht_bug_workaround
> > 
> > to activate/deactivate the PMU HT bug workaround.
> > 
> > To activate (activated by default):
> >  # echo 1 > /sys/devices/cpu/ht_bug_workaround
> > 
> > To deactivate:
> >  # echo 0 > /sys/devices/cpu/ht_bug_workaround
> 
> If I put my simple-user hat and stare at this sysfs node, I'm not really
> becoming any smarter from looking at the name. HT bug? A hyper-threading
> bug?? I see the user forums going nuts already.
> 
> Instead of adding a sysfs node per CPU bug, I'm wondering whether adding
> a
> 
> 	/sys/devices/system/cpu/bugs
> 
> file which gets a mask of bits to enable and disable workarounds would
> be much cleaner.
> 
> x86 guys, what do you guys think?

Well a bitmask is a pretty indescriptive item as well. Putting my user
hat on: Where is the documentation for the bits?

> Such a scheme should be much more easily extensible in the future in
> case we want to add another workaround toggle.

Agreed, but that does not make it more intuitive.
 
> The hierarchy is not optimal either as it should be under
> "perf"-something but I don't think we have a perf sysfs node...

I'm not sure about that. Its a CPU bug at the very end. We should not
care much which of the various bits and pieces of a CPU it affects and
some of them affect more than one ....

But OTOH, we dont want to have random entries with impossible to
understand file names under /sys/devices/cpu/ either.

So what about adding:

 /sys/devices/cpu/bugs/
 
and collect the various user tweakable (or not) bug data there.

So for the problem at hand:

 /sys/devices/cpu/bugs/ht_some_sensible_name/

   Directory

 /sys/devices/cpu/bugs/ht_some_sensible_name/info

   File, which describes the bug comprehensive. URL reference, Errata
   Nr. or something like that.

 /sys/devices/cpu/bugs/ht_some_sensible_name/workaround

   File, to retrieve the status of the workaround. Possibly RO
   depending on the nature of the issue.

> >  static DEVICE_ATTR(rdpmc, S_IRUSR | S_IWUSR, get_attr_rdpmc, set_attr_rdpmc);
> > +static DEVICE_ATTR(ht_bug_workaround, S_IRUSR | S_IWUSR, get_attr_xsu,
> > +		   set_attr_xsu);
> >  
> >  static struct attribute *x86_pmu_attrs[] = {
> >  	&dev_attr_rdpmc.attr,
> > +	&dev_attr_ht_bug_workaround.attr,
> 
> You should be adding this dynamically, only when running on Intel, i.e.
> 
> 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
> 		/* add bug_workaround attr */

and if it's a family/model specific issue, we don't want to see it if
we are not running on such a machine.
 
> For an example, see amd_l3_attrs() in
> arch/x86/kernel/cpu/intel_cacheinfo.c

Given the fact that the number of bugs is going to grow, we probably
want some infrastructure for this.

Thanks,

	tglx
