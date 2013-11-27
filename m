Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab3K0XPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 18:15:24 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55987 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611Ab3K0XPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 18:15:22 -0500
MIME-Version: 1.0
In-Reply-To: <529677D7.9080203@zytor.com>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>
	<5294F10C.8060901@amacapital.net>
	<CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com>
	<52964EC7.9000504@zytor.com>
	<52966C0A.7070201@zytor.com>
	<CA+55aFzr9ZKcGfT_Q31T9_vuCcmWxGCh0wixuZqt7VhjxxYU9g@mail.gmail.com>
	<529677D7.9080203@zytor.com>
Date: Wed, 27 Nov 2013 15:15:21 -0800
X-Google-Sender-Auth: CJRimdsR_mm8oOslQkUkO_KUfMU
Message-ID: <CA+55aFx9mXy3VASfek5052GTbiUVSgBVsRwnF4cse1dc=z70HQ@mail.gmail.com>
Subject: Re: [PATCH] Add a text_poke syscall v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 2:53 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> If we are going to go down that route, I would like to see a list of
> patch sites, not just one with a "timeout" that won't get used.

Oh, I agree. The interface of the original patch was just inane/insane.

The timeout and the callback is pointless. The only thing the system
call should get as an argument is the address and the replacement
instruction.  So

  int text_poke(void *addr, const void *opcode, size_t len)

sounds fine to me. And it would do:
 - take some (possibly per-mm) mutex
 - write the one-byte int3
 - do the IPI
 - write the other bytes
 - do the IPI
 - do the first byte
 - release the (possibly per-mm) mutex

and then in the BP handler we'd just take the mutex, see if the first
byte of the exception is still int3, if it's not, just return silently
(because that means that we hit the race).

And I would seriously suggest just open-coding the above simple
sequence instead of trying to force-reuse the text_poke_bp() function
we already have. Because I think doing this on kernel code is
*very*different* (for irq reasons _and_ for IPI mask reasons).

Hmm? It doesn't sound too bad. And I really don't see the point of
some timeout handling or anything like that.

           Linus
