Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968311Ab3HISpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:45:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49093 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968272Ab3HISpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:45:13 -0400
Message-ID: <520538B7.8050306@codeaurora.org>
Date: Fri, 09 Aug 2013 11:45:11 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>, srinivas.kandagatla@st.com,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <15e19315-ce88-4d3c-bad9-0a37d9e52f6b@CO1EHSMHS007.ehs.local> <51F99747.4060901@linaro.org> <a48f159a-e88c-42fa-b76b-662302d3a585@AM1EHSMHS003.ehs.local> <51FA9AE8.1060004@linaro.org> <1c83c081-60c6-49e3-a85c-f64dd5be0e60@CH1EHSMHS030.ehs.local> <51FA9F54.3060704@linaro.org> <c44e700d-64da-487b-a975-1263d7505371@CH1EHSMHS043.ehs.local> <5204C54A.9020105@st.com> <5204FA5D.3060908@linaro.org> <20130809172757.GD14845@codeaurora.org> <3a4049f6-aad6-4730-86e3-210afbc3836b@DB9EHSMHS028.ehs.local>
In-Reply-To: <3a4049f6-aad6-4730-86e3-210afbc3836b@DB9EHSMHS028.ehs.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/13 10:48, Sören Brinkmann wrote:
> On Fri, Aug 09, 2013 at 10:27:57AM -0700, Stephen Boyd wrote:
>> On 08/09, Daniel Lezcano wrote:
>>> yes, but at least the broadcast mechanism should send an IPI to cpu0 to
>>> wake it up, no ? As Stephen stated this kind of configuration should has
>>> never been tested before so the tick broadcast code is not handling this
>>> case properly IMHO.
>>>
>> If you have a per-cpu tick device that isn't suffering from
>> FEAT_C3_STOP why wouldn't you use that for the tick versus a
>> per-cpu tick device that has FEAT_C3_STOP? It sounds like there
>> is a bug in the preference logic or you should boost the rating
>> of the arm global timer above the twd. Does this patch help? It
>> should make the arm global timer the tick device and whatever the
>> cadence timer you have into the broadcast device.
> I'm not sure I'm getting this right. But neither the cadence_ttc nor the
> arm_global_timer have the FEAT_C3_STOP flag set. So, shouldn't they be
> treated equally even with your change?

The cadence_ttc is a global clockevent, i.e. the irq can interrupt any
CPU, and it has a rating of 200. The arm global timer is a per-cpu
clockevent with a rating of 300. The TWD is a per-cpu clockevent with a
rating of 350. Because the arm global timer is rated higher than the
cadence_ttc but less than the TWD the arm global timer will fill in the
broadcast spot and the TWD will fill in the tick position. We really
want the arm global timer to fill in the tick position and the
cadence_ttc to fill in the broadcast spot (although the cadence_ttc
should never be needed because the arm global timer doesn't need help in
deep idle states).

Unless I got lost in all the combinations of tests you've done so far?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

