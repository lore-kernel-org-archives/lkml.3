Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab3APDiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 22:38:06 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:45554 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107Ab3APDiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 22:38:04 -0500
MIME-Version: 1.0
In-Reply-To: <20130116032502.GN2668@htj.dyndns.org>
References: <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
 <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
 <20130115183204.GE2668@htj.dyndns.org> <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
 <20130115235043.GJ2668@htj.dyndns.org> <CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com>
 <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
 <20130116025251.GM2668@htj.dyndns.org> <CA+55aFxttTkWG0gfUz3=V8A-9az3+qY3j0JZEAoKv0ne-QupZw@mail.gmail.com>
 <20130116032502.GN2668@htj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Jan 2013 19:37:42 -0800
X-Google-Sender-Auth: 8yYTcOn-Hi6vHjcHQAAJQUsFJxA
Message-ID: <CA+55aFxCudzOv8e2XjHiT=Qhy9q+mrxUfSYAT=eU6Gq8uyNORw@mail.gmail.com>
Subject: Re: [PATCH] module, async: async_synchronize_full() on module init
 iff async is used
To: Tejun Heo <tj@kernel.org>
Cc: Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 7:25 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Linus.
>
> On Tue, Jan 15, 2013 at 07:00:31PM -0800, Linus Torvalds wrote:
>> That said, maybe we could just make the rule be that you can't pick a
>> default IO scheduler that is modular.
>
> This is definitely much more preferable but it would affect use case
> where everything is built modular and the elevator is selected via
> kernel param.  This is way outside the usual usage and we can warn
> about the new behavior but it still is an observable behavior change.
> Do you think this would be okay?

I do want the same user-visible semantics, so it's not some one-liner.

The compiled-in elevator would be easy enough to handle in the Kconfig
file (maybe we do already, I didn't even bother to check). The real
problem is the "chosen_elevator" one, which is dynamic with the kernel
command line. And we could handle that one by just trying to load the
module early (but exactly _when_?) and then instead of looking things
up by name, just keep a pointer to the default elevator around.

But no, it's not just some trivial one-liner. Especially the question
about "when to try to load the module that is given on the kernel
command line" is not trivial. Do we require that the module is in the
initrd and loadable basically immediate at boot? Do we try again after
switching the root filesystem? Things like that..

> And then this warning can be added without introducing
> request_module_but_dont_warn_about_being_called_from_async().

I do agree that it would be much nicer that way.

               Linus
