Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab3ARCsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 21:48:11 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:39348 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab3ARCsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 21:48:09 -0500
MIME-Version: 1.0
In-Reply-To: <20130118012503.GH16568@mtj.dyndns.org>
References: <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
 <20130116025251.GM2668@htj.dyndns.org> <CA+55aFxttTkWG0gfUz3=V8A-9az3+qY3j0JZEAoKv0ne-QupZw@mail.gmail.com>
 <20130116032502.GN2668@htj.dyndns.org> <CA+55aFxCudzOv8e2XjHiT=Qhy9q+mrxUfSYAT=eU6Gq8uyNORw@mail.gmail.com>
 <20130116164832.GP2668@htj.dyndns.org> <50F6DD4D.3070808@linux.intel.com>
 <CA+55aFyjrXzKMqmOuMo9z24OZj3kD4O4M4y_O-h=r6udCz2MyA@mail.gmail.com>
 <20130116213032.GS2668@htj.dyndns.org> <CA+55aFzdf44QOZn4KS6tT09COFsmCg80sTah1XpeoErJxAzbRQ@mail.gmail.com>
 <20130118012503.GH16568@mtj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Jan 2013 18:47:48 -0800
X-Google-Sender-Auth: y6qo9Q3FaZalMVixOwh5s4IckYE
Message-ID: <CA+55aFyCihvZqOo=83UwWq3AgJEfVqpNjsY2iCFOEm8o6Un-YA@mail.gmail.com>
Subject: Re: [PATCH 2/3] workqueue, async: implement work/async_current_func()
To: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 5:25 PM, Tejun Heo <tj@kernel.org> wrote:
> Implement work/async_current_func() which query whether the current
> task is a workqueue or async worker respectively and, if so, return
> the current function being executed along with work / async item
> related information.

So why the odd interface? The only user of it calls it with a
NULL/NULL pair of arguments, and in general it's just way too complex
to be an exported function at all. I *suspect* you chose that complex
interface because you feel you may have some use for it inside of the
async code itself, but why isn't that then not totally private to
there?

IOW, why isn't the interface just

   static struct worker *current_worker(void)
   {
      if (current->flags & PF_WQ_WORKER)
         return kthread_data(current);
      return NULL;
   }

   int current_is_async(void)
   {
      struct worker *worker = current_worker(void);
      return worker && worker->current_func == async_run_entry_fn;
   }

and that current_is_async() is enough for the exported interface.

Then, if you actually want to care about the work itself, you can use
that same "current_worker()" helper function, and look at the
different worker fields more. But why export that kind of logic?

Am I missing something?

                   Linus
