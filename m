Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab3DXMgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:36:17 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:56932 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab3DXMgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:36:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130423.133732.2222922370397287096.davem@davemloft.net>
References: <CA+55aFwogFL=nm=YHwARcz9OTRBdWEDPG0xcqM-H3k-VZTOZPQ@mail.gmail.com>
	<AE90C24D6B3A694183C094C60CF0A2F6026B71F2@saturn3.aculab.com>
	<CA+55aFxvpcF7+dyy5d3+JP4Wfv90zPsRVtEhNG9Pky5gWTm_Pg@mail.gmail.com>
	<20130423.133732.2222922370397287096.davem@davemloft.net>
Date: Wed, 24 Apr 2013 14:36:15 +0200
X-Google-Sender-Auth: FA3pE9ulKhvVIZ7lfmzS5yYAnpM
Message-ID: <CAMuHMdXzNMt63pOa3136Fmrs2tPQzh5SGe2YfCn+yGtzOyMqoQ@mail.gmail.com>
Subject: Re: Unsigned widening casts of binary "not" operations..
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David.Laight@aculab.com,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 7:37 PM, David Miller <davem@davemloft.net> wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Tue, 23 Apr 2013 08:42:49 -0700
>
>> An explicit cast fixes it, and shows that you were aware of the issue:
>>
>>    foo &= ~(foo_t)bar;
>>
>> and gcc will generate the right logic. Of course, casts then have
>> their own problems, which your thing avoids (as would just having a
>> "andn" operation in C)
>
> I just want to mention that this is dangerous in different ways, we
> just recently got a patch in the networking that removed such a cast.
> The problem is when the cast narrows, f.e.:
>
>         ~(u8)0
>
> doesn't do what you think it does.  That doesn't evaluate to 0xff.

This is the definition of MAC802154_CHAN_NONE?

We _should_ have noticed this earlier, as old gcc (e.g. 4.1.2) emits a
warning when comparing it to a u8:

net/mac802154/monitor.c: In function ‘mac802154_monitor_xmit’:
net/mac802154/monitor.c:49: warning: comparison is always false due to
limited range of data type
net/mac802154/wpan.c: In function ‘mac802154_wpan_xmit’:
net/mac802154/wpan.c:323: warning: comparison is always false due to
limited range of data type

Interestingly, none of this is seen in the build logs of the linux-next build
service, which uses gcc 4.2.3, 4.2.4, 4.5.1, and 4.6...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
