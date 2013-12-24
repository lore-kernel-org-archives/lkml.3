Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3LXMya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 07:54:30 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48337 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3LXMy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 07:54:28 -0500
Date: Tue, 24 Dec 2013 12:53:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20131224125358.GB30815@sirena.org.uk>
References: <20131211005106.GL11468@sirena.org.uk>
 <52A7C0C3.2070805@codeaurora.org>
 <20131211132729.GT11468@sirena.org.uk>
 <52AA42FD.4040503@codeaurora.org>
 <20131213104128.GT11044@sirena.org.uk>
 <20131213213707.GO21983@codeaurora.org>
 <20131216210153.GA3185@sirena.org.uk>
 <20131217023047.GC31766@codeaurora.org>
 <20131218184541.GH31886@sirena.org.uk>
 <52B897A1.8030205@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B897A1.8030205@codeaurora.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 81.132.50.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Allow regmap_bulk_write() to work for "no-bus"
 regmaps
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 12:05:53PM -0800, Stephen Boyd wrote:
> On 12/18/13 10:45, Mark Brown wrote:

> > This doesn't quite work - val is an array of objects of the size of the
> > size of a register not of unsigned integers so you're parsing extra data
> > out there.  That possibly wasn't the best choice of API but we have
> > quite a few users now so ick.

> Are you concerned that we'll read past the end of the val buffer? Do we
> need to cast the pointer to be the appropriate size according to
> val_bytes? Something like this?

That's one issue, the other is that if we try to read (say) and 8 bit
value as an unsigned int we'll not just read the value we're looking
for.

>                 for (i = 0; i < val_count; i++) {
>                         unsigned int ival;
> 
>                         switch (val_bytes) {
>                         case 1: 
>                                 ival = *(u8 *)(val + (i * val_bytes));
>                                 break;

I think we do sadly.  Or refactor the API to work in unsigned ints
which would've been more sensible in the first place but that'd make it
asymmetrical with the read API as it stands...
