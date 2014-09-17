Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbaIQMSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:18:34 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60142 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754653AbaIQMSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:18:33 -0400
Date: Wed, 17 Sep 2014 13:18:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Will Deacon <will.deacon@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: hw_breakpoint: Trap undef instruction exceptions
	on wake-up
Message-ID: <20140917121820.GR12361@n2100.arm.linux.org.uk>
References: <1410955036-1956-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410955036-1956-1-git-send-email-geert+renesas@glider.be>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 01:57:16PM +0200, Geert Uytterhoeven wrote:
> If power area D4, which contains the Coresight-ETM hardware block, is
> powered down on R-Mobile A1 (r8a7740), the kernel crashes when
> suspending from s2ram with:
> 
>     Internal error: Oops - undefined instruction: 0 [#1] ARM
> 
> This happens because dbg_cpu_pm_notify() calls reset_ctrl_regs(), which
> can't access the debug registers as the debug module is powered down.
> 
> Protect the call to reset_ctrl_regs() by an undefined instruction hook,
> like was done in commit 0d352e3d006c9589 ("ARM: hw_breakpoint: trap
> undef instruction exceptions in reset_ctrl_regs") for another caller.

I'd prefer a better solution to this (such as tracking whether the ETM
block is powered down).  This feels very much like a hack than a good
solution.

Also, the undefined instruction hook was not supposed to be used in this
way - certainly *not* dynamically like this.  While the lookup of the
undef handler is done in a safe atomic way, calling the resulting
function is outside of the locks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
