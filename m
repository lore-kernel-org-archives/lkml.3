Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaK1QNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:13:12 -0500
Received: from axentia.se ([87.96.186.132]:27583 "EHLO EMAIL.axentia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaK1QNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:13:11 -0500
From: Peter Rosin <peda@axentia.se>
To: Mark Brown <broonie@kernel.org>, Peter Rosin <peda@lysator.liu.se>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ASoC: Augment existing card DAPM routes in
 snd_soc_of_parse_audio_routing
Thread-Topic: [PATCH] ASoC: Augment existing card DAPM routes in
 snd_soc_of_parse_audio_routing
Thread-Index: AQHQCySafQnGBHEyvUCjtd9lRJLHS5x2M85A
Date: Fri, 28 Nov 2014 16:11:13 +0000
Message-ID: <c837f8c59be24429aeed270636aac570@EMAIL.axentia.se>
References: <1417122162-8122-1-git-send-email-peda@lysator.liu.se>
 <20141128160320.GY7712@sirena.org.uk>
In-Reply-To: <20141128160320.GY7712@sirena.org.uk>
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

Mark Brown wrote:
> On Thu, Nov 27, 2014 at 10:02:42PM +0100, Peter Rosin wrote:
> 
> > -	routes = devm_kzalloc(card->dev, num_routes * sizeof(*routes),
> > +	old_routes = card->num_dapm_routes;
> > +	routes = devm_kzalloc(card->dev,
> > +			      (old_routes + num_routes) * sizeof(*routes),
> >  			      GFP_KERNEL);
> >  	if (!routes) {
> >  		dev_err(card->dev,
> > @@ -4611,9 +4613,11 @@ int snd_soc_of_parse_audio_routing(struct
> snd_soc_card *card,
> >  		return -EINVAL;
> >  	}
> >
> > +	memcpy(routes, card->dapm_routes, old_routes * sizeof(*routes));
> > +
> 
> Aren't we open coding krealloc() here?

I don't think krealloc() is appropriate since we don't know where the memory
comes from. The typical use I see is that the card struct is initialized as:

static const struct snd_soc_dapm_route foo_intercon[] = {
	{ "MUX1", "Loop", "IN1" },
	{ "MUX1", "Mixer", "MIX1" },

	{ "MIX1", NULL, "DAC" },
	{ "MIX1", "IN1 Switch", "IN1" },

	{ "Line Out Jack", NULL, "MUX1" },
};

static struct snd_soc_card foo_card = {
	.name = "foo",
	.owner = THIS_MODULE,
	.dapm_routes = foo_intercon,
	.num_dapm_routes = ARRAY_SIZE(foo_intercon),
	/* etc */
};

If that's the case, krealloc() seems dead wrong. On the other hand, if
snd_soc_of_parse_audio_routing() were to be called many times, a lot
of devm_kzalloc()ed memory would be kept dangling. I don't expect a card
to call snd_soc_of_parse_audio_routing() more than once though...

Cheers,
Peter

