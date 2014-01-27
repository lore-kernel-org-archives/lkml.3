Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaA0S2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:28:21 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:17780 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbaA0S2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:28:19 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+7Skq+2gbBWVj7CPt+cpG2iKH5kkjpFdU=
X-DKIM: OpenDKIM Filter v2.0.1 titan 3D1885163FA
Date: Mon, 27 Jan 2014 13:28:07 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Kevin Hilman <khilman@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
Message-ID: <20140127182807.GM29184@titan.lakedaemon.net>
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140127153908.4f6f46c2@skate>
 <52E6A3B2.6060301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E6A3B2.6060301@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 07:21:38PM +0100, Sebastian Hesselbarth wrote:
> On 01/27/14 15:39, Thomas Petazzoni wrote:
> >On Sat, 25 Jan 2014 19:19:06 +0100, Sebastian Hesselbarth wrote:
> >>This patch set fixes clk init order that went upside-down with
> >>v3.14. I haven't really investigated what caused this, but I assume
> >>it is related with DT node reordering by addresses.
> >>
> >>Anyway, with v3.14 for MVEBU SoCs, the clock gating driver gets
> >>registered before core clocks driver. Unfortunately, we cannot
> >>return -EPROBE_DEFER in drivers initialized by clk_of_init. As the
> >>init order for our drivers is always core clocks before clock gating,
> >>we maintain init order ourselves by hooking CLK_OF_DECLARE to one
> >>init function that will register core clocks before clock gating
> >>driver.
> >>
> >>This patch is based on pre-v3.14-rc1 mainline and should go in as
> >>fixes for it. As we now send MVEBU clk pull-requests to Mike directly,
> >>I suggest Jason picks it up as a topic branch.
> >
> >I'm not sure I really like the solution you're proposing here. I'd very
> >much prefer to keep one CLK_OF_DECLARE() per clock type, associated to
> >one function registering only this clock type.
> 
> Have you ever had a look at e.g. clk-imx28.c? Not that I really like
> the approach, but it is common practice to do so.
> 
> >Instead, shouldn't the clock framework be improved to *not* register a
> >clock until its parent have been registered? If the DT you have the
> >gatable clocks that depend on the core clocks, then the gatable clocks
> >should not be registered if the core clocks have not yet been
> >registered.
> >
> >Do you think this is possible? Am I missing something here?
> 
> As I said, clk_of_init does not care about return values from the
> clock init functions. Without it, it cannot decide if a clock
> driver failed horribly, failed because of missing dependencies, or
> successfully installed all clocks. Also, it is early stuff and I guess
> clk_of_init will have to build its own "defered_list" and loop over
> until done.
> 
> BTW, this is a fix not an improvement. We should find an acceptable
> solution soon. But I am still open for suggestions, too.

fyi: I suspect this may be the problem currently experienced by Kevin on
mirabox in the boot farm.  He sees it on current master.  Adding him to
the Cc.

thx,

Jason.

