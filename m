Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3CKW0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 18:26:01 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:42732 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab3CKW0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 18:26:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130311220059.GA18499@cantiga.alporthouse.com>
References: <20130311212329.GA21629@www.outflux.net>
	<20130311220059.GA18499@cantiga.alporthouse.com>
Date: Mon, 11 Mar 2013 15:25:59 -0700
X-Google-Sender-Auth: e1DOlH0ZDrKt72m5DU9zg_UXEDA
Message-ID: <CAGXu5jJrszKtqwQxWFT3gbjubn4iRedaZHbyJ6LJRy7EVzbftw@mail.gmail.com>
Subject: Re: [PATCH v2] drm/i915: bounds check execbuffer relocation count
From: Kees Cook <keescook@chromium.org>
To: Chris Wilson <chris@chris-wilson.co.uk>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Julien Tinnes <jln@google.com>, marcheu@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 3:00 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Mon, Mar 11, 2013 at 02:23:29PM -0700, Kees Cook wrote:
>> It is possible to wrap the counter used to allocate the buffer for
>> relocation copies. This could lead to heap writing overflows.
>
> I'd keep the return value as EINVAL so that we can continue to
> distinguish between the user passing garbage and hitting an oom. And
> total_relocs is preferrable to total, which also leads us to think more
> carefully about the error condition. I think the check should be against
> INT_MAX / sizeof(struct reloc_entry) for consistency with our other
> guard against overflows whilst allocating.

I've ended up with this:

        int max_alloc = INT_MAX / sizeof(struct drm_i915_gem_relocation_entry);
...
                /* First check for malicious input causing overflow */
                if (exec[i].relocation_count > max_alloc)
                        return -EINVAL;
                if (exec[i].relocation_count > max_alloc - total_relocs)
                        return -EINVAL;
                total_relocs += exec[i].relocation_count;

And looking at that, I wonder if we should just eliminate the first if entirely?

-Kees

--
Kees Cook
Chrome OS Security
