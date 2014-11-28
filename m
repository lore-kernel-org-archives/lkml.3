Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaK1OOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:14:11 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63459 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaK1OOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:14:09 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-58-5478832e4311
Content-transfer-encoding: 8BIT
Message-id: <1417184044.18249.39.camel@AMDC1943>
Subject: Re: [PATCH v4 4/7] regulator: Use ena_gpio supplied with generic
 regulator bindings
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 28 Nov 2014 15:14:04 +0100
In-reply-to: <20141128113859.GH7712@sirena.org.uk>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
 <1417087253-12306-5-git-send-email-k.kozlowski@samsung.com>
 <20141127184342.GC7712@sirena.org.uk> <1417170655.18249.24.camel@AMDC1943>
 <20141128113859.GH7712@sirena.org.uk>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t/xK7p6zRUhBov2qVpsnLGe1WLqwyds
	FvOPnGO16H/8mtnibNMbdov7X48yWny70sFksenxNVaLy7vmsFnMOL+PyWLtkbvsDtweO2fd
	ZffYtKqTzePOtT1sHpuX1Hv0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXxt1z71gKTotVPOtZ
	ztjA+Fywi5GTQ0LAROLqv0ZWCFtM4sK99WxdjFwcQgJLGSXm/NnAApLgFRCU+DH5HpDNwcEs
	IC9x5FI2SJhZQF1i0rxFzBD1nxkl3s36ygRSwytgINHw2gmkRlggTmLf/tvMIDabgLHE5uVL
	2EBsEQFliavf97KA9DILNDNL/HvwD+wIFgFViZV7loPZnAJGEhdf72WFWPCLUWLlhE1gCySA
	uhv73SYwCsxCct4shPNmITlvASPzKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQmPi6g3Hp
	MatDjAIcjEo8vBMsK0KEWBPLiitzDzFKcDArifCmlwCFeFMSK6tSi/Lji0pzUosPMTJxcEo1
	MKanNjCckdz3RPPIj9SEsJbzZ/n/Cd9YudTkF7eaxs2/LodnsJ4+sbZ0V8uEmcxv9r5Xm9Hm
	KiPNkL5+f41vZ66I096DWxSeFHk/bOT5UHBMr+L7zH/b4u8EhjT33Hso49m6I6St5Wajg1Dr
	pScO6zK0PaL/blOpKFN90M7f1XEg5n9xTol7kRJLcUaioRZzUXEiAE3dpeRnAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-11-28 at 11:38 +0000, Mark Brown wrote:
> On Fri, Nov 28, 2014 at 11:30:55AM +0100, Krzysztof Kozlowski wrote:
> > On czw, 2014-11-27 at 18:43 +0000, Mark Brown wrote:
> 
> > > Why do we need some special magic operation for GPIO based enables
> > > that's separate to any other enable operation?  This seems really
> > > confusing, if the constraint setting doesn't work somehow for GPIO based
> > > enables we should fix that.  Though since this operation takes no
> > > parameters it's hard to see how it's supposed to apply constraints
> > > unless it reparses them which doesn't seem like a good idea...
> 
> > The regulator driver no longer parses GPIO control from DTS. So somehow
> > it should be notified that regulator core parsed this and GPIO should be
> > enabled.
> 
> > That is the purpose of ops->set_ena_gpio() call.
> 
> This sort of thing is a sign that we're not saving much by moving the
> parsing to the core and perhaps there's more flexiblity here... 

The driver receive callbacks (or exposes other kind of interface) for
other core-generalized code. Recent example is parsing regulator mode
(added by Javier) and .of_map_mode() callback.

I thought how to do this without this additional set_ena_gpio() call.
One way would be to extend the regulator modes (FAST/IDLE/STANDBY/ and
GPIO) but this would look somehow unnatural.

> It's
> also not something that should be in the constraints handling, it's not
> something that constrains the regulator.

Got it.

> > > > +static int regulator_ena_gpio_setup(struct regulator_dev *rdev,
> > > > +			const struct regulator_config *config,
> > > > +			const struct regulator_init_data *init_data)
> 
> > > Why is setting up the GPIO different to requesting it, especially given
> > > that we have an existing function called _request() which still exists?
> 
> > Maybe the name was not a best choice. The setup calls request.
> 
> > My patchset here tried to retain the compatibility with
> > "config.ena_gpio" way so the core would accept GPIOs passed in one of
> > two ways:
> > 1. old: config.ena_gpio,
> > 2. new: parsed by core from DTS.
> 
> > The request function previously worked only on "config.ena_gpio" and I
> > changed it here to accept any GPIO. The setup uses one of GPIO methods
> > (old or new) and calls request with appropriate GPIO.
> 
> We need to support both methods since not all the world is DT.  What I
> can't tell is how this code achieves these objectives - it seems to be
> an awfully big patch if that's all it's supposed to be doing, I'd expect
> just a conditional where we try the two methods in turn.  It may be that
> there's a good reason for all this but that needs to be made clear.

OK, I'll try to better describe the reason behind and to split the
patches (if possible).

Best regards,
Krzysztof


