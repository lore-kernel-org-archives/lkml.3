Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135Ab3IYGvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 02:51:47 -0400
Received: from xmailer.gwdg.de ([134.76.10.29]:39750 "EHLO xmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab3IYGvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 02:51:45 -0400
X-Greylist: delayed 8355 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Sep 2013 02:51:44 EDT
Message-ID: <5242674A.8020100@tuebingen.mpg.de>
Date: Wed, 25 Sep 2013 06:32:10 +0200
From: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Peter Hurley <peter@hurleysoftware.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Subject: Re: [Intel-gfx] BUG: sleeping function called from invalid context
 on 3.10.10-rt7
References: <20130911102809.GA31663@uudg.org> <20130911092623.42efd930@gandalf.local.home> <5230895B.5070400@hurleysoftware.com> <20130911113845.6d56a556@gandalf.local.home> <5230C52E.3050801@hurleysoftware.com> <5238B288.3000704@hurleysoftware.com> <CAKMK7uG9s8W6yebkmuJe0XHGsoru4_9FzGqfmKWtMFyCAfQZqA@mail.gmail.com> <523CC728.4040302@tuebingen.mpg.de> <20130923083841.GT4531@intel.com>
In-Reply-To: <20130923083841.GT4531@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.09.13 10:38, Ville Syrjälä wrote:
> On Sat, Sep 21, 2013 at 12:07:36AM +0200, Mario Kleiner wrote:
>> On 09/17/2013 10:55 PM, Daniel Vetter wrote:
>>> On Tue, Sep 17, 2013 at 9:50 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
>>>> On 09/11/2013 03:31 PM, Peter Hurley wrote:
>>>>>
>>>>> [+cc dri-devel]
>>>>>
>>>>> On 09/11/2013 11:38 AM, Steven Rostedt wrote:
>>>>>>
>>>>>> On Wed, 11 Sep 2013 11:16:43 -0400
>>>>>> Peter Hurley <peter@hurleysoftware.com> wrote:
>>>>>>
>>>>>>>> The funny part is, there's a comment there that shows that this was
>>>>>>>> done even for "PREEMPT_RT". Unfortunately, the call to
>>>>>>>> "get_scanout_position()" can call functions that use the rt-mutex
>>>>>>>> "sleeping spin locks" and it breaks there.
>>>>>>>>
>>>>>>>> I guess we need to ask the authors of the mainline patch exactly why
>>>>>>>> that preempt_disable() is needed?
>>>>>>>
>>>>>>>
>>>>>>> The drm core associates a timestamp with each vertical blank frame #.
>>>>>>> Drm drivers can optionally support a 'high resolution' hw timestamp.
>>>>>>> The vblank frame #/timestamp tuple is user-space visible.
>>>>>>>
>>>>>>> The i915 drm driver supports a hw timestamp via this drm helper function
>>>>>>> which computes the timestamp from the crtc scan position (based on the
>>>>>>> pixel clock).
>>>>>>>
>>>>>>> For mainline, the preempt_disable/_enable() isn't actually necessary
>>>>>>> because every call tree that leads here already has preemption disabled.
>>>>>>>
>>>>>>> For -RT, the maybe i915 register spinlock (uncore.lock) should be raw?
>>>>>>>
>>>>>>
>>>>>> No, it should not. Note, any other lock that can be held when it is
>>>>>> held would also need to be raw.
>>>>>
>>>>>
>>>>> By that, you mean "any other lock" that might be claimed "would also need
>>>>> to be raw"?  Hopefully not "any other lock" already held?
>>>>>
>>>>>> And by taking a quick audit of the code, I see this:
>>>>>>
>>>>>>       spin_lock_irqsave(&dev_priv->uncore.lock, irqflags);
>>>>>>
>>>>>>       /* Reset the chip */
>>>>>>
>>>>>>       /* GEN6_GDRST is not in the gt power well, no need to check
>>>>>>        * for fifo space for the write or forcewake the chip for
>>>>>>        * the read
>>>>>>        */
>>>>>>       __raw_i915_write32(dev_priv, GEN6_GDRST, GEN6_GRDOM_FULL);
>>>>>>
>>>>>>       /* Spin waiting for the device to ack the reset request */
>>>>>>       ret = wait_for((__raw_i915_read32(dev_priv, GEN6_GDRST) &
>>>>>> GEN6_GRDOM_FULL) == 0, 500);
>>>>>>
>>>>>> That spin is unacceptable in RT with preemption and interrupts disabled.
>>>>>
>>>>>
>>>>> Yep. That would be bad.
>>>>>
>>>>> AFAICT the registers read in i915_get_crtc_scanoutpos() aren't included
>>>>> in the force-wake set, so raw reads of the registers would
>>>>> probably be acceptable (thus obviating the need for claiming the
>>>>> uncore.lock).
>>>>>
>>>>> Except that _ALL_ register access is disabled with the uncore.lock
>>>>> during a gpu reset. Not sure if that's meant to include crtc registers
>>>>> or not, or what other synchronization/serialization issues are being
>>>>> handled/hidden by forcing all register accesses to wait during a gpu
>>>>> reset.
>>>>>
>>>>> Hopefully an i915 expert can weigh in here?
>>>>
>>>>
>>>>
>>>> Daniel,
>>>>
>>>> Can you shed some light on whether the i915+ crtc registers (specifically
>>>> those in i915_get_crtc_scanoutpos() and i915_/gm45_get_vblank_counter())
>>>> read as part of the vblank counter/timestamp handling need to
>>>> be prevented during gpu reset?
>>>
>>> The depency here in the locking is a recent addition:
>>>
>>> commit a7cd1b8fea2f341b626b255d9898a5ca5fabbf0a
>>> Author: Chris Wilson <chris@chris-wilson.co.uk>
>>> Date:   Fri Jul 19 20:36:51 2013 +0100
>>>
>>>       drm/i915: Serialize almost all register access
>>>
>>> It's a (slightly) oversized hammer to work around a hardware issue -
>>> we could break it down to register blocks, which can be accessed
>>> concurrently, but that tends to be more fragile. But the chip really
>>> dies if you access (even just reads) the same block concurrently :(
>>>
>>> We could try break the spinlock protected section a bit in the reset
>>> handler - register access on a hung gpu tends to be ill-defined
>>> anyway.
>>>
>>>> The implied wait with preemption and interrupts disabled is causing grief
>>>> in -RT, but also a 4ms wait inside an irq handler seems like a bad idea.
>>>
>>> Oops, the magic code in wait_for which is just there to make the imo
>>> totally misguided kgdb support work papered over the aweful long wait
>>> in atomic context ever since we've added this in
>>>
>>> commit b6e45f866465f42b53d803b0c574da0fc508a0e9
>>> Author: Keith Packard <keithp@keithp.com>
>>> Date:   Fri Jan 6 11:34:04 2012 -0800
>>>
>>>       drm/i915: Move reset forcewake processing to gen6_do_reset
>>>
>>> Reverting this change should be enough (code moved obviously a bit).
>>>
>>> Cheers, Daniel
>>>
>>>>
>>>> Regards,
>>>> Peter Hurley
>>>>
>>>>
>>>>
>>>>>> What's the real issue here?
>>>>>
>>>>>
>>>>> That the vblank timestamp needs to be an accurate measurement of a
>>>>> realtime event. Sleeping/servicing interrupts while reading
>>>>> the registers necessary to compute the timestamp would be bad too.
>>>>>
>>>>> (edit: which hopefully Mario Kleiner clarified in his reply)
>>>>>
>>>>> My point earlier was three-fold:
>>>>> 1. Don't need the preempt_disable() for mainline: all callers are already
>>>>>       holding interrupt-disabling spinlocks.
>>>>> 2. -RT still needs to prevent scheduling there.
>>>>> 3. the problem is i915-specific.
>>>>>
>>>>> [update: the radeon driver should also BUG like the i915 driver but
>>>>> probably
>>>>> should have mmio_idx_lock spinlock as raw]
>>>>
>>
>> Ok, so register access must be serialized, at least within a register
>> block, no way around it. Thanks for explaining this. That makes me a bit
>> depressed. Is this also true for older hw generations than gen6?
>>
>> Daniel, could we move access to the display register block to a separate
>> lock, so the I915_READ to PIPEDSL in  i915_get_crtc_scanoutpos() can
>> avoid the uncore.lock? If the display registers don't need forcewake
>> then i assume we could have much shorter lock hold times by avoiding the
>> large up to 4 msecs waits in forcewake handling. Probably also much less
>> contention in normal operation when no modesetting happens? I think i
>> can get rid of the other register reads in that function. Those settings
>> are already cached and accessible from the intel_crtc_config->adjusted_mode.
>
> I actually have a patch to kill most of the registers reads in
> get_scanout_position on i915 somewhere. Let me dig that out and send it
> to the list...
>
> <snip>
>> In any case, maybe the simple retry 3x loop in the DRM for measuring the
>> timestamp is not good enough anymore to keep this reliable and accurate.
>> Maybe we would need some loop that retries until an accurate measurement
>> or a user configurable timeout is reached. Then users like  mine could
>> set a very high timeout which rather totally degrades the system and
>> causes severe stuttering of graphics updates than silently failing with
>> inaccurate timestamps. The default could be something safe for normal
>> desktop use.
>
> I never really understood the need for the preempt disabled retry loop in
> drm core. What I would do is just something like this:
>
> get_scanoutpos_and_timestamp()
> {
>   local_irq_disable();
>   get_scanoutpos();
>   get_timestamp();
>   local_irq_enable();
> }

The preempt_disable serves the same purpose for PREEMPT_RT kernels as 
your local_irq_disable in your example - get rid of any preventable 
interruption, so a retry is unlikely to be ever needed. At least that 
was the idea.

I assume if a spin_lock_irqsave doesn't really disable interrupts on a 
RT kernel with normal spinlocks then local_irq_disable won't really 
disable interrupts either?

>
> If that has a lot of error, then it seems to me that the system is just
> crap and we shouldn't care. Or if you're really worried about SMIs and
> such then you could still do a retry loop.
>

I didn't expect a lot of error with preemption and interrupts disabled, 
essentially only such infrequent things as smi's, that's why the retry 
loop only tries 3x max, once for real, once in case the 1st one got 
spoiled by a smi or such, and once because three times a charm ;-) - In 
practice i didn't ever observe more than 3-4 usecs of delay, well below 
the 20 usecs retry threshold. But i didn't expect 
i915_crtc_get_scanoutpos() to ever take any locks or other stuff that 
could induce long waits.

But given the new situation, your proposal is great! If we push the 
clock readouts into the get_scanoutpos routine, we can make this robust 
without causing grief for the rt people and without the need for a new 
separate lock for display regs in intel-kms.

E.g., for intel-kms:

i915_get_crtc_scanoutpos(..., ktime_t *stime, ktime_t *etime)
{
   ...
   spin_lock_irqsave(...uncore.lock);
   preempt_disable();
   *stime = ktime_get();
   position = __raw_i915_read32(dev_priv, PIPEDSL(pipe));
   *etime = ktime_get();
   preempt_enable();
   spin_unlock_irqrestore(...uncore.lock)
   ...
}

With your patchset to reduce the amount of register reads needed in that 
function, and given that forcewake handling isn't needed for these 
registers, this should make it robust again and wouldn't need new locks.

Unless ktime_get is also a bad thing to do in a preempt disabled section?

-mario
