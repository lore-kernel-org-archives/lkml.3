Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaAaVNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:13:22 -0500
Received: from netrider.rowland.org ([192.131.102.5]:54357 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754372AbaAaVNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:13:20 -0500
Date: Fri, 31 Jan 2014 16:13:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <ivan.khoronzhuk@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: keystone: switch to use runtime pm
In-Reply-To: <20140131164534.GL20736@saruman.home>
Message-ID: <Pine.LNX.4.44L0.1401311608590.12368-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014, Felipe Balbi wrote:

> probe()
> {
> 	...
> 
> 	clk_get(dev, "fck");
> 	clk_prepare(clk);
> 	clk_enable(clk);
> 	pm_runtime_set_active(dev);
> 	pm_runtime_enable(dev);
> 	pm_runtime_get_sync(dev);
> 	...
> }

> note that because of pm_runtime_set_active() that first
> pm_runtime_get_sync() in probe() will simply increase the reference
> counter without calling my ->runtime_resume() callback, which is exactly
> what we want, as that would completely avoid situations of bad context
> being restored because of that initial pm_runtime_get_sync().

Very minor note...  A slightly better way to do the same thing is:

	pm_runtime_set_active(dev);
	pm_runtime_get_noresume(dev);
	pm_runtime_enable(dev);

The get_noresume says that you want to increment the usage counter
without performing any callbacks, and doing it before the
pm_runtime_enable avoids any window during which a runtime suspend
might somehow occur.

Alan Stern

