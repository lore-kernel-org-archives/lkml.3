Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaLDMv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:51:58 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:43602 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaLDMv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:51:56 -0500
MIME-Version: 1.0
In-Reply-To: <20141203205237.GE31246@pd.tnic>
References: <CANVTcTaChssJEU48iS6a1WwFf59Tqz2T9VrnsSM9ZLwnRC+SWw@mail.gmail.com>
	<20141203205237.GE31246@pd.tnic>
Date: Thu, 4 Dec 2014 20:51:54 +0800
Message-ID: <CANVTcTbaGxDPQx503m91KqUY1oGPMTQR3ZCXNrfC5LKs44pBmw@mail.gmail.com>
Subject: Re: Bug: Fatal errors result in infinite stream of error messages
From: rui wang <ruiv.wang@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, aris@redhat.com,
        rui.y.wang@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/4/14, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, Dec 03, 2014 at 05:11:49PM +0800, rui wang wrote:
>> The problem is because kdump fails to load a new kernel, and we're
>> executing past crash_kexec() in panic(). And it calls
>> bust_spinlocks(0) which calls into the GPU driver trying to unblank
>> the screen, which eventually calls __schedule() while waiting for a
>> mutex to be released. But we're still in the machine check context.
>> The infinite stream of errors is because there's a for(;;) loop in
>> __mutex_lock_common(), so we enter __schedule() again and again.
>
> Hmm, there's a bust_spinlocks(1) call in mce_panic() for which I have no
> idea what it is for? To stop us from scheduling?
>
> If so, why doesn't it stop us...?
>
> There's also this:
>
> void console_unblank(void)
> {
>         struct console *c;
>
>         /*
>          * console_unblank can no longer be called in interrupt context
> unless
> ====>    * oops_in_progress is set to 1..
>          */
>         if (oops_in_progress) {
>                 if (down_trylock_console_sem() != 0)
>                         return;
>         } else
>                 console_lock();
>

That points to the direction of a potential fix. There are places
under drivers/gpu/drm/ which should do this kind of check in order to
make it work in panic. An existing example is here :

void drm_warn_on_modeset_not_all_locked(struct drm_device *dev)
{
        struct drm_crtc *crtc;

        /* Locking is currently fubar in the panic handler. */
        if (oops_in_progress) <======
                return;

        list_for_each_entry(crtc, &dev->mode_config.crtc_list, head)
                WARN_ON(!drm_modeset_is_locked(&crtc->mutex));

        WARN_ON(!drm_modeset_is_locked(&dev->mode_config.connection_mutex));
        WARN_ON(!mutex_is_locked(&dev->mode_config.mutex));
}

I'll send a patch later.

Thanks
Rui
