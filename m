Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3IJItJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:49:09 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60919 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab3IJItH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:49:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130909200610.GA28416@roeck-us.net>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
	<20130909015945.GA4029@kroah.com>
	<20130909134012.GA24738@infradead.org>
	<20130909163902.GA28685@kroah.com>
	<20130909170819.GA22764@roeck-us.net>
	<20130909172232.GA10029@kroah.com>
	<CAMuHMdWwFwWeenfsiF+yBYS29rwJTJ1YP5waf=ePK+MRCru3qg@mail.gmail.com>
	<20130909200610.GA28416@roeck-us.net>
Date: Tue, 10 Sep 2013 10:49:05 +0200
X-Google-Sender-Auth: h9EDrO9sWvCCz_DdnIDP2vlOo1w
Message-ID: <CAMuHMdXWaVivv3RL9dyLdeA7p4=XiBLAyhXNEiay3ARoWjM5gw@mail.gmail.com>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and XTENSA
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>, Peng Tao <tao.peng@emc.com>,
        Peng Tao <bergwolf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 10:06 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> [*] Why does m68k allmodconfig still succeed on kissb???
>>     It does fail for me, as m68k's copy_from_user_page() calls
>>     flush_icache_user_range(), which is not exported.
>>
> I don't see a build failure in m68k:allmodconfig either.
>
> flush_icache_user_range() is called from copy_to_user_page(), not from
> copy_from_user_page(). copy_from_user_page() calls flush_cache_page()
> which calls __flush_cache_030(). The first is inline, the second is
> assembler, so I would expect it to work. Which doesn't answer
> the question why it fails for you.

Sorry, I meant copy_to_user_page().

I tried with 2.6.3 from crosstool, and it succeeded, too.

Turns out cfs_access_process_vm() is called with write=0 only.
Gcc 2.6.3 optimizes away the write != 0 branch (which calls copy_to_user_page()
and thus flush_icache_user_range()), while gcc 4.1.2 doesn't do that.
Mystery solved.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
