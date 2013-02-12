Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541Ab3BLVDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:03:42 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:45797 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3BLVDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:03:39 -0500
From: Kevin Hilman <khilman@linaro.org>
To: NeilBrown <neilb@suse.de>
Cc: Igor Grinberg <grinberg@compulab.co.il>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] usb: musb: fix context save over suspend.
References: <20130121202831.40a09bbc@notabene.brown>
	<50FD28D3.5070107@compulab.co.il>
	<20130122083832.7a3026c9@notabene.brown>
Date: Tue, 12 Feb 2013 13:03:36 -0800
In-Reply-To: <20130122083832.7a3026c9@notabene.brown> (NeilBrown's message of
	"Tue, 22 Jan 2013 08:38:32 +1100")
Message-ID: <87zjz9i6s7.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown <neilb@suse.de> writes:

> On Mon, 21 Jan 2013 13:38:59 +0200 Igor Grinberg <grinberg@compulab.co.il>
> wrote:
>
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>> 
>> Hi Neil,
>> 
>> On 01/21/13 11:28, NeilBrown wrote:
>> > 
>> > 
>> > The standard suspend sequence involves runtime_resuming
>> > devices before suspending the system.
>> > So just saving context in runtime_suspend and restoring it
>> > in runtime resume isn't enough.  We  must also save in "suspend"
>> > and restore in "resume".
>> > 
>> > Without this patch, and OMAP3 system with off_mode enabled will find
>> > the musb port non-functional after suspend/resume.  With the patch it
>> > works perfectly.
>> 
>> Hmmm... Some time ago, this has been removed in
>> 5d193ce8 (usb: musb: PM: fix context save/restore in suspend/resume path)
>> 
>> Am I missing something? Or things changed and now this patch is correct?
>
> Hi Igor,
>  thanks for alerting me to that patch .... does anyone else get the feeling
>  that power management to too complex to be understood by a mere human?

Yes.  ;)

>  That commit (5d193ce8) suggests that the musb-hdrc device is an
>  'omap_device', or maybe has a PM domain set to something else.
>  However it isn't/doesn't.  dev->pm_domain is NULL.  So no PM domain layer
>  will ever call the musb_core musb_runtime_suspend/resume.
>
>  The parent device - musb-omap2430 - is an omap device, does have pm_domain
>  set, and does have its omap2430_runtime_suspend/resume called for system
>  suspend and so the context for that device is saved and restored.
>  However that doesn't help the context for musb-hdrc.
>
>  Whether musb ever was an omap_device is beyond my archaeological skills to
>  determine.
>
>  Kevin:  Was musb-hdrc ever a device with a pm_domain? or was it only ever
>      the various possible parents that had domains?
>      Are you able to defend your earlier patch in today's kernel?  It
>      certainly causes my device not to work properly.

Sorry for the delay here, I'm back to a place where I can test this on
real hardware.

My patch was fixing a real hang when musb was built-in (or loaded), in
host-mode (mini-A cable attached) but no devices attached.  I just tried
to reproduce this, and with your patch, the system hangs during suspend.

That being said, your description makes sense why this context
save/restore is needed.  Perhaps your patch needs to add a check whether
the device is runtime suspended (I gather this is what Ruslan's patch is
doing.)

Kevin
