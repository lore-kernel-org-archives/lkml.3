Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaAATE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 14:04:56 -0500
Received: from smtp-out-181.synserver.de ([212.40.185.181]:1032 "EHLO
	smtp-out-079.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752978AbaAATEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 14:04:55 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 21093
Message-ID: <52C466E1.3030302@metafoo.de>
Date: Wed, 01 Jan 2014 20:05:05 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: generic: add generic compound card
 with DT support
References: <20131231113138.102044cf@armhf>
In-Reply-To: <20131231113138.102044cf@armhf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2013 11:31 AM, Jean-Francois Moine wrote:
> Some audio cards are built from different hardware components.
> When such compound cards don't need specific code, this driver creates
> them with the required DAI links and routes from a DT.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
> This code was first developped on the generic simple card, but its
> recent DT extension cannot be easily extended again to support compound
> cards as the one in the Cubox.
> Note also that the example relies on a proposed patch of mine aiming to
> render the codec name / OF node optional in DAI links
> (http://mailman.alsa-project.org/pipermail/alsa-devel/2013-December/070082.html).
> ---
>  .../devicetree/bindings/sound/compound-card.txt |  95 ++++++++++++
>  sound/soc/generic/Kconfig                       |   6 +
>  sound/soc/generic/Makefile                      |   2 +
>  sound/soc/generic/compound-card.c               | 247 +++++++++++++++++++++++++
>  4 file changed, 350 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/sound/compound-card.txt b/Documentation/devicetree/bindings/sound/compound-card.txt
> new file mode 100644
> index 0000000..554a796
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/sound/compound-card.txt
> @@ -0,0 +1,95 @@
> +Device-Tree bindings for compound audio card
> +
> +Compound audio card describes the links between the different parts
> +of an audio card built from different hardware components.
> +
> +Required properties:
> +  - compatible: should be "compound-audio-card"
> +  - audio-controller: phandle of the audio controller
> +
> +Optional properties:
> +  - routes: list of couple of strings (sink, source)
> +
> +Required subnodes:
> +  - link: DAI link subnode
> +	At least one link must be specified.
> +
> +Required link subnode properties:
> +  - link-name: names of the DAI link and of the stream
> +  - cpu-dai-name: name of the CPU or CODEC DAI
> +		An empty string indicates that the CPU DAI is
> +		the same as the audio controller.
> +  - codec-dai-name: name of the CODEC DAI
> +
> +Optional link subnode properties:
> +  - audio-codec or codec-name: phandle or name of the CODEC
> +		in case the codec-dai-name is not unique
> +  - format: DAI format. One of:
> +		"i2s", "right_j", "left_j" , "dsp_a"
> +		"dsp_b", "ac97", "pdm", "msb", "lsb"
> +  - front-end or back-end: present if the DAI link describes resp.
> +		a front-end CPU DAI or a back-end CODEC DAI
> +  - playback or capture: present if the DAI link is used for
> +		playback or capture only


As Mark also said, this binding definitely leaks way too much internals of
the current ASoC implementation. In my opinion the way forward for ASoC is
to stop to distinguish between different types of components. This is on one
hand CODECS and CPU-DAIs and on the other hand also front-end and beck-end
DAIs. The first steps in this direction have already been take by the start
of the component-fication, but its still a long way to go. Exposing those
concepts via the devicetree will only make it harder to get rid of them
later. The bindings for a compound card should essentially describe which
components are involved and how the fabric between and around them looks
like. If the type of the component is needed in the ASoC implementation it
should be possible to auto-discover it. Also I think we want to align the
devicetree bindings with what the media people have been doing[1]. Audio and
video are not that different in this regard and there will also be boards
where the audio and video fabric will be intermingled  (e.g. like on your
board with HDMI).

- Lars
