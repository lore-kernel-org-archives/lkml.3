Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbaEUVh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:37:28 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:34782 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbaEUVh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:37:27 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
	<1400639227.9759.21.camel@pippen.local.home>
	<CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
	<alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz>
	<CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com>
	<20140521163315.GJ21205@pd.tnic>
	<alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
Date: Thu, 22 May 2014 06:37:26 +0900
X-Google-Sender-Auth: XNdZiNZI_hwWqWlmDB0Y5PXZRmE
Message-ID: <CA+55aFwiZxg3kS7seKPnkteOBA5N8ENXt6Y+Azn_HH6Z1iRN5w@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 6:25 AM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> Yeah, but it tries to send SIGBUS from MCE context. And if MCE triggered
> at the time the CPU was already holding sighand->siglock for that
> particular task, it'll deadlock against itself.

Don't worry too much about the MCE's. The hardware is f*cking broken,
and nobody sane ever thought that synchronous MCE's were a good idea.

Proof: look at Itanium.

The truly nonmaskable synchronous MCE's are a fatal error. It's that
simple. Anybody who thinks anything else is simply wrong, and has
probably talked to too many hardware engineers that don't actually
understand the bigger picture.

Sane hardware handles anything that *can* be handled in hardware, and
then reports (later) to software about the errors with a regular
non-critical MCE that doesn't punch through NMI or even regular
interrupt disabling.

So the true "MCE punches through even NMI protection" case is
relegated purely to the "hardware is broken and needs to be replaced"
situation, and our only worry as kernel people is to try to be as
graceful as possible about it - but that "as graceful as possible"
does *not* include bending over and worrying about random possible
deadlocks or other crazy situations. It's purely a "best effort" kind
of thing where we try to do whatever logging etc that is easy to do.

Seriously. If an NMI is interrupted by an MCE, you might as well
consider the machine dead. Don't worry about it. We may or may not
recover, but it is *not* our problem.

                Linus
