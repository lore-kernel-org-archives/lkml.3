Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbaGSQgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 12:36:37 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:57348 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbaGSQgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 12:36:35 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1407160308550.1775@eggly.anvils>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>
	<1402655819-14325-7-git-send-email-dh.herrmann@gmail.com>
	<alpine.LSU.2.11.1407160308550.1775@eggly.anvils>
Date: Sat, 19 Jul 2014 18:36:34 +0200
Message-ID: <CANq1E4SMTcTyWJ5ngbq1c-cu0YWn84vjNZsx6C82EAxYeyh2Dg@mail.gmail.com>
Subject: Re: [RFC v3 6/7] shm: wait for pins to be released when sealing
From: David Herrmann <dh.herrmann@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Ryan Lortie <desrt@desrt.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        John Stultz <john.stultz@linaro.org>,
        Lennart Poettering <lennart@poettering.net>,
        Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Tony Battersby <tonyb@cybernetics.com>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Jul 16, 2014 at 12:09 PM, Hugh Dickins <hughd@google.com> wrote:
> On Fri, 13 Jun 2014, David Herrmann wrote:
>
>> We currently fail setting SEAL_WRITE in case there're pending page
>> references. This patch extends the pin-tests to wait up to 150ms for all
>> references to be dropped. This is still not perfect in that it doesn't
>> account for harmless read-only pins, but it's much better than a hard
>> failure.
>>
>> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
>
> Right, I didn't look through the patch itself, just compared the result
> with what I sent.  Okay, you prefer to separate out shmem_tag_pins().

The main reason why I split both is to avoid goto-label "restart" and
"restart2".

> Yes, it looks fine.  There's just one change I'd like at this stage,
> something I realized shortly after sending the code fragment: please
> add a call to lru_add_drain() at the head of shmem_tag_pins().  The
> reason being that lru_add_drain() is local to the cpu, so cheap, and
> in many cases will bring down all the raised refcounts right then.
>
> Whereas lru_add_drain_all() in the first scan of shmem_wait_for_pins()
> is much more expensive, involving inter-processor interrupts to do
> that on all cpus: it is appropriate to call it at that point, but we
> really ought to try the cheaper lru_add_drain() at the earlier stage.

I added an lru_add_drain_all() to my shmem_test_pins() function in
Patch 2/7. This patch dropped it again as your wait_for_pins() already
included it and it's quite expensive. But yes, the local
lru_add_drain() makes perfect sense. Fixed!

Thanks
David

> I would also like never to embark on this scan of the radix_tree
> and wait for pins, if the pages were never given out in a VM_SHARED
> mapping - or is that unrealistic, because every memfd is read-write,
> and typical initialization expected to be by mmap() rather than write()?
> But anyway, you're quite right not to get into that at this stage:
> it's best left as an optimization once the basics are safely in.
