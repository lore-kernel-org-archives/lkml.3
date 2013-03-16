Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab3CPApp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 20:45:45 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:45242 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab3CPApn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 20:45:43 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBTLcJ2NuRJZa0bdM8uZrjf2APz0tE2wW9_u4LLBLv53ng@mail.gmail.com>
References: <20130315132607.GA4565@quad>
	<20130315203123.GA28128@kroah.com>
	<CAKocOOMkLwLAjF9GpbY7QFe2SvcDpWwD7Oqi213fAeu0yUaFpA@mail.gmail.com>
	<CABPqkBTLcJ2NuRJZa0bdM8uZrjf2APz0tE2wW9_u4LLBLv53ng@mail.gmail.com>
Date: Fri, 15 Mar 2013 18:45:42 -0600
Message-ID: <CAKocOOMV6iK9_b9AyekseRMb-OsNDx8UbtOzStcxM1uqwZhG9w@mail.gmail.com>
Subject: Re: [PATCH] perf,x86: fix kernel crash with PEBS/BTS after suspend/resume
From: Shuah Khan <shuahkhan@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 2:56 PM, Stephane Eranian <eranian@google.com> wrote:
> On Fri, Mar 15, 2013 at 9:53 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
>> On Fri, Mar 15, 2013 at 2:31 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>> On Fri, Mar 15, 2013 at 02:26:07PM +0100, Stephane Eranian wrote:
>>>>
>>>> This patch fixes a kernel crash when using precise sampling (PEBS)
>>>> after a suspend/resume. Turns out the CPU notifier code is not invoked
>>>> on CPU0 (BP). Therefore, the DS_AREA (used by PEBS) is not restored properly
>>>> by the kernel and keeps it power-on/resume value of 0 causing any PEBS
>>>> measurement to crash when running on CPU0.
>>>>
>>>> The workaround is to add a hook in the actual resume code to restore
>>>> the DS Area MSR value. It is invoked for all CPUS. So for all but CPU0,
>>>> the DS_AREA will be restored twice but this is harmless.
>>>>
>>>> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
>>>> Signed-off-by: Stephane Eranian <eranian@google.com>
>>>> ---
>>>
>>> Is this needed for the 3.8 or older kernels as well?
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Just about to ask the same question. Patch applies to 3.8, 3.4, 3.2
>> and 3.5. But needs some massaging for 3.0. I have the kernels built,
>> haven't started testing yet.
>>
> Testing the patch is easy:
>
> # echo mem >/sys/power/state
> Then press the power button again, when you get control again, type:
>
> $ taskset -c 0 perf record -e cycles:pp my_test_program
>
> Note that this problem impacts only Intel processors after Core 2
> (PEBS enabled).

Thanks. Reproduced the problem on 3.8.3, 3.4.36, and 3.0.69. Tested
the patch on 3.4 and 3.8 and the problem is fixed. I had to re-cut the
patch for 3.0. Sending it to stable tagged for 3.0

Thanks,
-- Shuah
