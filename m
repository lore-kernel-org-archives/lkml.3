Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab3IQUzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:55:54 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41181 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab3IQUzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:55:52 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <5238B288.3000704@hurleysoftware.com>
References: <20130911102809.GA31663@uudg.org>
	<20130911092623.42efd930@gandalf.local.home>
	<5230895B.5070400@hurleysoftware.com>
	<20130911113845.6d56a556@gandalf.local.home>
	<5230C52E.3050801@hurleysoftware.com>
	<5238B288.3000704@hurleysoftware.com>
Date: Tue, 17 Sep 2013 22:55:51 +0200
Message-ID: <CAKMK7uG9s8W6yebkmuJe0XHGsoru4_9FzGqfmKWtMFyCAfQZqA@mail.gmail.com>
Subject: Re: BUG: sleeping function called from invalid context on 3.10.10-rt7
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Dave Airlie <airlied@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 9:50 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On 09/11/2013 03:31 PM, Peter Hurley wrote:
>>
>> [+cc dri-devel]
>>
>> On 09/11/2013 11:38 AM, Steven Rostedt wrote:
>>>
>>> On Wed, 11 Sep 2013 11:16:43 -0400
>>> Peter Hurley <peter@hurleysoftware.com> wrote:
>>>
>>>>> The funny part is, there's a comment there that shows that this was
>>>>> done even for "PREEMPT_RT". Unfortunately, the call to
>>>>> "get_scanout_position()" can call functions that use the rt-mutex
>>>>> "sleeping spin locks" and it breaks there.
>>>>>
>>>>> I guess we need to ask the authors of the mainline patch exactly why
>>>>> that preempt_disable() is needed?
>>>>
>>>>
>>>> The drm core associates a timestamp with each vertical blank frame #.
>>>> Drm drivers can optionally support a 'high resolution' hw timestamp.
>>>> The vblank frame #/timestamp tuple is user-space visible.
>>>>
>>>> The i915 drm driver supports a hw timestamp via this drm helper function
>>>> which computes the timestamp from the crtc scan position (based on the
>>>> pixel clock).
>>>>
>>>> For mainline, the preempt_disable/_enable() isn't actually necessary
>>>> because every call tree that leads here already has preemption disabled.
>>>>
>>>> For -RT, the maybe i915 register spinlock (uncore.lock) should be raw?
>>>>
>>>
>>> No, it should not. Note, any other lock that can be held when it is
>>> held would also need to be raw.
>>
>>
>> By that, you mean "any other lock" that might be claimed "would also need
>> to be raw"?  Hopefully not "any other lock" already held?
>>
>>> And by taking a quick audit of the code, I see this:
>>>
>>>     spin_lock_irqsave(&dev_priv->uncore.lock, irqflags);
>>>
>>>     /* Reset the chip */
>>>
>>>     /* GEN6_GDRST is not in the gt power well, no need to check
>>>      * for fifo space for the write or forcewake the chip for
>>>      * the read
>>>      */
>>>     __raw_i915_write32(dev_priv, GEN6_GDRST, GEN6_GRDOM_FULL);
>>>
>>>     /* Spin waiting for the device to ack the reset request */
>>>     ret = wait_for((__raw_i915_read32(dev_priv, GEN6_GDRST) &
>>> GEN6_GRDOM_FULL) == 0, 500);
>>>
>>> That spin is unacceptable in RT with preemption and interrupts disabled.
>>
>>
>> Yep. That would be bad.
>>
>> AFAICT the registers read in i915_get_crtc_scanoutpos() aren't included
>> in the force-wake set, so raw reads of the registers would
>> probably be acceptable (thus obviating the need for claiming the
>> uncore.lock).
>>
>> Except that _ALL_ register access is disabled with the uncore.lock
>> during a gpu reset. Not sure if that's meant to include crtc registers
>> or not, or what other synchronization/serialization issues are being
>> handled/hidden by forcing all register accesses to wait during a gpu
>> reset.
>>
>> Hopefully an i915 expert can weigh in here?
>
>
>
> Daniel,
>
> Can you shed some light on whether the i915+ crtc registers (specifically
> those in i915_get_crtc_scanoutpos() and i915_/gm45_get_vblank_counter())
> read as part of the vblank counter/timestamp handling need to
> be prevented during gpu reset?

The depency here in the locking is a recent addition:

commit a7cd1b8fea2f341b626b255d9898a5ca5fabbf0a
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri Jul 19 20:36:51 2013 +0100

    drm/i915: Serialize almost all register access

It's a (slightly) oversized hammer to work around a hardware issue -
we could break it down to register blocks, which can be accessed
concurrently, but that tends to be more fragile. But the chip really
dies if you access (even just reads) the same block concurrently :(

We could try break the spinlock protected section a bit in the reset
handler - register access on a hung gpu tends to be ill-defined
anyway.

> The implied wait with preemption and interrupts disabled is causing grief
> in -RT, but also a 4ms wait inside an irq handler seems like a bad idea.

Oops, the magic code in wait_for which is just there to make the imo
totally misguided kgdb support work papered over the aweful long wait
in atomic context ever since we've added this in

commit b6e45f866465f42b53d803b0c574da0fc508a0e9
Author: Keith Packard <keithp@keithp.com>
Date:   Fri Jan 6 11:34:04 2012 -0800

    drm/i915: Move reset forcewake processing to gen6_do_reset

Reverting this change should be enough (code moved obviously a bit).

Cheers, Daniel

>
> Regards,
> Peter Hurley
>
>
>
>>> What's the real issue here?
>>
>>
>> That the vblank timestamp needs to be an accurate measurement of a
>> realtime event. Sleeping/servicing interrupts while reading
>> the registers necessary to compute the timestamp would be bad too.
>>
>> (edit: which hopefully Mario Kleiner clarified in his reply)
>>
>> My point earlier was three-fold:
>> 1. Don't need the preempt_disable() for mainline: all callers are already
>>     holding interrupt-disabling spinlocks.
>> 2. -RT still needs to prevent scheduling there.
>> 3. the problem is i915-specific.
>>
>> [update: the radeon driver should also BUG like the i915 driver but
>> probably
>> should have mmio_idx_lock spinlock as raw]
>
>
>



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
