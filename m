Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3JBQXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:23:35 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:57435 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab3JBQXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:23:33 -0400
MIME-Version: 1.0
In-Reply-To: <524C46E2.5040804@wwwdotorg.org>
References: <1380725919-1961-1-git-send-email-dh.herrmann@gmail.com>
	<524C46E2.5040804@wwwdotorg.org>
Date: Wed, 2 Oct 2013 18:23:31 +0200
Message-ID: <CANq1E4TuzskdyXVza3YRbR7GmGzHnm9jFmeHmyO2ghuC9u_5WA@mail.gmail.com>
Subject: Re: [PATCH 1/2] simplefb: fix unmapping fb during destruction
From: David Herrmann <dh.herrmann@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tom Gundersen <teg@jklm.no>, Alexandre Courbot <acourbot@nvidia.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Oct 2, 2013 at 6:16 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 10/02/2013 08:58 AM, David Herrmann wrote:
>> Unfortunately, fbdev does not create its own "struct device" for
>> framebuffers. Instead, it attaches to the device of the parent layer. This
>> has the side-effect that devm_* managed resources are not cleaned up on
>> framebuffer-destruction but rather during destruction of the
>> parent-device. In case of fbdev this might be too late, though.
>> remove_conflicting_framebuffer() may remove fbdev devices but keep the
>> parent device as it is.
>>
>> Therefore, we now use plain ioremap() and unmap the framebuffer in the
>> fb_destroy() callback. Note that we must not free the device here as this
>> might race with the parent-device removal. Instead, we rely on
>> unregister_framebuffer() as barrier and we're safe.
>
> So, once the .fb_destroy callback has been executed, there's no other
> callback to resurrect it? The framebuffer itself is still registered
> until the device's remove, yet after .fb_destroy, the memory is
> unmapped, which would be dangerous if the FB can be re-started.

fbdev lifetime tracking is weird.. ->fb_destroy() is called by
unregister_framebuffer() _after_ it got unlinked. So no, the
framebuffer is gone and cannot be resurrected. However, the
unregistered/dead fbdev object itself stays around until you call
framebuffer_release(). We cannot call it from fb_destroy(), though as
the platform_data in your platform device still points to the fbdev
device. Therefore we keep it and wait for the platform-driver to be
removed which then again calls unregister_framebuffer() (which will
immediately return as the fbdev device is not registered) and then you
can finally call framebuffer_release().

Note that even though there's fb_get_info() and fb_put_info(), both
are not exported and never used. So there is *no* fbdev ref-counting
(which would be horribly broken anyway) and the driver is the sole
owner of the fbdev object.

> If that's not an issue, this patch seems fine, so
> Acked-by: Stephen Warren <swarren@nvidia.com>

Thanks!

>> I know that simplefb was supposed to stay "as simple as possible" but I really
>> think this series is the last set of fixes I have. Unfortunately framebuffer DRM
>> handover is mandatory so we cannot ignore it in simplefb.
>
> I don't think this patch adds any significant complexity, so I'm not
> worried at least.

Good to hear!

Thanks
David
