Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbaEVKau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 06:30:50 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47073 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbaEVKas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 06:30:48 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-e3-537dd1d5c11d
Message-id: <537DD1D2.9010107@samsung.com>
Date: Thu, 22 May 2014 12:30:42 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>,
        linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 3/4] clk: samsung: Add driver to control CLKOUT line on
 Exynos SoCs
References: <1400604211-9447-1-git-send-email-t.figa@samsung.com>
 <1400604211-9447-4-git-send-email-t.figa@samsung.com>
 <537D7CF4.6050305@linaro.org>
In-reply-to: <537D7CF4.6050305@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t/xq7pXL9YGGzy4zWYx9eETNov5R86x
	WvQuuMpmsenxNVaLy7vmsFnMOL+PyWLtkbvsFkuvX2SyeDrhIpvFoq1f2C2mLDrMatG69wi7
	xapdfxgt2v/uZXPg81gzbw2jx85Zd9k9Nq3qZPO4c20Pm8fmJfUefVtWMXp83iQXwB7FZZOS
	mpNZllqkb5fAlXFw+Q3WgmM8Fd8XljUwNnJ1MXJySAiYSPR/uswCYYtJXLi3nq2LkYtDSGAp
	o8S0xftYIJzPjBKvLn1gA6niFdCSOPHtD5jNIqAq0bl9CzuIzSagJvG54RFYnB+oZk3TdaBm
	Dg5RgQiJxxeEIFoFJX5Mvge2TETAX+L0vfPMIPOZBU4wS3x9+ZoRJCEsEClx6+JzqMUzGSWO
	vJjECpLgBBp69M17ZhCbWUBHYn/rNDYIW15i85q3zBMYBWchWTILSdksJGULGJlXMYqmliYX
	FCel5xrpFSfmFpfmpesl5+duYoTE1dcdjEuPWR1iFOBgVOLh7ciqDRZiTSwrrsw9xCjBwawk
	wrvvDFCINyWxsiq1KD++qDQntfgQIxMHp1QDY9WxnZpqi0Q1D9Vk8YQINNx7sEH6gsnPKdUT
	Ju2Rd7TdmCz8/OimZ88iz6fY7Pg6VVUz52lHyHat9ed+fq6evvXtitPTVCacnuf9+E7BpKu5
	N2SZ3166+HDdq9pyp8xbHCc1Jrj9bgqffeqt3XJz4yP/JVqfHevi5a2/yap1YJ7q23+2809s
	FtukxFKckWioxVxUnAgAHWCdZ4kCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.05.2014 06:28, Tushar Behera wrote:
> On 05/20/2014 10:13 PM, Tomasz Figa wrote:
>> This patch introduces a driver that handles configuration of CLKOUT pin
>> of Exynos SoCs that can be used to output certain clocks from inside of
>> the SoC to a dedicated output pin.
>>
>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>> ---
>>  .../devicetree/bindings/arm/samsung/pmu.txt        |  30 ++++
>>  drivers/clk/samsung/Makefile                       |   1 +
>>  drivers/clk/samsung/clk-exynos-clkout.c            | 153 +++++++++++++++++++++
>>  3 files changed, 184 insertions(+)
>>  create mode 100644 drivers/clk/samsung/clk-exynos-clkout.c
>>
>> diff --git a/Documentation/devicetree/bindings/arm/samsung/pmu.txt b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
>> index b562634..5ed94a9 100644
>> --- a/Documentation/devicetree/bindings/arm/samsung/pmu.txt
>> +++ b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
>> @@ -11,8 +11,38 @@ Properties:
>>  
>>   - reg : offset and length of the register set.
>>  
>> + - #clock-cells : must be <1>, since PMU requires once cell as clock specifier.
> 
> s/once/one
> 
>> +		The single specifier cell is used as index to list of clocks
>> +		provided by PMU, which is currently:
>> +			0 : SoC clock output (CLKOUT pin)
> 
> Will it make more sense if we add a macro for this clock number that
> would be referred in the device tree files?

Right now, with just one clock, it doesn't make sense, but if further
clocks show up with newer SoCs, then macros will have to be added.

Best regards,
Tomasz
