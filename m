Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbbANKAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 05:00:53 -0500
Received: from smtp-out-243.synserver.de ([212.40.185.243]:1062 "EHLO
	smtp-out-243.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbbANKAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 05:00:50 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 17920
Message-ID: <54B63E4F.2010506@metafoo.de>
Date: Wed, 14 Jan 2015 11:00:47 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Wang, Jiada (ESD)" <Jiada_Wang@mentor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "Frkuska, Joshua" <Joshua_Frkuska@mentor.com>
Subject: Re: [alsa-devel] unload Audio drivers while playback stream is active
 case kernel crash
References: <857E9EDCA6C0904DB3357321AA9123EB0108B66919@NA-MBX-01.mgc.mentorg.com>	<s5h1tmyiof7.wl-tiwai@suse.de>	<20150113215412.GS4160@sirena.org.uk>	<s5hr3ux24em.wl-tiwai@suse.de>	<54B625A8.8090406@metafoo.de> <s5hoaq121gh.wl-tiwai@suse.de>
In-Reply-To: <s5hoaq121gh.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015 09:47 AM, Takashi Iwai wrote:
> At Wed, 14 Jan 2015 09:15:36 +0100,
> Lars-Peter Clausen wrote:
>>
>> On 01/14/2015 08:43 AM, Takashi Iwai wrote:
>>> At Tue, 13 Jan 2015 21:54:12 +0000,
>>> Mark Brown wrote:
>>>>
>>>> On Tue, Jan 13, 2015 at 06:24:44PM +0100, Takashi Iwai wrote:
>>>>> Wang, Jiada (ESD) wrote:
>>>>
>>>>>> I am using i.MX6Q sabreSD board, which have imx_wm892 machine driver, wm8962 codec and SSI CPU DAI,
>>>>
>>>>>> I got Kernel crash when unloading audio drivers (playback stream is active)
>>>>>> modprobe -r snd_soc_imx_wm8962
>>>>>> modprobe -r snd_soc_fsl_ssi
>>>>>> modprobe -r snd_soc_wm8962
>>>>
>>>>> The root problem is that you can unload the module while playing.
>>>>> The corresponding module refcounts should have been increased during
>>>>> used.
>>>>
>>>>> Do we miss [try_]module_get() somewhere in ASoC?
>>>>
>>>> That doesn't help, users can still forcibly unbind the driver at runtime
>>>> without loading the module - and there's always the potential for
>>>> actually hotpluggable hardware.  The teardown paths should be able to
>>>> cope somewhat gracefully.
>>>
>>> The module refcount has to be handled while being used for stopping
>>> module unload.  That's irrelevant from the dynamic unbinding support
>>> itself.  Of course, the module refcount doesn't save the world, but
>>> it's the right fix for this particular scenario.
>>
>> Refcounting won't help in this case. The issue is caused by a delayed work
>> item that gets launched when the PCM stream is stopped. So if you decrease
>> the refcount when the stream is stopped you still have a window where it is
>> possible to remove the module while the work is still being scheduled.
>
> OK, so it's not about active stream.  From the reporter's description,
> I supposed that the module gets unloaded while playing a stream, which
> shouldn't be allowed.

Well one of the ways to trigger this is to remove the module while the 
stream is active. But it is not exclusively a problem module unload problem. 
E.g. the same happens if you hot-unplug the ASoC card.

I don't think that we need to prevent module unload when a stream is active. 
 From a framework point of view is not different from hot-unplug. I don't 
see a reason why we'd jump through hoops to actively forbid removing the 
module once it works just fine.

- Lars
