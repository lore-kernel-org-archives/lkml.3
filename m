Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751115AbaLPNpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 08:45:21 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:45142 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaLPNpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 08:45:19 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <54902AA1.7080301@hurleysoftware.com>
References: <1418681761-3709-1-git-send-email-imre.deak@intel.com>
	<1418681761-3709-3-git-send-email-imre.deak@intel.com>
	<20141216075300.GI2711@phenom.ffwll.local>
	<1418725405.3185.31.camel@ideak-mobl>
	<54902AA1.7080301@hurleysoftware.com>
Date: Tue, 16 Dec 2014 14:45:18 +0100
X-Google-Sender-Auth: xWya7Ybr36FRQkV_wb8Ic-XSnyQ
Message-ID: <CAKMK7uFN0qnxuQyWwpq4dgNy4eS+LdE-2404UqG4TQoAh58q7w@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] vt: fix console lock vs. kernfs s_active lock order
From: Daniel Vetter <daniel@ffwll.ch>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Imre Deak <imre.deak@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 1:50 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
>>> So NACK from me for this.
>>
>> I think I proved it in the commit message that this issue is independent
>> of fbcon/fbdev, so refactoring these will not solve it. This patch fixes
>> an issue in vt and while your points may be valid, they are not really
>> about this issue or how the patch fixes it.
>
> I think you may have missed Daniel's point. Which is what I was trying to
> point out earlier but in an overly terse manner.
>
> If you start by just moving the sysfs teardown outside the console_lock
> (but still in the same thread of execution), then the direct lock inversion
> between console_lock and the sysfs lock goes away.
>
> However, you'll now realize that you can't move the sysfs teardown outside
> the console lock because fbcon is doing teardown from inside its notifier,
> which means that there would be a lock inversion between the console lock
> and the notifier lock.
>
> Which is why we're pointing out that the real problem here is the
> fb notifier call chain lock.

It's more the overall story. The patch is imo technically ok, but it's
yet another step in the wrong direction. We've unfortunately piled up
lots of those around fbcon/console_lock and eventually we need to
start going a better direction. Applying a hack will just result in
everyone forgetting about this until the next head of the hydra pops
out of the water.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
