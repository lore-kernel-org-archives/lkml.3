Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab3BAWAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:00:22 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53822 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432Ab3BAWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:00:20 -0500
Message-ID: <510C3AF0.6050109@amacapital.net>
Date: Fri, 01 Feb 2013 14:00:16 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, Don Zickus <dzickus@redhat.com>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH] x86, x2apic: Only WARN on broken BIOSes inside a virtual
 guest
References: <1359650435-73586-1-git-send-email-dzickus@redhat.com>  <20130131185200.GA1757@redhat.com> <20130131193427.GP98867@redhat.com>  <20130131200024.GB1757@redhat.com> <1359665532.7958.3.camel@ul30vt.home>
In-Reply-To: <1359665532.7958.3.camel@ul30vt.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 12:52 PM, Alex Williamson wrote:
> On Thu, 2013-01-31 at 22:00 +0200, Gleb Natapov wrote:
>> On Thu, Jan 31, 2013 at 02:34:27PM -0500, Don Zickus wrote:
>>> On Thu, Jan 31, 2013 at 08:52:00PM +0200, Gleb Natapov wrote:
>>>>> http://www.invisiblethingslab.com/resources/2011/Software%20Attacks%20on%20Intel%20VT-d.pdf
>>>>>
>>>>> After talking with folks, the threat of irq injections on virtual guests
>>>>> made sense.  However, when discussing if this was possible on bare metal
>>>>> machines, we could not come up with a plausible scenario.
>>>>>
>>>> The irq injections is something that a guest with assigned device does
>>>> to attack a hypervisor it runs on. Interrupt remapping protects host
>>>> from this attack. According to pdf above if x2apic is disabled in a
>>>> hypervisor interrupt remapping can be bypassed and leave host vulnerable
>>>> to guest attack. This means that situation is exactly opposite: warning
>>>> has sense on a bare metal, but not in a guest. I am not sure that there is
>>>> a hypervisor that emulates interrupt remapping device though and without
>>>> it the warning cannot be triggered in a guest.
>>>
>>> Ah, it makes sense.  Not sure how I got it backwards then.  So my patch is
>>> pointless then?  I'll asked for it to be dropped.
>> Yes, it is backwards.
>>
>>>
>>> >From my previous discussions with folks, is that KVM was protected from
>>> this type of attack.  Is that still true?
>>>
>> Copying Alex. He said that to use device assignment without interrupt
>> remapping customer needs to opt-in explicitly. Not sure what happens
>> with interrupt remapping but with x2apic disabled.
> 
> Per the paper above, compatibility format is only vulnerable if EIM
> (Extended Interrupt Mode) is clear (x2APIC not enabled) and CFIS in the
> global command register is set.  The latter is never set.

The existing code is either confusing or entirely wrong.  Here's what
my Dell server says:

[    0.192168] ------------[ cut here ]------------
[    0.197320] WARNING: at drivers/iommu/intel_irq_remapping.c:542
intel_enable_
irq_remapping+0x7b/0x27e()
[    0.207799] Hardware name: PowerEdge R620
[    0.212268] Your BIOS is broken and requested that x2apic be disabled
[    0.212268] This will leave your machine vulnerable to irq-injection
attacks
[    0.212268] Use 'intremap=no_x2apic_optout' to override BIOS request
[    0.234378] Modules linked in:
[    0.237792] Pid: 1, comm: swapper/0 Not tainted 3.5.7-ama+ #6
[    0.244199] Call Trace:
[    0.246924]  [<ffffffff81afb7e6>] ? intel_enable_irq_remapping+0x7b/0x27e
[    0.254497]  [<ffffffff8104529f>] warn_slowpath_common+0x7f/0xc0
[    0.261196]  [<ffffffff81045396>] warn_slowpath_fmt+0x46/0x50
[    0.267604]  [<ffffffff81afb7e6>] intel_enable_irq_remapping+0x7b/0x27e
[    0.274982]  [<ffffffff81afbb23>] irq_remapping_enable+0x20/0x22
[    0.281682]  [<ffffffff81ad4581>] enable_IR+0x39/0x41
[    0.287315]  [<ffffffff81ad48a4>] enable_IR_x2apic+0x88/0x1cc
[    0.293725]  [<ffffffff814f9685>] ? set_cpu_sibling_map+0x416/0x433
[    0.300715]  [<ffffffff81ad66d3>] default_setup_apic_routing+0x12/0x78
[    0.307997]  [<ffffffff81ad26bd>] native_smp_prepare_cpus+0x430/0x476
[    0.315183]  [<ffffffff81ac7bf2>] kernel_init+0x8d/0x1c0
[    0.321106]  [<ffffffff81513cd4>] kernel_thread_helper+0x4/0x10
[    0.327710]  [<ffffffff81ac7b65>] ? start_kernel+0x346/0x346
[    0.334020]  [<ffffffff81513cd0>] ? gs_change+0xb/0xb
[    0.339654] ---[ end trace 6a8759eb4c55eb5c ]---
[    0.345193] Enabled IRQ remapping in xapic mode
[    0.350241] x2apic not enabled, IRQ remapping is in xapic mode

(This is Linux 3.5, but I don't think anything has changed.)

Note:

1. I've been warned that x2apic is off, so I'm vulnerable.
2. IRQ remapping *is* enabled.

So disabling the x2apic opt-out is a red herring, *except* that,
according to the VT-d spec (Section 5.3.2.1, page 42):

If Extended Interrupt Mode is enabled (EIME field in Interrupt
Remapping Table Address register is Set), or if the Compatibility format
interrupts are disabled (CFIS field in the Global Status register is
Clear), the Compatibility format interrupts are blocked.


EIME appears to be set in x2apic mode but not in xapic mode.  I'll send
a patch to clean up the warnings and explicitly clear CFI once I
test-boot it.

--Andy


