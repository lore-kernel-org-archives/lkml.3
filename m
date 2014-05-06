Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbaEFNxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:53:33 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:35987 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaEFNxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:53:32 -0400
MIME-Version: 1.0
In-Reply-To: <s5heh07uivs.wl%tiwai@suse.de>
References: <s5htx94fkfi.wl%tiwai@suse.de>
	<CAKMK7uHcYvuViEeyxLc75+kMVPPaKMr8svJQysk124--cjGL+g@mail.gmail.com>
	<s5hd2fsffhk.wl%tiwai@suse.de>
	<CAKMK7uGD5JCQSfk+Vuf=qrjU9x+Y+-W3o-xyGyTM_BreR_XZcw@mail.gmail.com>
	<s5hha53ujeq.wl%tiwai@suse.de>
	<CANq1E4QkzqhrgeJrAZ=wxQR751BdSK13E4QjWPWkiq5B8vFr9Q@mail.gmail.com>
	<s5heh07uivs.wl%tiwai@suse.de>
Date: Tue, 6 May 2014 15:53:32 +0200
Message-ID: <CANq1E4Qfohv7A-rcGVb6pc5rRffWsef4FkXButSJUkYxz9qkng@mail.gmail.com>
Subject: Re: Atomicity in KMS panic notifier
From: David Herrmann <dh.herrmann@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, May 6, 2014 at 3:38 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 6 May 2014 15:32:21 +0200,
> David Herrmann wrote:
>> fbcon is called through the VT or fbdev layer, which is called by
>> bust_spinlocks(1) via either unblank_screen() or console_unblank().
>
> You mean bust_spinlocks(0), right?
>
> void __attribute__((weak)) bust_spinlocks(int yes)
> {
>         if (yes) {
>                 ++oops_in_progress;
>         } else {
> #ifdef CONFIG_VT
>                 unblank_screen();
> #endif
>                 console_unblank();
>                 if (--oops_in_progress == 0)
>                         wake_up_klogd();
>         }
> }
>
> bust_spinlocks(0) is called after the notifier chain, and it's almost
> at the end of panic().

Yes, it's called _after_ the panic-handlers but _before_
console_unlock() (see console_unblank() in printk.c). Therefore, we
call into set_config() before the serial drivers get the panic-message
(flushed via console_unlock()). If the serial drivers (or whatever you
use for debugging) register their own panic-handlers, then they're
fine of course.

Thanks
David
