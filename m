Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaGVOFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:05:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41734 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaGVOFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:05:45 -0400
Message-ID: <53CE6FB0.90500@canonical.com>
Date: Tue, 22 Jul 2014 16:05:36 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
        Dave Airlie <airlied@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [PATCH 09/17] drm/radeon: use common fence implementation for
 fences
References: <20140709093124.11354.3774.stgit@patser> <20140709122953.11354.46381.stgit@patser> <CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com> <53CE2421.5040906@amd.com> <20140722114607.GL15237@phenom.ffwll.local> <20140722115737.GN15237@phenom.ffwll.local> <53CE56ED.4040109@vodafone.de>
In-Reply-To: <53CE56ED.4040109@vodafone.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 22-07-14 14:19, Christian König schreef:
> Am 22.07.2014 13:57, schrieb Daniel Vetter:
>> On Tue, Jul 22, 2014 at 01:46:07PM +0200, Daniel Vetter wrote:
>>> On Tue, Jul 22, 2014 at 10:43:13AM +0200, Christian König wrote:
>>>> Am 22.07.2014 06:05, schrieb Dave Airlie:
>>>>> On 9 July 2014 22:29, Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:
>>>>>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>>>>> ---
>>>>>>   drivers/gpu/drm/radeon/radeon.h        |   15 +-
>>>>>>   drivers/gpu/drm/radeon/radeon_device.c |   60 ++++++++-
>>>>>>   drivers/gpu/drm/radeon/radeon_fence.c  |  223 ++++++++++++++++++++++++++------
>>>>>>   3 files changed, 248 insertions(+), 50 deletions(-)
>>>>>>
>>>>>  From what I can see this is still suffering from the problem that we
>>>>> need to find a proper solution to,
>>>>>
>>>>> My summary of the issues after talking to Jerome and Ben and
>>>>> re-reading things is:
>>>>>
>>>>> We really need to work out a better interface into the drivers to be
>>>>> able to avoid random atomic entrypoints,
>>>> Which is exactly what I criticized from the very first beginning. Good to
>>>> know that I'm not the only one thinking that this isn't such a good idea.
>>> I guess I've lost context a bit, but which atomic entry point are we
>>> talking about? Afaics the only one that's mandatory is the is
>>> fence->signaled callback to check whether a fence really has been
>>> signalled. It's used internally by the fence code to avoid spurious
>>> wakeups. Afaik that should be doable already on any hardware. If that's
>>> not the case then we can always track the signalled state in software and
>>> double-check in a worker thread before updating the sw state. And wrap
>>> this all up into a special fence class if there's more than one driver
>>> needing this.
>> One thing I've forgotten: The i915 scheduler that's floating around runs
>> its bottom half from irq context. So I really want to be able to check
>> fence state from irq context and I also want to make it possible
>> (possible! not mandatory) to register callbacks which are run from any
>> context asap after the fence is signalled.
>
> NAK, that's just the bad design I've talked about. Checking fence state inside the same driver from interrupt context is OK, because it's the drivers interrupt that we are talking about here.
>
> Checking fence status from another drivers interrupt context is what really concerns me here, cause your driver doesn't have the slightest idea if the called driver is really capable of checking the fence right now.
I think there is a usecase for having atomic context allowed with fence_is_signaled, but I don't think there is one for interrupt context, so it's good with me if fence_is_signaled cannot be called in interrupt context, or with irqs disabled.

fence_enable_sw_signaling disables interrupts because it holds fence->lock, so in theory it could be called from any context including interrupts. But no sane driver author does that, or at least I hope not..

Would a sanity check like the one below be enough to allay your fears?
8<-------

diff --git a/include/linux/fence.h b/include/linux/fence.h
index d174585b874b..c1a4519ba2f5 100644
--- a/include/linux/fence.h
+++ b/include/linux/fence.h
@@ -143,6 +143,7 @@ struct fence_cb {
  * the second time will be a noop since it was already signaled.
  *
  * Notes on signaled:
+ * Called with interrupts enabled, and never from interrupt context.
  * May set fence->status if returning true.
  *
  * Notes on wait:
@@ -268,15 +269,29 @@ fence_is_signaled_locked(struct fence *fence)
 static inline bool
 fence_is_signaled(struct fence *fence)
 {
+	bool ret;
+
 	if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
 		return true;
 
-	if (fence->ops->signaled && fence->ops->signaled(fence)) {
+	if (!fence->ops->signaled)
+		return false;
+
+	if (config_enabled(CONFIG_PROVE_LOCKING))
+		WARN_ON(in_interrupt() || irqs_disabled());
+
+	if (config_enabled(CONFIG_DEBUG_ATOMIC_SLEEP))
+		preempt_disable();
+
+	ret = fence->ops->signaled(fence);
+
+	if (config_enabled(CONFIG_DEBUG_ATOMIC_SLEEP))
+		preempt_enable();
+
+	if (ret)
 		fence_signal(fence);
-		return true;
-	}
 
-	return false;
+	return ret;
 }
 
 /**
8<--------

>> If the radeon hw/driver doesn't want to cope with that complexity we can
>> fully insolate it with the sw tracked fence state if you don't like
>> Maarten's radeon implementation. But forcing everyone to forgoe this just
>> because you don't like it and don't want to use it in radeon doesn't sound
>> right.
>
> While it's clearly a hack Maarten's solution for radeon would indeed work, but that's not really the point here.
>
> It's just that I think leaking interrupt context from one driver into another driver is just a really really bad idea from a design point of view.
>
> And calling into a driver while in atomic context to check for a fence being signaled doesn't sounds like a good idea either, cause that limits way to much what the called driver can do for checking the status of a fence.
No, you really shouldn't be doing much in the check anyway, it's meant to be a lightweight check. If you're not ready yet because of a lockup simply return not signaled yet.

~Maarten

