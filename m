Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab3APAg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:36:58 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:61097 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab3APAgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:36:55 -0500
MIME-Version: 1.0
In-Reply-To: <20130115235043.GJ2668@htj.dyndns.org>
References: <Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
 <CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
 <CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
 <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
 <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
 <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
 <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
 <20130115183204.GE2668@htj.dyndns.org> <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
 <20130115235043.GJ2668@htj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Jan 2013 16:36:34 -0800
X-Google-Sender-Auth: zbF4Ho30qlcgCw-WObzAaoDkxUg
Message-ID: <CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than
 120 seconds"
To: Tejun Heo <tj@kernel.org>
Cc: Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 3:50 PM, Tejun Heo <tj@kernel.org> wrote:
>
> For now, I'm gonna implement simple "I'm not gonna wait for myself"
> self-deadlock avoidance.

You can't really do that. Or rather, it won't *help*.

The thing is, the module loading in particular is not necessarily
happening in the same context as what *started* the module loading. A
module loader will request the module from user space, and then later
user space - through possibly a totally unrelated process - will
finish it. So there is no "myself". There's not even necessarily any
relationship that the kernel even knows about, because the module
loading request can have gone from usermode_helper over something like
dbus to systemd.

See?

There's a reason I asked for a warning for this. Or the "let's flag
the current thread if it ever started anything asynchronous". Because
it's complicated.

          Linus
