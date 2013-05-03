Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab3ECQOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 12:14:47 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:44905 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757537Ab3ECQOq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 12:14:46 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6vr1kh2yqnG6kpASBGDUQrC7taBu00VWu6VG+qCO2u9QA@mail.gmail.com>
References: <CACxGe6vr1kh2yqnG6kpASBGDUQrC7taBu00VWu6VG+qCO2u9QA@mail.gmail.com>
Date: Fri, 3 May 2013 09:14:44 -0700
X-Google-Sender-Auth: igRTEiMLlgeMQoXXcLcituuEz4w
Message-ID: <CA+55aFw9fbZBiZDC25j4A50NmsYbpwV-wUfWMpE_D7bEXQ-XVg@mail.gmail.com>
Subject: Re: [git pull] GPIO for v3.10
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Jean Delvare <khali@linux-fr.org>, Marek Vasut <marex@denx.de>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 3:37 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>
> Here are the GPIO changes staged for v3.10. Please pull.

Grrr. These clearly have not been tested at all, and they break the
allmodconfig build.

> Jean Delvare (2):
>       gpio: ucb1400: Can be built as a module

The above one is pure and utter garbage. That driver cannot be built
as a module, and clearly nobody ever even tested it.

You have:

   void __init ucb1400_gpio_set_data(struct ucb1400_gpio_data *data)

(which, btw, seems entirely unused), but then in the header file
(remember: this is a totally unused function as far as I can tell) we
have

   #ifdef CONFIG_GPIO_UCB1400
   void __init ucb1400_gpio_set_data(struct ucb1400_gpio_data *data);
   #else
   static inline void ucb1400_gpio_set_data(struct ucb1400_gpio_data *data) {}
   #endif

which means that in the modular case, you get

   drivers/gpio/gpio-ucb1400.c:106:13: error: redefinition of
‘ucb1400_gpio_set_data’

again, I see absolutely no way that (a) this piece of crap has ever
been tested and (b) how /why that useless piece of shit even gets
used.

I'm upset. How the f*ck did this get into your tree in the first
place, and after it got into the tree, WHY THE HELL DID YOU SEND THIS
CRAP TO ME?

The one-liner commit that enables this piece of shit is signed off by
two people, has another person with a "Reviewed-by:" and there is no
way in hell it was ever tested or anybody has ever looked at the
driver in question. WTF?

I'm going out on a limb here, and guessing that it wasn't in linux-next either.

Piece of unadulterated shit.

Quite frankly, I'm not taking any GPIO changes from you this merge
window. I only noticed this after having done two other merges on top
of it, so now I'll have to go back and undo all of this, because quite
frankly, I'm upset enough that I don't want to have any remains of
this whole experience in my tree.

                    Linus
