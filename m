Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbaJVJX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:23:28 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:61897 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbaJVJX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:23:26 -0400
Message-ID: <54477775.7070401@atmel.com>
Date: Wed, 22 Oct 2014 17:23:01 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Rosin <peda@axentia.se>
CC: "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "Takashi Iwai" <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, "Mark Brown" <broonie@kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: atmel_ssc_dai: Track playback and
 capture CMR dividers separately.
References: <a541333cf46b4c61b790df927d4b315d@EMAIL.axentia.se> <5445BCBF.5090002@atmel.com> <dc4461593ddb4d539f2db74b69bab98c@EMAIL.axentia.se> <544620C8.4040001@atmel.com> <8559eca320324092be82f7d942606102@EMAIL.axentia.se> <544707F3.1020505@atmel.com> <c61abc1ef0f341c2be04e3d7b07d97de@EMAIL.axentia.se> <54476640.5050603@atmel.com> <05f8e371e0ac40949bfc01b8d86d3c6e@EMAIL.axentia.se>
In-Reply-To: <05f8e371e0ac40949bfc01b8d86d3c6e@EMAIL.axentia.se>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 10/22/2014 04:33 PM, Peter Rosin wrote:
> The sama5d3xek/wm9804 combo, as implemented in the kernel, has the
> ssc dai in slave mode, and therefore don't need to fiddle with any
> ssc dai dividers (atmel_9804.c :atmel_asoc_wm9804_hw_params() only
> sets things in the wm9804 codec dai driver and leaves the ssc dai to itself).
>
> Instead, try the above code on your code with the ssc dai in master mode
> that you pointed at previously.

Yes, I try the ssc working as master mode.

> https://github.com/Android4SAM/linux-at91/commit/33db8ebd3e75632c482dda271340f4d2adcfd320
>
> If that happens to not hit -EBUSY (which it might not, since the wm9804 codec
> will only allow stereo, so the SNDCTL_DSP_CHANNELS ioctl might not need
> to make any change for any ssc divider) add code to also set a non-default
> sample rate, e.g.:
>
> speed = 22050;
> if (ioctl(fd, SNDCTL_DSP_SPEED, &speed) == -1) {
> 	perror("SNDCTL_DSP_SPEED");
> 	return 1;
> }

with this piece of code, I reproduce your issue.

Now, I know the reason of this issue, work in oss mode, it will set the 
default clock to 8KHz, and then if change to other sample rate, for 
example 48KHz, the div is different, then it reports -EBUSY.

So, I think we won't change the ATMEL_SSC_CMR_DIV to ATMEL_SSC_TCMR_DIV 
and ATMEL_SSC_RCMR_DIV, as it will affect other users. We just deal with 
this situation in ATMEL_SSC_CMR_DIV block, check the direction, if the 
same direction change the div, then accept the change, otherwise, return 
-EBUSY.

>
> Cheers,
> Peter

Best Regards,
Bo Shen
