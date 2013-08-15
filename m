Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab3HOUrC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:47:02 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:50551 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab3HOUrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:47:00 -0400
MIME-Version: 1.0
In-Reply-To: <520D1363.3090708@codeaurora.org>
References: <1374702089-2832-1-git-send-email-hanumant@codeaurora.org>
	<CAJAp7OjbJwaH8SFdSwDU4VLwTAY1PfDWy1S+yF05=oPuUApvNA@mail.gmail.com>
	<CACRpkdbNpVUV9B1p1Cp5q2vJtQ78zhqsDBss2k28=cxF9Mn7pg@mail.gmail.com>
	<520D1363.3090708@codeaurora.org>
Date: Thu, 15 Aug 2013 22:47:00 +0200
Message-ID: <CACRpkdYVQ-Yk_b0cW0-sB6eGkpkgfFsnd3NXQmCYCuiLmm5qww@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: msm: Add support for MSM TLMM pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Hanumant Singh <hanumant@codeaurora.org>
Cc: Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 7:44 PM, Hanumant Singh <hanumant@codeaurora.org> wrote:

> Ok i can switch to using pin groups defined in per soc files.
> But in our case we have one soc going into different types of boards.
> (atleast 3). In each of the boards the same external devices end up using
> different pins. For ex camera on board 1 uses different pin group
> then the same camera on board 2. Both having the same SOC.
> So in this case the design would be to have all possible pin groups
> for different boards enumerated in the same soc-pinctrl.c file?

Sorry I don't get this at all.

What pin groups and functions that exist on a SoC is what you put into
a SoC driver. Because this is a hardware characteristic.

How these are combined on a board into different states is what you put
into the device tree. (Or platform data.)

> Also in this implementation I will have.
> 1) pinctrl-msm.c => DT parsing and interface to framework.
> 2) pinctrl-msm-tlmm<version>.c => Register programming and pin types
> supported by a particular TLMM pinmux version.
> 3) pinctrl-<soc>.c => All the pins/pin groups supported by a given SOC.

Seems OK.

> As I
> mentioned we will have a bloat of these, since we have entire families of
> SOC using a given TLMM version but with unique pin groupings.

Bring 'em on. But is that really different groups you are talking about,
and not just combinations of groups with functions for a certain board
as I describe above?

If you have many SoC subdrivers, consider creating a subdir as some
drivers already have.

> I don't override the default values, since resistor values are not
> configurable. I only care about which config option is chosen to program it
> as pull up/down or disable.

That sounds correct.

>> Actually the data should be more carefully handled for each
>> config option I think.
>>
> Not sure I follow. Based on my use mentioned above, what do you suggest for
> the read? Should I return default config value, which is what I am doing ?

Here:

+       switch (id) {
+       case PIN_CONFIG_BIAS_DISABLE:
+               mask = TLMMV3_GP_PULL_MASK;
+               shft = TLMMV3_GP_PULL_SHFT;
+               data = TLMMV3_NO_PULL;

data should just be zero. (Maybe TLMMV3_NO_PULL is
zero? But anyway...)

+               if (!write) {
+                       val >>= shft;
+                       val &= mask;
+                       data = rval_to_pull(val);

Dito.

Because it has no meaning in the framework.

Yours,
Linus Walleij
