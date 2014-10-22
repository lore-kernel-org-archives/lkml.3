Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaJVIgC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:36:02 -0400
Received: from axentia.se ([87.96.186.132]:22144 "EHLO EMAIL.axentia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbaJVIfU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:35:20 -0400
From: Peter Rosin <peda@axentia.se>
To: Bo Shen <voice.shen@atmel.com>
CC: "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "Takashi Iwai" <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, "Mark Brown" <broonie@kernel.org>
Subject: RE: [alsa-devel] [PATCH] ASoC: atmel_ssc_dai: Track playback and
 capture CMR dividers separately.
Thread-Topic: [alsa-devel] [PATCH] ASoC: atmel_ssc_dai: Track playback and
 capture CMR dividers separately.
Thread-Index: Ac/saz/Ebhtl/6cSQtuv8Muf3bNWIgBK9e7bAAahiEAAA0jtAAAETwBQ
Date: Wed, 22 Oct 2014 08:33:29 +0000
Message-ID: <05f8e371e0ac40949bfc01b8d86d3c6e@EMAIL.axentia.se>
References: <a541333cf46b4c61b790df927d4b315d@EMAIL.axentia.se>
 <5445BCBF.5090002@atmel.com>
 <dc4461593ddb4d539f2db74b69bab98c@EMAIL.axentia.se>
 <544620C8.4040001@atmel.com>
 <8559eca320324092be82f7d942606102@EMAIL.axentia.se>
 <544707F3.1020505@atmel.com>
 <c61abc1ef0f341c2be04e3d7b07d97de@EMAIL.axentia.se>
 <54476640.5050603@atmel.com>
In-Reply-To: <54476640.5050603@atmel.com>
Accept-Language: en-US, sv-SE
Content-Language: sv-SE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [217.210.101.82]
x-gfi-smtp-submission: 1
x-gfi-smtp-hellodomain: EMAIL.axentia.se
x-gfi-smtp-remoteip: 192.168.2.5
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> With the patch, it is OK?
> >
> > Yes.
> >
> >>> #include <sys/ioctl.h>
> >>> #include <unistd.h>
> >>> #include <fcntl.h>
> >>> #include <sys/soundcard.h>
> >>>
> >>> int
> >>> main(void)
> >>> {
> >>> 	int fd;
> >>> 	int format;
> >>> 	int channels;
> >>>
> >>> 	if ((fd = open("/dev/dsp", O_WRONLY, 0)) == -1) {
> >>> 		perror("open");
> >>> 		return 1;
> >>> 	}
> >>> 	format = AFMT_S16_LE;
> >>> 	if (ioctl(fd, SNDCTL_DSP_SETFMT, &format) == -1) {
> >>> 		perror("SNDCTL_DSP_SETFMT");
> >>> 		return 1;
> >>> 	}
> >>> 	channels = 2;
> >>> 	if (ioctl(fd, SNDCTL_DSP_CHANNELS, &channels) == -1) {
> >>> 		perror("SNDCTL_DSP_CHANNELS");
> >>> 		return 1;
> >>> 	}
> >>> 	return 0;
> >>> }
> >>>
> >>> Output:
> >>> SNDCTL_DSP_CHANNELS: Device or resource busy
> >>
> >> This return from codec or from atmel_ssc_dai?
> >
> > This -EBUSY definitely comes from atmel_ssc_set_dai_sysclk, when my
> > card-driver tries to set ATMEL_SSC_CMR_DIV. With the patch, it works.
> > (the codec is spdif-transmitter, since the i2c interface of the actual
> > tfa9879 codec is not directly reachable from the linux cpu, but that
> > has nothing to do with this issue).
> 
> I try to reproduce it (using the code your pasted directly) on atmel
> sama5d3xek with wm8904 code, don't meet this error.
> 
> I also go through the OSS code, I still don't find this is related with
> atmel_ssc_set_dai_sysclk.
> 
> So, am I missing something or something else?

The sama5d3xek/wm9804 combo, as implemented in the kernel, has the
ssc dai in slave mode, and therefore don't need to fiddle with any
ssc dai dividers (atmel_9804.c :atmel_asoc_wm9804_hw_params() only
sets things in the wm9804 codec dai driver and leaves the ssc dai to itself). 

Instead, try the above code on your code with the ssc dai in master mode
that you pointed at previously.

https://github.com/Android4SAM/linux-at91/commit/33db8ebd3e75632c482dda271340f4d2adcfd320

If that happens to not hit -EBUSY (which it might not, since the wm9804 codec
will only allow stereo, so the SNDCTL_DSP_CHANNELS ioctl might not need
to make any change for any ssc divider) add code to also set a non-default
sample rate, e.g.:

speed = 22050;
if (ioctl(fd, SNDCTL_DSP_SPEED, &speed) == -1) {
	perror("SNDCTL_DSP_SPEED");
	return 1;
}

Cheers,
Peter

