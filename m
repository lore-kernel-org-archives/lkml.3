Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaKRW6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 17:58:13 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:39063 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbaKRW6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 17:58:11 -0500
Date: Tue, 18 Nov 2014 23:55:46 +0100
From: Beniamino Galvani <b.galvani@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Subject: Re: [PATCH v2 1/4] spi: Add 'last' flag to spi_transfer structure
Message-ID: <20141118225546.GA27182@gmail.com>
References: <1416264471-774-1-git-send-email-b.galvani@gmail.com>
 <1416264471-774-2-git-send-email-b.galvani@gmail.com>
 <20141118140658.GI22111@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118140658.GI22111@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 02:06:58PM +0000, Mark Brown wrote:
> It's incredibly sad to iterate through the entire list in order to find
> the last entry, especially given that it's a doubly linked list and this
> is a bit of a hot path.  We should look at the previous entry for the
> list head instead, or perhaps better yet by doing this as part of
> spi_validate() which already itereates over the entire list and is where
> we do other similar fixups.
> 
> Though looking at this I'm not sure that a flag is the best approach at
> all - why not just have the driver call list_is_last() in the transfer
> function or ideally provide an inline function that does that so that we
> can change the implementation later?

I didn't realize that the master structure passed to transfer_one()
has a reference to the current message and thus to the transfer
list. Then yes, the additional flag in the transfer structure probably
doesn't make much sense.

Would it be better to introduce something like:

static inline bool
spi_transfer_is_last(struct spi_master *master, struct spi_transfer *xfer)
{
        return list_is_last(&xfer->transfer_list, &master->cur_msg->transfers);
}

or open code it in the driver?

Beniamino
