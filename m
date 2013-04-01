Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237Ab3DAS7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:59:52 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:50574 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758783Ab3DAS7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:59:51 -0400
Message-ID: <5159D92B.9020401@prisktech.co.nz>
Date: Tue, 02 Apr 2013 07:59:55 +1300
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com, arnd@arndb.de,
        olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 3/6] pinctrl: gpio: vt8500: Add pincontrol driver for
 arch-vt8500
References: <1364451049-2981-1-git-send-email-linux@prisktech.co.nz> <1364451049-2981-4-git-send-email-linux@prisktech.co.nz> <5159BE78.5020905@wwwdotorg.org>
In-Reply-To: <5159BE78.5020905@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/13 06:06, Stephen Warren wrote:
> On 03/28/2013 12:10 AM, Tony Prisk wrote:
>> This patch adds support for the GPIO/pinmux controller found on the VIA
>> VT8500 and Wondermedia WM8xxx-series SoCs.
>>
>> Each pin within the controller is capable of operating as a GPIO or as
>> an alternate function. The pins are numbered according to their control
>> bank/bit so that if new pins are added, the existing numbering is maintained.
>>
>> All currently supported SoCs are included: VT8500, WM8505, WM8650, WM8750 and
>> WM8850.
>> diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
>> +static int wmt_pctl_dt_node_to_map_pull(struct wmt_pinctrl_data *data,
>> +					struct device_node *np,
>> +					u32 pin, u32 pull,
>> +					struct pinctrl_map **maps)
>> +	configs[0] = 0;
> I assume that should be
>
> 	configs[0] = pull;
Err, yeah. Oops.
>> +static int wmt_pctl_dt_node_to_map(struct pinctrl_dev *pctldev,
>> +				   struct device_node *np,
>> +				   struct pinctrl_map **map,
>> +				   unsigned *num_maps)
>> +fail:
>> +	kfree(maps);
>> +	return err;
>> +}
> There, I think you also want to iterate over maps[] and free
> map->data.configs.config for any PIN_MAP_TYPE_CONFIGS_PIN.
>
> Perhaps just call wmt_pctl_dt_free_map() here, with roughly nmaps =
> cur_map - maps?
I have dropped the kfree() and used devm_kzalloc instead. Makes the fail 
path tidier as well.
>> +static int wmt_gpio_of_xlate(struct gpio_chip *gc,
>> +				const struct of_phandle_args *gpiospec,
>> +				u32 *flags)
>> +{
>> +	if (flags)
>> +		*flags = gpiospec->args[1];
>> +
>> +	return gpiospec->args[0];
>> +}
> Can't you use of_gpio_simple_xlate(), and hence just not set .of_xlate in:
I have dropped this - as you pointed out, ..simple_xlate() is an 
equivalent.
>
>> +static struct gpio_chip wmt_gpio_chip = {
> ...
>> +	.of_xlate = wmt_gpio_of_xlate,
> Aside from that, this patch,
>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
>
> Although I didn't review pinctrl-*.c other than pinctrl-wmt.c, since
> they're just big tables of data. Oh, except that the following could
> probably be moved inside wmt_pinctrl_probe()?
>
>> +	struct wmt_pinctrl_data *data;
>> +	struct resource *res;
>> +
>> +	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
>> +	if (!data) {
>> +		dev_err(&pdev->dev, "failed to allocate data\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	data->base = devm_request_and_ioremap(&pdev->dev, res);
>> +	if (!data->base) {
>> +		dev_err(&pdev->dev, "failed to map memory resource\n");
>> +		return -EBUSY;
>> +	}
I have moved the resource-related portion of this code to the common 
init. The data part needs to be here to assign the per-soc variables to.

Thanks for the review.
Regards
Tony P
