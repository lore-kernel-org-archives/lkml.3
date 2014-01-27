Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaA0Oph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:45:37 -0500
Received: from top.free-electrons.com ([176.31.233.9]:50738 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753822AbaA0Opf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:45:35 -0500
Date: Mon, 27 Jan 2014 15:45:32 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/11] pinctrl: mvebu: fix misdesigned resource
 allocation
Message-ID: <20140127154532.4bc3eeef@skate>
In-Reply-To: <1390674856-4993-6-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1390674856-4993-6-git-send-email-sebastian.hesselbarth@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Sat, 25 Jan 2014 19:34:10 +0100, Sebastian Hesselbarth wrote:
> Allocating the pinctrl resource in common pinctrl-mvebu was a misdesign,
> as it does not allow SoC specific parts to access the allocated resource.
> This moves resource allocation from mvebu_pinctrl_probe to SoC specific
> _probe functions and passes the base address to common pinctrl driver
> instead.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

I definitely agree with that: I had the same problem several months ago
when I started doing the pinctrl driver for Orion5x, which has a
non-linear MPP register set.

However, I'd like this to go a little bit further if possible. See
below.


> -	return mvebu_pinctrl_probe(pdev);
> +	return mvebu_pinctrl_probe(pdev, base);

I think there is no need to pass "base" to mvebu_pinctrl_probe(). The
only reason we have this is because the base gets stored in the
mvebu_pinctrl structure so that the mvebu_common_mpp_get() and
mvebu_common_mpp_set() functions that are the default behavior
for mvebu_pinconf_group_get() and mvebu_pinconf_group_set() work
properly.

Shouldn't we turn these functions mvebu_common_mpp_get() and
mvebu_common_mpp_set() into helper functions, accessible from the
per-SoC pinctrl drivers, so that they can easily implement their
->mpp_get() and ->mpp_set() callbacks?

This way, the "base" thing is completely owned by the per-SoC driver,
which would be more logical I believe.

Thanks!

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
