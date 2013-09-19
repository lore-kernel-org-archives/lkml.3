Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab3ISIE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 04:04:26 -0400
Received: from mailout02.t-online.de ([194.25.134.17]:55980 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3ISIEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 04:04:23 -0400
Message-ID: <523AAFFC.2070300@t-online.de>
Date: Thu, 19 Sep 2013 10:04:12 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Dave Chinner <david@fromorbit.com>, Linux MM <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Glauber Costa <glommer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] [PATCH] [RFC] mm/shrinker: Add a shrinker flag to
 always shrink a bit
References: <1379495401-18279-1-git-send-email-daniel.vetter@ffwll.ch> <5239829F.4080601@t-online.de> <20130918203822.GA4330@dastard> <CAKMK7uGR7HtMLgu2-tvfTm+W=_gndVJ7QPcf0okFcKX6Htd61Q@mail.gmail.com>
In-Reply-To: <CAKMK7uGR7HtMLgu2-tvfTm+W=_gndVJ7QPcf0okFcKX6Htd61Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: S+BmTuZSwheIpfTq+OwlO-9h6Xkb2baeaAxmbwrUxIVLo45QGuvzX7jUABI8c5ow1y
X-TOI-MSGID: 9867d6c8-d2c6-46ae-acf4-027ad42f50ac
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.09.2013 08:57, Daniel Vetter wrote:
> On Wed, Sep 18, 2013 at 10:38 PM, Dave Chinner <david@fromorbit.com> wrote:
>> No, that's wrong. ->count_objects should never ass SHRINK_STOP.
>> Indeed, it should always return a count of objects in the cache,
>> regardless of the context.
>>
>> SHRINK_STOP is for ->scan_objects to tell the shrinker it can make
>> any progress due to the context it is called in. This allows the
>> shirnker to defer the work to another call in a different context.
>> However, if ->count-objects doesn't return a count, the work that
>> was supposed to be done cannot be deferred, and that is what
>> ->count_objects should always return the number of objects in the
>> cache.
> So we should rework the locking in the drm/i915 shrinker to be able to
> always count objects? Thus far no one screamed yet that we're not
> really able to do that in all call contexts ...

If this would have been a problem in the past, it probably would
have been ended up as one of those unresolved random glitches ...

> So should I revert 81e49f or will the early return 0; completely upset
> the core shrinker logic?

After Daves answer and a look at all other uses of SHRINK_STOP in the current
kernel sources it is clear that 81e49f must be reverted.

Wherever else SHRINK_STOP  is returned, it ends up in ->scan_objects.
So i915_gem_inactive_scan() and not  i915_gem_inactive_count()
should return that value in case of a failed trylock:

i915_gem_inactive_scan(struct shrinker *shrinker, struct shrink_control *sc)
{
         struct drm_i915_private *dev_priv =
                 container_of(shrinker,
                              struct drm_i915_private,
                              mm.inactive_shrinker);
         struct drm_device *dev = dev_priv->dev;
         int nr_to_scan = sc->nr_to_scan;
         unsigned long freed;
         bool unlock = true;

         if (!mutex_trylock(&dev->struct_mutex)) {
                 if (!mutex_is_locked_by(&dev->struct_mutex, current))
-                        return 0;
+                        return SHRINK_STOP;

                 if (dev_priv->mm.shrinker_no_lock_stealing)
-                        return 0;
+                        return SHRINK_STOP;

                 unlock = false;
         }


atm a kernel with 81e49f reverted,
i915_gem_inactive_scan() changed as described above,
and i915_gem_inactive_count() always counting _without_ any locking
seems to work fine here. Is locking really needed at that place?

cu,
  Knut

