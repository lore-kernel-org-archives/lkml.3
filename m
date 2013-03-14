Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab3CNHHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 03:07:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:20515 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979Ab3CNHHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 03:07:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,843,1355126400"; 
   d="scan'208";a="270538369"
Message-ID: <1363244859.11441.81.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v5 0/3] mtd: use the full-id as the keyword for some
 nand chips
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Brian Norris <computersforpeace@gmail.com>
Cc: Huang Shijie <b32955@freescale.com>, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Mar 2013 09:07:39 +0200
In-Reply-To: <CAN8TOE9XBphuTY6h_fgBaSfrFRVg0ZuG+9OxDYR+yvfJn1CcGQ@mail.gmail.com>
References: <1363229965-13128-1-git-send-email-b32955@freescale.com>
	 <CAN8TOE9XBphuTY6h_fgBaSfrFRVg0ZuG+9OxDYR+yvfJn1CcGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-13 at 21:48 -0700, Brian Norris wrote:
> On Wed, Mar 13, 2013 at 7:59 PM, Huang Shijie <b32955@freescale.com> wrote:
> > As time goes on, we begin to meet the situation that we can not
> > get enough information from some nand chips's id data.
> > Take some Toshiba's nand chips for example.
> > I have 4 Toshiba's nand chips in my hand:
> >         TC58NVG2S0F, TC58NVG3S0F, TC58NVG5D2, TC58NVG6D2
> >
> > When we read these chips' datasheets, we will get the geometry of these chips:
> >         TC58NVG2S0F : 4096 + 224
> >         TC58NVG3S0F : 4096 + 232
> >         TC58NVG5D2  : 8192 + 640
> >         TC58NVG6D2  : 8192 + 640
> >
> > But we can not parse out the correct oob size for these chips from the id data.
> > So it is time to add some new fields to the nand_flash_dev{},
> > and update the detection mechanisms.
> >
> > v4 --> v4:
> >         [1] remove the id_len field.
> >         [2] based on Artem "mtd: nand: use more reasonable integer types"
> >         [3] add more comments.
> 
> Sorry for not posting this earlier, but why don't we want an id_len
> field? NAND chips often only have a 5-byte or 6-byte ID "defined" in
> their datasheet, and so the next few bytes aren't guaranteed to be any
> particular value. Wouldn't we want to accommodate for any potential
> variation in the "undefined" bytes? (These bytes do typically have a
> pattern, and in fact, we currently rely on that fact.) Also, I can
> easily foresee a situation in which someone might want to support NAND
> based solely on the datasheet, not waiting till they get a sample of
> that chip in their hands. In that case, they cannot specify a full 8
> bytes in the table; they can (and should) only specify the few
> substring found in their datasheet.
> 
> Really, the only argument I see for dropping id_len is to save space.
> I think this is a bad choice.

Let's take a flash which has 5 bytes ID length, suppose it is
{1, 2, 3, 4, 5}. The 8-byte table value for this flash would be:
{1, 2, 3, 4, 5, 0, 0, 0}. When we read the ID sequence, we need to start
with allocating an 8-byte array and initializing it to 0. Then we read
the 5-byte ID and end up with: {1, 2, 3, 4, 5, 0, 0, 0}. And we
successfully match the table entry.

That was my thinking.

There is a potential problem: there may be a flash with 6 bytes ID with
value {1, 2, 3, 4, 5, 0}, in which case the algorithm would not work.

However, I consider this to be very unlikely. And even if this unlikely
situation happens, it will probably be noticed and we could fix this
with adding the ID length field.

My rationale is avoiding over-designing and trying to cover low
probability theoretical cases.

But yes, I did not really strongly opposed the field, it was more that I
asked questions from Huang about why is this needed, and expected to
hear some justification. Huang preferred to answer that he does not
really need this, and I just thought that if this is all he can say,
then he should not add it.

This is often, generally, the role of maintainer who cannot get into all
the details - ask questions and validate the answers. Generally, good
answers have correlation with quality code.

You did provide good arguments thanks! If my rationally is not
convincing enough and you think this is not over-engineering, let's have
the ID length field.

BTW, Huang, I think we should introduce a Macro instead of the '8'
constant. And if ATM we do not have 8-byte ID's in our table, we should
make the macro to contain a smaller number. This number can be increased
when needed.

-- 
Best Regards,
Artem Bityutskiy

