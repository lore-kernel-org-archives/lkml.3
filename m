Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935106AbaKNEIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 23:08:32 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41874 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933512AbaKNEI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 23:08:29 -0500
Message-ID: <fd33d16f31eb73cc6f0585c192601d9e.squirrel@www.codeaurora.org>
In-Reply-To: <5464CDE2.2070406@linux.intel.com>
References: <85499f52ebd29581bf58b9cafbae6864.squirrel@www.codeaurora.org>
    <5464CDE2.2070406@linux.intel.com>
Date: Fri, 14 Nov 2014 04:08:28 -0000
Subject: Re: [alsa-devel] Question on Compressed offload session
From: gsantosh@codeaurora.org
To: "Pierre-Louis Bossart" <pierre-louis.bossart@linux.intel.com>
Cc: gsantosh@codeaurora.org, alsa-devel-bounces@alsa-project.org,
        "Mark Rutland" <mark.rutland@arm.com>, "Rob Herring" <robh@kernel.org>,
        "ALSA Development Mailing List" <alsa-devel@alsa-project.org>,
        "Kuninori Morimoto" <kuninori.morimoto.gx@renesas.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        "Magnus" <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        "Mark Brown" <broonie@kernel.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Olof Johansson" <olof@lixom.net>,
        "Kuninori Morimoto" <kuninori.morimoto.gx@gmail.com>
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 11/12/14, 9:02 PM, gsantosh@codeaurora.org wrote:
>> Hi All,
>>
>> The Question is for the compressed offload session.
>>
>> For a generic codec driver during the startup function it will set some
>> of
>> the hw_constraints rule similarly like this.
>>
>>          snd_pcm_hw_constraint_list(substream->runtime, 0,
>>                      SNDRV_PCM_HW_PARAM_RATE,
>>                      &constraints_12_24);
>>
>> pcm_lib.c will try to add the rule to the runtime structure by accessing
>> the pointers which will be initialized during opening of the session,
>> as The Constraints added by the codec driver will be updated in the
>>
>> struct snd_pcm_hw_constraints of runtime structure which will be part of
>> substream handle.
>>
>> But for the compressed offload I do not see the initialization done for
>> HW
>> constraints, as done in pcm session
>>
>> 2092int snd_pcm_open_substream(struct snd_pcm *pcm, int stream,
>> 2093			   struct file *file,
>> 2094			   struct snd_pcm_substream **rsubstream)
>>
>> most of the existing drivers which has the hw_constraint_list code will
>> not be applicable for compress offload session, how to solve this?
>
> You can't directly link physical output/input with the decoder/encoder
> in general.
> For decoders, the sample-rate may not always be known ahead of time,
> e.g. with AAC-SBR implicit signaling. There is no way to add constraints
> on open, there is an assumption that a sample-rate converter is part of
> the chain to take care of the difference between the output of the
> offloaded decoder and the back-end actual sampling frequency (same with
> number of channels and bit-width btw).
> Likewise if you encode the frequency may not be the same as what the
> backend provides and some SRC might be needed.
> -Pierre
>

I Agree we cannot have a direct link between physical output  / input with
decoder / encoder, during compressed playback.
My concern here is, if we have a legacy codec driver which is used for the
PCM out, and in the start up of this codec driver it is adding
hw_constraints list, now the same codec driver is used for the compressed
session FE or PCM session FE,
If the routing is such that compressed FE -> codec the hw_constraints
added by this driver is not valid here,
and legacy drivers needs to be changed,
Now the question comes how to change this drivers?
I can think of following things
if the routing is done for Compressed FE -> codec

1) in Codec driver avoid adding hw_constraint during startup if compressed
session is routed, this recommend for codec driver to know that compress
session is routed to codec which I feel not the correct way to handle this

I was checking how to handle this situation in much better way.

Regards
Santosh

> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
>


