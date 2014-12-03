Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaLCUwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:52:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56967 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbaLCUwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:52:40 -0500
Date: Wed, 3 Dec 2014 21:52:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: rui wang <ruiv.wang@gmail.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, aris@redhat.com,
        rui.y.wang@intel.com
Subject: Re: Bug: Fatal errors result in infinite stream of error messages
Message-ID: <20141203205237.GE31246@pd.tnic>
References: <CANVTcTaChssJEU48iS6a1WwFf59Tqz2T9VrnsSM9ZLwnRC+SWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANVTcTaChssJEU48iS6a1WwFf59Tqz2T9VrnsSM9ZLwnRC+SWw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 05:11:49PM +0800, rui wang wrote:
> The problem is because kdump fails to load a new kernel, and we're
> executing past crash_kexec() in panic(). And it calls
> bust_spinlocks(0) which calls into the GPU driver trying to unblank
> the screen, which eventually calls __schedule() while waiting for a
> mutex to be released. But we're still in the machine check context.
> The infinite stream of errors is because there's a for(;;) loop in
> __mutex_lock_common(), so we enter __schedule() again and again.

Hmm, there's a bust_spinlocks(1) call in mce_panic() for which I have no
idea what it is for? To stop us from scheduling?

If so, why doesn't it stop us...?

There's also this:

void console_unblank(void)
{
        struct console *c;

        /*
         * console_unblank can no longer be called in interrupt context unless
====>    * oops_in_progress is set to 1..
         */
        if (oops_in_progress) {
                if (down_trylock_console_sem() != 0)
                        return;
        } else
                console_lock();


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
