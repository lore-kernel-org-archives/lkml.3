Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3ARUNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:13:18 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49784 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3ARUNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:13:17 -0500
Date: Fri, 18 Jan 2013 20:13:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>
Subject: Re: [PATCH v3] drivers/pinctrl: grab default handles from device
	core
Message-ID: <20130118201307.GG23505@n2100.arm.linux.org.uk>
References: <1358521728-14300-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358521728-14300-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 04:08:48PM +0100, Linus Walleij wrote:
> - Abstain from using IS_ERR_OR_NULL() in the driver core,
>   Russell recently sent a patch to remove it. Handle the
>   NULL case explicitly even though it's a bogus case.

Hmmmmmmmm... I assume you're talking about this:

> +	p = create_pinctrl(dev);
> +	if (p && !IS_ERR(p))
> +		kref_init(&p->users);
> +	return p;

which is... interesting.  In mainline currently, the version I see there
never returns NULL - it either returns an err pointer or a real pointer.

Next thing though is...

create_pinctrl adds the struct pinctrl onto the global list, and then you
intialize it here, which is an interesting sequence.  It's safe at the
moment because everything here is operating under a mutex, but it's a
little obscure.

Is there a reason not to initialize p->users inside create_pinctrl() ?
