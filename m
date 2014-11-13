Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbaKMBec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 20:34:32 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:37941 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbaKMBeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 20:34:31 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3292BD44@ORSMSX114.amr.corp.intel.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141112220058.GA5295@redhat.com> <CALCETrWA5z7-1fiz_9N0Qi2OR5s1jCkHiynCtTD_+9taOBs-Mg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BAB4@ORSMSX114.amr.corp.intel.com>
 <CALCETrU8uyc4nu-5MBXQR0PY0rexUhPkuPRLK+gWt0gEWMDhTA@mail.gmail.com> <3908561D78D1C84285E8C5FCA982C28F3292BD44@ORSMSX114.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Nov 2014 17:34:08 -0800
Message-ID: <CALCETrXp-bR+1+sfBzGdK0vWJ=Mav3p5T5sxKo_dM24ANfVuhQ@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 4:31 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> v2's not going to make a difference unless you're using uprobes at the
>> same time.
>
> Not (knowingly) using uprobes. System is installed with a RHEL7 userspace ... but is essentially
> idle except for my test program.
>
>> In the interest of my sanity, can you add something like
>> BUG_ON(!user_mode_vm(regs)) or the mce_panic equivalent before calling
>> memory_failure?
>
> I don't think that can possibly trip - we can only end up with a recoverable error from
> a user mode access.  But I'll see about adding it anyway
>
>> What happens if there's a shared bank but the actual offender has a
>> higher order than the cpu that finds the error?
>
> This test case injects a memory error which is logged in bank1. This bank is shared by the
> two hyperthreads that are on the same core.  The mce_severity() function distinguishes
> which is the active thread and which the innocent bystander by looking at MCG_STATUS.
> In the active thread MCG_STATUS.EIPV is 1, in the bystander it is 0. The returned severity
> is MCE_AR_SEVERITY for the thread that hit the error, MCE_KEEP_SEVERITY for the bystander.
> So it doesn't matter which thread has the lower order and sees it first.
>
>> Is this something I can try under KVM?
>
> I don't know if KVM has a way to simulate a machine check event.

With mce-inject and this input:

CPU 1
BANK 0
STATUS uc s ar val en 0x0134
MCGSTATUS mcip eipv
ADDR 4096
MISC 0
IN_PROC
EXCP

I blow up because mce-inject doesn't have a credible emulation of
process context (i.e. IN_PROC doesn't work).

--Andy

>
> -Tony



-- 
Andy Lutomirski
AMA Capital Management, LLC
