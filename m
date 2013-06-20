Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab3FTJAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:00:50 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:44569 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab3FTJAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:00:47 -0400
Date: Thu, 20 Jun 2013 11:00:42 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: patrice.chotard.st@gmail.com
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: Re: [PATCH 2/2] pinctrl: abx500: fix abx500_gpio_get()
Message-ID: <20130620090042.GC20594@balto.lan>
References: <1371713084-19098-1-git-send-email-patrice.chotard.st@gmail.com>
 <1371713084-19098-3-git-send-email-patrice.chotard.st@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371713084-19098-3-git-send-email-patrice.chotard.st@gmail.com>
X-Operating-System: Linux balto 3.10.0-rc6-00001-g8177a9d x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Patrice,

On Thu, Jun 20, 2013 at 09:24:44AM +0200, patrice.chotard.st@gmail.com wrote:
> From: Patrice Chotard <patrice.chotard@st.com>
> 
> _ allow to get output GPIO value.
> _ as there is no GPIO0 on ABX500, use correct offset with 
>   abx500_gpio_get_bit().
> 
> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
> ---
>  drivers/pinctrl/pinctrl-abx500.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
> index 4307b0f..070442d 100644
> --- a/drivers/pinctrl/pinctrl-abx500.c
> +++ b/drivers/pinctrl/pinctrl-abx500.c
> @@ -162,10 +162,22 @@ static int abx500_gpio_get(struct gpio_chip *chip, unsigned offset)
>  {
>  	struct abx500_pinctrl *pct = to_abx500_pinctrl(chip);
>  	bool bit;
> +	bool is_out;
> +	u8 gpio_offset = offset - 1;
>  	int ret;
>  
> -	ret = abx500_gpio_get_bit(chip, AB8500_GPIO_IN1_REG,
> -				  offset, &bit);
> +	ret = abx500_gpio_get_bit(chip, AB8500_GPIO_DIR1_REG, gpio_offset, &is_out);
> +	if (ret < 0) {
> +		dev_err(pct->dev, "%s failed\n", __func__);
> +		return ret;
> +	}
> +
> +	if (is_out)
> +		ret = abx500_gpio_get_bit(chip, AB8500_GPIO_OUT1_REG,
> +				gpio_offset, &bit);
> +	else
> +		ret = abx500_gpio_get_bit(chip, AB8500_GPIO_IN1_REG,
> +				gpio_offset, &bit);

Why would you want to read the pin state from the output register?  The
input one should be the one that reflect the real electrical value of
the pin, and I think it may be useful to detect some fault condition
too...  Is there a specific reasion to use the output register instead?

Thanks,
Fabio

>  	if (ret < 0) {
>  		dev_err(pct->dev, "%s failed\n", __func__);
>  		return ret;
> -- 
> 1.7.10
> 

-- 
Fabio Baltieri
