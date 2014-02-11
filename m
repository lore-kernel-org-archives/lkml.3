Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbaBKTtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:49:07 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:44617 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbaBKTtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:49:01 -0500
Message-ID: <52FA7EA0.6050509@gmail.com>
Date: Tue, 11 Feb 2014 23:48:48 +0400
From: Dmitry Osipenko <digetx@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: kusmabite@gmail.com
CC: thierry.reding@gmail.com, tbergstrom@nvidia.com, airlied@linux.ie,
        swarren@wwwdotorg.org, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drm/tegra: Add guard to avoid double disable/enable
 of RGB outputs
References: <1392138747-18198-1-git-send-email-digetx@gmail.com> <CABPQNSYNpwf_EQqUc2zpQ1cVQE++2ma-bR-rfQPdNoaJc07W4w@mail.gmail.com>
In-Reply-To: <CABPQNSYNpwf_EQqUc2zpQ1cVQE++2ma-bR-rfQPdNoaJc07W4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11.02.2014 23:13, Erik Faye-Lund пишет:
> On Tue, Feb 11, 2014 at 6:12 PM, Dmitry Osipenko <digetx@gmail.com> wrote:
>> Add guard to check whether RGB output is already enabled in the way it's
>> done for HDMI output. Fixes possible hang on trying to disable output twice
>> (first time during driver probe and second on fb registering).
>>
>> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
>> ---
>>  drivers/gpu/drm/tegra/rgb.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
>> index 338f7f6..0266fb4 100644
>> --- a/drivers/gpu/drm/tegra/rgb.c
>> +++ b/drivers/gpu/drm/tegra/rgb.c
>> @@ -15,6 +15,7 @@
>>  struct tegra_rgb {
>>         struct tegra_output output;
>>         struct tegra_dc *dc;
>> +       bool enabled;
>>
>>         struct clk *clk_parent;
>>         struct clk *clk;
>> @@ -89,6 +90,9 @@ static int tegra_output_rgb_enable(struct tegra_output *output)
>>         struct tegra_rgb *rgb = to_rgb(output);
>>         unsigned long value;
>>
>> +       if (rgb->enabled)
>> +               return 0;
>> +
>>         tegra_dc_write_regs(rgb->dc, rgb_enable, ARRAY_SIZE(rgb_enable));
>>
>>         value = DE_SELECT_ACTIVE | DE_CONTROL_NORMAL;
>> @@ -122,6 +126,8 @@ static int tegra_output_rgb_enable(struct tegra_output *output)
>>         tegra_dc_writel(rgb->dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
>>         tegra_dc_writel(rgb->dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
>>
>> +       rgb->enabled = true;
>> +
>>         return 0;
>>  }
>>
>> @@ -130,6 +136,9 @@ static int tegra_output_rgb_disable(struct tegra_output *output)
>>         struct tegra_rgb *rgb = to_rgb(output);
>>         unsigned long value;
>>
>> +       if (!rgb->enabled)
>> +               return 0;
>> +
>>         value = tegra_dc_readl(rgb->dc, DC_CMD_DISPLAY_POWER_CONTROL);
>>         value &= ~(PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
>>                    PW4_ENABLE | PM0_ENABLE | PM1_ENABLE);
>> @@ -144,6 +153,8 @@ static int tegra_output_rgb_disable(struct tegra_output *output)
>>
>>         tegra_dc_write_regs(rgb->dc, rgb_disable, ARRAY_SIZE(rgb_disable));
>>
>> +       rgb->enabled = false;
>> +
>>         return 0;
>>  }
>>
> 
> Wouldn't it make more sense to make "enabled" and int that counts how
> many times tegra_output_rgb_enable has been called? That way you can
> have tegra_output_rgb_disable only really disable the display once the
> same amount of disables have been performed...
> 
RGB is a part of DC, i.e. one per DC. tegra_output_rgb_enable() would be called
for each individual DC, so it doesn't make any sense. Besides, I doubt tegra
device with two panels ever existed or will be :)
