Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaKBQ7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 11:59:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:50744 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaKBQ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 11:59:46 -0500
Date: Sun, 2 Nov 2014 17:59:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Balbir Singh <bsingharora@gmail.com>
Subject: Re: [RFC 0/2] drivers: spi/i2c: account completions as iowait
Message-ID: <20141102165943.GT10501@worktop.programming.kicks-ass.net>
References: <1414936689-2707-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414936689-2707-1-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 02:58:07PM +0100, Wolfram Sang wrote:

> However, researching the net, users currently interpret iowait entirely as
> blkio wait. Furthermore, io_schedule() calls delayacct_blkio_{start|end}() which
> worked fine for my tests with I2C but might show that iowait was really meant as
> blkiowait? So, should other subsystems use it?

I would tend to agree with that; historically this has always been about
blkio, not device io.

> To make it more confusing, some people (like Peter Zijlstra [1]) seem to like
> iowait gone, so maybe it is all not worth it?

Yeah, iowait accounting is terminally broken :-) Mostly because the
iowait is accounted per-cpu but that is a very tenuous relation because
the IO devices are not per IO and blocking tasks are not associated with
any particular CPU -- after all they're not consuming CPU time.

If people really think its worth; we could invent new IO-wait measure
that do make sense -- maybe, but the current thing is complete bollocks.
