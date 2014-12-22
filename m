Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaLVXTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 18:19:34 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45748 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbaLVXTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 18:19:32 -0500
Date: Tue, 23 Dec 2014 00:19:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, tony.luck@intel.com,
        dougthompson@xmission.com, mchehab@osg.samsung.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        dave.hansen@linux.intel.com, mgorman@suse.de, bp@suse.de,
        riel@redhat.com, jacob.w.shin@gmail.com
Subject: Re: [PATCH 0/3] Fix MCE handling for AMD multi-node processors
Message-ID: <20141222231929.GC1942@pd.tnic>
References: <1419279012-4754-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141222201542.GB1942@pd.tnic>
 <5498858F.1030209@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5498858F.1030209@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 02:56:47PM -0600, Aravind Gopalakrishnan wrote:
> On 12/22/2014 2:15 PM, Borislav Petkov wrote:
> >On Mon, Dec 22, 2014 at 02:10:09PM -0600, Aravind Gopalakrishnan wrote:
> >>When a MCE happens that is to be logged onto bank 4 of AMD multi-node
> >>processors, they are reported only to corresponding node base core of
> >>the cpu on which the error occurred.
> >>
> >>Refer D18F3x44[NbMcaToMstCpuEn] on BKDGs of Fam10h and later for
> >Let me try to understand this correctly:
> >
> >Does that mean that we could fix this by simply doing:
> >
> >D18F3x44[NbMcaToMstCpuEn]=0b
> >
> >on each NB?
> >
> 
> Not quite..
> When this field is 0, BKDG says the error may be reported to the core that
> originated the request *if applicable and known*
> Looking at the error signatures table for MC4 (Part 2),
> we can see only some errors have 'ErrCoreId' column as valid
> 
> Besides, if IO originated the request, then it is reported only to NBC.
> 
> So, to take care of all these cases, I am just following one approach here:
> and that is to look at NBC MSRs for any bank 4 errors.
> (It seems to be what the BKDG recommends anyway as BIOS by default should
> set D18F3x44[NbMcaToMstCpuEn])

Then in that case you have to check the case where
D18F3x44[NbMcaToMstCpuEn] is 0 for whatever reason (some BIOS forgot to
set it or whatever) and to set it again.

Then, upon a quick scan, your patches are adding a lot of vendor-specific
stuff which doesn't belong in the #MC handler, should probably be
wrapped or so, no good idea right now.

Then, you're using rd/wrmsr_on_cpu which does smp_call_function_single()
which can deadlock in atomic context and #MC is one.

Also, the math in amd_get_nbc_for_node() is too fragile and will break
the moment some BIOS renumbers cores to accomodate some other OS.

In any case, I won't be able to take a detailed look soon with the
holidays coming up.

Also, I'm wondering if this can't be solved much more elegantly
by detecting that condition (bank == 4) in the #MC handler and
issuing an IPI before exiting it using irq_work which will schedule
do_machine_check on the NBC. And that should be even easier to do since
we're moving the #MC handler out of the IST and to the normal kernel
stack for 3.20, which would make this endeavor pretty cheap.

Anyway, just a couple of thoughts...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
