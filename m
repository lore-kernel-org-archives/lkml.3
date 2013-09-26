Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3IZQQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:16:50 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:60303 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3IZQQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:16:48 -0400
Message-ID: <52445DEF.1060007@gmail.com>
Date: Thu, 26 Sep 2013 18:16:47 +0200
From: Mario Kleiner <mario.kleiner.de@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Peter Hurley <peter@hurleysoftware.com>,
        Clark Williams <williams@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Subject: Re: [Intel-gfx] BUG: sleeping function called from invalid context
 on 3.10.10-rt7
References: <20130911102809.GA31663@uudg.org> <20130911092623.42efd930@gandalf.local.home> <5230895B.5070400@hurleysoftware.com> <20130911113845.6d56a556@gandalf.local.home> <5230C52E.3050801@hurleysoftware.com> <5238B288.3000704@hurleysoftware.com> <CAKMK7uG9s8W6yebkmuJe0XHGsoru4_9FzGqfmKWtMFyCAfQZqA@mail.gmail.com> <523CC728.4040302@tuebingen.mpg.de> <20130923083841.GT4531@intel.com> <5242674A.8020100@tuebingen.mpg.de> <20130925101301.6cbe5d0f@gandalf.local.home>
In-Reply-To: <20130925101301.6cbe5d0f@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.09.13 16:13, Steven Rostedt wrote:
> On Wed, 25 Sep 2013 06:32:10 +0200
> Mario Kleiner <mario.kleiner@tuebingen.mpg.de> wrote:
>
>
>> But given the new situation, your proposal is great! If we push the
>> clock readouts into the get_scanoutpos routine, we can make this robust
>> without causing grief for the rt people and without the need for a new
>> separate lock for display regs in intel-kms.
>>
>> E.g., for intel-kms:
>>
>> i915_get_crtc_scanoutpos(..., ktime_t *stime, ktime_t *etime)
>> {
>>     ...
>>     spin_lock_irqsave(...uncore.lock);
>>     preempt_disable();
>>     *stime = ktime_get();
>>     position = __raw_i915_read32(dev_priv, PIPEDSL(pipe));
>>     *etime = ktime_get();
>>     preempt_enable();
>>     spin_unlock_irqrestore(...uncore.lock)
>>     ...
>> }
>>
>> With your patchset to reduce the amount of register reads needed in that
>> function, and given that forcewake handling isn't needed for these
>> registers, this should make it robust again and wouldn't need new locks.
>>
>> Unless ktime_get is also a bad thing to do in a preempt disabled section?
>
> ktime_get() works fine in preempt_disable sections, although it may add
> some latencies, but you shouldn't need to worry about it.
>
> I like this solution the best too, but if it does go in, I would ask to
> send us the patch for adding the preempt_disable() and we can add the
> preempt_disable_rt() to it. Why make mainline have a little more
> overhead?
>
> -- Steve

Good! I will do that. Thanks for clarifying the irq and constraints on 
raw locks in the other thread.

-mario

> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx
>

