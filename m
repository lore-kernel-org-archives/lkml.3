Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaB1P6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:58:40 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.153]:61817 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677AbaB1P6j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:58:39 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-4.tower-179.messagelabs.com!1393603115!29131215!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David Dajun Chen" <david.chen@diasemi.com>
Subject: RE: [RFC V1] drivers/base/regmap: Implementation for
 regmap_multi_reg_write
Thread-Topic: [RFC V1] drivers/base/regmap: Implementation for
 regmap_multi_reg_write
Thread-Index: AQHPM7GHqEaxopCzZ0K0S2ic/AwIdprKBVuAgAB97oA=
Date: Fri, 28 Feb 2014 15:58:34 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51BCFDE02F@NB-EX-MBX02.diasemi.com>
References: <201402271146.s1RBkCGg004925@swsrvapps-02.lan>
 <20140228033715.GE9383@sirena.org.uk>
In-Reply-To: <20140228033715.GE9383@sirena.org.uk>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.24.126]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: 28 February 2014 03:37
> To: Opensource [Anthony Olech]
> Cc: Greg Kroah-Hartman; linux-kernel@vger.kernel.org; David Dajun Chen
> Subject: Re: [RFC V1] drivers/base/regmap: Implementation for
> regmap_multi_reg_write
> On Thu, Feb 27, 2014 at 11:28:56AM +0000, Opensource [Anthony Olech]
> wrote:
> > This is the implementation of regmap_multi_reg_write()
> > It replaces the first definition, which just defined the API.
> Aside from any review comments this won't apply with the recent patches
> that Charles did to provide a bypassed version of the API, it needs to be
> rebased.

I see that next-20140228 has Charles' patch applied, my next attempt
will be rebased against the latest linux-next.
 
> > a) should an async operation be allowed? easy in the case where
> >    all the changes are in the same page - but if the operation
> >    is broken due to changes over several pages not so easy.
> It's fine to support only the simple cases, async operation is just an
> optimisation so we can always just serialise in cases where it gets
> complicated and someone can optimise later if they care.  It'd be fine to just
> decay to a series of regmap_reg_write()s if there's paging involved.

The algorithm for splitting up into smaller _multi_reg_writes is easy enough,
so if the calling device driver created a set of (reg,val) pairs for a multi reg
write operation then surely the intention is for the individual pieces to be
handled as multi reg writes.
 
> > b) the user supplied set (array of struct reg_default) of changes
> >    has the register address modified when the target page alters.
> >    Would it be better not to do an in-situ change, but rather to
> >    alloc a new array of struct reg_default?
> Yes, the user should be able to pass in a const pointer (indeed Charles
> changed the API to do that).

my next attempt will match the API.

> > +++ b/drivers/base/regmap/regmap.c
> > @@ -1442,6 +1442,7 @@ int regmap_field_write(struct regmap_field
> > *field, unsigned int val)  }  EXPORT_SYMBOL_GPL(regmap_field_write);
> > +
> >  /**
> >   * regmap_field_update_bits():	Perform a read/modify/write cycle
> Random whitespace change here.

sorry about that - it slipped past my quality control!
 
> > +static int _switch_register_page(struct regmap *map, unsigned int
> win_page,
> > +					struct regmap_range_node *range) {
> > +	int ret;
> > +	bool page_chg;
> > +	void *orig_work_buf = map->work_buf;
> > +	unsigned int swp;
> > +
> > +	map->work_buf = map->selector_work_buf;
> > +
> > +	swp = win_page << range->selector_shift;
> > +	ret = _regmap_update_bits(map,
> > +				range->selector_reg,
> > +				range->selector_mask,
> > +				swp, &page_chg);
> > +
> > +	map->work_buf = orig_work_buf;
> > +
> I'd expect this to be using _regmap_select_page()?  In general there seems
> like quite a bit of duplication to handle paging.

I will try to revamp that part!

> > +	return ret;
> > +}
> > +/*
> You need a blank here.

I missed that one as well - I will do better in my next attempt!
 
> > +	buf = kzalloc(len , GFP_KERNEL);
> > +
> > +	if (!buf)
> > +		return -ENOMEM;
> Coding style - extra blank between the kzalloc and the check and an extra
> space before the comma.

it will be fixed.

> > +	/*
> > +	 * the set of registers are not neccessarily in order, but
> > +	 * since the order of write must be preserved this algorithm
> > +	 * chops the set each time the page changes
> > +	 */
> > +	for (i = 0, n = 0, switched = false, base = regs; i < num_regs;
> > +								i++, n++) {
> Don't put all this stuff in the for (), just put the iteration in the for ().

all those variables are a fundamental part of the loop, but I will change it.
 
> > +	/*
> > +	 * Some devices do not support multi write, for
> > +	 * them we have a series of single write operations.
> > +	 */
> > +	if (map->use_single_rw) {
> > +		for (i = 0; i < num_regs; i++) {
> > +			ret = _regmap_write(map, regs[i].reg, regs[i].def);
> > +			if (ret != 0)
> > +				goto out;
> > +		}
> > +	} else {
> > +		ret = _regmap_multi_reg_write(map, regs, num_regs);
> 
> I'd expect to see something that devices do to specifically advertise this
> capability, it doesn't follow that a device that a device that only supports
> single writes will support the multi write operation and frameworks may try
> to use the multi write API to help optimise things.

Yes, you are correct - I think a driver needs to pass an extra bit of
information in "struct regmap_config" to indicate that it is capable
of using the multi_req_write mode.

I will invent a new flag

many thanks Mark for your very help review and comments.

Tony Olech
Dialog Semiconductor
