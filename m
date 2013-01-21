Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab3AUTOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 14:14:01 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:38150 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3AUTN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 14:13:59 -0500
MIME-Version: 1.0
In-Reply-To: <20130118201307.GG23505@n2100.arm.linux.org.uk>
References: <1358521728-14300-1-git-send-email-linus.walleij@stericsson.com>
	<20130118201307.GG23505@n2100.arm.linux.org.uk>
Date: Mon, 21 Jan 2013 20:13:59 +0100
Message-ID: <CACRpkdYXmgOiuiW2Ccas375_3zfrqiOML5qWxaXP4Qzm6KEmWw@mail.gmail.com>
Subject: Re: [PATCH v3] drivers/pinctrl: grab default handles from device core
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Anmar Oueja <anmar.oueja@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 9:13 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Jan 18, 2013 at 04:08:48PM +0100, Linus Walleij wrote:
>> - Abstain from using IS_ERR_OR_NULL() in the driver core,
>>   Russell recently sent a patch to remove it. Handle the
>>   NULL case explicitly even though it's a bogus case.
>
> Hmmmmmmmm... I assume you're talking about this:
>
>> +     p = create_pinctrl(dev);
>> +     if (p && !IS_ERR(p))
>> +             kref_init(&p->users);
>> +     return p;
>
> which is... interesting.  In mainline currently, the version I see there
> never returns NULL - it either returns an err pointer or a real pointer.

Actually it was this thing:

+ dpi->p = devm_pinctrl_get(dev);
+ if (!dpi->p) {
+    /* Shouldn't happen, but handle this anyway */
+    dev_warn(dev, "devm_pinctrl_get() returned NULL\n");
+    devm_kfree(dev, dpi);
+    dev->pins = NULL;
+    return 0;
+ }

I will delete both NULL checks and spin a v4.

> Next thing though is...
>
> create_pinctrl adds the struct pinctrl onto the global list, and then you
> intialize it here, which is an interesting sequence.  It's safe at the
> moment because everything here is operating under a mutex, but it's a
> little obscure.
>
> Is there a reason not to initialize p->users inside create_pinctrl() ?

Not really. I'll fix it...

Yours,
Linus Walleij
