Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab3JUMiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 08:38:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43993 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab3JUMiK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 08:38:10 -0400
Message-ID: <52652042.4090200@arm.com>
Date: Mon, 21 Oct 2013 13:38:26 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: Re: [PATCH] of: fix iteration bug over CPU reg properties
References: <1380904802-10432-1-git-send-email-grant.likely@linaro.org>
In-Reply-To: <1380904802-10432-1-git-send-email-grant.likely@linaro.org>
X-OriginalArrivalTime: 21 Oct 2013 12:38:05.0883 (UTC) FILETIME=[63E7B0B0:01CECE5A]
X-MC-Unique: 113102113380806501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 04/10/13 17:40, Grant Likely wrote:
> The size of each hwid in a cpu nodes 'reg' property is defined by the
> parents #address-cells property in the normal way. The cpu parsing code
> has a bug where it will overrun the end of the property if
> address-cells is greater than one. This commit fixes the problem by
> adjusting the array size by the number of address cells. It also makes
> sure address-cells isn't zero for that would cause an infinite loop.
> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> I discovered this during code inspection. I don't think it is an actual
> bug seen in the wild, but the code does look wrong. I'd appreciate
> someone take a look and confirm that I've read the code right.
> 

Thanks for finding and fixing the bug.
I have tested this on ARM64 with 2 cell reg value using [1].

Tested-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Regards,
Sudeep

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/206401.html

>  drivers/of/base.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index e4c9945..470b871 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -263,11 +263,11 @@ static bool __of_find_n_match_cpu_property(struct device_node *cpun,
>  	int ac, prop_len, tid;
>  	u64 hwid;
>  
> -	ac = of_n_addr_cells(cpun);
> +	ac = of_n_addr_cells(cpun) ? : OF_ROOT_NODE_ADDR_CELLS_DEFAULT;
>  	cell = of_get_property(cpun, prop_name, &prop_len);
>  	if (!cell)
>  		return false;
> -	prop_len /= sizeof(*cell);
> +	prop_len /= sizeof(*cell) * ac;
>  	for (tid = 0; tid < prop_len; tid++) {
>  		hwid = of_read_number(cell, ac);
>  		if (arch_match_cpu_phys_id(cpu, hwid)) {
> 


