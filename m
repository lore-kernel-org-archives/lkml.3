Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbaLTStw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 13:49:52 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:59022 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaLTStt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 13:49:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Sat, 20 Dec 2014 19:49:32 +0100
From: Stefan Agner <stefan@agner.ch>
To: Arnd Bergmann <arnd@arndb.de>, robh+dt@kernel.org, keescook@chromium.org
Cc: linux-arm-kernel@lists.infradead.org, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        daniel.lezcano@linaro.org, tglx@linutronix.de, mark.rutland@arm.com,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, robh@kernel.org
Subject: Re: [PATCH 11/12] ARM: dts: add support for Vybrid running on
 Cortex-M4
In-Reply-To: <2375016.nxLFC8UMcD@wuerfel>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch>
 <2615697.uVqMY8zKot@wuerfel> <44e9d518da24fb0c910de464269b8551@agner.ch>
 <2375016.nxLFC8UMcD@wuerfel>
Message-ID: <7bc0b583d64785eab13d28132af528b0@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sat Dec 20 19:48:47 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5495c48f12812304293850
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-18 23:44, Arnd Bergmann wrote:
> On Thursday 18 December 2014 21:36:31 Stefan Agner wrote:
>> On 2014-12-17 13:31, Arnd Bergmann wrote:
>> > On Wednesday 17 December 2014 00:41:33 Stefan Agner wrote:
>> >> On 2014-12-03 12:03, Arnd Bergmann wrote:
>> >> > Starting with v3.19, you should be able to use the earlycon framework on
>> >> > arm32, so it would be better to replace earlyprintk with earlycon here
>> >> > and add a stdout-path property in chosen that points to the console
>> >> > uart.
>> >>
>> >> I started to implement earlycon support, but something currently fails
>> >> when earlycon tries to map the UART registers:
>> >> [    0.000000] earlycon_map: Couldn't map 0x40027000
>> >>
>> >> I traced the issue a bit further down and found that get_vm_area_caller
>> >> returns NULL (in __arm_ioremap_pfn_caller). This happend on Linus master
>> >> as of today (2dbfca5a181973558277b28b1f4c36362291f5e0). Do I miss
>> >> something here?
>> >
>> > Hmm, I fear the arm32 FIX_EARLYCON_MEM support ended up not making it
>> > into 3.19 after all.
>>
>> Is it because early_ioremap and fixmap still missing for arm32?
>> According to Rob's patchset from spring fixmap is required, there is
>> something in this tree:
>> https://git.kernel.org/cgit/linux/kernel/git/robh/linux.git/log/?h=arm-fixmap
> 
> Right, that's the one, thanks for finding that again. There are five
> patches on that branch. The first three got merged, and the one we
> need is just the last one (ARM: fixmap early permanent mapping support),
> but the implementation depends on the previous patch (arm: add
> early_ioremap support).
> 
> I was hoping we'd see both of them in 3.19, but apparently Rob didn't
> submit the latest version. If you don't mind, could you try forward-porting
> them to the latest kernel and then submit them for inclusion? You could
> also try adapting the last patch to work without the early_ioremap
> support that we don't really need that urgently on arm32.

Looked into that a bit more in depth. I tried creating a patch which
adds just what is necessary to support FIX_EARLYCON_MEM. Fixmap seems to
be in place, just for earlycon it would need a fixmap entry with
FIX_EARLYCON_MEM_BASE. And I guess later during boot, it would need a
call to create_mapping to create a permanent mapping of it.

Currently I'm stuck in the __set_fixmap call, on set_pte_ext call the
kernel freezes. The arguments look fine as far as I can tell (vaddr
ffeff000, phys 40027000, pgprot is FIXMAP_PAGE_IO, defined as in Rob's
patchset). 

Afaik, initialization for early fixmap is missing, I guess we could do
something which looks similar to what ARM64 has now:

https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=af86e5974d3069bd26ebcf7c046c6e59726acaaa

I'm wondering what the value is of __set_fixmap without that, as is
right now? I still need to understand the whole MM stuff a bit more. I
will be away the next couple of days, but will have a look into it
towards the end of the year. But if anyone else can help make that
happen (who might be better in the picture of fixmap than I am), I'm
happy too :-)

--
Stefan

