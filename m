Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab3E0Ozu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:55:50 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44869 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab3E0Ozs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:55:48 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CAKMK7uEG1t5ahSfCkUm39vK-K-A=XgnPK_2RKcCYU7pHuc1v1g@mail.gmail.com>
References: <20130428165914.17075.57751.stgit@patser>
	<20130428170407.17075.80082.stgit@patser>
	<20130430191422.GA5763@phenom.ffwll.local>
	<519CA976.9000109@canonical.com>
	<20130522161831.GQ18810@twins.programming.kicks-ass.net>
	<519CFF56.90600@canonical.com>
	<20130527082149.GE2781@laptop>
	<CAKMK7uEG1t5ahSfCkUm39vK-K-A=XgnPK_2RKcCYU7pHuc1v1g@mail.gmail.com>
Date: Mon, 27 May 2013 16:55:47 +0200
X-Google-Sender-Auth: xBoqqPZM_KzSiIEeu9ho2JtiBwY
Message-ID: <CAKMK7uHgEKsBT97c0zBeNfj7E3MSZwOUN9cj-AN6cyO_vm0+kw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mutex: add support for wound/wait style locks, v3
From: Daniel Vetter <daniel@ffwll.ch>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, x86@kernel.org,
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

On Mon, May 27, 2013 at 4:47 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Mon, May 27, 2013 at 10:21 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Wed, May 22, 2013 at 07:24:38PM +0200, Maarten Lankhorst wrote:
>>> >> +static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
>>> >> +                             struct ww_class *ww_class)
>>> >> +{
>>> >> +  ctx->task = current;
>>> >> +  do {
>>> >> +          ctx->stamp = atomic_long_inc_return(&ww_class->stamp);
>>> >> +  } while (unlikely(!ctx->stamp));
>>> > I suppose we'll figure something out when this becomes a bottleneck. Ideally
>>> > we'd do something like:
>>> >
>>> >  ctx->stamp = local_clock();
>>> >
>>> > but for now we cannot guarantee that's not jiffies, and I suppose that's a tad
>>> > too coarse to work for this.
>>> This might mess up when 2 cores happen to return exactly the same time, how do you choose a winner in that case?
>>> EDIT: Using pointer address like you suggested below is fine with me. ctx pointer would be static enough.
>>
>> Right, but for now I suppose the 'global' atomic is ok, if/when we find
>> it hurts performance we can revisit. I was just spewing ideas :-)
>
> We could do a simple
>
> ctx->stamp = (local_clock() << nr_cpu_shift) | local_processor_id()
>
> to work around any bad luck in grabbing the ticket. With sufficient
> fine clocks the bias towards smaller cpu ids would be rather
> irrelevant. Just wanted to drop this idea before I'll forget about it
> again ;-)
Not a good idea to throw around random ideas right after a work-out.
This is broken since different threads could end up with the same low
bits. Comparing ctx pointers otoh on top of the timestamp should work.
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
