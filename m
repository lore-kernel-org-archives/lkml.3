Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab3CIItM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 03:49:12 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:39715 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab3CIItK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 03:49:10 -0500
Message-ID: <513AF783.6050906@gmail.com>
Date: Sat, 09 Mar 2013 09:49:07 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org
Subject: Re: memory leak and other oddness in pinctrl-mvebu.c
References: <1362758331.32099.121.camel@i7.infradead.org>
In-Reply-To: <1362758331.32099.121.camel@i7.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 04:58 PM, David Woodhouse wrote:
> I'm just looking through the kernel for krealloc() abuse, and the
> 'interesting' code in mvebu_pinctrl_build_functions() came to my
> attention.
>
> First it allocates an array 'funcs' as follows:
> 	/* we allocate functions for number of pins and hope
> 	 * there are less unique functions than pins available */
> 	funcs = devm_kzalloc(&pdev->dev, pctl->desc.npins *
> 			     sizeof(struct mvebu_pinctrl_function), GFP_KERNEL);
>
> (note: s/less/fewer/ in the comment).
>
> Then it populates the array, seemly trusting to its "hope" and just
> going off the end of the array if there are more unique functions than
> pins?
>
> And then finally it reallocates the array to the correct size:
>
> 	/* with the number of unique functions and it's groups known,
> 	   reallocate functions and assign group names */
> 	funcs = krealloc(funcs, num * sizeof(struct mvebu_pinctrl_function),
> 			 GFP_KERNEL);
>
> (note: s/it's/its/)
>
> So... if krealloc fails, we *leak* the originally-allocated 'funcs'.
> Except actually we don't because it was allocated with devm_kzalloc() so
> that's OK.

David,

the purpose of the above code is to build up a list of unique functions
and the pins supporting this function. This is a requirement of the pinctrl
API and we had a lengthy discussion with Steven and LinusW back then as
the hardware works just the other way round, i.e. a list of pins with a
set of functions.

The idea was to first assume there will be no more unique functions than
pins available and use that array to store the unique function names. After
that shrink the array to the actual number of unique functions. BTW, this
array isn't used within the driver at all, except to fulfill API requirements
for debugfs.

> If krealloc *succeeds* then I think we should get a double-free because
> it doesn't free the old 'funcs' via devm_kfree() so when the device is
> eventually released, won't devres_release_all() free it again?

I understand that using devm_kzalloc and krealloc will lead to either
double-free or ignored krealloc failure. Is there any other/more correct
way of reallocating that pointer? The fix I would prefer is to allocate
the array but not realloc it to the correct size.

> I'm not entirely sure what that krealloc is *for*, anyway. Apart from
> retrospectively reallocating the array to the size that we've already
> *scribbled* over? Some kind of request for forgiveness, perhaps?
>
> We should probably make the standard kfree() (and hence krealloc())
> actually fail when handed pointers which were allocated with
> devm_kzalloc()?
>
> This completely untested patch attempts to fix it by counting the
> maximum number of functions in advance, then allocating the array at
> that size. In practice it may overallocate if there are name collisions
> and _add_function() returns -EEXIST. Is that something we really need to
> lose sleep over?

I agree that counting all potential unique functions is safe here, but
will lead to overallocation for sure. Actually, the number of unique functions
is known in advance for each SoC but first the information is already there
in what the driver uses for controlling the HW (pins with functions) but with
multiarch kernels in mind, we chose to built that list on runtime.

I don't have a strong opinion on that, but I prefer not to have the list
statically in the SoC specific drivers. I think counting the number of
unique functions for each SoC specific driver once and verify the above
heuristic (fewer unique functions than pins) is still valid. Then drop
the krealloc and leave the array the way it is allocated on devm_kzalloc.

Sebastian
