Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524Ab3KZWaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 17:30:16 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:34320 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758476Ab3KZWaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 17:30:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAKA=qzY2JYxbO=0s8_SnUn-8b=1+RqsdAzXQhfHYxo1isv0K-g@mail.gmail.com>
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
	<CAKA=qzY2JYxbO=0s8_SnUn-8b=1+RqsdAzXQhfHYxo1isv0K-g@mail.gmail.com>
Date: Tue, 26 Nov 2013 14:30:10 -0800
X-Google-Sender-Auth: 1WGLv30aZEY6W9NDSjsuwSN6HSc
Message-ID: <CA+55aFx0j5QXCtHtZcc=JHkjW_vCB80j+fSer1B_fEqAaqDu=A@mail.gmail.com>
Subject: Re: [3.8-rc3 -> 3.8-rc4 regression] Re: [PATCH] module, async:
 async_synchronize_full() on module init iff async is used
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Jonathan Nieder <jrnieder@gmail.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 2:12 PM, Josh Hunt <joshhunt00@gmail.com> wrote:
>
> I should have clarified that I'm not using dm/md in my setup. I know
> the modules are getting loaded in the log I attached, but root is not
> a md/dm device.

Hmm. The initcall debugging doesn't actually show any of the "wait for
async events", because those debug messages come from
"do_one_initcall()", and the waiting happens later. Plus your messages
don't actually show where you are trying to - and failing - to mount
the root filesystem.

Without that kind of information, it's kind of hard to guess. Maybe
you could add a few printk's to your kernel? Add one to
do_init_module() *after* the

        if (current->flags & PF_USED_ASYNC)
                async_synchronize_full();

thing, and another to fs/namespace.c: do_mount() (just put something like

        printk("do_mount: %s at %s\n", dev_name, dir_name);

or whatever, so that we can see when that happens..

              Linus
