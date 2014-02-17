Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaBQPV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:21:57 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39712 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752748AbaBQPV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:21:56 -0500
Date: Mon, 17 Feb 2014 12:21:48 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Emilio =?utf-8?B?TMOzcGV6?= <emilio@elopez.com.ar>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
Message-ID: <20140217152147.GC2765@localhost>
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140205183457.GW8533@titan.lakedaemon.net>
 <20140217141336.GA2765@localhost>
 <53021BD2.3090301@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53021BD2.3090301@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 03:25:22PM +0100, Gregory CLEMENT wrote:
> On 17/02/2014 15:13, Ezequiel Garcia wrote:
> > On Wed, Feb 05, 2014 at 01:34:57PM -0500, Jason Cooper wrote:
> >> On Sat, Jan 25, 2014 at 07:19:06PM +0100, Sebastian Hesselbarth wrote:
> >>> This patch set fixes clk init order that went upside-down with
> >>> v3.14. I haven't really investigated what caused this, but I assume
> >>> it is related with DT node reordering by addresses.
> >>>
> >>> Anyway, with v3.14 for MVEBU SoCs, the clock gating driver gets
> >>> registered before core clocks driver. Unfortunately, we cannot
> >>> return -EPROBE_DEFER in drivers initialized by clk_of_init. As the
> >>> init order for our drivers is always core clocks before clock gating,
> >>> we maintain init order ourselves by hooking CLK_OF_DECLARE to one
> >>> init function that will register core clocks before clock gating
> >>> driver.
> >>>
> >>> This patch is based on pre-v3.14-rc1 mainline and should go in as
> >>> fixes for it. As we now send MVEBU clk pull-requests to Mike directly,
> >>> I suggest Jason picks it up as a topic branch.
> >>>
> >>> The patches have been boot tested on Dove and compile-tested only
> >>> for Kirkwood, Armada 370 and XP.
> >>>
> >>> Sebastian Hesselbarth (4):
> >>>   clk: mvebu: armada-370: maintain clock init order
> >>>   clk: mvebu: armada-xp: maintain clock init order
> >>>   clk: mvebu: dove: maintain clock init order
> >>>   clk: mvebu: kirkwood: maintain clock init order
> >>>
> >>>  drivers/clk/mvebu/armada-370.c | 21 ++++++++++-----------
> >>>  drivers/clk/mvebu/armada-xp.c  | 20 +++++++++-----------
> >>>  drivers/clk/mvebu/dove.c       | 19 +++++++++----------
> >>>  drivers/clk/mvebu/kirkwood.c   | 34 ++++++++++++++++------------------
> >>>  4 files changed, 44 insertions(+), 50 deletions(-)
> >>
> >> Whole series applied to mvebu/clk-fixes.
> >>
> > 
> > Are we still in time to consider Emilio's oneline proposal?
> > (Emilio: would you mind preparing a suitable patch against dove,
> > kirkwood, armada370/xp, so we can see the real thing?).
> 
> I am still strongly against this proposal because hard-coded the parent
> clock name in the driver seems very wrong and moreover in some circumstances
> (if there is no output-name, which is our default case) this proposal
> just ignored the parent clock given by the device tree and this looked
> more wrong.
> 

So you're against the proposal as a permanent fix, *and* against the
proposal as a workaround fix?

> > 
> > Sebastian fix works perfect, and it easy to understand. However, it has
> > quite a large diffstat. When compared to Emilio's oneline proposal, it
> > seems to me it would be preferable, unless it's broken.
> > 
> > Workaround or not, the fact is this code will be in v3.14, so maybe we
> > can spend some time considering a cleaner option.
> > 

Before discussing the solution as compared to your for-v3.15 clock
registration order patch, I wanted to trigger some discussion around
replacing this big and intrusive workaround with Emilio's oneline fix.

Let's suppose we're considering them as workaround to live just one or
two releases. Wouldn't it be better to take the least instrusive?
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
