Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaAZUXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 15:23:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38518 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbaAZUXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 15:23:51 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140126202140.GB8224@gmail.com>
References: <1390611565-18709-1-git-send-email-yinghai@kernel.org> <20140125080232.GA20935@gmail.com> <52E4FE02.2020004@redhat.com> <20140126133203.GA1370@gmail.com> <52E55FB1.4060404@redhat.com> <20140126202140.GB8224@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -v2] x86: allocate cpumask during check irq vectors
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 26 Jan 2014 12:23:13 -0800
To: Ingo Molnar <mingo@kernel.org>, Prarit Bhargava <prarit@redhat.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Message-ID: <4f0b30ff-6adb-46f5-bad4-ed42956e2a39@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/global/static/, with a big loud comment why it is okay.

Ingo Molnar <mingo@kernel.org> wrote:
>
>* Prarit Bhargava <prarit@redhat.com> wrote:
>
>> 
>> 
>> On 01/26/2014 08:32 AM, Ingo Molnar wrote:
>> > 
>> > * Prarit Bhargava <prarit@redhat.com> wrote:
>> > 
>> >> On 01/25/2014 03:02 AM, Ingo Molnar wrote:
>> >>>
>> >>> * Yinghai Lu <yinghai@kernel.org> wrote:
>> >>>
>> >>>> Fix warning:
>> >>>> arch/x86/kernel/irq.c: In function
>check_irq_vectors_for_cpu_disable:
>> >>>> arch/x86/kernel/irq.c:337:1: warning: the frame size of 2052
>bytes is larger than 2048 bytes
>> >>>>
>> >>>> when NR_CPUS=8192
>> >>>>
>> >>>> We should use zalloc_cpumask_var() instead.
>> >>>>
>> >>>> -v2: update to GFP_ATOMIC instead and free the allocated cpumask
>at last.
>> >>>>
>> >>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> >>>> Cc: Prarit Bhargava <prarit@redhat.com>
>> >>>>
>> >>>> ---
>> >>>>  arch/x86/kernel/irq.c |   24 +++++++++++++++++-------
>> >>>>  1 file changed, 17 insertions(+), 7 deletions(-)
>> >>>>
>> >>>> Index: linux-2.6/arch/x86/kernel/irq.c
>> >>>>
>===================================================================
>> >>>> --- linux-2.6.orig/arch/x86/kernel/irq.c
>> >>>> +++ linux-2.6/arch/x86/kernel/irq.c
>> >>>> @@ -277,11 +277,18 @@ int check_irq_vectors_for_cpu_disable(vo
>> >>>>  	unsigned int this_cpu, vector, this_count, count;
>> >>>>  	struct irq_desc *desc;
>> >>>>  	struct irq_data *data;
>> >>>> -	struct cpumask affinity_new, online_new;
>> >>>> +	cpumask_var_t affinity_new, online_new;
>> >>>> +
>> >>>> +	if (!alloc_cpumask_var(&affinity_new, GFP_ATOMIC))
>> >>>> +		return -ENOMEM;
>> >>>> +	if (!alloc_cpumask_var(&online_new, GFP_ATOMIC)) {
>> >>>> +		free_cpumask_var(affinity_new);
>> >>>> +		return -ENOMEM;
>> >>>> +	}
>> >>>
>> >>> Atomic allocations can fail easily if the system is under duress.
>> >>
>> >> Then the hotplug attempt will fail which IMO is okay. [...]
>> > 
>> > Which is not OK at all for reliable operation, if the system has 
>> > otherwise gobs of RAM, which just don't happen to be atomic 
>> > allocatable!
>> 
>> Ingo, I'm really not sure what other option there is here.  Care to 
>> suggest one?
>
>Since only ever a single instance of this code will run, can it simply 
>be a global cpumask_t variable?
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
