Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab3K1JbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 04:31:10 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:41819 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200Ab3K1JbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 04:31:05 -0500
Message-ID: <529707C3.40208@st.com>
Date: Thu, 28 Nov 2013 09:07:15 +0000
From: Angus Clark <angus.clark@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100312 Lightning/1.0b2pre Shredder/3.0.1
MIME-Version: 1.0
To: Huang Shijie <b32955@freescale.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <dwmw2@infradead.org>, <linux-mtd@lists.infradead.org>,
        <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>,
        <linux-spi@vger.kernel.org>
Subject: Re: [PATCH 00/23] mtd: st_spi_fsm: Add new device
References: <1385137380-28968-1-git-send-email-lee.jones@linaro.org> <20131127040723.GZ9468@ld-irv-0074.broadcom.com> <20131127115226.GC3296@lee--X1> <5296B9C5.3060704@freescale.com>
In-Reply-To: <5296B9C5.3060704@freescale.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.65.49.178]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang Shijie,

On 11/28/2013 03:34 AM, Huang Shijie wrote:
> 于 2013年11月27日 19:52, Lee Jones 写道:
>> However, as we send entire 'message sequences' to the FSM Controller
>> as opposed to merely OPCODEs we would have to extract the OPCODE from
>> flash->command[0] and call our own functions to craft the correct
>> 'message sequence' for the task. For this reason we rejected the idea
>> and went with a stand-alone driver.
>>
> could you send me the datasheet of your spi nor controller?
> I can change my code if it really not good enough.

I will reply to the "mtd: spi-nor" thread regarding the proposed framework, but
a couple of answers to your specific questions below.

> 
> we can store the opcode to a field, such as spi_nor_write_op.
>> The framework which Huang is proposing suffers from the same issues.
>> Only providing read(), write(), read_reg() and write_reg() doesn't
>> work for our use-case, as we'd have to decode the flash->command[0] and
>> invoke our own internal routines as before.
>>
>> The only framework with would work for us would consist almost all
>> of the important functions such as; read(), write(), erase(),
>> wait_busy(), read_jedec(), read_status_reg(), write_status_reg(),
>> read_control_reg(), write_control_reg(), etc. However, this approach
>>   
> read_jedec() can be replaced by read_reg(0x9f);
> 
> read_status() can be replaced by read_reg(0x5);
> 
> ....
> 
> write_control_reg() can be replaced by write_reg(xx).

Unfortunately the H/W Controller in question comes with a few restrictions.  One
restriction is that data must be read in multiples of 4 bytes.  As such, it
would not be able to honour a call of "flash->read_reg(flash, OPCODE_RDID, id, 5);"

Of course, if the H/W driver knows that we are issuing a read_jedec() operation,
then it can make the assumption that over-reading is benign, and we can instead
read 8 bytes of data from the Flash device, and return 5 to the caller.
However, without knowing what operation is being requested, no such assumption
can be made.

> Please correct me if i am wrong.
> 
> IMHO, the current four hooks for spi-nor{} can do all the things.
> 
>      read/write/read_reg/write_reg.

As it stands, the spi-nor framework cannot support the requirements of the
st_spi_fsm controller.  I will go into further details on the "mtd: spi-nor" thread.

Cheers,

Angus


-- 
-------------------------------------
Angus Clark
ST Microelectronics (R&D) Ltd.
1000 Aztec West, Bristol, BS32 4SQ
email: angus.clark@st.com
tel: +44 (0) 1454 462389
st-tina: 065 2389
-------------------------------------
