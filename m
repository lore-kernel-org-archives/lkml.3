Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab3IWWYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:24:17 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:40068 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab3IWWYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:24:15 -0400
MIME-Version: 1.0
In-Reply-To: <5240AF20.8030301@wwwdotorg.org>
References: <1379528245-6283-1-git-send-email-rklein@nvidia.com>
	<52408DC8.3020407@wwwdotorg.org>
	<52409B1E.3030405@nvidia.com>
	<52409D63.3020909@wwwdotorg.org>
	<5240AC3A.9060206@nvidia.com>
	<5240AF20.8030301@wwwdotorg.org>
Date: Mon, 23 Sep 2013 16:24:14 -0600
X-Google-Sender-Auth: 8zo0Vm1cyKYvxjvpF5iwiiW1R0E
Message-ID: <CAPnjgZ3GB8q=CMREX6YF_TR-FD6kRTZwWpJTuNQRA2JNmGWRMQ@mail.gmail.com>
Subject: Re: [RESEND] spi/tegra114: Correct support for cs_change
From: Simon Glass <sjg@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Rhyland Klein <rklein@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[trying again]

Hi,

On Mon, Sep 23, 2013 at 3:14 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 09/23/2013 03:01 PM, Rhyland Klein wrote:
>> On 9/23/2013 3:58 PM, Stephen Warren wrote:
>>> On 09/23/2013 01:48 PM, Rhyland Klein wrote:
>>>> On 9/23/2013 2:51 PM, Stephen Warren wrote:
>>>>> On 09/18/2013 12:17 PM, Rhyland Klein wrote:
>>>>>> The tegra114 driver wasn't currently handling the cs_change functionality.
>>>>>> It is meant to invert normal behavior, and we were only using it to possibly
>>>>>> delay at the end of a transfer.
>>> ...
>>>>>> diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
>>> ...
>>>>>> @@ -717,7 +718,12 @@ static int tegra_spi_start_transfer_one(struct spi_device *spi,
>>>>>>           else if (req_mode == SPI_MODE_3)
>>>>>>                   command1 |= SPI_CONTROL_MODE_3;
>>>>>>
>>>>>> -         tegra_spi_writel(tspi, command1, SPI_COMMAND1);
>>>>>> +         if (tspi->cs_control) {
>>>>>> +                 if (tspi->cs_control != spi)
>>>>>> +                         tegra_spi_writel(tspi, command1, SPI_COMMAND1);
>>>>>
>>>>> Do you really need a separate write call there? The value of command1
>>>>> isn't fully set up there (the CS bits are all set up immediately after),
>>>>> so won't that glitch the CS lines in some cases?
>>>>
>>>> On our hardware (as far as I've seen), the CS line is normally low. We
>>>
>>> I assume you meant "normally *active* low", not "normally low"?
>>
>> I mean that when I look at CS, before a transaction starts, the line is
>> low. Then we do a write like this (default SPI_COMMAND1) you see CS rise
>> and fall very soon after. This is purely how we generate the edge
>> triggers (as far as I can tell on all Tegra hw, though Laxman can
>> correct me if I am wrong).
>
> That sounds broken. Normally, shouldn't CS assert before a transaction,
> stay asserted during a transaction, then deassert after the transaction?
> It shouldn't rise and fall very quickly in between parts of the transaction.
>
>>>> need to generate a falling-edge to trigger the beginning of a SPI
>>>> transaction. Doing this write with the default value of SPI_COMMAND1
>>>> causes a brief rise and fall of CS, giving us our falling-edge.
>>>
>>> That sounds like exactly the glitch I was talking about.
>>>
>>> Assuming CS isn't held constantly asserted (low), isn't CS de-asserted
>>> (rises) at the end of transaction n-1, and re-asserted (falls) at the
>>> start of transaction n? If so, I'm not sure why the setup for
>>> transaction n needs to both de-assert and then re-assert it? It seems
>>> like cs_control should be handled at the end of a transaction, not at
>>> the start of the next one.
>>
>> cs_change has to maintain state over spi_message boundries, not just
>> between spi_transfers within a spi_message.
>>
>> In this specific case, this is a safe guard.
>>
>>>>>> +         if (tspi->cs_control) {
>> This sees that the previous transfer stored its spi_device pointer,
>> meaning it had cs_change set on the last part of the last spi_message
>> (I.E. CS hasn't been deasserted, so the SPI transaction is still on-going).
>>
>>>>>> +                 if (tspi->cs_control != spi)
>> This however finds that the device trying to send a SPI message isn't
>> the same one that was in the middle of its transaction. This is a
>> collision between 2 clients on 1 bus. This simply ends the previous
>> transaction (the ongoing one) in favor of starting a new transaction.
>>
>> Otherwise, this logic allows us to skip the spi of COMMAND1 which would
>> normally be used to create the falling edge to start a new transaction,
>> leaving the previous one open for more transfers.
>
> This sounds like something the SPI core should be managing. If a driver
> is using the SPI bus to communicate with a device in a way that needs CS
> left active while outside a transaction, it shouldn't be possible for
> another driver to come along and communicate with another device before
> the first transaction is all complete. The bus should be locked.
> Allowing anything else could corrupt the protocol that required specific
> CS states outside the transaction.

Perhaps the client driver should use spi_sync_locked() instead if it
wants to avoid this problem? To me this driver code seems reasonable
in the circumstances.

Note: at present the Chrome OS EC driver does not support sharing a
SPI bus with anything else, and neither does the EC.

Regards,
Simon
