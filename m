Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab3C3DqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 23:46:11 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:40848 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585Ab3C3DqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 23:46:09 -0400
MIME-Version: 1.0
In-Reply-To: <CA+i8gK+LP_4SU8GwLMau0QvyGswZ5sKqOYnJVPZNWXZY_W9dEA@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
	<20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	<20130329161746.GA8391@redhat.com>
	<CA+55aFyKhgwYUMGs8MBLY5WDXhHwXP3dLWs40ayCYfgiwwncsQ@mail.gmail.com>
	<CA+55aFyT6jxC=+jfORJkymo4Eagzpz-SajmnCO_PjGAPE6o25A@mail.gmail.com>
	<CA+55aFygTH-tqhL1=FY32+HkjfqqpkX-nvb1c5f3V6S-iykS8A@mail.gmail.com>
	<CA+i8gK+NTCK6OUzobvxPj+UaCO-iit-ww9VGNzmdqDfRC_+SuA@mail.gmail.com>
	<1364609309.1818.8.camel@buesod1.americas.hpqcorp.net>
	<CA+i8gK+LP_4SU8GwLMau0QvyGswZ5sKqOYnJVPZNWXZY_W9dEA@mail.gmail.com>
Date: Fri, 29 Mar 2013 20:46:08 -0700
X-Google-Sender-Auth: d43RgD7alalTX0jabkk1w7iN_2c
Message-ID: <CA+55aFzqzHa_6bHrqaa+6k3PZiibuJuDd1VwVD7jL047BjR=hA@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 8:02 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>
> Then I start building a random package and the problems start. They
> may also happen without compiling but this seems to trigger the bug
> quite quickly.

I suspect it's about preemption, and the build just results in enough
scheduling load that you start hitting whatever race there is.

> Anyway, some progress here, I hope: dmesg seems to be
> willing to reveal some secrets (using some pastebin service since this
> is pretty big):
>
> https://gist.github.com/anonymous/5275120

That looks like exactly the exit_sem() bug that Davidlohr was talking
about, where the

                /* exit_sem raced with IPC_RMID, nothing to do */
                if (IS_ERR(sma))
                        continue;

should be moved to *before* the

                sem_lock(sma, NULL, -1);

call. And apparently the bug I had found is already fixed in -next.

               Linus
