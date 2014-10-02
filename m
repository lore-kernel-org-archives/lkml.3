Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbaJBPgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:36:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53865 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164AbaJBPgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:36:44 -0400
Message-ID: <542D70F4.5040806@zytor.com>
Date: Thu, 02 Oct 2014 08:36:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
CC: Sebastian Lackner <sebastian@fds-team.de>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] x86_64,entry: Filter RFLAGS.NT on entry from userspace
References: <cover.1412189265.git.luto@amacapital.net> <395749a5d39a29bd3e4b35899cf3a3c1340e5595.1412189265.git.luto@amacapital.net> <CALCETrUPqT3WR9-B4mjS791i+nK0ApDyqf9dr0cB_vSRAbgDGQ@mail.gmail.com>
In-Reply-To: <CALCETrUPqT3WR9-B4mjS791i+nK0ApDyqf9dr0cB_vSRAbgDGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 12:49 PM, Andy Lutomirski wrote:
> On Wed, Oct 1, 2014 at 11:49 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> The NT flag doesn't do anything in long mode other than causing IRET
>> to #GP.  Oddly, CPL3 code can still set NT using popf.
>>
> 
> [...]
> 
>> +
>> +       /*
>> +        * Sysenter doesn't filter flags, so we need to clear NT
>> +        * ourselves.  To save a few cycles, we can check whether
>> +        * NT was set instead of doing an unconditional popfq.
>> +        */
>> +       testl $X86_EFLAGS_NT,EFLAGS(%rsp)       /* saved EFLAGS match cpu */
>> +       jnz sysenter_fix_flags
>> +sysenter_flags_fixed:
>> +
> 
> Because this thread hasn't gone on long enough:
> 
> Do we need to clear IOPL here, too?  With patch 2 applied, an IOPL !=
> 0 program can leak IOPL into another task.  It should be cleared on
> iret, sysexit (via popf) and sysret (directly), so this shouldn't
> matter.  Am I missing something?
> 
> Adding IOPL to the test will add no overhead for non-iopl-using tasks,
> but it will slighly slow down 32-bit tasks that use iopl.
> 

As you correctly point out, IOPL is completely irrelevant in ring 0.  We
have to restore the user space flags before returning to user space, so
it shouldn't matter.

	-hpa


