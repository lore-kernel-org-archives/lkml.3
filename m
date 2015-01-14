Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbbANIZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:25:43 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:59044 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbbANIZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:25:26 -0500
Message-ID: <54B627F0.90207@mentor.com>
Date: Wed, 14 Jan 2015 17:25:20 +0900
From: jiwang <jiada_wang@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "Frkuska, Joshua" <Joshua_Frkuska@mentor.com>
Subject: Re: [alsa-devel] unload Audio drivers while playback stream is active
 case kernel crash
References: <857E9EDCA6C0904DB3357321AA9123EB0108B66919@NA-MBX-01.mgc.mentorg.com> <s5h1tmyiof7.wl-tiwai@suse.de> <20150113215412.GS4160@sirena.org.uk> <s5hr3ux24em.wl-tiwai@suse.de> <54B625A8.8090406@metafoo.de>
In-Reply-To: <54B625A8.8090406@metafoo.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 01/14/2015 05:15 PM, Lars-Peter Clausen wrote:
> On 01/14/2015 08:43 AM, Takashi Iwai wrote:
>> At Tue, 13 Jan 2015 21:54:12 +0000,
>> Mark Brown wrote:
>>>
>>> On Tue, Jan 13, 2015 at 06:24:44PM +0100, Takashi Iwai wrote:
>>>> Wang, Jiada (ESD) wrote:
>>>
>>>>> I am using i.MX6Q sabreSD board, which have imx_wm892 machine 
>>>>> driver, wm8962 codec and SSI CPU DAI,
>>>
>>>>> I got Kernel crash when unloading audio drivers (playback stream 
>>>>> is active)
>>>>> modprobe -r snd_soc_imx_wm8962
>>>>> modprobe -r snd_soc_fsl_ssi
>>>>> modprobe -r snd_soc_wm8962
>>>
>>>> The root problem is that you can unload the module while playing.
>>>> The corresponding module refcounts should have been increased during
>>>> used.
>>>
>>>> Do we miss [try_]module_get() somewhere in ASoC?
>>>
>>> That doesn't help, users can still forcibly unbind the driver at 
>>> runtime
>>> without loading the module - and there's always the potential for
>>> actually hotpluggable hardware.  The teardown paths should be able to
>>> cope somewhat gracefully.
>>
>> The module refcount has to be handled while being used for stopping
>> module unload.  That's irrelevant from the dynamic unbinding support
>> itself.  Of course, the module refcount doesn't save the world, but
>> it's the right fix for this particular scenario.
>
> Refcounting won't help in this case. The issue is caused by a delayed 
> work item that gets launched when the PCM stream is stopped. So if you 
> decrease the refcount when the stream is stopped you still have a 
> window where it is possible to remove the module while the work is 
> still being scheduled.
>
> And while we do flush the scheduled work when we remove the ASoC card 
> this is done before snd_card_free() is called. So when snd_card_free() 
> is called it gets re-scheduled again. I think the correct fix is to 
> add a snd_card_disconnect() at the very top of 
> soc_cleanup_card_resources().
>
when stream is active, snd_card_disconnect() will trigger pcm_close() be 
executed by another thread,
we can't ensure the pcm_close() is executed before the rest of 
soc_cleanup_card_resources().

- Jiada

> - Lars

