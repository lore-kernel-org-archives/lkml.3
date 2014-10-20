Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaJTRgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:36:13 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:38586 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751181AbaJTRgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:36:10 -0400
Date: Mon, 20 Oct 2014 18:36:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Vladimir Zapolskiy <vz@mleia.com>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>, jonsmirl@gmail.com,
        Simon <longsleep@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv8 1/2] pwm: Add Allwinner SoC support
Message-ID: <20141020173601.GX27405@n2100.arm.linux.org.uk>
References: <1413743305-1979-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1413743305-1979-2-git-send-email-alexandre.belloni@free-electrons.com>
 <54442BB1.1080403@mleia.com>
 <20141020102939.GB10616@piout.net>
 <544509C7.9010309@mleia.com>
 <20141020170603.GG10616@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020170603.GG10616@piout.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 07:06:04PM +0200, Alexandre Belloni wrote:
> Because the PWM is getting configured from either a kernel thread or a
> userspace thread accessing /sys. So you probably want the current thread
> to sleep so the other thread accessing the register can finish. Unless
> you are on smp and then, the mutex will spin for some time and your
> other cpu will be finished by then.

I agree with Vladimir.  A spinlock would be better here.  You're only
needing to sleep for a short time (the time it takes to complete the
register accesses) and to have a competing thread go through a context
switch twice is stupidly expensive compared to having it wait a short
time for the spinlock to be released.

What the driver could do with is using the relaxed IO accessors too,
if you care about eliminating the unnecessary barriers in there.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
