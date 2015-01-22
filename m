Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbbAVH4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:56:08 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:47913 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbbAVHz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:55:57 -0500
MIME-Version: 1.0
In-Reply-To: <20150122074001.GB427@ulmo>
References: <1421756555-20266-1-git-send-email-digetx@gmail.com> <20150122074001.GB427@ulmo>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 22 Jan 2015 16:55:36 +0900
Message-ID: <CAAVeFuJHST9VOWXe_cZNvLmfGdamuU4HSgdZC6EoQvrsGFt+Fg@mail.gmail.com>
Subject: Re: [PATCH 1/2] i2c: tegra: Maintain CPU endianness
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Dmitry Osipenko <digetx@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Bob Mottram <bob.mottram@codethink.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 4:40 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Tue, Jan 20, 2015 at 03:22:25PM +0300, Dmitry Osipenko wrote:
>> Support CPU BE mode by adding endianness conversion for memcpy interactions.
>>
>> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
>> ---
>>  drivers/i2c/busses/i2c-tegra.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
>> index 28b87e6..e0d3ef1 100644
>> --- a/drivers/i2c/busses/i2c-tegra.c
>> +++ b/drivers/i2c/busses/i2c-tegra.c
>> @@ -286,6 +286,7 @@ static int tegra_i2c_empty_rx_fifo(struct tegra_i2c_dev *i2c_dev)
>>       if (rx_fifo_avail > 0 && buf_remaining > 0) {
>>               BUG_ON(buf_remaining > 3);
>>               val = i2c_readl(i2c_dev, I2C_RX_FIFO);
>> +             val = cpu_to_le32(val);
>
> Should this not technically be le32_to_cpu() since the data originates
> from the I2C controller?
>
>>               memcpy(buf, &val, buf_remaining);
>>               buf_remaining = 0;
>>               rx_fifo_avail--;
>> @@ -343,7 +344,9 @@ static int tegra_i2c_fill_tx_fifo(struct tegra_i2c_dev *i2c_dev)
>>        */
>>       if (tx_fifo_avail > 0 && buf_remaining > 0) {
>>               BUG_ON(buf_remaining > 3);
>> +             val = 0;
>
> Why does this have to be initialized to 0 now?

I suspect this is because we are going to memcpy less than 4 bytes
into it, but I cannot figure out how that memcpy if guaranteed to
produce the expected result for both endiannesses.
