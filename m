Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3DVU6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:58:13 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:58256 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625Ab3DVU6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:58:12 -0400
Message-ID: <5175A4F5.1050304@metafoo.de>
Date: Mon, 22 Apr 2013 23:00:37 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: Jon Hunter <jon-hunter@ti.com>
CC: Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] dma: of: Remove check on always true condition
References: <1366619613-30639-1-git-send-email-lars@metafoo.de> <1366619613-30639-2-git-send-email-lars@metafoo.de> <5175A317.1010304@ti.com>
In-Reply-To: <5175A317.1010304@ti.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 10:52 PM, Jon Hunter wrote:
> 
> On 04/22/2013 03:33 AM, Lars-Peter Clausen wrote:
>> Both of_dma_nbcells field of the of_dma_controller and the args_count field of
>> the dma_spec are initialized by parsing the #dma-cells attribute of their device
>> tree node. So if the device tree nodes of a DMA controller and the dma_spec
>> match this means that of_dma_nbcells and args_count will also match. So the
>> second test in the of_dma_find_controller loop is redundant because given the
>> first test yields true the second test will also yield true. So we can safely
>> remove the test whether of_dma_nbcells matches args_count. Since this was the
>> last user of the of_dma_nbcells field we can remove it altogether.
> 
> This assumes that someone has correctly added the dma information to the
> dma slave binding. I could see systems where different dma controllers
> have different of_dma_nbcells and so someone could put the enter wrong
> number of cells for a dma slave binding. Its really to catch user error.

No, this assumes nothing. The condition will _always_ be true.

dma_spec->args_count is initialized by parsing the #dma-cells attribute of
dma_sepc->np. of_dma->of_dma_nbcells is initialized by parsing the #dma-cells
attribute of of_dma->of_node. If ofdma->of_node equals dma_spec->np then
dma_spec->args_count will also equal of_dma->of_dma_nbcells.

> 
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>> ---
>>  drivers/dma/of-dma.c   | 14 +-------------
>>  include/linux/of_dma.h |  1 -
>>  2 files changed, 1 insertion(+), 14 deletions(-)
>>
>> diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
>> index 268cc8a..75334bd 100644
>> --- a/drivers/dma/of-dma.c
>> +++ b/drivers/dma/of-dma.c
>> @@ -35,8 +35,7 @@ static struct of_dma *of_dma_find_controller(struct of_phandle_args *dma_spec)
>>  	struct of_dma *ofdma;
>>  
>>  	list_for_each_entry(ofdma, &of_dma_list, of_dma_controllers)
>> -		if ((ofdma->of_node == dma_spec->np) &&
>> -		    (ofdma->of_dma_nbcells == dma_spec->args_count))
>> +		if (ofdma->of_node == dma_spec->np)
>>  			return ofdma;
> 
> Other device-tree functions perform similar tests to this such as ...
> 

So it's redundant there as well ;)

> static int of_gpiochip_find_and_xlate(struct gpio_chip *gc, void *data)
> {
>          struct gg_data *gg_data = data;
>          int ret;
> 
>          if ((gc->of_node != gg_data->gpiospec.np) ||
>              (gc->of_gpio_n_cells != gg_data->gpiospec.args_count) ||
>              (!gc->of_xlate))
>                  return false;
> 
> ...
> 
> Cheers
> Jon

