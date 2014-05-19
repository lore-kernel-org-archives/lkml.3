Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaESInl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:43:41 -0400
Received: from smtp-out-049.synserver.de ([212.40.185.49]:1100 "EHLO
	smtp-out-145.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753284AbaESInk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:43:40 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 30104
Message-ID: <5379C435.9080703@metafoo.de>
Date: Mon, 19 May 2014 10:43:33 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linux-ALSA <alsa-devel@alsa-project.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Tushar Behera <tushar.behera@linaro.org>
Subject: Re: [alsa-devel] [PATCH] dma: pl330: Add support for DMA_PAUSE	command
References: <1400037830-21211-1-git-send-email-tushar.behera@linaro.org> <CABb+yY3YocX=8Dv7DysM4tcx=NTCCGGipz_gpMfpKDnAw7R8iw@mail.gmail.com> <CAHbNUh0fVND_oGLXWzsyKzbmJc_=FqhZTAnVHE4GGZ5aaJQbEg@mail.gmail.com> <5373607D.2000200@metafoo.de> <CAHbNUh1bmBniGVtvK4PpmpaKOnwG=MgtupkTEnjD6SS3r_-yjw@mail.gmail.com> <537513A8.701@metafoo.de> <s5hha4qp92i.wl%tiwai@suse.de> <5375EDC7.5070105@metafoo.de> <s5h4n0mduzw.wl%tiwai@suse.de>
In-Reply-To: <s5h4n0mduzw.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 10:37 AM, Takashi Iwai wrote:
> At Fri, 16 May 2014 12:51:51 +0200,
> Lars-Peter Clausen wrote:
>>
>> On 05/16/2014 07:49 AM, Takashi Iwai wrote:
>>> At Thu, 15 May 2014 21:21:12 +0200,
>>> Lars-Peter Clausen wrote:
>>>>
>>>> On 05/15/2014 02:01 PM, Tushar Behera wrote:
>>>>> On 14 May 2014 17:54, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>>>>> On 05/14/2014 02:07 PM, Tushar Behera wrote:
>>>>>>>
>>>>>>> On 14 May 2014 17:29, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>>>>>>>>
>>>>>>>> On Wed, May 14, 2014 at 8:53 AM, Tushar Behera <tushar.behera@linaro.org>
>>>>>>>> wrote:
>>>>>>>>>
>>>>>>>>> While playing back audio, pmc_dmaengine requests the DMA channel to
>>>>>>>>> stop DMA transmission through DMA_PAUSE command.
>>>>>>>>>
>>>>>>>>> Currently PL330 driver doesn't support DMA pause command, leaving
>>>>>>>>> the DMA state inconsistent when the system resumes. Instead, it would
>>>>>>>>> be better to terminate the DMA transfer during suspend and restart
>>>>>>>>> again during resume.
>>>>>>>>>
>>>>>>>>> Tested with audio playback across a suspend-resume cycle.
>>>>>>>>>
>>>>>>>> What is pmc_dmaengine? How does DMA_PAUSE help, when there is no
>>>>>>>> DMA_RESUME?
>>>>>>>>
>>>>>>>
>>>>>>> Sorry, it is a typo.
>>>>>>>
>>>>>>> sound/core/pcm_dmaengine.c:snd_dmaengine_pcm_trigger() -->
>>>>>>> dmaengine_pause() is called during system suspend.
>>>>>>
>>>>>>
>>>>>> It is only called if the DMA driver has support for pausing and resuming DMA
>>>>>> transfers. Or at least that is the intention.
>>>>>>
>>>>>> - Lars
>>>>>
>>>>> During suspend, snd_dmaengine_pcm_trigger():SNDRV_PCM_TRIGGER_SUSPEND
>>>>> is called which unconditionally calls dmaengine_pause(). Should we
>>>>> update snd_dmaengine_pcm_trigger() to check for DMA pause/resume
>>>>> support and call dmaengine_pause() or dmaengine_terminate_all()
>>>>> accordingly?
>>>>
>>>> As far as I understand it we do not have to do anything for TRIGGER_SUSPEND
>>>> if we do not set the SNDRV_PCM_INFO_RESUME flag. It looks like
>>>> TRIGGER_SUSPEND is called unconditionally during suspend. But since the
>>>> error code is ignored it should be fine if we just call dmaengine_pause()
>>>> and that return -ENOSYS or similar.
>>>
>>> Well, TRIGGER_SUSPEND is issued by PCM core no matter whether
>>> SNDRV_PCM_INFO_RESUME flag is set or not.  The resume behavior depends
>>> on the flag (SNDRV_PCM_TRIGGER_RESUME is issued if the flag is set,
>>> otherwise the normal setup is done by alsa-lib at resume), but the
>>> suspend is always triggered in the same way.
>>>
>>> So, PCM core assumes that the driver stops the stream somehow by
>>> SNDRV_PCM_TRIGGER_SUSPEND.
>>
>> Ok, so we should call terminate_all() when we get a
>> SNDRV_PCM_TRIGGER_SUSPEND if the dmaengine driver does not support pauseing
>> the transfer. Thanks for the clarification.
>>
>> On a related note it seems like it is still possible to get
>> PAUSE_PUSH/PAUSE_RELEASE events even if SNDRV_PCM_INFO_PAUSE is not set. Do
>> you have an idea what should be the right thing to do in such a case? Return
>> -ENOSYS?
>
> That's weird.  We have already a check in snd_pcm_pre_pause() in
> pcm_native.c to filter only for substreams with SNDRV_PCM_INFO_PAUSE
> flag.
>
> Could you check in which code path it is triggered?

Uhm, yes, I was only looking at the code, but couldn't find the check that 
makes sure that the PAUSE_PUSH/PAUSE_RELEASE events are only triggered if 
SNDRV_PCM_INFO_PAUSE is set. Looks like I need a pair of glasses.

Thanks and sorry for the noise,
- Lars

