Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaLJCJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 21:09:10 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9576 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbaLJCJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 21:09:08 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 09 Dec 2014 18:05:51 -0800
Message-ID: <5487AB39.1050706@nvidia.com>
Date: Wed, 10 Dec 2014 10:08:57 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sean Paul <seanpaul@chromium.org>
CC: Thierry Reding <thierry.reding@gmail.com>, <tbergstrom@nvidia.com>,
        "Dave Airlie" <airlied@linux.ie>,
        Stephen Warren <swarren@wwwdotorg.org>, <gnurou@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/tegra: dsi: Add suspend/resume support
References: <1418020850-7664-1-git-send-email-markz@nvidia.com> <CAOw6vbKegB8cgmqgRit+XdvYNtdEXy3Pcv5=1bYSCJv4v1F2AQ@mail.gmail.com>
In-Reply-To: <CAOw6vbKegB8cgmqgRit+XdvYNtdEXy3Pcv5=1bYSCJv4v1F2AQ@mail.gmail.com>
X-Originating-IP: [10.19.224.104]
X-ClientProxiedBy: HKMAIL102.nvidia.com (10.18.16.11) To
 HKMAIL102.nvidia.com (10.18.16.11)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 03:29 AM, Sean Paul wrote:
> On Sun, Dec 7, 2014 at 10:40 PM, Mark Zhang <markz@nvidia.com> wrote:
>> This patch adds the suspend/resume support for Tegra drm
>> driver by calling the corresponding DPMS functions.
[...]
>> +       if (dsi->slave) {
>> +               err = tegra_dsi_pad_calibrate(dsi->slave);
>> +               if (err < 0) {
>> +                       dev_err(dsi->slave->dev,
>> +                               "MIPI calibration failed: %d\n", err);
>> +                       return err;
>> +               }
>> +       }
> 
> Move this duplicate call into tegra_dsi_pad_calibrate() to be
> consistent with the other functions in this file (eg:
> tegra_dsi_set_timeout).
> 

Yeah, will do.

>> +
>>         err = tegra_dsi_get_muldiv(dsi->format, &mul, &div);
>>         if (err < 0)
>>                 return err;
>> @@ -833,6 +850,13 @@ static int tegra_output_dsi_setup_clock(struct tegra_output *output,
>>                 dev_err(dsi->dev, "failed to set parent clock: %d\n", err);
>>                 return err;
>>         }
>> +       if (dsi->slave) {
>> +               err = tegra_dsi_ganged_setup(dsi);
>> +               if (err < 0) {
>> +                       dev_err(dsi->dev, "DSI ganged setup failed: %d\n", err);
>> +                       return err;
>> +               }
>> +       }
> 
> I think this belongs in ->enable() instead of here.
> 

Actually "tegra_dsi_ganged_setup" is not needed any more. This function
ensures that DSIA & DSIB use the same PLL in ganged mode. But if you
read the Tegra124/Tegra132 TRM, you'll find there is no way to select
the clock source for DSIB. I.E, DSIB always uses the same clock source
with DSIA. Besides, PLLD is the only clock source for DSIA. I.E,
"clk_get_parent"/"clk_set_parent" doesn't make sense for dsia & dsib
clock now.

I've posted a patch(in tegra clock driver) to fix this:

http://article.gmane.org/gmane.linux.ports.tegra/20313

And the corresponding changes in dsi driver will arrive soon.

>>
>>         err = clk_set_rate(dsi->clk_parent, plld);
>>         if (err < 0) {
[...]
>> +
>> +       drm_modeset_lock_all(tegra->drm);
>> +       list_for_each_entry(connector, &tegra->drm->mode_config.connector_list,
>> +                           head) {
>> +               if (connector->funcs->dpms)
>> +                       connector->funcs->dpms(connector, connector->dpms);
>> +       }
>> +       drm_modeset_unlock_all(tegra->drm);
>> +
>> +       drm_helper_resume_force_mode(tegra->drm);
>> +
>> +       return 0;
>> +}
>> +#endif
> 
> So this is the tricky chunk, it definitely does not belong here. I
> think it makes most sense for this to live in drm.c, however
> host1x_driver doesn't have suspend/resume hooks.
> 

Agree. drm.c is the best place for putting this.

> I suspect the correct thing to do here is to add them to
> host1x_driver, but I'm not sure how much effort is involved in doing
> that.
> 

I thought about this before. If we do it in host1x driver, IIUC, it
means that when host1x starts suspending, it will suspend all host1x
client devices, right? Honestly I feel this is not a good thing despite
I can't tell what's the problem in this right now...

Mark
> Sean
> 
>> +
>> +
>>  static const struct of_device_id tegra_dsi_of_match[] = {
>>         { .compatible = "nvidia,tegra114-dsi", },
>>         { },
>> @@ -1557,4 +1636,9 @@ struct platform_driver tegra_dsi_driver = {
>>         },
>>         .probe = tegra_dsi_probe,
>>         .remove = tegra_dsi_remove,
>> +#ifdef CONFIG_PM
>> +       .suspend = tegra_dsi_suspend,
>> +       .resume = tegra_dsi_resume,
>> +#endif
>> +
>>  };
>> --
>> 1.8.1.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
