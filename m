Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab3BLRZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:25:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51783 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab3BLRZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:25:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Tue, 12 Feb 2013 17:25:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <CACxGe6uHx4KdZRgAyL-wQ2GurojAH0eTa6YRCoSuCg89BAvBTA@mail.gmail.com> <CAHTX3dKPWg35Az8eE45AGriPZh2G6LLaQMynhFPKSZ+7UvM=9g@mail.gmail.com>
In-Reply-To: <CAHTX3dKPWg35Az8eE45AGriPZh2G6LLaQMynhFPKSZ+7UvM=9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302121725.07641.arnd@arndb.de>
X-Provags-ID: V02:K0:1Uu1LcGGH/MAnnNcIUedaP79fz9HEucPgOMBLcwW5uo
 STgbV4l7uFE2dDkBD1rNsmmGAzMMb+ytyWvs+ZLI/E/mUblCHb
 vwaa7GIlSj7sfynKCXIJsXXBAkJ9KgmeTPkY3xE/BKdtHhatQO
 GQOJcY0D9rrpWUK+XfvMevSC30SSg8MMEhbbzLnuGibC3vgRMJ
 zsaGZzv4P+klT4lx1lp7VjJJs5bqiaPtkC/wtEJxFO0SeJybbs
 TFFOZ00uW1duKkAd+AyuePCG/roIJDYry2VeFTebFvBWg1NdXV
 KeAya5nIGBYUDg/5sQelK5V4U/kuGRmCrFkVa31MFDqGjNx4ix
 wdNnXPNmfkYoNj9ekntY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2013, Michal Simek wrote:
> But on Microblaze LE is necessary to use different datain/out_le16
> functions as below
> which are also not compatible with Microblaze and PPC BE.
> 
> diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
> index bbad046..8dd192c 100644
> --- a/drivers/block/xsysace.c
> +++ b/drivers/block/xsysace.c
> @@ -314,7 +314,7 @@ static void ace_datain_le16(struct ace_device *ace)
>         int i = ACE_FIFO_SIZE / 2;
>         u16 *dst = ace->data_ptr;
>         while (i--)
> -               *dst++ = ioread16be(ace->baseaddr + 0x40);
> +               *dst++ = ioread16(ace->baseaddr + 0x40);
>         ace->data_ptr = dst;
>  }

Hmm, that actually seems sane then: You can replace the loop around
ioread16be with a single ioread32_rep() call, which will use
the correct native endian accesses on both LE Microblaze
and on all the big-endian platforms. Note that the asm-generic
definition of that function was broken until quite recently
when Will Deacon repaired it in order to support ARM64.

	Arnd
