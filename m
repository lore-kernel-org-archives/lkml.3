Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539Ab3DBKfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:35:12 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:53654 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760974Ab3DBKfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:35:09 -0400
Message-ID: <1364898904.2556.26.camel@host5.opentask.org>
Subject: Re: [PATCH v2] wait while adding MMC host to ensure root mounts
From: Sergey Yanovich <ynvich@gmail.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Date: Tue, 02 Apr 2013 14:35:04 +0400
In-Reply-To: <CAPDyKFroki00+SCLjUXYN_=+qcVZwZ2H4NJacH+d8p3dFXoLPg@mail.gmail.com>
References: <1363223183-3772-1-git-send-email-ynvich@gmail.com>
	 <1363224194-7366-1-git-send-email-ynvich@gmail.com>
	 <87620jmkoe.fsf@octavius.laptop.org>
	 <CAPDyKFp27MUOjhydLXf92vN3cua=XcX4oTJnMGfOJPpBhtwM8Q@mail.gmail.com>
	 <CAL0eWdGjPKUUcm6mStAHgHKHLABmPw7nMwDhR8D5rbvg+DPzfQ@mail.gmail.com>
	 <CAPDyKFroki00+SCLjUXYN_=+qcVZwZ2H4NJacH+d8p3dFXoLPg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-02 at 12:13 +0200, Ulf Hansson wrote:
> Consider a platform having two eMMCs and one SD-card. Each eMMC card
> will take around 400 ms to initialize and the SD-card 700 ms. The card
> initialization times are real examples from eMMCs and SD-cards,
> moreover those are typical values not worth cases. In total we have
> around 1.5 s to initialize the cards.

We have a separate workqueue per host, so all probes go in parallel.
They also go in parallel with probing for other devices. So the actual
delay is 700 ms minus maximum probing time for other devices. The time
is either zero or small (dozen us) on the hardware I have access to
(intel laptop, arm controller).

> Now, suppose you boot using an initrd image. Thus neither of the cards
> needs to be accessible immediately after the kernel has booted. It all
> depends what the init process decides to do. With this patch the init
> process will always be delayed to wait for each and every card to be
> initialized. I would prefer a solution where this can be configurable
> somehow, since certainly this is not the scenario you want for all
> cases.

If the system is booted using initrd and root is not on an mmc card,
then mmc modules can be omitted from initrd. The probing will happen
only after root is mounted.

If root is on an mmc, kernel needs to wait for the mmc probe.

