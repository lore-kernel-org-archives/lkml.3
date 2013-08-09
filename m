Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967993Ab3HIPnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:43:16 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:59896 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967927Ab3HIPnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:43:14 -0400
MIME-Version: 1.0
In-Reply-To: <001a01ce9505$59c28b20$0d47a160$%jun@samsung.com>
References: <1373470926-19314-1-git-send-email-dianders@chromium.org>
	<1375825071-20922-1-git-send-email-dianders@chromium.org>
	<1375825071-20922-4-git-send-email-dianders@chromium.org>
	<001a01ce9505$59c28b20$0d47a160$%jun@samsung.com>
Date: Fri, 9 Aug 2013 08:43:13 -0700
X-Google-Sender-Auth: qJWe4i-o3WSnFRpCo-stk0X8GYM
Message-ID: <CAD=FV=VO=50uMXfwY5iNa+xiamRiHTSpTMXs+EdMeUTawkeyqw@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] mmc: dw_mmc: Always setup the bus after suspend/resume
From: Doug Anderson <dianders@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Jaehoon Chung <jh80.chung@samsung.com>,
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

Seungwon,

On Fri, Aug 9, 2013 at 6:35 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> On Wed, August 07, 2013, Doug Anderson wrote:
>> After suspend/resume all of the dw_mmc registers are reset to
>> defaults.  We restore most of them, but specifically don't setup the
>> clock registers after resume unless we've got a powered card.  Things
>> still work because the core will eventually call set_ios() and we'll
>> set things up.
>
> Hmm, I didn't get the need of this call during resume.
> I think set_ios is only valid where core layer calls.
> Besides, important things is ios's parameters.
> If suspend has finished successfully, last call of set_ios() is from mmc_power_off().
> On seeing fields of 'mmc->ios' stored last, these values aren't proper in resume phase.
> Please check mmc_power_off() function.
> In case MMC_PM_KEEP_POWER it could be kept.

Most of my reasoning has to do with the fact that the state of the
system after suspend/resume should not be significantly different than
the state of the system before suspend/resume.  If the state of the
system is different in the two cases it points out potential problems
or inefficiencies.

To make this more concrete:

1. Boot up a system with no card in the SD Card slot.
2. Note down the value of registers like CLKDIV, CLKENA, etc.
3. Suspend / resume (S2R)
4. Check the values of CLKDIV, CLKENA, etc.

You will notice that they are different.  This is a bad sign and can
be a source of bugs (though I don't know of any).  ...or it could mean
that power draw is different (could be better, could be worse) after a
suspend/resume cycle.


Said another way, if the value of CLKDIV, CLKENA, etc is not important
when a card is not inserted, why do they get initialized at boot time?


In general, I think that the mmc core code makes the assumption that
it's up to the driver to make sure that its state is preserved across
S2R.  For dw_mmc the driver doesn't do the "brute force" that some
drivers do of just saving and restoring all registers using a copy
loop.  Instead, the dw_mmc driver runs code that tries to set the
state back to something reasonable.  Without my patch the dw_mmc
driver doesn't run any code that restores these registers.
dw_mci_set_ios() will do so.

Another option would be to forcibly save/restore registers in suspend/resume.

-Doug
