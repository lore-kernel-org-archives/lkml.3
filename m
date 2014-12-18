Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaLRCmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 21:42:22 -0500
Received: from mail-bn1bn0106.outbound.protection.outlook.com ([157.56.110.106]:36366
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751518AbaLRCmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 21:42:21 -0500
Message-ID: <54924009.8040207@freescale.com>
Date: Thu, 18 Dec 2014 10:46:33 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Thierry Reding <thierry.reding@gmail.com>,
        <dri-devel@lists.freedesktop.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <p.zabel@pengutronix.de>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <mturquette@linaro.org>, <airlied@linux.ie>
Subject: Re: [PATCH RFC 09/15] drm: imx: Add MIPI DSI host controller driver
References: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
 <1418200648-32656-10-git-send-email-Ying.Liu@freescale.com>
 <20141210131640.GD23558@ulmo.nvidia.com> <54915081.6020508@freescale.com>
 <20141217104049.GU11285@n2100.arm.linux.org.uk>
In-Reply-To: <20141217104049.GU11285@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(377454003)(479174004)(51704005)(24454002)(189002)(199003)(6806004)(47776003)(64706001)(20776003)(36756003)(87936001)(97736003)(54356999)(21056001)(76176999)(120916001)(83506001)(93886004)(99136001)(99396003)(68736005)(65816999)(117636001)(110136001)(23746002)(77096005)(50466002)(31966008)(65806001)(104016003)(46102003)(106466001)(62966003)(107046002)(65956001)(86362001)(87266999)(4396001)(105606002)(84676001)(2950100001)(92566001)(59896002)(50986999)(85426001)(77156002)(217873001)(62816006);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0630;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0630;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0630;
X-Forefront-PRVS: 042957ACD7
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0630;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On 12/17/2014 06:40 PM, Russell King - ARM Linux wrote:
> On Wed, Dec 17, 2014 at 05:44:33PM +0800, Liu Ying wrote:
>> Hi Thierry,
>>
>> Sorry for the late response.
>> I tried to address almost all your comments locally first.
>> More feedback below.
>>
>> On 12/10/2014 09:16 PM, Thierry Reding wrote:
>>> On Wed, Dec 10, 2014 at 04:37:22PM +0800, Liu Ying wrote:
>>>> +static int check_status(struct imx_mipi_dsi *dsi, u32 reg, u32 status,
>>>> +			int timeout, bool to_set)
>>>> +{
>>>> +	u32 val;
>>>> +	bool out = false;
>>>> +
>>>> +	val = dsi_read(dsi, reg);
>>>> +	for (;;) {
>>>> +		out = to_set ? (val & status) : !(val & status);
>>>> +		if (out)
>>>> +			break;
>>>> +
>>>> +		if (!timeout--)
>>>> +			return -EFAULT;
>>>> +
>>>> +		msleep(1);
>>>> +		val = dsi_read(dsi, reg);
>>>> +	}
>>>> +	return 0;
>>>> +}
>>>
>>> You should probably use a properly timed loop here. msleep() isn't
>>> guaranteed to return after exactly one millisecond, so your timeout is
>>> never going to be accurate. Something like the following would be better
>>> in my opinion:
>>>
>>> 	timeout = jiffies + msecs_to_jiffies(timeout);
>>>
>>> 	while (time_before(jiffies, timeout)) {
>>> 		...
>>> 	}
>>>
>>> Also timeout should be unsigned long in that case.
>>
>> Accepted.
>
> Actually, that's a bad example: what we want to do is to assess success
> after we wait, before we decide that something has failed.  In other
> words, we don't want to wait, and decide that we failed without first
> checking for success.
>
> In any case, returning -EFAULT is not sane: EFAULT doesn't mean "fault"
> it means "Bad address", and it is returned to userspace to mean that
> userspace passed the kernel a bad address.  That definition does /not/
> fit what's going on here.
>
> 	timeout = jiffies + msecs_to_jiffies(timeout);
>
> 	do {
> 		val = dsi_read(dsi, reg);
> 		out = to_set ? (val & status) : !(val & status);
> 		if (out)
> 			break;
>
> 		if (time_is_after_jiffies(timeout))

time_is_after_jiffies(a) is defined as time_before(jiffies, a).

So, this line should be changed to

	if (time_after(jiffies, timeout))

Right?

> 			return -ETIMEDOUT;
>
> 		msleep(1);
> 	} while (1);
>
> 	return 0;
>
> would be better: we only fail immediately after we have checked whether
> we succeeded, and we also do the first check immediately.
>

Does this one look better?  I use cpu_relax() instead of msleep(1).

         expire = jiffies + msecs_to_jiffies(timeout);
         for (;;) {
                 val = dsi_read(dsi, reg);
                 out = to_set ? (val & status) : !(val & status);
                 if (out)
                         break;

                 if (time_after(jiffies, expire))
                         return -ETIMEDOUT;

                 cpu_relax();
         }

	return 0;

Regards,

Liu Ying
