Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbaFSLw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:52:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33748 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbaFSLw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:52:27 -0400
Message-ID: <53A2CEF4.3050902@gmail.com>
Date: Thu, 19 Jun 2014 14:52:20 +0300
From: Nadav Amit <nadav.amit@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        "Gabriel L. Somlo" <gsomlo@gmail.com>,
        Eric Northup <digitaleric@google.com>,
        Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, joro@8bytes.org, agraf@suse.de
Subject: Re: [PATCH 3/3] KVM: x86: correct mwait and monitor emulation
References: <CAG7+5M1T=OSqMLOJjb-txRCL_J_q=KSNV9yOfeP=98YuyD27Fw@mail.gmail.com> <20140618184601.GE1695@ERROL.INI.CMU.EDU> <20140619101811.GA5777@redhat.com> <1B06E887-9D07-4E85-AE06-75B01787C488@gmail.com> <20140619112356.GB429@minantech.com>
In-Reply-To: <20140619112356.GB429@minantech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/19/14, 2:23 PM, Gleb Natapov wrote:
> On Thu, Jun 19, 2014 at 01:53:36PM +0300, Nadav Amit wrote:
>>
>> On Jun 19, 2014, at 1:18 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
>>
>>> On Wed, Jun 18, 2014 at 02:46:01PM -0400, Gabriel L. Somlo wrote:
>>>> On Wed, Jun 18, 2014 at 10:59:14AM -0700, Eric Northup wrote:
>>>>> On Wed, Jun 18, 2014 at 7:19 AM, Nadav Amit <namit@cs.technion.ac.il> wrote:
>>>>>> mwait and monitor are currently handled as nop. Considering this behavior, they
>>>>>> should still be handled correctly, i.e., check execution conditions and generate
>>>>>> exceptions when required. mwait and monitor may also be executed in real-mode
>>>>>> and are not handled in that case.  This patch performs the emulation of
>>>>>> monitor-mwait according to Intel SDM (other than checking whether interrupt can
>>>>>> be used as a break event).
>>>>>>
>>>>>> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
>>>>
>>>> How about this instead (details in the commit log below) ? Please let
>>>> me know what you think, and if you'd prefer me to send it out as a
>>>> separate patch rather than a reply to this thread.
>>>>
>>>> Thanks,
>>>> --Gabriel
>>>
>>> If there's an easy workaround, I'm inclined to agree.
>>> We can always go back to Gabriel's patch (and then we'll need
>>> Nadav's one too) but if we release a kernel with this
>>> support it becomes an ABI and we can't go back.
>>>
>>> So let's be careful here, and revert the hack for 3.16.
>>>
>>>
>>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>>
>> Personally, I got a custom guest which requires mwait for executing correctly.
> Can you elaborate on this guest a little bit. With nop implementation
> for mwait the guest will hog a host cpu. Do you consider this to be
> "executing correctly?"
>
> --

mwait is not as "clean" as it may appear. It encounters false wake-ups 
due to a variety of reasons, and any code need to recheck the wake-up 
condition afterwards. Actually, some CPUs had bugs that caused excessive 
wake-ups that degraded performance considerably (Nehalem, if I am not 
mistaken).
Therefore, handling mwait as nop is logically correct (although it may 
degrade performance).

For the reference, if you look at the SDM 8.10.4, you'll see:
"Multiple events other than a write to the triggering address range can 
cause a processor that executed MWAIT to wake up. These include events 
that would lead to voluntary or involuntary context switches, such as..."

Note the words "include" in the sentence "These include events". 
Software has no way of controlling whether it gets false wake-ups and 
cannot rely on the wake-up as indication to anything.

Nadav


