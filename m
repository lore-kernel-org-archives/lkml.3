Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbbALDdg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 22:33:36 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:56794 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbbALDdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 22:33:33 -0500
Message-ID: <54B34035.60107@atmel.com>
Date: Mon, 12 Jan 2015 11:32:05 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
CC: Mark Brown <broonie@kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-sound@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: wm8904: fix runtime warning
References: <1420793620-2866-1-git-send-email-voice.shen@atmel.com> <20150109111642.GU14516@opensource.wolfsonmicro.com>
In-Reply-To: <20150109111642.GU14516@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Charles,

On 01/09/2015 07:16 PM, Charles Keepax wrote:
> On Fri, Jan 09, 2015 at 04:53:40PM +0800, Bo Shen wrote:
>> As the commit 5fe5b76 (ASoC: dapm: Do not pretend to support
>> controls for non mixer/mux widgets) remove the fake control.
>>
>> Then, the wm8904 throw out the following warning at runtime.
>> --->8---
>> wm8904 1-001a: Control not supported for path ADCL -> [Left] -> AIFOUTL
>> wm8904 1-001a: ASoC: no dapm match for ADCL --> Left --> AIFOUTL
>> wm8904 1-001a: ASoC: Failed to add route ADCL -> Left -> AIFOUTL
>> wm8904 1-001a: Control not supported for path ADCR -> [Right] -> AIFOUTL
>> wm8904 1-001a: ASoC: no dapm match for ADCR --> Right --> AIFOUTL
>> wm8904 1-001a: ASoC: Failed to add route ADCR -> Right -> AIFOUTL
>> wm8904 1-001a: Control not supported for path ADCL -> [Left] -> AIFOUTR
>> wm8904 1-001a: ASoC: no dapm match for ADCL --> Left --> AIFOUTR
>> wm8904 1-001a: ASoC: Failed to add route ADCL -> Left -> AIFOUTR
>> wm8904 1-001a: Control not supported for path ADCR -> [Right] -> AIFOUTR
>> wm8904 1-001a: ASoC: no dapm match for ADCR --> Right --> AIFOUTR
>> wm8904 1-001a: ASoC: Failed to add route ADCR -> Right -> AIFOUTR
>> wm8904 1-001a: Control not supported for path AIFINR -> [Right] -> DACL
>> wm8904 1-001a: ASoC: no dapm match for AIFINR --> Right --> DACL
>> wm8904 1-001a: ASoC: Failed to add route AIFINR -> Right -> DACL
>> wm8904 1-001a: Control not supported for path AIFINL -> [Left] -> DACL
>> wm8904 1-001a: ASoC: no dapm match for AIFINL --> Left --> DACL
>> wm8904 1-001a: ASoC: Failed to add route AIFINL -> Left -> DACL
>> wm8904 1-001a: Control not supported for path AIFINR -> [Right] -> DACR
>> wm8904 1-001a: ASoC: no dapm match for AIFINR --> Right --> DACR
>> wm8904 1-001a: ASoC: Failed to add route AIFINR -> Right -> DACR
>> wm8904 1-001a: Control not supported for path AIFINL -> [Left] -> DACR
>> wm8904 1-001a: ASoC: no dapm match for AIFINL --> Left --> DACR
>> wm8904 1-001a: ASoC: Failed to add route AIFINL -> Left -> DACR
>> ---8<---
>>
>> This patch is used to remove these warning.
>>
>> Signed-off-by: Bo Shen <voice.shen@atmel.com>
>> ---
>>
>>   sound/soc/codecs/wm8904.c | 16 ++++++++--------
>>   1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
>> index 4d2d2b1..38582d7 100644
>> --- a/sound/soc/codecs/wm8904.c
>> +++ b/sound/soc/codecs/wm8904.c
>> @@ -1076,10 +1076,10 @@ static const struct snd_soc_dapm_route adc_intercon[] = {
>>   	{ "Right Capture PGA", NULL, "Right Capture Mux" },
>>   	{ "Right Capture PGA", NULL, "Right Capture Inverting Mux" },
>>
>> -	{ "AIFOUTL", "Left",  "ADCL" },
>> -	{ "AIFOUTL", "Right", "ADCR" },
>> -	{ "AIFOUTR", "Left",  "ADCL" },
>> -	{ "AIFOUTR", "Right", "ADCR" },
>> +	{ "AIFOUTL", NULL, "ADCL" },
>> +	{ "AIFOUTL", NULL, "ADCR" },
>> +	{ "AIFOUTR", NULL, "ADCL" },
>> +	{ "AIFOUTR", NULL, "ADCR" },
>
> Is this the right fix here? I am not super familiar with the
> driver but it appears to contain an "AIFOUTL Mux" control which
> is not connected to anything. Looks like maybe this is a mistake
> the mux is indeded to be included in the path? Feels like we
> should either remove the control as well or hook it into the
> path.

Thank for your information.
I think here it should correct the path name as
--->8---
{ "AIFOUTL Mux", "Left",  "ADCL" },
{ "AIFOUTL Mux", "Right", "ADCR" },
{ "AIFOUTR Mux", "Left",  "ADCL" },
{ "AIFOUTR Mux", "Right", "ADCR" },
---8<---

Thanks again. I will send out the new version.

> Thanks,
> Charles
>

Best Regards,
Bo Shen
