Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3JHMR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:17:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:21084 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab3JHMRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:17:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1056,1371106800"; 
   d="scan'208";a="407283049"
Date: Tue, 8 Oct 2013 20:17:42 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Message-ID: <20131008121742.GA29280@localhost>
References: <20131007021118.GA27927@localhost>
 <20131007051038.GA9764@localhost>
 <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
 <20131007083505.GA22585@localhost>
 <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
 <CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
 <20131008020918.GA1220@localhost>
 <20131008021452.GA6456@localhost>
 <CA+55aFwrovZf-LYa=_SyMNvqQkTfxREm0YuzDk8wJy+Krs0xzw@mail.gmail.com>
 <20131008031152.GA8218@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008031152.GA8218@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

> I'm now trying to disable all drivers shows up in the kobject_release messages:
> 
> [    2.756392] kobject: 'ipmi_si' (ffff880007764a00): kobject_release, parent ffff8800001b7648 (delayed)
> [    2.758091] kobject: 'ipmi_si' (ffff880007764800): kobject_release, parent ffff880000221248 (delayed)
> [    2.759858] kobject: 'ipmi_si' (ffff880007764c00): kobject_release, parent ffff880000189248 (delayed)
> [    2.929669] kobject: 'drm' (ffff880006db2848): kobject_release, parent ffff880000189648 (delayed)
> [    2.932143] kobject: 'drm' (ffff880006daf000): kobject_release, parent           (null) (delayed)
> [    2.941844] kobject: 'controlD64' (ffff880006db2020): kobject_release, parent           (null) (delayed)
> [    2.958432] kobject: 'parport_pc.956' (ffff880006db2020): kobject_release, parent           (null) (delayed)
> [    2.965698] kobject: 'parport_pc.888' (ffff880006dc5820): kobject_release, parent           (null) (delayed)
> [    2.972583] kobject: 'parport_pc.632' (ffff880006dc5020): kobject_release, parent           (null) (delayed)
> [    3.031704] kobject: 'physmap-flash' (ffff880006ddc800): kobject_release, parent ffff880000189248 (delayed)
> [    3.055119] kobject: 'docg3' (ffff880006de3c00): kobject_release, parent ffff880000189248 (delayed)
> [    3.496256] kobject: 'gpio-vbus' (ffff880006817400): kobject_release, parent ffff880000189248 (delayed)
> [    3.619023] kobject: '(null)' (ffff88000777baf0): kobject_release, parent           (null) (delayed)
> [    3.657587] kobject: 'proc-osm' (ffff88000684be00): kobject_release, parent ffff880006849848 (delayed)
> [    3.662546] kobject: 'mc13xxx-rtc' (ffff880006851e00): kobject_release, parent ffff880000189248 (delayed)
> [    3.669144] kobject: 'rtc-msm6242' (ffff880006851c00): kobject_release, parent ffff880000189248 (delayed)
> [    3.677494] kobject: 'pcap-rtc' (ffff880006851a00): kobject_release, parent ffff880000189248 (delayed)
> [    3.680280] kobject: 'rtc-rp5c01' (ffff880006855a00): kobject_release, parent ffff880000189248 (delayed)
> [    3.750200] kobject: 'mc13783-adc' (ffff880007707000): kobject_release, parent ffff880000189248 (delayed)
 
I find the above debug messages very helpful in locating the buggy
driver. How about enabling it whenever CONFIG_DEBUG_KOBJECT_RELEASE is
enabled? Something like

 #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
-       pr_debug("kobject: '%s' (%p): %s, parent %p (delayed)\n",
+       printk(KERN_INFO "kobject: '%s' (%p): %s, parent %p (delayed)\n",
                 kobject_name(kobj), kobj, __func__, kobj->parent);

pr_debug() won't be displayed by default, and it depends on
CONFIG_DYNAMIC_DEBUG.

> with some manual bisects, I find a good config (attached) that can
> reliably boot the kernel up.
> 
> Based on that config, I tried adding parport_pc and see that it still
> boots fine.
> 
> Adding drm, however will bring back the oops. Will try a kernel based
> on the original kconfig with drm disabled only.

Thanks,
Fengguang
