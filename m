Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab3BFQS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:18:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56135 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab3BFQS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:18:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Wed, 6 Feb 2013 16:18:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        alan@lxorguk.ukuu.org.uk, dahinds@users.sourceforge.net
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <201302052303.01795.arnd@arndb.de> <CAMuHMdWTtEyP_505x4S+uT1J-uFWb9VOMHNOCPcF-z1uSF6xDQ@mail.gmail.com>
In-Reply-To: <CAMuHMdWTtEyP_505x4S+uT1J-uFWb9VOMHNOCPcF-z1uSF6xDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302061618.07378.arnd@arndb.de>
X-Provags-ID: V02:K0:X87B3X91aEhs3wiAqO8VotHMaYz+Y1oGyDR1HtNSZnt
 H1yxmx6ydNLnRnCgZbHjvTjaUscqo6yragp52tVg59zlARC0We
 hugkNbwaZKPQ+LgitmrTzsnhr8qh15cM1gEi6CMjpHaYgBH/ci
 VJmgC3Sm/33ZNwt7XrjMraCunfUV0JlgjEjaZ8Nt8uGB2tODVQ
 emxvtBsXwo6XCaP1wbvJHO5AivhIIiuSFsV6+1U8TMFCk3KR0q
 E0hEGPwdtIG7ZkyAlJULQDWHNFlek4A1Qv5vGXroTHizGulKjW
 vkI0M8TIki3Z2F26TkFZvtEEkSP1OCA3w/Oqm662JM0siAZonE
 Q30w1H4J6mM5629m9TVA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2013, Geert Uytterhoeven wrote:
> On Wed, Feb 6, 2013 at 12:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 05 February 2013, Michal Simek wrote:
> >> I want to be sure about this. I have parsed this again with closer look and
> >> seems to me that ioread32 is equal to readl and iowrite32 to writel.
> >> Arnd: Am I right?
> >
> > Correct. On all the architectures you care about (most importantly, not
> > x86), readl and ioread32 are defined to have the same semantics. There
> > are a few exceptions where ioread32 provides a wrapper for PCI
> > PIO accesses that are not memory mapped, making ioread32 slightly
> > slower than readl, but for all practical purposes you don't have
> > to worry about it ;-)
> 
> PCI PIO? Do you mean "PCI I/O space"?

Yes.

> That's different, and accessed through inb() and friends, right?

Sort of. The native methods are readl() etc for MMIO and inb() etc. for PIO,
as you say. However, the ioread32() family does the superset of the two,
either using a wrapper function with a mangled port number / pointer
argument (e.g. on x86), or it gets defined to do the same as readl on
platforms where the PCI I/O space is memory mapped. The requirement
here is that whatever the result of ioport_map() is must be turned
back into a PIO access when passed into ioread32(). On memory mapped
platforms, there is typically just an offset that gets added to the
port number to turn that into an __iomem pointer.

	Arnd
