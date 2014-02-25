Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaBYACK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 19:02:10 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:49460 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753331AbaBYACG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 19:02:06 -0500
Date: Tue, 25 Feb 2014 00:01:54 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        devicetree@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, dmaengine@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] clk: sun6i: Protect CPU clock
Message-ID: <20140225000154.GR21483@n2100.arm.linux.org.uk>
References: <1393258967-4843-1-git-send-email-maxime.ripard@free-electrons.com> <1393258967-4843-2-git-send-email-maxime.ripard@free-electrons.com> <20140224163034.GN21483@n2100.arm.linux.org.uk> <530BD804.5090806@elopez.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <530BD804.5090806@elopez.com.ar>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emilio.

On Mon, Feb 24, 2014 at 08:38:44PM -0300, Emilio López wrote:
> Why is this so? Can't a clock be left enabled while nobody has a  
> reference to it? I have looked around in Documentation/ (rather quickly  
> I must say) and have not found any explicit mention that it is required  
> to keep a reference to the clock while it's enabled. I'd appreciate it  
> if you could explain this a bit more verbosely or point me to the  
> relevant documents.

First up, if you have a requirement that a clock be enabled, then is it
not unreasonable to ensure that the clock is referenced?

Secondly, what if we have code which scans the clocks in the system,
shutting down those leaf clocks which appear to be unreferenced?

Thirdly, the API (as I designed it) says so:

/**
 * clk_put      - "free" the clock source
 * @clk: clock source
 *
 * Note: drivers must ensure that all clk_enable calls made on this
 * clock source are balanced by clk_disable calls prior to calling
 * this function.
 *
 * clk_put should not be called from within interrupt context.
 */
void clk_put(struct clk *clk);

which has been there since the API was first created - it's part of the
contract between drivers using the API and implementers creating something
which conforms to the API - which today means CCF.

The intention here is that while there are any users holding a clk_get()
reference on a clock, the clock is assumed to be required for some
device, and the struct clk may not be kfree'd, nor may its state be
changed in an unpredictable way to those drivers holding a reference
to it.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
