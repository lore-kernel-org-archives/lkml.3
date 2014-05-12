Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbaELL7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 07:59:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbaELL7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 07:59:54 -0400
Message-ID: <5370B78A.7060709@redhat.com>
Date: Mon, 12 May 2014 13:59:06 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>, linux-sunxi <linux-sunxi@googlegroups.com>
CC: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Boris Brezillon <boris@free-electrons.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-usb <linux-usb@vger.kernel.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, Shuge <shuge@allwinnertech.com>,
        zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [linux-sunxi] [PATCH v2 3/7] phy: usb: sunxi: Introduce Allwinner
 A31 USB PHY support
References: <1399726619-30150-1-git-send-email-maxime.ripard@free-electrons.com> <1399726619-30150-4-git-send-email-maxime.ripard@free-electrons.com> <CAGb2v65Pstk6MqEeK838VUpNXw2cQH8K66Oo4oG3__zzWO3pig@mail.gmail.com>
In-Reply-To: <CAGb2v65Pstk6MqEeK838VUpNXw2cQH8K66Oo4oG3__zzWO3pig@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/12/2014 11:14 AM, Chen-Yu Tsai wrote:
> Hi,
> 
> On Sat, May 10, 2014 at 8:56 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
>> The USB phy controller in the A31 differs mostly from the older controllers
>> because it has a clock dedicated for each phy, while the older ones were having
>> a single clock for all the phys.
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>  drivers/phy/phy-sun4i-usb.c | 35 ++++++++++++++++++++++++++---------
>>  1 file changed, 26 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
>> index e6e6c4ba7145..8bd89430d945 100644
>> --- a/drivers/phy/phy-sun4i-usb.c
>> +++ b/drivers/phy/phy-sun4i-usb.c
>> @@ -61,7 +61,6 @@
>>  #define MAX_PHYS                       3
>>
>>  struct sun4i_usb_phy_data {
>> -       struct clk *clk;
>>         void __iomem *base;
>>         struct mutex mutex;
>>         int num_phys;
>> @@ -71,6 +70,7 @@ struct sun4i_usb_phy_data {
>>                 void __iomem *pmu;
>>                 struct regulator *vbus;
>>                 struct reset_control *reset;
>> +               struct clk *clk;
>>                 int index;
>>         } phys[MAX_PHYS];
>>  };
>> @@ -146,13 +146,13 @@ static int sun4i_usb_phy_init(struct phy *_phy)
>>         struct sun4i_usb_phy_data *data = to_sun4i_usb_phy_data(phy);
>>         int ret;
>>
>> -       ret = clk_prepare_enable(data->clk);
>> +       ret = clk_prepare_enable(phy->clk);
>>         if (ret)
>>                 return ret;
>>
>>         ret = reset_control_deassert(phy->reset);
>>         if (ret) {
>> -               clk_disable_unprepare(data->clk);
>> +               clk_disable_unprepare(phy->clk);
>>                 return ret;
>>         }
>>
>> @@ -170,11 +170,10 @@ static int sun4i_usb_phy_init(struct phy *_phy)
>>  static int sun4i_usb_phy_exit(struct phy *_phy)
>>  {
>>         struct sun4i_usb_phy *phy = phy_get_drvdata(_phy);
>> -       struct sun4i_usb_phy_data *data = to_sun4i_usb_phy_data(phy);
>>
>>         sun4i_usb_phy_passby(phy, 0);
>>         reset_control_assert(phy->reset);
>> -       clk_disable_unprepare(data->clk);
>> +       clk_disable_unprepare(phy->clk);
>>
>>         return 0;
>>  }
>> @@ -228,8 +227,10 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
>>         struct phy_provider *phy_provider;
>>         struct reset_control *reset;
>>         struct regulator *vbus;
>> +       bool dedicated_clocks;
> 
> No default?
> 
>>         struct resource *res;
>>         struct phy *phy;
>> +       struct clk *clk;
>>         char name[16];
>>         int i;
>>
>> @@ -249,15 +250,20 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
>>         else
>>                 data->disc_thresh = 2;
>>
>> +       if (of_device_is_compatible(np, "allwinner,sun6i-a31-usb-phy"))
>> +               dedicated_clocks = true;
>> +
> 
> dedicated_clocks is more than likely to be true from leftover data
> on the stack. This results in the usb phy driver probe failing, and
> the usb host drivers left in perpetual probe deferral on my Cubietruck.
> 
> Adding an else section fixes this.

Good catch, fixed this in the sunxi-devel branch for now (until Maxime sends a new version).

Regards,

Hans
