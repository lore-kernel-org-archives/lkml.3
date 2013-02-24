Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420Ab3BXAib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 19:38:31 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:50626 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758986Ab3BXAi3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 19:38:29 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH] i2c: s3c2410: check for NULL pinctrl handle
Date: Sun, 24 Feb 2013 01:38:26 +0100
Message-ID: <5027662.bpQdq7jhyn@flatron>
User-Agent: KMail/4.10 (Linux/3.8.0-gentoo; KDE/4.10.0; x86_64; ; )
In-Reply-To: <CACRpkdbV-CznfnbCbKkKpndjiG32V9yNdrF1F7M=4qe1EUroGA@mail.gmail.com>
References: <201302231855.47560.heiko@sntech.de> <201302231857.46445.heiko@sntech.de> <CACRpkdbV-CznfnbCbKkKpndjiG32V9yNdrF1F7M=4qe1EUroGA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sunday 24 of February 2013 01:16:21 Linus Walleij wrote:
> On Sat, Feb 23, 2013 at 6:57 PM, Heiko Stübner <heiko@sntech.de> wrote:
> > When pinctrl is not built the fallback functions fail silently
> > and emit either 0 error codes or NULL pinctrl handles.
> > 
> > Therefore it's needed to also check for this NULL-handle when
> > falling back to parsing the i2c gpios from devicetree.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> 
> NAK.
> 
> This is not the right solution for this driver.
> 
> It uses pinctrl in a very simplistic way, just grabbing the
> default handler.
> 
> After commit
> ab78029ecc347debbd737f06688d788bd9d60c1d:
> "drivers/pinctrl: grab default handles from device core"
> 
> The right solution is to simply revert commit
> 2693ac69880a33d4d9df6f128415b65e745f00ba
> "i2c: s3c2410: Add support for pinctrl"
> 
> Tomasz are you OK with this, or will you add more
> fine-grained pinctrl (like runtime PM etc) to this driver?

Yes, I'm fine. However reverting this patch will not solve the problem 
completely.

There are 3 methods of pin configuration that has to be supported by this 
driver (and several other drivers):
 1) cfg_gpio callback passed in platform data,
 2) legacy Samsung GPIO bindings (to be dropped ASAP),
 3) pin control.
Each supported platform will support only one of these methods at the same 
time.

The first one is already handled correctly because it is always used 
wherever it is available. The problem is with the remaining two.

The driver must know whether pin control is available, because it has to 
fall back to legacy GPIO-based pin configuration if it is not. This means 
that we must either check for NULL (which probably is not right, since 
returned handle is considered to be opaque) or pin control core must 
return an error code specific to this situation, e.g. -ENODEV.

Keep in mind that there is no way to check whether method 2) succeeded, 
because all it does is parsing GPIOs from device tree, assuming that the 
custom xlate function of the old Samsung GPIO driver would do all the 
configuration.

I do not see another solution of this problem. Feel free to suggest 
anything better.

Best regards,
Tomasz

