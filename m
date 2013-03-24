Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab3CXRKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 13:10:18 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:35479 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab3CXRKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 13:10:16 -0400
MIME-Version: 1.0
In-Reply-To: <CA+i8gKJuykoCk=O3qbDmmZXd=8U13wF7o_NzUviccaZoU6WLaA@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<CA+i8gKKK_VxZtyyp1tqHnztd4++XyNXwbEEr-A29-J23PyuCfQ@mail.gmail.com>
	<CA+55aFzqBEX=cGGZJJsfNWcDwQcUOP7njEog-kZZLRxuDg8Tzg@mail.gmail.com>
	<CA+i8gK+h+FyPiOL85BPa-Pu8+bDw6LW60-oRoLHgP2AnzMADCA@mail.gmail.com>
	<CA+55aFxjGFi+gt3UwdVCVKP5riHSR=_qLkp0SovgW2zx+gcRow@mail.gmail.com>
	<CA+i8gKJuykoCk=O3qbDmmZXd=8U13wF7o_NzUviccaZoU6WLaA@mail.gmail.com>
Date: Sun, 24 Mar 2013 10:10:15 -0700
X-Google-Sender-Auth: DCVDC-w3WXr9N7H2Fz_TH5clrqI
Message-ID: <CA+55aFwb9v9cUG4Ton3faO6xAD18JxxoTPcObXDV_5Zf3QQ=Kw@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Rik van Riel <riel@surriel.com>, Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 6:46 AM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>
> Thanks Linus. I hope I got this right, here's the result (3.9-rc4, 7+1
> patches): http://i.imgur.com/BebGZxV.jpg

Ok, that's *slightly* more informative, but not much. At least now we
see the actual page fault information, and see what the bad
dereference was.

It seems to be a branch through the rcu list "->func" pointer in the
rcu callbacks, and the ->func pointer has been corrupted. Instead of
being a valid kernel pointer (or a "kfree_rcu_offset" marker, which is
a small number between 0-4096), it has the odd value
"0x0000006400000064". Two words of decimal "100", in other words.

That's not one of the usual "use-after-free" patters or anything like
that, so I don't see what it would be. So I have to admit to not
really having any better clue about what is going on. Sometimes the
corruption pattern give a hint of what it was that overwrote it, but
not here..

And you never see this problem without Rik's patches? Could you bisect
*which* patch it starts with? Are the first four ones ok (the moving
of the locking around, but without the fine-grained ones), for
example?

Another thing to try might be to enable SLUB debugging (ie make sure that all of

  CONFIG_SLUB_DEBUG=y
  CONFIG_SLUB=y
  CONFIG_SLUB_DEBUG_ON=y

are set in your kernel config), which might help pin things down a
bit. Sometimes that makes any allocation problems show up earlier in
the path, so that it's more obvious who screwed up.

              Linus
