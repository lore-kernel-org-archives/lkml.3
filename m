Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab3JXH23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:28:29 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:39150 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab3JXH21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:28:27 -0400
MIME-Version: 1.0
In-Reply-To: <001701cecfe2$9831eb90$c895c2b0$%jun@samsung.com>
References: <1381876762-10892-1-git-send-email-dianders@chromium.org>
	<1381876762-10892-2-git-send-email-dianders@chromium.org>
	<52610273.3080005@samsung.com>
	<CAD=FV=UiUxoqbAeq+3iUChqksHd_NpJs2rM83=ng3fprMj0E-A@mail.gmail.com>
	<001701cecfe2$9831eb90$c895c2b0$%jun@samsung.com>
Date: Thu, 24 Oct 2013 08:28:26 +0100
X-Google-Sender-Auth: 5GvOzCo1oJXXkmYD-43cMvwkm3o
Message-ID: <CAD=FV=WL0K4qiRGsQxG7vfp41dV9fp=7d6d6i5qomJd7jbLEPg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: dw_mmc: Cleanup disable of low power mode w/
 SDIO interrupts
From: Doug Anderson <dianders@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Bing Zhao <bzhao@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seungwon,

On Wed, Oct 23, 2013 at 12:25 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
>> >> +             if (card->type == MMC_TYPE_SDIO ||
>> >> +                 card->type == MMC_TYPE_SD_COMBO) {
> && card->quirks & MMC_QUIRK_BROKEN_CLK_GATING
> How about considering MMC_QUIRK_BROKEN_CLK_GATING?
> Some sdio device can work with gating clock.
> For this, mmc_fixup_device() should be called prior to init_card() in core(sdio.c).
> I guess you found that.

By SDIO devices, are you referring to actual SDIO cards or some
implementations of dw_mmc?

As far as I understand in the CLKENA description in the generic
documentation from Synopsys it say that for SDIO cards you must not
stop the clock if interrupts must be detected.  To me, that means that
all dw_mmc implementations require this change if they support SDIO
interrupts (hence checking for MMC_CAP_SDIO_IRQ).

I guess I did make the assumption in this change that all (reasonable)
SDIO cards would be using SDIO interrupts if they are available.  If
we could find out ahead of time if a given SDIO driver was planning to
use interrupts we could do better.  The old solution did better in
this way and we could probably make it work (and still fix the
read-modify-write race) if we thought this was really important.  The
code gets a little more twisted to try to avoid holding the IRQ-safe
spinlock while updating the clock, but I could attempt it...


NOTE: We've recently found that there are still occasions when we lose
SDIO interrupts with dw_mmc and our Marvell WiFi driver, especially
when those interrupts happen back-to-back.  That problem appears
unrelated to this one (it's what Bing was investigating when he found
the original race).  Anyone that has any thoughts, please let me
know...

-Doug
