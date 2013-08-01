Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab3HARHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:07:46 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:34449 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab3HARHo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:07:44 -0400
MIME-Version: 1.0
In-Reply-To: <201308011835.22186.heiko@sntech.de>
References: <201307291510.31679.heiko@sntech.de>
	<1375106520.4223.24.camel@pizza.hi.pengutronix.de>
	<CAHCPf3vSQHtRkk-_cs3monHfrF-hVx3vTDt1ctcax_bspXDmsg@mail.gmail.com>
	<201308011835.22186.heiko@sntech.de>
Date: Thu, 1 Aug 2013 12:07:43 -0500
Message-ID: <CAHCPf3vHQ0P0xL1XUt93-aLp9zbMjTcCroOORiBOmoi6uePWjw@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] misc: sram: add ability to mark sram sections as reserved
From: Matt Sealey <neko@bakuhatsu.net>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IEEE1275 (Open Firmware) specification has details on it in the MMU
(section 3.6.5), Memory (section 3.7.6) node specifications and the
glossary defines how the property should look. How you find that
document is.. up to you (I have a PDF of it I got hold of around 2004,
it used to be linked at www.openfirmware.org but I've not checked). I
think it's missed from the devicetree.org spec since it's already very
well defined and there's no reason to reinvent (or redefine) the
wheel.

Essentially it follows the same format as "reg" - phys.hi phys.lo
length - which define regions which are ACTUALLY available to the
system. The intent is that it would be used to define the memory as
going from an address for a certain size, but mark sections of it the
device tree user could use (further intent being that you would want
the OS to know that there is, for example, 4GiB of memory there and
set up any mappings to suit, but the last 256MiB is where you've put
some important data and you would rather it didn't just allocate it to
something else..).

Linux doesn't actually parse and use the information in the available
property (or care about "existing" property in an MMU node since it
replaces page tables super early and has different ideas about mapping
than most bootloaders), but other operating systems possibly do. It
would not be a significant hardship for Linux to actually parse the
property if present and use that information after a bit of sanity
checking rather than just trusting reg. And in that sense, it would
not be a significant hardship to use existing specifications to define
nodes that describe memory, since if there IS parsing code available,
it will be re-used, which is good all round.

-- 
Matt

On Thu, Aug 1, 2013 at 11:35 AM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Montag, 29. Juli 2013, 23:39:45 schrieb Matt Sealey:
>> On Mon, Jul 29, 2013 at 9:02 AM, Philipp Zabel <p.zabel@pengutronix.de>
> wrote:
>> > Hi Heiko,
>> >
>> > Am Montag, den 29.07.2013, 15:12 +0200 schrieb Heiko Stübner:
>> >> Some SoCs need parts of their sram for special purposes. So while being
>> >> part of the peripheral, it should not be part of the genpool
>> >> controlling the sram.
>> >>
>> >> Therefore add an option mmio-sram-reserved to keep arbitrary portions of
>> >> the sram from being part of the pool.
>> >>
>> >> Suggested-by: Rob Herring <robherring2@gmail.com>
>> >> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
>> >> Tested-by: Ulrich Prinz <ulrich.prinz@googlemail.com>
>> >> ---
>> >> Philipp: I didn't carry the ack, because the loop changed significantly
>> >> again. So if it looks ok, could you re-ack it please?
>> >
>> > I'd prefer the first loop to contain the magic and produce a list of
>> > useable chunks, instead of a list of reserved blocks. The second loop
>> > could then iterate over the array and just call gen_pool_add_virt
>> > repeatedly.
>> >
>> > regards
>> > Philipp
>>
>> Agreed, however specifying chunks of memory should probably match the
>> format of the standard memory@ node "available" property - mostly
>> because it would be the same syntax and definition as defining any
>> other chunk of memory, as OpenFirmware and device trees have been
>> doing since the dark ages. In this case, why not re-use the
>> "available" property name instead of creating a new one? Standard OF
>> memory parsing code is then free for you to use to pull the chunks
>> out.
>
> Sound interesting, but could you give me a pointer to some sort of docs about
> this "available" property in memory nodes?
>
> Documentation/devicetree/booting-without-of.txt seems to be the only file
> describing the memory node at all but only required properties, and not any
> "available" property.
>
> I've found a document  on power.org describing the memory node, but also not
> mentioning any "available" property.
>
> And devicetree.org does not seem to handle the memory node at all.
>
>
> Thanks for any hints
> Heiko
