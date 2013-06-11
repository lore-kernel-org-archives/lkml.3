Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab3FKKJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 06:09:45 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1396 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab3FKKJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 06:09:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 11 Jun 2013 03:09:42 -0700
Message-ID: <51B6F763.2080004@nvidia.com>
Date: Tue, 11 Jun 2013 13:09:39 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] memory: tegra20-mc: Fix hang in IRQ handler.
References: <1370855624-30564-1-git-send-email-ttynkkynen@nvidia.com> <1370855624-30564-2-git-send-email-ttynkkynen@nvidia.com> <20130610203641.GA26036@mithrandir>
In-Reply-To: <20130610203641.GA26036@mithrandir>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 11:36 PM, Thierry Reding wrote:
> On Mon, Jun 10, 2013 at 12:13:43PM +0300, Tuomas Tynkkynen wrote:
>> In Tegra20 memory controller any MC interrupt would cause an
>> infinite loop in the IRQ handler.
>>
>> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
>> ---
>>  drivers/memory/tegra20-mc.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/memory/tegra20-mc.c b/drivers/memory/tegra20-mc.c
>> index 2ca5f28..bd5a553 100644
>> --- a/drivers/memory/tegra20-mc.c
>> +++ b/drivers/memory/tegra20-mc.c
>> @@ -193,8 +193,11 @@ static irqreturn_t tegra20_mc_isr(int irq, void *data)
>>  	mask &= stat;
>>  	if (!mask)
>>  		return IRQ_NONE;
>> -	while ((bit = ffs(mask)) != 0)
>> +	while ((bit = ffs(mask)) != 0) {
>>  		tegra20_mc_decode(mc, bit - 1);
>> +		mask &= BIT(bit);
> 
> Shouldn't this be "mask &= ~BIT(bit);"? The intent of the code is to
> clear the bit which was handled by the loop body, right? The above
> clears all other bits instead.
> 
> Thierry

Whoops, yes it should be clearing just one bit. And since ffs() returned
a one-based bit-index, it seemed to work in practice.

I'll fix those & resend.

- Tuomas
