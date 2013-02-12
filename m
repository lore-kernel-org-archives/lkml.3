Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512Ab3BLRaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:30:22 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:60480 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348Ab3BLRaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:30:20 -0500
MIME-Version: 1.0
In-Reply-To: <587312497.6453.1360650312498.JavaMail.mail@webmail01>
References: <587312497.6453.1360650312498.JavaMail.mail@webmail01>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Feb 2013 09:29:59 -0800
X-Google-Sender-Auth: AO-HaOh_YfC54SMTj_hH1yQLF5I
Message-ID: <CA+55aFyscOeZUPaYj_-QYgjADPD59+=c5aMvtpPEnd1tmpUGiA@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
To: "Artem S. Tashkinov" <t.artem@lycos.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 10:25 PM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
> Hello Linus,
>
> I've already posted a bug report (https://bugzilla.kernel.org/show_bug.cgi?id=53551),
> a message to LKML (http://lkml.indiana.edu/hypermail/linux/kernel/1302.1/00837.html)
> and so far I've received zero response even though the bug is quite critical as it prevents
> me from using suspend altogether.
>
> I wonder if you could tell me who is responsible for this problem and who I need to CC in
> bugzilla.

According to your bugzilla it doesn't really seem to be strictly
UEFI-specific, and it's hard to tell what subsystem is to blame.

A few things to try to pinpoint:

 (a) Is it *only* write performance that suffers, or is it other
performance too? Networking (DMA? Perhaps only writing *to* the
network?)? CPU?

 (b) the fact that it apparently happens with both SATA and USB
implies that it's neither, and is more likely something core like
memory speed (mtrr, caching) or PCI (DMA, burst sizes, whatever).

 (c) can you find anything that changes over the suspend/resume? IOW,
look at things like "lspci -vvxxx" before-and-after, and see what
changed on the bridges leading to both things etc.

The performance drop sounds extreme enough that it sounds like caches
got disabled or something, but that should show up as CPU performance
in general being slow, not just writes to disk. But basically, I think
we need more clues about which sub-area is actually the culprit. My
*guess* would be some core PCI thing not being initialized, but I
don't see how you could even make PCI go that slow. Interrupt
problems? DMA failures? I have no idea.

Has it ever worked? Suspend on desktop motherboards used to be quite
spotty (nobody ever used it, manufacturers didn't care), but it
generally has gotten better since people use it more these days..

Added lkml and Bjorn to the participants, in case anybody has any ideas..

                Linus
