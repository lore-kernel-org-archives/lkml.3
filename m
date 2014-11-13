Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329AbaKMP2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:28:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:17408 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbaKMP2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:28:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487211176"
Message-ID: <5464CDE2.2070406@linux.intel.com>
Date: Thu, 13 Nov 2014 09:27:30 -0600
From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: gsantosh@codeaurora.org, alsa-devel-bounces@alsa-project.org
CC: Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Magnus <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, grant.likely@linaro.org,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Subject: Re: [alsa-devel] Question on Compressed offload session
References: <85499f52ebd29581bf58b9cafbae6864.squirrel@www.codeaurora.org>
In-Reply-To: <85499f52ebd29581bf58b9cafbae6864.squirrel@www.codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/14, 9:02 PM, gsantosh@codeaurora.org wrote:
> Hi All,
>
> The Question is for the compressed offload session.
>
> For a generic codec driver during the startup function it will set some of
> the hw_constraints rule similarly like this.
>
>          snd_pcm_hw_constraint_list(substream->runtime, 0,
>                      SNDRV_PCM_HW_PARAM_RATE,
>                      &constraints_12_24);
>
> pcm_lib.c will try to add the rule to the runtime structure by accessing
> the pointers which will be initialized during opening of the session,
> as The Constraints added by the codec driver will be updated in the
>
> struct snd_pcm_hw_constraints of runtime structure which will be part of
> substream handle.
>
> But for the compressed offload I do not see the initialization done for HW
> constraints, as done in pcm session
>
> 2092int snd_pcm_open_substream(struct snd_pcm *pcm, int stream,
> 2093			   struct file *file,
> 2094			   struct snd_pcm_substream **rsubstream)
>
> most of the existing drivers which has the hw_constraint_list code will
> not be applicable for compress offload session, how to solve this?

You can't directly link physical output/input with the decoder/encoder 
in general.
For decoders, the sample-rate may not always be known ahead of time, 
e.g. with AAC-SBR implicit signaling. There is no way to add constraints 
on open, there is an assumption that a sample-rate converter is part of 
the chain to take care of the difference between the output of the 
offloaded decoder and the back-end actual sampling frequency (same with 
number of channels and bit-width btw).
Likewise if you encode the frequency may not be the same as what the 
backend provides and some SRC might be needed.
-Pierre

