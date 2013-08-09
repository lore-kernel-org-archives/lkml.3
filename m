Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966883Ab3HIAQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:16:58 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58174 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966748Ab3HIAQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:16:56 -0400
MIME-Version: 1.0
Date: Thu, 8 Aug 2013 17:16:55 -0700
Message-ID: <CAD=FV=U3aT1KKtSwAFhYURJJerp70ij8h647=xyV51et4jYipg@mail.gmail.com>
Subject: dw_mmc: Does anyone use multiple slots?
From: Doug Anderson <dianders@google.com>
To: James Hogan <james.hogan@imgtec.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Tomasz Figa <tomasz.figa@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sonny Rao <sonnyrao@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A quick question: does anyone know of any hardware that actually
implements multiple slots per host on the dw_mmc controller?

When working on the driver I often find myself running into questions
about how things should work on the theoretical "multiple slot" dw_mmc
implementation.  ...and I often find bugs where things couldn't
possibly work for a multiple slot implementation.

As an example, recently I sent up (870556a mmc: dw_mmc: Handle late
vmmc regulators with EPROBE_DEFER).  Before that patch the host-global
"host->vmmc" was being set once per slot.  Said another way, if slot 0
set host->mmc to ABC, then slot 1 would come along and clobber
host->mmc to DEF.  After my patch the dw_mmc code assumes one vmmc
regulator per host.  As Tomasz pointed out, that might not be so good
(*), but it was better than what was there before.  Maybe all
multislot implementations don't use vmmc?

Another example, though, is dw_mci_init_slot().  It calls this once per slot:
  mmc_alloc_host(sizeof(struct dw_mci_slot), host->dev);

...where "host->dev" is shared among all the slots.  I haven't tested
it (since I don't have multislot), but that doesn't seem wise to me.
Reading through mmc_alloc_host(), it looks like it assumes that this
host owns host->dev and it feels free to clobber variables.  Sound
familiar?

I guess my overall question is: if there are no actual implementations
of multislot, shouldn't we kill it and simplify the code a whole lot?
If someone out there has a real multislot device they can step back in
and do it more correctly?

Of course we need to find someone to actually go through and do the
killing of multislot, but finding that person might be easier if there
was some agreement that it was good to do.

Cheers?  Flames?

-Doug

---

(*) On the other hand, maybe my patch is OK.  A reasonable way that
multi-slot power might work is with a since vmmc and then it is
multiplexed through with PWREN?  All I know is that exynos says
"PWREN" is not implemented and that exynos only has one slot per host.
