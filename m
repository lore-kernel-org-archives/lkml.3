Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaLETlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:41:10 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:41232 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaLETlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:41:08 -0500
Message-ID: <54820A4F.6000708@imgtec.com>
Date: Fri, 5 Dec 2014 11:41:03 -0800
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>, Kees Cook <keescook@chromium.org>
CC: Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        <Zubair.Kakakhel@imgtec.com>, <geert+renesas@glider.be>,
        <david.daney@cavium.com>, Peter Zijlstra <peterz@infradead.org>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>, <davidlohr@hp.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>, <chenhc@lemote.com>,
        <cl@linux.com>, "Ingo Molnar" <mingo@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        James Hogan <james.hogan@imgtec.com>, Tejun Heo <tj@kernel.org>,
        <alex@alex-smith.me.uk>, Paolo Bonzini <pbonzini@redhat.com>,
        John Crispin <blogic@openwrt.org>,
        Paul Burton <paul.burton@imgtec.com>, <qais.yousef@imgtec.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        "Markos Chandras" <markos.chandras@imgtec.com>,
        <dengcheng.zhu@imgtec.com>, <manuel.lauss@gmail.com>,
        <lars.persson@axis.com>
Subject: Re: [PATCH v3 3/3] MIPS: set stack/data protection as non-executable
References: <20141203015537.13886.50830.stgit@linux-yegoshin> <20141203015824.13886.74616.stgit@linux-yegoshin> <5481EB52.6060706@gmail.com> <CAGXu5jJJx0O7GhHghy+sC4fJL2O=RsO+Zgm78r9SNt-aTbhqcw@mail.gmail.com> <54820244.5010304@gmail.com>
In-Reply-To: <54820244.5010304@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2014 11:06 AM, David Daney wrote:
> On 12/05/2014 10:51 AM, Kees Cook wrote:
>> On Fri, Dec 5, 2014 at 9:28 AM, David Daney <ddaney.cavm@gmail.com> 
>> wrote:
>>>
>>> Some programs require an executable stack, this patch will break them.
>>
>> Have you tested this?
>
> Do you require empirical evidence that the patch is incorrect, or is 
> it enough to just to trust me when I say that it is incorrect? 
> Typically the burden of proof is with those proposing the patches.
>
>>
>>> You can only select a non-executable stack in response to PT_GNU_STACK
>>> program headers in the ELF file of the executable program.
>>
>> This is already handled by fs/binfmt_elf.c. It does the parsing of the
>> PT_GNU_STACK needs, and sets up the stack flags appropriately. All the
>> change to VM_DATA_DEFAULT_FLAGS does is make sure that EXSTACK_DEFAULT
>> now means no VM_EXEC by default. If PT_GNU_STACK requires it, it gets
>> added back in.
>>
>
> The problem is not with "modern" executables that are properly 
> annotated with PT_GNU_STACK.
>
> My objection is to the intentional breaking of old executables that 
> have no PT_GNU_STACK annotation, but require an executable stack.  
> Since we usually try not to break userspace, we cannot merge a patch 
> like this one.
>

I ran Debian, buildroot etc and I had only one problem - ssh_keygen is 
built with PT_GNU_STACK annotation stack executable protection. And 
debug output shows a spectacular discarding this setup from kernel by 
GLIBC loader a couple of milliseconds later, at first library load. You 
can test it yourself - run ssh_keygen and look into it's 
/proc/<pid>/maps, stack would have +X.

The rest of Debian distribution, buildroot and Android runs fine with 
this patch series.

Without any step forward the stack protection would be never solved. 
GLIBC team looked into problem and they agree to fix a default 
cancellation of no-X but they need a platform for that.


But of course, we can delay this specific non-X setup for stack until 
GLIBC fixes loader and do this patch optional or via boot flag.

Note: I push this series not because of default non-X stack but because 
an explicit PT_GNU_STACK no-X is ignored.


