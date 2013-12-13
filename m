Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab3LMPHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:07:46 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:38307 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751489Ab3LMPHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:07:45 -0500
Message-ID: <52AB228D.5030003@st.com>
Date: Fri, 13 Dec 2013 15:06:53 +0000
From: Angus Clark <angus.clark@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100312 Lightning/1.0b2pre Shredder/3.0.1
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dwmw2@infradead.org>,
        <linus.walleij@linaro.org>, <linux-mtd@lists.infradead.org>,
        Angus CLARK <angus.clark@st.com>
Subject: Re: [PATCH v3 08/36] mtd: devices: Provide header for shared OPCODEs
 and SFDP commands
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org> <1385727565-25794-9-git-send-email-lee.jones@linaro.org> <20131210214849.GE27149@ld-irv-0074.broadcom.com>
In-Reply-To: <20131210214849.GE27149@ld-irv-0074.broadcom.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.49.178]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 09:48 PM, Brian Norris wrote:
> On Fri, Nov 29, 2013 at 12:18:57PM +0000, Lee Jones wrote:
>> JEDEC have helped to standardise a great deal of the commands which
>> can be issued to a Serial Flash devices. Many of the OPCODEs and all
>> of the Serial Flash Discoverable Parameters (SFDP) commands are
>> generic across devices. This patch provides a shared point where
>> these commands can be defined.

This comment isn't entirely correct.  The SFDP standard (JESD216A) does not go
as far as standardising the OPCODES, but merely a way of determining at runtime
which operations are supported (e.g. READ_1_1_4, READ_1_4_4), and the associated
opcodes; vendors are still free to use a different opcode for a particular
operation.

>> +/* JEDEC Standard - Serial Flash Discoverable Parmeters (SFDP) Commands */
>> +#define FLASH_CMD_READ		0x03	/* READ */
>> +#define FLASH_CMD_READ_FAST	0x0b	/* FAST READ */
>> +#define FLASH_CMD_READ_1_1_2	0x3b	/* DUAL OUTPUT READ */
>> +#define FLASH_CMD_READ_1_2_2	0xbb	/* DUAL I/O READ */
>> +#define FLASH_CMD_READ_1_1_4	0x6b	/* QUAD OUTPUT READ */
>> +#define FLASH_CMD_READ_1_4_4	0xeb	/* QUAD I/O READ */
> 
> All of these {1,2,4}_{1,2,4}_{1,2,4} suffixes are a little cryptic; I
> ended up referring to the SFDP spec to figure out what the first number
> meant. Can you document them briefly at the top of this SFDP list?

I think the {x,y,z} descriptions offer the simplest way of representing the
myriad of operations supported by various devices -- it was one thing SFDP did
get right.  However, I agree, the nomenclature  does need explained.  We also
need a way of representing 32-bit address commands, and SDR vs DDR commands --
this has not yet been addresses by SFDP.

> Since you list these, does SFDP even describe the 32-bit addressing
> commands? 

Not yet, but I believe "JESD216B" will include a parameter table related to
32-bit address instructions.

> It seems like it assumes the device is switched (statefully)
> between 24-bit and 32-bit address modes (or kept permanently in one or
> the other).

And the complexity increases!  The st_spi_fsm H/W also supports a memory-mapped
mode for booting.  However, the boot controller is hard-coded to issue 24-bit
address cycles.  If the Serial Flash device includes a dedicated REST pin, and
this is appropriately routed to the system reset, then we have no issue -- the
device will reset to its power-on state following a warm reset.  If a reset pin
is not available, then certain precautions can be followed to minimise problems
with warm resets.   If the Serial Flash device supports a 32-bit instruction
set, then this should be used in preference, and we can avoid any statefull
transitions.  Failing that, we can minimise the window in which a reset would
fail by issuing EN4B/EX4B before/after each operation.  Of course, if we know
the system is not subject to these constraints, then we just need to issue EN4B
at the start, and stay in 4B mode.

All this knowledge needs to be in the spi-nor layer...

