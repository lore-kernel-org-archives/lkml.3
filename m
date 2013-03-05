Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab3CEWoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:44:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42025 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab3CEWof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:44:35 -0500
Date: Tue, 5 Mar 2013 23:44:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [3.9-rc1 x86] Bug in ioremap code?
Message-ID: <20130305224432.GD27022@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	hpa@linux.intel.com, linux-kernel@vger.kernel.org
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp>
 <201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp>
 <201303052031.JFG81705.FSOOFQHJMVFOLt@I-love.SAKURA.ne.jp>
 <201303060041.AIF15342.tJFOHLQFFOMVSO@I-love.SAKURA.ne.jp>
 <20130305180650.GD4914@pd.tnic>
 <201303060628.CBG00578.OJtMFFHLQVSFOO@I-love.SAKURA.ne.jp>
 <51367104.5050200@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51367104.5050200@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 02:26:12PM -0800, Dave Hansen wrote:
> Just booted a qemu-kvm guest with this .config.  It didn't trip over
> anything, so I'm looking for some more ACPI tables to feed in to it.
> 
> Looking through the code, it looks like this is the __pa() that's
> hitting the BUG_ON():

Shouldn't it be this one:

#ifdef CONFIG_DEBUG_VIRTUAL
unsigned long __phys_addr(unsigned long x)
{
        unsigned long phys_addr = x - PAGE_OFFSET;
        /* VMALLOC_* aren't constants  */
        VIRTUAL_BUG_ON(x < PAGE_OFFSET);
        VIRTUAL_BUG_ON(__vmalloc_start_set && is_vmalloc_addr((void *) x));
        /* max_low_pfn is set early, but not _that_ early */
        if (max_low_pfn) {
                VIRTUAL_BUG_ON((phys_addr >> PAGE_SHIFT) > max_low_pfn);
                BUG_ON(slow_virt_to_phys((void *)x) != phys_addr); 		<--- **
        }
        return phys_addr;
}
EXPORT_SYMBOL(__phys_addr);
#endif

?

At least this is what the oops says:

> [    0.083350] ------------[ cut here ]------------
> [    0.084000] kernel BUG at arch/x86/mm/physaddr.c:79!
> [    0.084000] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC


Tetsuo says in some of the earlier mails:

"But I get VMware's virtual machine kernel stack fault (hardware reset)
as soon as kernel is loaded if CONFIG_DEBUG_VIRTUAL=y is added to the
config above."

> What kind of hardware is this?

[    0.084000] Pid: 0, comm: swapper/0 Not tainted 3.8.0-rc5-00105-g68d00bb #47 VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform

I asked Tetsuo to confirm but it looks like 32-bit guest running in
vmware.

Ok, before we continue guessing stuff, Tetsuo, can you please explain
how exactly you're triggering this. More specifically, we need .config,
hypervisor version, I'm assuming kernel is 3.9-rc1, Linux is guest/host
etc, etc.

Basically everything one would need to know if one would like to
reproduce this bug in his environment.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
