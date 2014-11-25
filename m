Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaKYFgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 00:36:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbaKYFgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 00:36:06 -0500
Message-ID: <54741540.3010607@suse.com>
Date: Tue, 25 Nov 2014 06:36:00 +0100
From: =?windows-1252?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <CALCETrUp5kCnzFokCKVf3kn7K_d_5YP-phyNfL4rFR0tMZJi2A@mail.gmail.com> <CA+55aFxn_T=UgBUwqkRJvALygrNORaB6ox3nowvHpV6yFBfDoA@mail.gmail.com> <CA+55aFyEnuByhPM3FEdi=Q0WGuJWiBgtkWNAbRLHDpmPRaqnQA@mail.gmail.com> <20141121142301.564f7eb7@gandalf.local.home> <CA+55aFw6w+pkG7fs7tBVm7jV_TjsnEyG5XDdk+Ghf5Af+ELUeA@mail.gmail.com> <CA+55aFwOL8thHWWLtuzXkriEH1mJDCQO=NUsMRPptDXc6HC4sg@mail.gmail.com> <CALCETrX9CNx+Zs3timzxoccrqia1RiaOe5dj7crENnt2W6PGjg@mail.gmail.com> <CA+5PVA4mgpAg53bQKnXXgY3N0mkEZrUYf4rgOTHCV-pbK9UF3g@mail.gmail.com> <CALCETrUT3Pn0ZCMsgp9dyDvoaiszCrQRc4159Tyggo5wA6Mp7w@mail.gmail.com> <CA+5PVA5L1Vcs+nrJWZ+jXgnhQMZ_L22rksopPnO7Wt04jD3kUQ@mail.gmail.com> <20141124184856.GA9349@laptop.dumpdata.com>
In-Reply-To: <20141124184856.GA9349@laptop.dumpdata.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 07:48 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Nov 21, 2014 at 03:23:13PM -0500, Josh Boyer wrote:
>> On Fri, Nov 21, 2014 at 3:16 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Fri, Nov 21, 2014 at 12:14 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>>>> On Fri, Nov 21, 2014 at 2:52 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>>> On Fri, Nov 21, 2014 at 11:46 AM, Linus Torvalds
>>>>> <torvalds@linux-foundation.org> wrote:
>>>>>> On Fri, Nov 21, 2014 at 11:34 AM, Linus Torvalds
>>>>>> <torvalds@linux-foundation.org> wrote:
>>>>>>>
>>>>>>> So I kind of agree, but it wouldn't be my primary worry. My primary
>>>>>>> worry is actually paravirt doing something insane.
>>>>>>
>>>>>> Btw, on that tangent, does anybody actually care about paravirt any more?
>>>>>>

Funny, during testing some patches related to Xen I hit the lockup
issue. It looked a little bit different, but a variation of your patch
solved my problem. The difference to the original report might be due
to the rather low system load during my test, so the system was still
responsive when the first lockup messages appeared. I could see the
hanging cpus were spinning in pmd_lock() called during
__handle_mm_fault().

I could reproduce the issue within a few minutes reliably without the
patch below. With it the machine survived 12 hours and is still running.

WHY my test would trigger the problem so fast I have no idea. I saw it
on a rather huge machine only (128GB memory, 120 cpus), that's quite
understandable. My test remapped some pages via the hypervisor and
removed those mappings again. Perhaps the TLB flushing involved in these
operations is triggering the problem.


diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index d973e61..b847ff7 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -377,7 +377,7 @@ static noinline int vmalloc_fault(unsigned long address)
          * happen within a race in page table update. In the later
          * case just flush:
          */
-       pgd = pgd_offset(current->active_mm, address);
+       pgd = (pgd_t *)__va(read_cr3()) + pgd_index(address);
         pgd_ref = pgd_offset_k(address);
         if (pgd_none(*pgd_ref))
                 return -1;



Juergen
