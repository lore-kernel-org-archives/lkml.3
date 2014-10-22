Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbaJVDk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 23:40:59 -0400
Received: from regular1.263xmail.com ([211.150.99.134]:33105 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaJVDk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 23:40:57 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Oct 2014 23:40:56 EDT
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: jinkun.hong@rock-chips.com
X-FST-TO: jack.dai@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: jinkun.hong@rock-chips.com
X-UNIQUE-TAG: <d517e96f6880d22775ed128916807778>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <54472740.2000006@rock-chips.com>
Date: Wed, 22 Oct 2014 11:40:48 +0800
From: Hong jinkun <jinkun.hong@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@kernel.org>
CC: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, dianders@chromium.org,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jack Dai <jack.dai@rock-chips.com>
Subject: Re: [PATCH v4 1/3] power-domain: add power domain drivers for Rockchip
 platform
References: <1413795824-3453-1-git-send-email-jinkun.hong@rock-chips.com>	<1413795824-3453-2-git-send-email-jinkun.hong@rock-chips.com> <7hppdme8d6.fsf@deeprootsystems.com>
In-Reply-To: <7hppdme8d6.fsf@deeprootsystems.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ÔÚ 2014/10/21 5:31, Kevin Hilman Ð´µÀ:
> "jinkun.hong" <jinkun.hong@rock-chips.com> writes:
>
>> From: "jinkun.hong" <jinkun.hong@rock-chips.com>
>>
>> Add power domain drivers based on generic power domain for Rockchip platform,
>> and support RK3288.
>>
>> Signed-off-by: Jack Dai <jack.dai@rock-chips.com>
>> Signed-off-by: jinkun.hong <jinkun.hong@rock-chips.com>
> [...]
>
>> +static int rockchip_pmu_set_idle_request(struct rockchip_domain *pd,
>> +					 bool idle)
>> +{
>> +	u32 idle_mask = BIT(pd->idle_shift);
>> +	u32 idle_target = idle << (pd->idle_shift);
>> +	u32 ack_mask = BIT(pd->ack_shift);
>> +	u32 ack_target = idle << (pd->ack_shift);
>> +	unsigned int mask = BIT(pd->req_shift);
>> +	unsigned int val;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&pd->idle_lock, flags);
>> +	val = (idle) ? mask : 0;
>> +	regmap_update_bits(pd->regmap_pmu, REQ_OFFSET, mask, val);
>> +	dsb();
> A summary of the locking and barriers here (or in changelog) would be
> helpful for reviewers to verify you're protecting what you need to
> protect.
>
>> +	do {
>> +		regmap_read(pd->regmap_pmu, ACK_OFFSET, &val);
>> +	} while ((val & ack_mask) != ack_target);
>> +
>> +	do {
>> +		regmap_read(pd->regmap_pmu, IDLE_OFFSET, &val);
>> +	} while ((val & idle_mask) != idle_target);
>> +
>> +	spin_unlock_irqrestore(&pd->idle_lock, flags);
> These IRQ-disabled while loops look like opportunities to lockup the
> system.  Maybe add a timeout or a maximum number of tries?
Ok,I will add a timeout in new version.
>> +	return 0;
>> +}
> Kevin
>
>
>
Thank you for your review.

