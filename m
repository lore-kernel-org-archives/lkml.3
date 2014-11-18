Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaKRBLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 20:11:38 -0500
Received: from regular1.263xmail.com ([211.150.99.131]:46800 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbaKRBLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 20:11:34 -0500
X-Greylist: delayed 38758 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Nov 2014 20:11:33 EST
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <f00cf1f62bb3db3f38b2163e747f6477>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <546A9CB7.1030207@rock-chips.com>
Date: Tue, 18 Nov 2014 09:11:19 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>
CC: Paul Zimmerman <paulz@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Romain Perier <romain.perier@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Douglas Anderson <dianders@chromium.org>,
        Sonny Rao <sonnyrao@chromium.org>, addy ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, wulf <wulf@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Roy Li <roy.li@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc2: resume root hub when device detect with suspend
 state
References: <1416230077-17535-1-git-send-email-kever.yang@rock-chips.com> <CAODwPW8r0cq2aozVjY9o9wOwqa4Nn1Oom9+Td8e-H0FoDf-LfQ@mail.gmail.com>
In-Reply-To: <CAODwPW8r0cq2aozVjY9o9wOwqa4Nn1Oom9+Td8e-H0FoDf-LfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julius,

On 11/18/2014 05:21 AM, Julius Werner wrote:
> On Mon, Nov 17, 2014 at 5:14 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
>> After we implement the bus_suspend/resume, auto suspend id enabled.
>> The root hub will be auto suspend if there is no device connected,
>> we need to resume the root hub when a device connect detect.
>>
>> This patch tested on rk3288.
>>
>> Signed-off-by: Roy Li <roy.li@rock-chips.com>
>> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
>> ---
>>
>>   drivers/usb/dwc2/hcd_intr.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/usb/dwc2/hcd_intr.c b/drivers/usb/dwc2/hcd_intr.c
>> index 551ba87..c8299fd 100644
>> --- a/drivers/usb/dwc2/hcd_intr.c
>> +++ b/drivers/usb/dwc2/hcd_intr.c
>> @@ -355,6 +355,13 @@ static void dwc2_port_intr(struct dwc2_hsotg *hsotg)
>>                  hprt0_modify |= HPRT0_CONNDET;
>>
>>                  /*
>> +                * Check if root hub is in suspend state
>> +                * if root hub in suspend, resume it.
>> +                */
>> +               if ((bus->root_hub) && (hcd->state == HC_STATE_SUSPENDED))
> What is bus->root_hub checking for? Is there any chance that this
> could be NULL here?
I add bus->root_hub check because the _dwc2_hcd_start check this before it
call the usb_hcd_resume_root_hub.
I think we don't need this check for the root_hub must be there if we 
register
the HCD success, right?
I will remove this in next version.
>
>> +                       usb_hcd_resume_root_hub(hcd);
>> +
>> +               /*
>>                   * The Hub driver asserts a reset when it sees port connect
>>                   * status change flag
>>                   */
>> --
>> 1.9.1
> Seems sensible in general. Does this actually fix the problem Doug was
> reporting?
Yes, this fix the problem Doug reported with my dwc2 hcd suspend/resume 
patch.

- Kever

