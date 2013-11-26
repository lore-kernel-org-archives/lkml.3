Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab3KZWMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 17:12:50 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:41904 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758091Ab3KZWMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 17:12:43 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFw9wNBoJBYQ+kjpqs6cnVjGHVs2oxfguMmyYXNPcqqzkQ@mail.gmail.com>
References: <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
	<CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
	<CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
	<20130115183204.GE2668@htj.dyndns.org>
	<CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
	<20130115235043.GJ2668@htj.dyndns.org>
	<CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com>
	<CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
	<20130116025251.GM2668@htj.dyndns.org>
	<20130812070411.GA2878@elie.Belkin>
	<20130812150900.GJ15892@htj.dyndns.org>
	<CAKA=qzY5NBZSv8r9sHqX-3fY-yrSXq26zPM1AvjoANaZkqJavQ@mail.gmail.com>
	<CA+55aFw9wNBoJBYQ+kjpqs6cnVjGHVs2oxfguMmyYXNPcqqzkQ@mail.gmail.com>
Date: Tue, 26 Nov 2013 16:12:41 -0600
Message-ID: <CAKA=qzY2JYxbO=0s8_SnUn-8b=1+RqsdAzXQhfHYxo1isv0K-g@mail.gmail.com>
Subject: Re: [3.8-rc3 -> 3.8-rc4 regression] Re: [PATCH] module, async:
 async_synchronize_full() on module init iff async is used
From: Josh Hunt <joshhunt00@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Jonathan Nieder <jrnieder@gmail.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 3:53 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Nov 26, 2013 at 1:29 PM, Josh Hunt <joshhunt00@gmail.com> wrote:
>>
>> Both ahci and sata_svw call ata_host_activate(), which call
>> ata_host_register() and async_schedule(async_port_probe, ap).
>
> Well, with the modern logic ("only wait for async probing if the
> module itself did async probing") the ahci and svw modules didn't
> really change any behavior.
>
> But other modules did. I wonder, for example, if people insmod the dm
> module, and expect all devices to exist afterwards. Which the old
> logic of "we always wait for all async code regardless of whether we
> started it ourselves" would do, but the new logic does not.
>
> Something similar might hit the (non-modular) md auto-detect ioctl.
>
> So maybe we should just special-case those two issues, and say "let's
> just wait for async requests here"
>
> Something like the appended (whitespace-damaged) diff. Does that make
> a difference to you guys? And if it does, can you check *which* of the
> two async_synchronize_full() calls it is that matters for your cases?
>
>                  Linus
>
> --- duh, apply by hand --
>
>     diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>     index 0704c523a76b..7e7a2f743b11 100644
>     --- a/drivers/md/dm.c
>     +++ b/drivers/md/dm.c
>     @@ -351,6 +351,7 @@ static int __init dm_init(void)
>                             goto bad;
>             }
>
>     +       async_synchronize_full();
>             return 0;
>
>            bad:
>     diff --git a/drivers/md/md.c b/drivers/md/md.c
>     index b6b7a2866c9e..1d173dc662fc 100644
>     --- a/drivers/md/md.c
>     +++ b/drivers/md/md.c
>     @@ -8602,6 +8602,7 @@ static void autostart_arrays(int part)
>             i_scanned = 0;
>             i_passed = 0;
>
>     +       async_synchronize_full();
>             printk(KERN_INFO "md: Autodetecting RAID arrays.\n");
>
>             while (!list_empty(&all_detected_devices) && i_scanned < INT_MAX) {

I should have clarified that I'm not using dm/md in my setup. I know
the modules are getting loaded in the log I attached, but root is not
a md/dm device.

-- 
Josh
