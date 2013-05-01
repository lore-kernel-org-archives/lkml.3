Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab3EAUyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 16:54:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55870 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab3EAUyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 16:54:01 -0400
Date: Wed, 1 May 2013 22:53:55 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: David Rientjes <rientjes@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: linux-next: Tree for May 1 (media/usb/stk1160)
Message-ID: <20130501205355.GB18811@free.fr>
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au>
 <518157EB.3010700@infradead.org>
 <20130501192845.GA18811@free.fr>
 <alpine.DEB.2.02.1305011258180.8448@chino.kir.corp.google.com>
 <518179BD.3010407@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518179BD.3010407@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy, All,

On Wed, May 01, 2013 at 01:23:25PM -0700, Randy Dunlap wrote:
> On 05/01/13 12:58, David Rientjes wrote:
> > On Wed, 1 May 2013, Yann E. MORIN wrote:
> > 
> >>> When CONFIG_SND=m and CONFIG_SND_AC97_CODEC=m and
> >>> CONFIG_VIDEO_STK1160=y
> >>> CONFIG_VIDEO_STK1160_AC97=y
> >>>
> >>> drivers/built-in.o: In function `stk1160_ac97_register':
> >>> (.text+0x122706): undefined reference to `snd_card_create'
> >>> drivers/built-in.o: In function `stk1160_ac97_register':
> >>> (.text+0x1227b2): undefined reference to `snd_ac97_bus'
> >>> drivers/built-in.o: In function `stk1160_ac97_register':
> >>> (.text+0x1227cd): undefined reference to `snd_card_free'
> >>> drivers/built-in.o: In function `stk1160_ac97_register':
> >>> (.text+0x12281b): undefined reference to `snd_ac97_mixer'
> >>> drivers/built-in.o: In function `stk1160_ac97_register':
> >>> (.text+0x122832): undefined reference to `snd_card_register'
> >>> drivers/built-in.o: In function `stk1160_ac97_unregister':
> >>> (.text+0x12285e): undefined reference to `snd_card_free'
> >>>
> >>>
> >>> This kconfig fragment:
> >>> config VIDEO_STK1160_AC97
> >>> 	bool "STK1160 AC97 codec support"
> >>> 	depends on VIDEO_STK1160 && SND

BTW, can you check that:
    make silentoldconfig
does not warn about unmet dependencies for those symbols?

> > This doesn't depend on SND, it depends on SND=y.
> 
> Maybe this option *should* depend on SND=y, but that's not what the
> kconfig syntax says.

I'd say  Documentation/kbuild/kconfig-language.txt  is not complete wrt
the current syntax, grammar and semantics of the language. :-(

> The kconfig language does not care if the variable is
> a bool or a tristate when evaluating a depends expression AFAICT (but I am
> only reading Documentation/kbuild/kconfig-language.txt, not the source code).

Yes, it does, I've just tried with the following snippet:

    config MODULES
        bool "modules"
    
    config A
        tristate "A"
    
    config B
        tristate "B"
        depends on A
    
    config C
        tristate "C"
    
    config D
        bool "D"
        depends on C
        select B
    
    config E
        bool "E"
        depends on C=y
        select B

As you can test, E will not be visible if C is not =y, while D will be
visible if C is =m or =y.

Also, if A=m (and C=n), then B can only be =n or =m.

But with the test-case above, if C=y and ( D=y or E=y ), then B will be
forced to =y, even though A might be unset, which means silentoldconfig
would warn abount unmet dependencies:
    warning: (D && E) selects B which has unmet direct dependencies (A)

Worse! With: A=m, C=y, D=y  -> B is forced to =y, which is wrong because
it can only be =n or =m (see above), but silentoldconfig will not warn
about this situation.

Sigh... :-(

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
