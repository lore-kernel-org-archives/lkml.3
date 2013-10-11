Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab3JKX2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 19:28:44 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:53714 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3JKX2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 19:28:42 -0400
Date: Fri, 11 Oct 2013 16:28:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KY Srinivasan <kys@microsoft.com>
cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Olaf Hering <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [patch x86/hyperv] x86, hyperv: Fix build error
In-Reply-To: <86627d477ccc42aea289f62ad96d0e4b@SN2PR03MB061.namprd03.prod.outlook.com>
Message-ID: <alpine.DEB.2.02.1310111619470.31170@chino.kir.corp.google.com>
References: <1380554932-9888-1-git-send-email-olaf@aepfle.de> <tip-9e7827b5ea4ca93b4d864bc07c0fafb838d496b1@git.kernel.org> <alpine.DEB.2.02.1310111604160.31170@chino.kir.corp.google.com>
 <86627d477ccc42aea289f62ad96d0e4b@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Oct 2013, KY Srinivasan wrote:

> > From: David Rientjes [mailto:rientjes@google.com]
> > Sent: Friday, October 11, 2013 4:08 PM
> > To: Ingo Molnar; H. Peter Anvin; tglx@linutronix.de; H. Peter Anvin
> > Cc: KY Srinivasan; Olaf Hering; linux-kernel@vger.kernel.org; linux-tip-
> > commits@vger.kernel.org
> > Subject: [patch x86/hyperv] x86, hyperv: Fix build error
> > 
> > 9e7827b5ea4c ("x86, hyperv: Get the local APIC timer frequency from the
> > hypervisor") breaks the build with some configs because apic.h isn't
> > directly included:
> > 
> > arch/x86/kernel/cpu/mshyperv.c: In function 'ms_hyperv_init_platform':
> > arch/x86/kernel/cpu/mshyperv.c:90:3: error: 'lapic_timer_frequency' undeclared
> > (first use in this function)
> > arch/x86/kernel/cpu/mshyperv.c:90:3: note: each undeclared identifier is
> > reported only once for each function it appears in
> > 
> > Fix it by including asm/apic.h.
> 
> Thank you. The issue was configuration related - local APIC was not configured. This has already been fixed.
> 

Yeah, it's config related as stated in the changelog.  If you're referring 
to 90ab9d551093 ("x86, hyperv: Correctly guard the local APIC calibration 
code ")as "fixing" it, it does not.  (I'm left to wonder what you mean by 
it being fixed since you didn't elaborate.)  You can trigger this build 
breakage even with CONFIG_X86_LOCAL_APIC=y.

Let me be explicit: this file includes desc.h, which includes linux/smp.h, 
which includes asm/smp.h iff CONFIG_SMP is enabled.  That's what you're 
relying upon to get asm/apic.h when CONFIG_X86_LOCAL_APIC is enabled.  It 
will break when CONFIG_SMP is disabled.

So you need to include asm/apic.h directly for such a configuration.
