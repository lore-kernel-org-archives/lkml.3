Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab3IKJ0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 05:26:15 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:40416 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab3IKJ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 05:26:14 -0400
MIME-Version: 1.0
From: John Tapsell <johnflux@gmail.com>
Date: Wed, 11 Sep 2013 10:25:53 +0100
Message-ID: <CAHQ6N+pQpfmG-b_9iv0Ajg5EYPjfEK0=KYcQa0DLVmyN8VKZrQ@mail.gmail.com>
Subject: Deadlock in fb and tty
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I'm consistently and constantly hitting a deadlock.

console_callback in drivers/tty/vt/vt.c does:  console_lock()  and then calls:
  do_blank_screen, which calls:
    vc->vc_sw->con_blank(..)  which can be a pointer to the function:
      fbcon_blank in video/console/fbcon.c.  This is missing a
WARN_CONSOLE_UNLOCKED.  This calls:
        fbcon_generic_blank which does lock_fb_info(info)

So we have a console_lock() followed by a lock_fb_info(info).

Now if while that is running, we have an ioctl call:

do_fb_ioctl in drivers/video/fbmem.c which does:
               if (!lock_fb_info(info))
                        return -ENODEV;
                console_lock();


So it tries to acquire the same locks in the reverse order.  This
deadlocks consistently for me.

(I'm also curious why I'm hitting this continually, when everyone else
seems to be okay.)

I understand that this is really difficult to fix, but if anyone has
even a suggestion on how to hack it to make it work for me, I'd be
very grateful.

Thank you,

John Tapsell
