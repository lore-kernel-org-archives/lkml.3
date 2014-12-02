Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbaLBHur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:50:47 -0500
Received: from regular1.263xmail.com ([211.150.99.137]:59321 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbaLBHun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:50:43 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <f6868829d0c25d700fd224f45e2b81e3>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547D6F36.50103@rock-chips.com>
Date: Tue, 02 Dec 2014 15:50:14 +0800
From: addy ke <addy.ke@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: dianders@chromium.org
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, tgih.jun@samsung.com, jh80.chung@samsung.com,
        chris@printf.net, ulf.hansson@linaro.org, dinguyen@altera.com,
        heiko@sntech.de, olof@lixom.net, sonnyrao@chromium.org,
        amstan@chromium.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, lintao@rock-chips.com, chenfen@rock-chips.com,
        zyf@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, hj@rock-chips.com,
        kever.yang@rock-chips.com, zhangqing@rock-chips.com, hl@rock-chips.com
Subject: Re: [PATCH v2] mmc: dw_mmc: add quirk for broken data transfer over
 scheme
References: <1415970338-2637-1-git-send-email-addy.ke@rock-chips.com>	<1416903008-4160-1-git-send-email-addy.ke@rock-chips.com> <CAD=FV=UmG1okxJ5JV-1cuRRQJi7EEPXc7Q90sWjfMWBqb7VSMw@mail.gmail.com>
In-Reply-To: <CAD=FV=UmG1okxJ5JV-1cuRRQJi7EEPXc7Q90sWjfMWBqb7VSMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On 2014/11/27 06:46, Doug Anderson wrote:
> Hi,
> 
> On Tue, Nov 25, 2014 at 12:10 AM, Addy Ke <addy.ke@rock-chips.com> wrote:
>> This patch add a new quirk to add a s/w timer to notify the driver
>> to terminate current transfer and report a data timeout to the core,
>> if DTO interrupt does NOT come within the given time.
>>
>> dw_mmc call mmc_request_done func to finish transfer depends on
>> DTO interrupt. If DTO interrupt does not come in sending data state,
>> the current transfer will be blocked.
>>
>> But this case really exists, when driver reads tuning data from
>> card on RK3288-pink2 board. I measured waveforms by oscilloscope
>> and found that card clock was always on and data lines were always
>> holded high level in sending data state.
>>
>> We got the reply from synopsys:
>> There are two counters but both use the same value of [31:8] bits.
>> Data timeout counter doesn't wait for stop clock and you should get
>> DRTO even when the clock is not stopped.
>> Host Starvation timeout counter is triggered with stop clock condition.
>>
>> This means that host should get DRTO and DTO interrupt.
>>
>> But we really don't get any data-related interrupt in RK3X SoCs.
>> And driver can't get data transfer state, it can do nothing but wait for.
> 
> Have you asked someone on your IC team to confirm this is an SoC
> errata on your SoC?  ...or is there something else we could be doing
> wrong (overclocking?  jitter in the clock?  bad dividers?) that could
> be causing this problem?
> 
> 
>>  #ifdef CONFIG_OF
>>  static struct dw_mci_of_quirks {
>>         char *quirk;
>> @@ -2513,6 +2549,9 @@ static struct dw_mci_of_quirks {
>>         }, {
>>                 .quirk  = "disable-wp",
>>                 .id     = DW_MCI_QUIRK_NO_WRITE_PROTECT,
>> +       }, {
>> +               .quirk  = "broken-dto",
>> +               .id     = DW_MCI_QUIRK_BROKEN_DTO,
> 
> You're adding a device tree property without any binding.  If you need
> to add this please send a patch before this one modifying the device
> tree bindings.
> 
> ...but that brings up the question: do you _really_ need to add a
> property?  You already know that all rk3288 SoCs need this and you
> already know that you're an rk3288 SoC.  Just add this quirk in the
> rk3288 code always and be done with it.  ...and if this is also needed
> on other Rockchip parts, add it there too.
> 
> -Doug

We don't know why we have this problem,
but this problem is really exist, and we need patch to fix this problem now.
I will post a follow up change when we find the root cause.

And there is a little probability of this problem on RK SoC, such as RK3188, RK3066,
when worse card inserted in.
Maybe the other SoCs have the similar problem.

So I will add this quirk in rockchip code(dw_mmc-rockchip.c) as follows:
static int dw_mci_rockchip_parse_dt(struct dw_mci *host)
{
	host->quirk |= DW_MCI_QUIRK_BROKEN_DTO;

	return 0;
}

......
	.parse_dt = dw_mci_rockchip_parse_dt,
......

is right?

> 
> 
> 

