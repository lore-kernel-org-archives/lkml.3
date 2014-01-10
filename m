Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaAJL4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:56:37 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24659 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343AbaAJL4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:56:34 -0500
Message-ID: <52CFE0AE.1030606@marvell.com>
Date: Fri, 10 Jan 2014 19:59:42 +0800
From: Nenghua Cao <nhcao@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Liam Girdwood <liam.r.girdwood@linux.intel.com>
CC: Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: dpcm: don't do hw_param when BE has
 done	hw_param
References: <1389332195-15900-1-git-send-email-nhcao@marvell.com>  <s5htxdcxg0q.wl%tiwai@suse.de> <52CFD7BE.5030907@marvell.com> <1389354435.2293.32.camel@loki>
In-Reply-To: <1389354435.2293.32.camel@loki>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-10_04:2014-01-10,2014-01-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1401100039
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 07:47 PM, Liam Girdwood wrote:
> On Fri, 2014-01-10 at 19:21 +0800, Nenghua Cao wrote:
>> On 01/10/2014 06:55 PM, Takashi Iwai wrote:
>>> [Corrected mail addresses of both Mark and Liam]
>>>
>> Hi, Takashi:
>> Thanks for correcting my mistake.
>>> At Fri, 10 Jan 2014 13:36:35 +0800,
>>> Nenghua Cao wrote:
>>>>
>>>> From: Nenghua Cao <nhcao@marvell.com>
>>>>
>>>>     It fixes the following case:
>>>>     Two FEs connects the same BE; FE1 & BE path has been opened and hw_paramed.
>>>> At this momment, FE2 & BE path is being opened and hw_paramed. The BE
>>>> dai will do hw_param again even if it has done hw_param. It is not
>>>> reasonable.
>>>> FE1------------>BE
>>>> FE2-------------^
>>>
>>> What happens if FE2 tries to set up an incompatible hw_params?
>>> (Through a quick glance, it won't work properly well, too, though...)
>>>
> 
> The intention in this case would be for the DSP FE driver to determine
> if it can perform format conversion or SRC to the running BE. If the DSP
> cant do the conversion then it should fail.
> 
>> If FE2 uses an incompatible param, it will make FE1 doesn't work. Maybe
>> FE2 works well.
>> If FE2 uses the same param, BE hw_param function will be called twice
>> (This is the most happening case).
>> So we can't get benefits from it.
> 
> We shouldn't be calling the hw_params() on the BE when it's already
> configured in this case. So this seems like a bug. However :-
> 
> /* only allow hw_params() if no connected FEs are running */
> 		if (!snd_soc_dpcm_can_be_params(fe, be, stream))
> 			continue;
> 
> 		if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_OPEN) &&
> 		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_PARAMS) &&
> 		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_FREE))
> 			continue;
> 
> We do do a test to check if any connected FEs are running (i.e.
> triggered) prior to calling hw_params() on the BE. Can you confirm if
> the FE was running in your case ?
> 
Hi, Liam:
   I am so glad to hear from you. In my case, FE1 has called hw_param,
and before FE1 calls prepare/trigger function, the scheduler switches to
do FE2 open, hw_param. So hw_param is called twice.

> Thanks
> 
> Liam
> 
>>>
>>> Takashi
>>>
>>>>
>>>> Signed-off-by: Nenghua Cao <nhcao@marvell.com>
>>>> ---
>>>>  sound/soc/soc-pcm.c |    1 -
>>>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
>>>> index 891b9a9..ec07e37 100644
>>>> --- a/sound/soc/soc-pcm.c
>>>> +++ b/sound/soc/soc-pcm.c
>>>> @@ -1339,7 +1339,6 @@ static int dpcm_be_dai_hw_params(struct snd_soc_pcm_runtime *fe, int stream)
>>>>  			continue;
>>>>  
>>>>  		if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_OPEN) &&
>>>> -		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_PARAMS) &&
>>>>  		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_FREE))
>>>>  			continue;
>>>>  
>>>> -- 
>>>> 1.7.0.4
>>>>
>>>> _______________________________________________
>>>> Alsa-devel mailing list
>>>> Alsa-devel@alsa-project.org
>>>> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
>>>>
>>
> 
> 
> 

