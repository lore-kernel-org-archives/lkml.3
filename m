Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3IKPdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:33:33 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:37335 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754367Ab3IKPda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:33:30 -0400
Message-ID: <52308D47.409@hurleysoftware.com>
Date: Wed, 11 Sep 2013 11:33:27 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: John Tapsell <johnflux@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Deadlock in fb and tty
References: <CAHQ6N+pQpfmG-b_9iv0Ajg5EYPjfEK0=KYcQa0DLVmyN8VKZrQ@mail.gmail.com>
In-Reply-To: <CAHQ6N+pQpfmG-b_9iv0Ajg5EYPjfEK0=KYcQa0DLVmyN8VKZrQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 05:25 AM, John Tapsell wrote:
> Hi,
>    I'm consistently and constantly hitting a deadlock.
>
> console_callback in drivers/tty/vt/vt.c does:  console_lock()  and then calls:
>    do_blank_screen, which calls:
>      vc->vc_sw->con_blank(..)  which can be a pointer to the function:
>        fbcon_blank in video/console/fbcon.c.  This is missing a
> WARN_CONSOLE_UNLOCKED.  This calls:
>          fbcon_generic_blank which does lock_fb_info(info)
>
> So we have a console_lock() followed by a lock_fb_info(info).
>
> Now if while that is running, we have an ioctl call:
>
> do_fb_ioctl in drivers/video/fbmem.c which does:
>                 if (!lock_fb_info(info))
>                          return -ENODEV;
>                  console_lock();
>
>
> So it tries to acquire the same locks in the reverse order.  This
> deadlocks consistently for me.
>
> (I'm also curious why I'm hitting this continually, when everyone else
> seems to be okay.)
>
> I understand that this is really difficult to fix, but if anyone has
> even a suggestion on how to hack it to make it work for me, I'd be
> very grateful.

As a temporary workaround, you can disable timed console blanking on the
kernel command line with 'consoleblank=0'.

Regards,
Peter Hurley

