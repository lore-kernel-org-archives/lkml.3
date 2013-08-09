Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934384Ab3HIPWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:22:45 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:40261 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934353Ab3HIPWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:22:43 -0400
MIME-Version: 1.0
In-Reply-To: <001801ce9504$d9976ab0$8cc64010$%jun@samsung.com>
References: <1373470926-19314-1-git-send-email-dianders@chromium.org>
	<1375825071-20922-1-git-send-email-dianders@chromium.org>
	<1375825071-20922-2-git-send-email-dianders@chromium.org>
	<001801ce9504$d9976ab0$8cc64010$%jun@samsung.com>
Date: Fri, 9 Aug 2013 08:22:42 -0700
X-Google-Sender-Auth: woP8n_bLRrl6B1NIsJppDW87qGA
Message-ID: <CAD=FV=VmtoxnRzjsKF1rVTwvkJRAxKGUvNZHAEwuWaeVokzSZA@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mmc: dw_mmc: Invalidate cache of current_speed
 after suspend/resume
From: Doug Anderson <dianders@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seungwon and Jaehoon,

On Fri, Aug 9, 2013 at 6:32 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> On Wed, August 07, 2013, Doug Anderson wrote:
>> The dw_mmc driver keeps a cache of the current slot->clock in order to
>> avoid doing a whole lot of work every time set_ios() is called.
>> However, after suspend/resume the register values are bogus so we need
>> to ensure that the cached value is invalidated.
> This mismatch comes only in case MMC_PM_KEEP_POWER, right?

Actually, no.  I saw problems with the SD Card slot, which doesn't
have MMC_KEEP_POWER.  Problems showed up when no card was inserted
across suspend/resume.  In other words:

1. At boot time, slot is all setup and configured to 400kHz.

2. Suspend

3. Resume; clock registers are reset (by suspend/resume) and not
restored since dw_mmc still thinks slot is configured for 400kHz due
to host->current_speed cache.

4. Insert card.

5. No code sees any need to change the clock for detecting the card,
since everyone thinks it's at 400kHz.  ...but it's not.


>> In many cases we got by without this since the core mmc code fiddles
>> with the clock a lot.  If we've got a card present we're probably
>> running it at something like 50MHz and the core will temporarily
>> switch us to 400kHz after resume.  One case that didn't work (for me)
>> is the case of having no card in the slot.  The slot is initted to
>> 400kHz at boot time.  After suspend/resume the slot thinks it's still
>> at 400kHz (due to the cache) so doesn't adjust timing.  When it tries
>> to send the command at probe time it just times out and gets left in a
>> bad state.
> I understand this change although some part of commit message (boot time, probe time...) make me confused.

Sorry to be confusing.  I was trying to explain why the old code works
fine in many cases.  It's because the core MMC code tends to adjust
the clock a lot around suspend/resume.  When it does that, it works
around this problem.  ...but I found one case where suspend/resume
would happen and the MMC core didn't adjust the clock.


> I guess this change intends to update clock programming forcedly.
> It looks like another version of 'dw_mci_setup_bus(slot, true)'.
> Eventually, this change does same?

Effectively, yes.  As Jaehoon points out, that means we can actually
eliminate the "force" parameter to dw_mci_setup_bus().


I will send a new version out that eliminates the "force" parameter
and updates the commit message to (hopefully) be clearer.

-Doug
