Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237Ab3CMUqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:46:09 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49644 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab3CMUqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:46:07 -0400
X-Nat-Received: from [202.181.97.72]:50365 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1363207559.20351
To: hpa@linux.intel.com
Cc: fenghua.yu@intel.com, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [3.9-rc1] Bug in bootup code or debug code?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp>
	<201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp>
	<201303132224.BEC60922.JStQOFMVFFOHLO@I-love.SAKURA.ne.jp>
	<3E5A0FA7E9CA944F9D5414FEC6C71220528C2DFF@ORSMSX105.amr.corp.intel.com>
	<5140BB13.10806@linux.intel.com>
In-Reply-To: <5140BB13.10806@linux.intel.com>
Message-Id: <201303140545.DAC69253.FtSJOOFMHVFOLQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 14 Mar 2013 05:45:55 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 13032013 #9704858, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 03/13/2013 08:22 AM, Yu, Fenghua wrote:
> >>
> >> I found the location of "hardware reset" trigger.
> >>
> >> It is __pa_symbol(&boot_params) call, for I don't encounter "hardware
> >> reset" if
> >> I remove the "//" from below debug patch.
> >>
> >> This bug is not yet fixed as of 3.9.0-rc2-00188-g6c23cbb .
> >>
> >> --- a/arch/x86/kernel/microcode_intel_early.c
> >> +++ b/arch/x86/kernel/microcode_intel_early.c
> >> @@ -741,7 +741,9 @@ load_ucode_intel_bsp(void)
> >>  #ifdef CONFIG_X86_32
> >>         struct boot_params *boot_params_p;
> >>
> >> +       //while (1);
> >>         boot_params_p = (struct boot_params *)__pa_symbol(&boot_params);
> >> +       while (1);
> >>         ramdisk_image = boot_params_p->hdr.ramdisk_image;
> >>         ramdisk_size  = boot_params_p->hdr.ramdisk_size;
> >>         initrd_start_early = ramdisk_image;
> > 
> > Tetsuo and Dave,
> > 
> > That's the place where we suspected to cause the problem.
> > 
> > My question is: how to access global variable in linear mode in virtualization? __pa_symbol() is not a problem for native.
> > 
> 
> What kind of virtualization are we talking about here?  We should not be
> running this code under any paravirtualized code path -- this is the
> hypervisor's job to take care of this.  For HVM, this should just work
> the same way.
> 
> 	-hpa
> 
H. Peter Anvin wrote:
> This is a CONFIG_DEBUG_VIRTUAL configuration, isn't it?

Yes. CONFIG_MICROCODE_INTEL_EARLY=y && CONFIG_64BIT=n && CONFIG_DEBUG_VIRTUAL=y
on VMware Workstation/Player environment.
