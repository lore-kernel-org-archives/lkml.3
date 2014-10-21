Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbaJULEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:04:50 -0400
Received: from axentia.se ([87.96.186.132]:43968 "EHLO EMAIL.axentia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971AbaJULEs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:04:48 -0400
From: Peter Rosin <peda@axentia.se>
To: Bo Shen <voice.shen@atmel.com>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCH] ASoC: atmel_ssc_dai: Track playback and
 capture CMR dividers separately.
Thread-Topic: [alsa-devel] [PATCH] ASoC: atmel_ssc_dai: Track playback and
 capture CMR dividers separately.
Thread-Index: Ac/saz/Ebhtl/6cSQtuv8Muf3bNWIgAVeLOAAA3ODdAAARn9AAAEcacw
Date: Tue, 21 Oct 2014 11:02:57 +0000
Message-ID: <75c3727e997844dd90e68dae4b00282b@EMAIL.axentia.se>
References: <a541333cf46b4c61b790df927d4b315d@EMAIL.axentia.se>
 <5445BCBF.5090002@atmel.com>
 <dc4461593ddb4d539f2db74b69bab98c@EMAIL.axentia.se>
 <544620C8.4040001@atmel.com>
In-Reply-To: <544620C8.4040001@atmel.com>
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

Hi again!

> Hi Peter,
> 
> On 10/21/2014 03:55 PM, Peter Rosin wrote:
> > Hi!
> >
> > (and thank you for the pointer to the example with the ssc-dai in
> > master mode)
> >
> >> Hi Peter,
> >>
> >> On 10/20/2014 09:45 PM, Peter Rosin wrote:
> >>>   From 1e5621d7b9887c648d1a66238dc82d715c1e2cad Mon Sep 17
> 00:00:00
> >>> 2001
> >>> From: Peter Rosin <peda@axentia.se>
> >>> Date: Mon, 20 Oct 2014 14:38:04 +0200
> >>> Subject: [PATCH] ASoC: atmel_ssc_dai: Track playback and capture CMR
> >> dividers
> >>>    separately.
> >>>
> >>> The CMR divider register is shared by playback and capture. The SSC
> >>> driver therefore tries to enforce rules so that the needed register
> >>> content do not conflict during simultaneous playback/capture.
> >>> However, the implementation also prevents changing the register
> >>> content in a half-duplex scenario, which is needed when changing
> sample rates.
> >>
> >> I am not fully get what you mean here, do you mean:
> >>     - when playback, first playback 48kHz, and then playback 8Khz,
> >> the 8Khz still playback in 48kHz mode?
> >>
> >> or other things?
> >
> > I do not know exactly why the problem occurs, but it might be
> > connected to the library (proprietary) we are using. It apparently
> > uses the OSS interface and somehow it opens a stream and changes the
> > playback sample-rate a couple of time before it settles on something.
> > I don't know why this is done, and I have no control over it. The end
> > result is that without this patch, the ssc-dai driver returns -EBUSY
> > when the library changes the playback sample-rate (the driver returns
> > -EBUSY because it thinks that the new sample rate does not match a
> > previously given capture sample-rate, but that is of course bogus when no
> capture is going on at all).
> 
> If this issue is caused by your proprietary library, please fix in the library.

Ah, but it's not "our" proprietary library to fix, it's simply a library that we
are using (speech synthesis, not our area of expertise). So, I'm not in a
position to simply fix it, as I have no source code.

> I don't know how this code can fix your issue and also there is no
> improvement to the code and it absolutely increase work (choose which
> clock to configure: tcmr or rcmr) for the SSC work in master. And also this
> patch may confuse the end user, let them thinking the clock for tcmr and
> rcmr can configure seperately.

I added some traces to our hw_params and got the following (without the patch):

[  161.170000] atmel ssc startup
[  161.170000]  TFA9879: axentia_asoc_tfa9879_hw_params - mclk rate 66000000
[  161.180000]  TFA9879: axentia_asoc_tfa9879_hw_params - bclk rate 128000
[  161.180000]  TFA9879: axentia_asoc_tfa9879_hw_params - bclk divider 128
[  161.190000]  TFA9879: axentia_asoc_tfa9879_hw_params - period 7
[  161.200000]  TFA9879: axentia_asoc_tfa9879_hw_params - mclk rate 66000000
[  161.200000]  TFA9879: axentia_asoc_tfa9879_hw_params - bclk rate 128000
[  161.210000]  TFA9879: axentia_asoc_tfa9879_hw_params - bclk divider 128
[  161.220000]  TFA9879: axentia_asoc_tfa9879_hw_params - period 7
[  161.230000]  TFA9879: axentia_asoc_tfa9879_hw_params - mclk rate 66000000
[  161.230000]  TFA9879: axentia_asoc_tfa9879_hw_params - bclk rate 256000
[  161.240000]  TFA9879: axentia_asoc_tfa9879_hw_params - bclk divider 64
[  161.250000]  TFA9879: axentia_asoc_tfa9879_hw_params - Failed to set cpu dai clk divider
[  161.260000] axentia-tfa9879-audio sound.9: ASoC: machine hw_params failed: -16

> So, I think keep the code as is (without this patch applied), what's your
> opinion?

In that case we'll simply carry the patch ourselves. I don't know why the above
happens, or if it is caused by bad behavior in the library, or what. But I do know
that the library is unusable for us without some action.

I thought it was an improvement, and therefore sent the patch...

Cheers,
Peter
