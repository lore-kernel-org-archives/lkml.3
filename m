Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaKQSzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:55:52 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:58551 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaKQSzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:55:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Jonas Gorski <jogo@openwrt.org>, Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 22/22] MIPS: Add multiplatform BMIPS target
Date: Mon, 17 Nov 2014 19:55:15 +0100
Message-ID: <14461008.6cZzGdpat2@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJiQ=7An5eZ3j2+Zkx1crV9pBSVodkEQ+6ESGcFk5z0tDV7cHA@mail.gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com> <2018325.yOrLZndTTm@wuerfel> <CAJiQ=7An5eZ3j2+Zkx1crV9pBSVodkEQ+6ESGcFk5z0tDV7cHA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:421rEaFY5Yg1YBGWOhxVtojTlDLGGIEdfAI5x7x/YOB
 X2pIN5OencsOZN46tiNJIvDnsGix1xTt5VKUX80uhWcPspUHoz
 xKHzBylVrSGSgTyKR1hmDgbSKeVBXBhStFOSlOi/tWX/oosReF
 w36rd/FuzUffivJ9BZBX5iql0NnWvWhsueyfZ4RrFLny0+81S7
 opVhB+jmTt/vNc4uBSSDnNjmpsG0151TQEO5a2USgELhIu0fPu
 +ZMETO/t5VeX5eBiYb9/pzL3HlrU4uVD+hAVdyd0kGn9bo8X8z
 5z06/Dkwj1/Ui3aFTUQ+W6yy5/xeoLvja7C4M4XUcby4PK8x+e
 CFFnsybqEKCBzp/CAywU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2014 09:19:17 Kevin Cernekee wrote:
> On Mon, Nov 17, 2014 at 8:13 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > This is not just DT, it's actually an implementation of a boot
> > interface. The situation here seems much more to what we had on
> > PowerPC a long time ago than what we had on ARM before the DT
> > conversion. I think the best approach here would be to move the
> > platform specific bits into the decompressor code, and allow
> > multiple implementations of that. This way you can have the
> > generic vmlinux file that has a common DT parser, and you wrap
> > that into one decompressor per platform, some of which can have
> > their own board detection logic or pre-boot setup where necessary.
> >
> > To be honest, I think having multiple DT files linked into the
> > kernel is a really bad idea, because it doesn't solve the
> > scalability problem at all. What we did on ARM was to force those
> > hacks out into external projects such as the PXA impedence
> > matcher [https://github.com/zonque/pxa-impedance-matcher]. This
> > can handle all weird boot protocol and adapt them to the normal
> > well-defined interfaces we have in the kernel.
> 
> To some extent this is how BCM3384 was done[1].
> 
> There is a tradeoff here: to add support for the older platforms it is
> easy to build a new DTB file into the kernel image, but it is a lot of
> trouble to write a new 3rd stage bootloader.  Do we want to maximize
> our list of supported boards, or are we shooting for a super clean
> kernel implementation right off the bat?

Right, when the norm is that you can't detect the board, having
the wrapper in the kernel is the better approach, as PowerPC, which
has a few dozen ways of linking the compressed kernel, while the
vmlinux file uses a common method and passes everything in DT.

That way you can have the best of both.

> >> And unless there is one, having a
> >> multiplatform kernel does not make much sense, as there is no sane way
> >> to tell apart different platforms on boot.
> >
> > How do you normally tell boards apart on MIPS when you don't use DT?
> 
> On BCM7xxx (STB) kernels, we could assume the chip ID was in a known
> register, and also we could call back into the bootloader to get a
> somewhat-accurate board name.
> 
> On BCM63xx there is logic in arch/mips/bcm63xx/cpu.c to try to guess
> the chip identity from the CPU type/revision (because the latter can
> be read directly from CP0).
> 
> These systems were never really designed to support multiplatform
> kernels.  The ARM BCM7xxx variants, by contrast, were.

Guessing the chip doesn't really help you all that much of course
as long as you don't know the board, and once you know that,
the chip is implied.

	Arnd
