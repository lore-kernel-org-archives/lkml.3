Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab3J1Wju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 18:39:50 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:48010 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab3J1Wjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 18:39:48 -0400
MIME-Version: 1.0
In-Reply-To: <000f01ced164$a8181b50$f84851f0$%jun@samsung.com>
References: <1381876762-10892-1-git-send-email-dianders@chromium.org>
	<1381876762-10892-2-git-send-email-dianders@chromium.org>
	<52610273.3080005@samsung.com>
	<CAD=FV=UiUxoqbAeq+3iUChqksHd_NpJs2rM83=ng3fprMj0E-A@mail.gmail.com>
	<001701cecfe2$9831eb90$c895c2b0$%jun@samsung.com>
	<CAD=FV=WL0K4qiRGsQxG7vfp41dV9fp=7d6d6i5qomJd7jbLEPg@mail.gmail.com>
	<000f01ced164$a8181b50$f84851f0$%jun@samsung.com>
Date: Mon, 28 Oct 2013 15:39:46 -0700
X-Google-Sender-Auth: StvAUz_JDRBkJW1__72QYRX26F4
Message-ID: <CAD=FV=VLNdNMg2gAj7yUs2ZgP0GqO5SOQLARq+p1qQTGwFDsQQ@mail.gmail.com>
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

On Fri, Oct 25, 2013 at 2:29 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
>> By SDIO devices, are you referring to actual SDIO cards or some
>> implementations of dw_mmc?
>>
>> As far as I understand in the CLKENA description in the generic
>> documentation from Synopsys it say that for SDIO cards you must not
>> stop the clock if interrupts must be detected.  To me, that means that
>> all dw_mmc implementations require this change if they support SDIO
>> interrupts (hence checking for MMC_CAP_SDIO_IRQ).
>
> CLKENA description in manual means that host controller can't detect the SDIO interrupt signal
> or wifi device can't generate the interrupt without clock?

My reading of the "if interrupts must be detected" in the manual
implies that that interrupts simply can't be detected by the
controller.


> Host controller based on Synopsys supports asynchronous interrupts. It seems to depend on wifi Device.
> If host can do and  wifi device can also work with clock gating, we may enable low-power mode.

Ah, interesting!  I wish I had known about this earlier and we could
have actually used it in our designs.  Please correct me if I'm wrong
but...

It looks like asynchronous interrupts is when you use a separate INT#
line for your SDIO interrupts and is available only for eSDIO
(embedded SDIO?), right.  ...so that means it more a property of the
board rather than the card itself.  In other words: to use
asynchronous interrupts you need to be on a SoC that supports the INT#
line, you need to have it wired up to an eSDIO module, and you need
the eSDIO card to support it.

Assuming that I understand all of the above I'd suggest (in a future
patch) that we add a property like 'dedicated-sdio-irq' to device
trees.  If we see this property AND we don't see
MMC_QUIRK_BROKEN_CLK_GATING then we know we don't need to disable
clock gating.

Does that sound right?  If so I'd still love to land my patch and we
could add the extra logic in a separate patch.


> For MMC_QUIRK_BROKEN_CLK_GATING, I referred the code in 'mmc/core/quirks.c'
> In addition, although host can support MMC_CAP_SDIO_IRQ, some wifi drivers use
> OOB(Out-of-band) interrupt. That means host can apply clock gating to reduce
> power consumption.

I think OOB interrupt is the same as asynchronous interrupt, but if
I'm wrong please correct me.

-Doug
