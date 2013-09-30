Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3I3TRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 15:17:52 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:58580 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab3I3TRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:17:51 -0400
Message-ID: <5249CE5B.7040505@gmail.com>
Date: Mon, 30 Sep 2013 12:17:47 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>,
        Markos Chandras <Markos.Chandras@imgtec.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        John Crispin <blogic@openwrt.org>
Subject: Re: Issue with BUG() in asm-gemeric/bug.h if CONFIG_BUG=n
References: <20130930145630.GA14672@linux-mips.org> <52499E8B.6000702@gmail.com> <C9BC92C2-A7F5-4F9A-B001-D1A7F4ADEA5A@caviumnetworks.com> <5249B8A4.9070905@gmail.com> <CAMuHMdXkb6BH=1QvfHwMN54db9mP64KnCgoAj3aXida7-6OtPA@mail.gmail.com>
In-Reply-To: <CAMuHMdXkb6BH=1QvfHwMN54db9mP64KnCgoAj3aXida7-6OtPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2013 12:03 PM, Geert Uytterhoeven wrote:
> On Mon, Sep 30, 2013 at 7:45 PM, David Daney <ddaney.cavm@gmail.com> wrote:
>>> What about using __builtin_unreachable when we can but turn off warnings
>>> and use do{}while(0) when __builtin_unreachable does not exist?  This seems
>>> the both worlds.  Newer compilers produce better code with unreachable
>>> anyways.
>>>
>>
>> Simply not true.
>>
>> do{}while(0) is a NOP it is no more useful than an ';' statement.  It
>> doesn't serve as a magic uninitialized variable hiding mechanism.
>
> You missed the "turn off warnings" part of the "and".

You are correct, I did miss it.

The real problem here is that the kernel is written to expect that BUG() 
never returns.  Any implementation that has BUG() return, is almost 
certainly *not* what we want.

But wieh people select CONFIG_BUG=n they expect the smallest possible code.

These two criteria are mutually exclusive, so something should change.

It is not just the uninitialized variable warning, there can be others 
as well (control reaching the end of a non-void function comes to mind). 
  So I don't think turning off the warnings is a good solution.

That leaves:

1) Remove CONFIG_BUG and make it unconditionally enabled.

2) Make CONFIG_BUG=n imply "static inline void BUG(void){do{}while(1);}" 
which might be bigger than with CONFIG_BUG=y

David Daney


>
> Gr{oetje,eeting}s,
>
>                          Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds
>
>

