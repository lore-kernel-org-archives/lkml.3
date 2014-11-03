Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaKCNEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:04:10 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:53051 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaKCND6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:03:58 -0500
Date: Mon, 3 Nov 2014 13:02:22 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [RFC 0/2] drivers: spi/i2c: account completions as iowait
Message-ID: <20141103130222.1c53fa39@alan.etchedpixels.co.uk>
In-Reply-To: <1414936689-2707-1-git-send-email-wsa@the-dreams.de>
References: <1414936689-2707-1-git-send-email-wsa@the-dreams.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  2 Nov 2014 14:58:07 +0100
Wolfram Sang <wsa@the-dreams.de> wrote:

> So, I recently learned that there is wait_for_completion_io_* because one I2C
> driver uses it instead of wait_for_completion_*. I want consistency, so
> technically the io-versions seem to be the correct ones to me, because, well,
> we are waiting for IO.
> 
> However, researching the net, users currently interpret iowait entirely as
> blkio wait. Furthermore, io_schedule() calls delayacct_blkio_{start|end}() which
> worked fine for my tests with I2C but might show that iowait was really meant as
> blkiowait? So, should other subsystems use it?

I don't think so. The traditional Unix use of I/O wait is block I/O wait,
in order to account for paging/swapping in "uptime".

The other problem is that if you change the way it behaves you'll get
lots of hate mail from people running server farms as all their load
balancing and cluster management changes behaviour, plus baffled users
wondering why their system is now busy and it wasn't in the last release.

I'm not really sure how it should be accounted - arguably an SPI
transaction to an SD card is I/O wait but one to a display controller on
the same i2c bus is not.

The other question you have to solve is that people are adding i2c and
SPI slave support both in Android space and now perhaps upstream. How do
you I/O account those transactions ?

Alan
