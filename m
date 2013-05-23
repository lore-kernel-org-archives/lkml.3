Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab3EWKpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:45:06 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:43625 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758358Ab3EWKpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:45:01 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <519DDDB2.80800@canonical.com>
References: <20130428165914.17075.57751.stgit@patser>
	<20130428170407.17075.80082.stgit@patser>
	<20130430191422.GA5763@phenom.ffwll.local>
	<519CA976.9000109@canonical.com>
	<20130522161831.GQ18810@twins.programming.kicks-ass.net>
	<519CFF56.90600@canonical.com>
	<519DDDB2.80800@canonical.com>
Date: Thu, 23 May 2013 12:45:00 +0200
Message-ID: <CAKMK7uF=0aW4dY_0bmUox1N-kmQvXRr2-x3NBjL2VGO4grW6fQ@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH v3 2/3] mutex: add support for wound/wait
 style locks, v3
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        rob clark <robclark@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Dave Airlie <airlied@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 11:13 AM, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
>> 2. Do you really want to drop the *_slow variants?
>> Doing so might reduce debugging slightly. I like method #2 in ww-mutex-design.txt, it makes it very clear why you
>> would handle the *_slow case differently anyway.
> As you pointed out, we wouldn't lose much debugging information.
> The same checks could be done in the normal variant with
> WARN_ON(ctx->lock && ctx->lock != lock);
> WARN_ON(ctx->lock && ctx->acquired > 0);

s/lock/contending_lock/ I guess. But yeah, I should have more
carefully read Peter's suggestion to fold in some of the ww_slow debug
checks, we can indeed keep the important debug checks even when
dropping slow. Silly me should be less sloppy.

> But it boils down to ww_mutex_lock_slow returning void instead of int __must_check from ww_mutex_lock.
>
> Maybe add inlines for *_slow, that use the ww_mutex_lock functions, and check ctx->lock == lock in debugging mode?

So either we keep the _slow versions or drop the __must_check for
ww_mutex_lock. In both cases the ww mutex user needs to think a bit
what to do, and I don't there's much we can do in the implementation
(beside all the existing debug support we have) to help. So now I'm
leaning more towards dropping the _slow variants to avoid interface
proliferation.
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
