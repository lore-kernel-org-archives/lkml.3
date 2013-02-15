Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395Ab3BOLOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 06:14:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43734 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab3BOLOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 06:14:24 -0500
Date: Fri, 15 Feb 2013 11:13:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Dinh Nguyen <dinguyen@altera.com>, Pavel Machek <pavel@denx.de>,
        Stephen Warren <swarren@nvidia.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: Re: [PATCH 8/9] [HACK] ARM: imx: work around v7_cpu_resume link
	error
Message-ID: <20130215111306.GM17833@n2100.arm.linux.org.uk>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de> <1360882071-4072668-9-git-send-email-arnd@arndb.de> <511D7701.8040809@wwwdotorg.org> <201302151105.14253.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302151105.14253.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 11:05:14AM +0000, Arnd Bergmann wrote:
> $ size  obj-tmp/vmlinux -A
> obj-tmp/vmlinux  :
> section                  size         addr
> .head.text                504   3221258240
> .text                32707336   3221258752
> .text.head                  8   3253966088

Interesting... I wonder if that should be .head.text, or maybe just .text.
Looking at iMX, it's just the secondary startup, which is calling into
.head.text, so it would be much safer given the size of the .text segment
for it to be in .head.text.

> The .text section alone is just short of 32MB.

I suspect when it does go over that, we'll see a lot more link time
failures due to the 'bl' instructions failing to encode their PC relative
jumps.  The only solution then will be to switch everything to use the
less efficient long jumps (load address from literal pool, bx) which'll
also need much of the asm changed.  That also brings up the question
whether we want to penalize the kernel performance just to make
allyesconfig work... I guess we can make it a compile time option, which
of course allyesconfig will automatically enable.  I suspect we'll see
a lot of people mistakenly enabling it too though.
