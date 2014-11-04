Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbaKDOL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:11:29 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54146 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaKDOL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:11:28 -0500
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
X-AuditID: cbfec7f5-b7f956d000005ed7-6f-5458de8d0b6c
Content-transfer-encoding: 8BIT
Message-id: <5458DE8C.7070909@samsung.com>
Date: Tue, 04 Nov 2014 15:11:24 +0100
From: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
To: Hugh Kang <hugh.kang@lge.com>, Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        jonghoon.park@lge.com
Subject: Re: [PATCH] regulator: adding disable options for regulator-always-on
 and regulator-boots-on
References: <1414978003-20437-1-git-send-email-hugh.kang@lge.com>
 <20141103120313.GC3815@sirena.org.uk> <54588C3B.9070605@lge.com>
In-reply-to: <54588C3B.9070605@lge.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t/xy7q99yJCDP791bSY+vAJm8W0BfNY
	LA6dfMVi8fqFocW3Kx1MFpd3zWFzYPPYOesuu8emVZ1sHl1vrzB59G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8aRuYvYC84KVxzfsoKtgfEOfxcjB4eEgInEw97iLkZOIFNM4sK99WxdjFwc
	QgJLGSUuXX3ODpLgFRCU+DH5HgtIPbOAvMSRS9kQprrElCm5IBVCAp8ZJU4+YgMJ8wpoSVzb
	EQ0SZhFQlbjQd4oRxGYT8JCY9r2HGcQWFYiQuLJmDlhcRMBJYuO1tWA2s0CcxOX7fawgtrBA
	usTp47ugrmlhlPj54DwryHxOoLXrthRMYBSYheS2WQi3zUK4bQEj8ypG0dTS5ILipPRcI73i
	xNzi0rx0veT83E2MkGD+uoNx6TGrQ4wCHIxKPLwr4iNChFgTy4orcw8xSnAwK4nwbjsNFOJN
	SaysSi3Kjy8qzUktPsTIxMEp1cDoUL5ngbOW1N7H85oFTlsuFT70XeLWu4tfjJIefp0Ua8Rr
	frlfbPmreoOgi1PLvTsjWleubXVzD3wyJbAt+uLHioO3Ty95/Kp5rrdL7EWFrzfcdtrwL1YW
	/+nx93f3kpUO3TMeHtmvryJkFaDjsnGfeO81izIZ73MnVu7du/92TsUH5c16Kl/+KbEUZyQa
	ajEXFScCAEZTLXxEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.11.2014 09:20, Hugh Kang wrote:
> Hello
> 
> On 2014년 11월 03일 21:03, Mark Brown wrote:
>> On Mon, Nov 03, 2014 at 10:26:43AM +0900, Hugh Kang wrote:
>>> From: "hugh.kang" <hugh.kang@lge.com>
>>>
>>> If a regulator is set by always-on option, the regulator will be set forever.
>>> For example, suppose LDO1 is set to always-on at RevA.dts with including of a.dtsi. After that
>>> RevB.dts may wants to include the same a.dtsi but override the LDO1 always-on option. However,
>>> currently there is no way to delete the always-on option, even when we change the LDO1 option value,
>>> the always-on setting is still remains.
>> This sounds like a problem with the way the DTSs have been written - I'd
>> expect the thing to do here is just to move the property to the rev A
>> DTS when rev B is created.  Why is that not the way forward?
>>
>> Otherwise this is an issue which affects any boolean property in the DT
>> so if it's something we need to fix we should be fixing it in a generic
>> fashion that will work for other properties too.
> 
> I understand that I could make Rev.B with b.dtsi due to LDOs option is different. However, aim to use device tree is that making easy steps. Refer to dts option, if you set to be set status disabled option, the driver dose not probe when the system boot up. Even though, the system has different board revision exist. So dts have to be no corrupts any overlap situation.
> I have mentions the simple example to change only one LDOs. However, if someone want to edit many regulators with similar configuration, he has to do lots of copy and paste works. Because he has to create new dts file. So I would suggest to make it as simple as I could.
> 
> Also, I have somehow agree with you that affects any boolean property in the DT.

Now you propose to have a final DTS like:
$ scripts/dtc/dtc -I dtb -O dts
	reg {
		regulator-name = "vdd";
		regulator-min-microvolt = <850000>;
		regulator-max-microvolt = <1100000>;
		regulator-always-on;
		regulator-disable-always-on;
	};
Which one of "always-on" is more important? Later one could add
"regulator-enable-always-even-if-disable-always-on;" ...

The "status" property can be overridden. So maybe the new property
should behave the same way? Something like:
dts-common {
		regulator-status-on = "always-on";
		regulator-boot-on = "boot-on";
}
dst-rev-b {
		regulator-status-on = "default";
		regulator-boot-on = "default";
}

Best regards,
Krzysztof

