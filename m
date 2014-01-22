Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaAVKgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 05:36:08 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:44720 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751612AbaAVKgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 05:36:03 -0500
Date: Wed, 22 Jan 2014 10:35:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Xiaoguang Chen <chenxg.marvell@gmail.com>
Cc: mturquette@linaro.org, Xiaoguang Chen <chenxg@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lucao@marvell.com, cxie4@marvell.com, Zhoujie Wu <zjwu@marvell.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: mutual exculsion between clk_prepare_enable
	/clk_disable_unprepare and clk_set_parent
Message-ID: <20140122103553.GY15937@n2100.arm.linux.org.uk>
References: <CAFgnuDdOKxzFSDCBQTGw=p_t0CvKfjVEudttOCP_wrzyA2K1Og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFgnuDdOKxzFSDCBQTGw=p_t0CvKfjVEudttOCP_wrzyA2K1Og@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 02:02:57PM +0800, Xiaoguang Chen wrote:
> Hi, Mike
> 
> We met a issue between clk_prepare_enable /clk_disable_unprepare and
> clk_set_parent.

clk_prepare_enable/disable_unprepare are perfectly fine in themselves.
You're looking at the problem wrongly - because drivers can perfectly
well call clk_prepare() and clk_unprepare() themselves.  There's no
requirement for the enable and prepare to be paired together under any
kind of lock.

> and if below condition occurs, there will be problem
>
> thread1                                                 thread 2
> call clk_disable_unprepare

Okay, if we're calling clk_disable_unprepare(), then the clock
must already have been prepared and enabled - which means that
the current parent is already prepared and enabled.

> 1) clk_disable
> get enable lock
> ...............
> release enable lock

This may result in the parent being disabled too.

> 
>                                                      call clk_set_parent
>                                                      get prepare lock
>                                                      set clock's
> parent to another parent

At this point, the existing parent clock should be disabled if this
clock was enabled, and unprepared if this clock was prepared.  The
new parent should be prepared and enabled as appropriate too so that
everything is kept balanced.

>                                                      release prepare lock
> 
> 2) clk_unprepare
> get prepare lock
> unprepare parent clock <<--------------
> release prepare lock

And with the above guarantee - which is required in any case to make
reparenting safe - there's no problem here.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
