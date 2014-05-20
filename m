Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbaETVcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:32:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35485 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751018AbaETVcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:32:07 -0400
Message-ID: <537BC9D4.6070200@free-electrons.com>
Date: Tue, 20 May 2014 23:32:04 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robherring2@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: Re: [PATCH v3 4/9] of: mtd: add documentation for the ONFI NAND timing
 mode property
References: <1394647664-8258-1-git-send-email-b.brezillon.dev@gmail.com> <1394647664-8258-5-git-send-email-b.brezillon.dev@gmail.com> <20140520182542.GS28907@ld-irv-0074> <537BAD59.3060902@free-electrons.com> <20140520195240.GW28907@ld-irv-0074>
In-Reply-To: <20140520195240.GW28907@ld-irv-0074>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 20/05/2014 21:52, Brian Norris wrote:
> On Tue, May 20, 2014 at 09:30:33PM +0200, Boris BREZILLON wrote:
>> Hi Brian,
>>
>> On 20/05/2014 20:25, Brian Norris wrote:
>>> Hi Boris,
>>>
>>> On Wed, Mar 12, 2014 at 07:07:39PM +0100, Boris BREZILLON wrote:
>>>> Add documentation for the ONFI NAND timing mode property.
>>>>
>>>> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
>>>> ---
>>>>  Documentation/devicetree/bindings/mtd/nand.txt |    8 ++++++++
>>>>  1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/mtd/nand.txt b/Documentation/devicetree/bindings/mtd/nand.txt
>>>> index b53f92e..2046027 100644
>>>> --- a/Documentation/devicetree/bindings/mtd/nand.txt
>>>> +++ b/Documentation/devicetree/bindings/mtd/nand.txt
>>>> @@ -19,3 +19,11 @@ errors per {size} bytes".
>>>>  The interpretation of these parameters is implementation-defined, so not all
>>>>  implementations must support all possible combinations. However, implementations
>>>>  are encouraged to further specify the value(s) they support.
>>>> +
>>>> +- onfi,nand-timing-mode: an integer encoding the supported ONFI timing modes of
>>>> +  the NAND chip. Each supported mode is represented as a bit position (i.e. :
>>>> +  mode 0 and 1 => (1 << 0) | (1 << 1) = 0x3).
>>>> +  This is only used when the chip does not support the ONFI standard.
>>>> +  The last bit set represent the closest mode fulfilling the NAND chip timings.
>>>> +  For a full description of the different timing modes see this document:
>>>> +  www.onfi.org/~/media/ONFI/specs/onfi_3_1_spec.pdf
>>> I'm not 100% convinced this property should go in the device tree. With
>>> most other flash properties (device size, page size, and even minimum
>>> ECC requirements), we try to auto-detect these parameters to some
>>> extent. ONFI makes it easy for some class of chips, but for others, we
>>> typically rely on an in-kernel device ID table or ID decoding heuristic
>>> -- we don't require a DT description of every property of the flash. So
>>> what makes this property different?
>> AFAICT nothing, but the same goes for the ECC requirements, and we've
>> recently added DT bindings to define these requirements.
>> I'm not telling we should drop these ECC requirements bindings (actually
>> I'm using them :-)), but what's different with the timings requirements ?
> ECC selection is not quite as scientific; with ECC, there are external
> factors that influence the ECC mode that you should use, since any data
> read/written from Linux has to be compatible with any data read/written
> with another entity (e.g., bootloader). Note that the ECC bindings do
> not represent a property of the flash chip itself (i.e., they don't hold
> the "minimum required ECC strength"), but of the entire flash system
> (i.e., "what ECC must I use to play nicely with the rest of the world").

If the ECC bindings don't encode the "minimum required ECC strength" but
rather the "ECC config on a specific board" then I guess "minimum
required ECC strength" for non-ONFI chips should be defined somewhere
else (stored in the device ID table ?).

Actually, in the sunxi NAND controller driver, I'm using the DT defined
ECC config when the NAND does not support ONFI timings retrieval.

>
> With timing modes, this is purely a property of the flash chip, and we
> do not have to synchronize it with the bootloader. We don't exactly care
> if a bootloader and Linux use slightly different timing modes.

Agreed.


>
>> Moreover, we will end up with a lot of new entries in the device ID
>> table if we decide to put these informations in this table.
> Yes, that could be a problem.
>
> What sort of non-ONFI flash chips do you have that need this property?

I only have the Hynix one defined in my patch series.
Other people tested my driver on different boards but I don't recall
exactly which NAND they had (a samsung one IIRC).

> And what timing mode(s) do they use? Is there, for instance, a pattern
> such that all Hynix MLC of a certain generation use a particular timing
> mode?

I'll take a look.

>
>>> I realize that we may not include device ID entries for every flash that
>>> you need in the ID table (although we still are able to detect the
>>> important properties accurately, like page and block size). But would it
>>> suffice to default these flash to a lowest common timing mode, like mode
>>> 0?
>> IMHO this is not a good solution: you'll end up with lower perfomances
>> on most of the supported NAND chips and I'm not sure this is what we want.
> No, we wouldn't want to always use mode 0. But it's possible we can get
> good enough heuristics for most flash, if we can integrate timing modes
> into the current extended ID decoding. Not sure.
>
> I'm also concerned here that this kind of binding will be difficult to
> use properly. A user/developer/board-designer would have to read the
> datasheet and compare all its values to the ONFI spec to find the
> closest match, and they would have to do this for each new flash they
> use. If we can help them by autodetecting this, that would be great.
 

>
>>> If no other option works well, then I am still open to describing the
>>> supported timing modes in the DT.
>>>
>>> BTW, this bitfield property looks kinda strange to me. Do non-ONFI flash
>>> typically support multiple timing modes? And if so, how are we supposed
>>> to *change* modes? AFAIK, ONFI provides the only standard for
>>> configuring the flash's timing mode. So maybe you're really only wanting
>>> a "default timing mode" property that is a single integer, not a
>>> bitfield.
>> Indeed, I based it on the ONFI NAND timings mode model, but AFAIK (tell
>> me if I'm wrong), it should work because most of the timings are min
>> requirements.
>> This means, even if you provide slower signals transitions, the NAND
>> will work as expected.
> So you're saying that even though the chip actually specifies a single
> set of timings, you would describe this as a bitmask of several
> supported ONFI timing modes, up to the "max performance"?
>
> Is there ever a case where (for instance) a non-ONFI flash supports the
> equivalent of timing mode 3, but it does not support mode 2 or 1?

I don't think so.

>> But I can modify the bindings to just encode the maximum supported
>> timing mode.
> AIUI, the non-ONFI datasheets really only specify a single timing mode,
> so I think we should only specify the "max." And as a bonus, this
> actually makes the binding easier to use. A driver does not care about
> how many different modes are supported; it only needs to know what the
> max is.

Agreed, actually my first binding was defining it this way.

>
> Brian

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

