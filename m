Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591Ab3B0LkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 06:40:14 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:54151 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759167Ab3B0LkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 06:40:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9tx_NCg4WS9Kmk_Gv1y7Yz9b8YWqZzg2xRjWyR9K5oarLQ@mail.gmail.com>
References: <1352665488-13818-1-git-send-email-mathieu.poirier@linaro.org>
	<20121119072525.GA16730@core.coreip.homeip.net>
	<CAPM=9tw8mefcYTqELXFbZWZ44a--SNcPnRMAvMSGTiODzRpDhg@mail.gmail.com>
	<CAPM=9tzyBuxwLS=0vAcF5h4vZnB01X7_1NbnMo0M=M454gwZBQ@mail.gmail.com>
	<CAPM=9txzwGBeKx=ozzTmf=FG6c3ke3Gw5meBD+d98UqhmjZJ2g@mail.gmail.com>
	<CAPM=9tx_NCg4WS9Kmk_Gv1y7Yz9b8YWqZzg2xRjWyR9K5oarLQ@mail.gmail.com>
Date: Wed, 27 Feb 2013 21:40:10 +1000
Message-ID: <CAPM=9tw9=ghEZ=xiyR=OVyyqY2c0c44YeRXy2rY4RCYu8mc5DQ@mail.gmail.com>
Subject: Re: [PATCH v4] drivers/tty: Folding Android's keyreset driver in sysRQ
From: Dave Airlie <airlied@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: mathieu.poirier@linaro.org, linux-kernel@vger.kernel.org, arve@android.com,
        kernel-team@android.com, john.stultz@linaro.org,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>
>>>> It looks to me like the weak bit isn't working so well
>>>>
>>>>         if (platform_sysrq_reset_seq) {
>>>>                 for (i = 0; i < ARRAY_SIZE(sysrq_reset_seq); i++) {
>>>>                         key = platform_sysrq_reset_seq[i];
>>>>   6d:   66 8b 8c 00 00 00 00    mov    0x0(%eax,%eax,1),%cx
>>>>   74:   00
>>>>
>>>> is around where it craps out.
>>>> gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC)
>>>> Fedora 18 machine.
>>>
>>> And just to confirm reverting
>>> 154b7a489a5b1d808323b933b04864958c2f1056.in Linus' tree allows boot to
>>> proceed.
>>
>>
>> Looks like my first picture bounced,
>>
>> here's a link
>> http://www.skynet.ie/~airlied/sysrq_oops.jpg
>
> Just some more disasm:
>
>        if (platform_sysrq_reset_seq) {
>   4c:   ba 00 00 00 00          mov    $0x0,%edx
>   51:   31 c0                   xor    %eax,%eax
>   53:   8b 1d 04 00 00 00       mov    0x4,%ebx
>   59:   85 d2                   test   %edx,%edx
>   5b:   75 2d                   jne    8a <sysrq_init+0x72>
>
>                         sysrq_reset_seq[sysrq_reset_seq_len++] = key;
>                 }
>         }
>
>         error = input_register_handler(&sysrq_handler);
>   5d:   b8 b4 00 00 00          mov    $0xb4,%eax
>   62:   e8 fc ff ff ff          call   63 <sysrq_init+0x4b>
>         if (error)
>   67:   85 c0                   test   %eax,%eax
>   69:   74 3e                   je     a9 <sysrq_init+0x91>
>   6b:   eb 2d                   jmp    9a <sysrq_init+0x82>
>         int error;
>         int i;
>   6d:   66 8b 8c 00 00 00 00    mov    0x0(%eax,%eax,1),%cx
>   74:   00
>                         if (key == KEY_RESERVED || key > KEY_MAX)
>   75:   8d 71 ff                lea    -0x1(%ecx),%esi
>   78:   66 81 fe fe 02          cmp    $0x2fe,%si
>   7d:   76 02                   jbe    81 <sysrq_init+0x69>
>   7f:   eb 11                   jmp    92 <sysrq_init+0x7a>
>                                 break;
>
>                         sysrq_reset_seq[sysrq_reset_seq_len++] = key;
>   81:   66 89 8c 12 08 00 00    mov    %cx,0x8(%edx,%edx,1)
>   88:   00
>
> Dave.

It really does look like gcc is screwing up here, after a debug
session on irc with dhowells and rmk.

I'm going to sleep, its too much for my brain at the moment.

Dave.
