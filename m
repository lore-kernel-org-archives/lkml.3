Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab3JCUPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:15:10 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:37487 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab3JCUPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:15:08 -0400
Message-ID: <524DD032.4060308@gmail.com>
Date: Thu, 03 Oct 2013 22:14:42 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ARM: kirkwood: retain MAC address for DT ethernet
References: <1380804294-13726-1-git-send-email-sebastian.hesselbarth@gmail.com> <1380826568-18587-1-git-send-email-sebastian.hesselbarth@gmail.com> <20131003190201.GA2504@localhost> <20131003190437.GY31178@titan.lakedaemon.net> <20131003194449.GB30298@obsidianresearch.com>
In-Reply-To: <20131003194449.GB30298@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 09:44 PM, Jason Gunthorpe wrote:
> On Thu, Oct 03, 2013 at 03:04:37PM -0400, Jason Cooper wrote:
>
>>> I'm wondering: is the clock really disabled if the device is not
>>> available (i.e. status == 'ok')? In other words: isn't the
>>> !of_device_is_available() test enough?
>>
>> Well, this stemmed from JasonG's scenario where the second iface is
>> shut off by the bootloader.  Although one could argue that the
>> bootloader should then update the dtb to mark that node as disabled...
>
> Right, that is what we do here, only the first eth is present in the
> dt, the second is gated and powered down (noting that Linux doesn't
> know how to power it up :()
>
> This check is only to prevent CPU lockup if the firmware has included
> a DT node for ethernet, not included the MAC address and turned off
> the clock.
>
> Sebastian, does __clk_enabled work properly for the mvebu clock
> provider? I don't see a clk_ops.is_enabled for mvebu.. (don't know
> much about clk)

(joint answer for all three above)

A node with status != "okay" means "hardware/board does not allow you
to use that port at all, i.e. no ethernet jack"; disabling the clock
just means "I don't expect _all_ users want to use this jack, but it
is connected". So there _is_ a difference here.

clk-gate, which is the underlying clk provider for our gates, does
provide .is_enabled and reads the register. I haven't tested this,
due to no KW hardware available right now, but it should test for
disabled clocks as expected.

> Also, I think you should move the pr_err above the clock test, or make
> a special pr_err for the clock test as well. Having the clock gated,
> no mac address and a dt node is still a fw bug.

Well, we have 4 cases here:
- status != "okay": skip
- of_get_mac_address() != NULL: skip (no registers read)
- !__clk_is_enabled(): skip and warn with FW_BUG about disabled
   clocks but no valid MAC address set.
- else, read registers, store MAC in DT, warn with FW_BUG about
   enabled clocks and no valid MAC address set.

Leaves missing public clk_is_enabled(), which I can provide a
patch for if Mike agrees (and I haven't missed anything without
really looking into CCF).

Sebastian

