Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbbAWSf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:35:28 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:10934 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbbAWSf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:35:26 -0500
Date: Fri, 23 Jan 2015 19:34:56 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jyri Sarha <jsarha@ti.com>
Subject: Re: [alsa-devel] [PATCH v2 3/3] ASoC: add generic dt-card support
Message-ID: <20150123193456.276ea512@armhf>
In-Reply-To: <54C252F4.9000504@metafoo.de>
References: <cover.1421868426.git.moinejf@free.fr>
	<d0c66c2e2f200119f9990fa52a503b1a4af6238f.1421868426.git.moinejf@free.fr>
	<54C0088F.9070609@metafoo.de>
	<20150122090723.50ac0156@armhf>
	<54C14EB3.8080305@metafoo.de>
	<20150123131554.623003f9@armhf>
	<54C252F4.9000504@metafoo.de>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015 14:56:04 +0100
Lars-Peter Clausen <lars@metafoo.de> wrote:

> On 01/23/2015 01:15 PM, Jean-Francois Moine wrote:
> [...]
> > The DT should describe the hardware, and the simple-card mixes hardware
> > and software.
> > For example, the kirkwood controller may create 2 CPU DAIs. With the
> > simple-card, the DT contains a number to reference these DAIs (for
> > example, implicitly, <audio1 0> references the I2S output). So, what if
> > the controller creates only one DAI, or, what if the FreeBSD/OpenBSD/..
> > driver does not set the same references to these DAIs?
> > The graph of port fixes this problem.
> 
> Even with the simple-card bindings there are no software specific bits. The 
> DAI that is referenced in your example is the physical DAI as it exists in 
> the hardware. Which DAI maps to which specifier is defined in the devicetree 
> bindings definition for the hardware unit.

There is no first or second output in the kirkwood controller; there
are I2S and S/PDIF outputs. Their hardware controls are done by bits in
the different registers. Then, the driver may define its DAIs in any
order and assign any DAI ID to these DAIs. So, for a given DAI, there
is no relation between its type (I2s or S/PDIF), index in the dai
driver (= asoc component index) and ID.

In the simple-card DT, the CPU DAI (as the CODEC DAI) is referenced by
a phandle (the audio-controller) and a number which should identify the
DAI. This number is translated to a DAI name thanks to the function
snd_soc_get_dai_name(). This function scans the components and returns
the name of the DAI (component) supported by the audio controller with
the searched number equal to the component index (there is no 'xlate'
function).

So, with the simple-card, the CPU or CODEC DAI binding (phandle +
number) identifies what the software has put in its table, but not a
hardware entity.

> > More: a simple audio card may easily be created from a graph of ports
> > as the simple-card does, but by the audio-controller (sorry, I also
> > forgot the kirkwood patch for this in my previous patch request).
> > In case of complex cards, the links and properties of this graph may
> > also be used by board specific card devices.
> >
> >> One issue is how to deal with multi-point-to-multi-point links. I2S/TDM is a
> >> bus and can have more than one reader/writer.
> >>
> >> The second issue is how to describe the clock and frame master
> >> relationships. Multiple different buses can share the same clock and frame
> >> generator. E.g. typically the capture and playback stream are linked in this
> >> way.
> >
> > The ports and endpoints may contain properties to describe these
> > configurations. Complex cases should be handled by specific card
> > builders.
> 
> Could you describe in detail what a card builder is and how to decide when 
> and how a card builder is executed?

A card builder is a device which
- scans the graph of ports,
- fills the struct snd_soc_card according to the links between the
  ports and their properties,
- and, eventually, calls snd_soc_register_card().

The simple card builder, 'dt-card' (maybe a better name would have been
'graph-card'), acts just like the simple-card except that it does not
appear in the DT. Its creation is done by an audio controller.

For complex cards, a card builder would be the same as an actual card
driver, but with the capability to know about the board thanks to the
graph of ports. Its creation could be done by a compatible device in
the DT (as actually) or by the unique or a 'master' audio controller.

A card builder is subject to a PROBE_DEFER after calling
snd_soc_register_card(), so, when it is created by an audio controller,
this last one should have created its own resources.

An audio controller does the following:
- initialize the hardware and software,
- create the DAIs from:
	- the graph of ports or
	- default values
- register these DAIs and
- if the DAIs where created by a graph of port,
	create the card builder.

> > On the other hand, where would this information appear in the graph?
> > As I understood, on card creation, the widgets and routes, which appear
> > at the card level, redefine the CPU and CODEC DAI definitions.
> 
> What do you mean by "redefine the CPU and CODEC DAI definitions".
> 
> > 
> > With a DT graph, each CPU/CODEC would know exactly the widgets and
> > routes it has to define.
> 
> Which widgets/routes do you mean?

Well, forget about this. I never clearly understood why some widgets
and routes had to be defined at card level.

> >> Your example is a relative simple one where you do not have any additional
> >> audio fabric on the board itself.
> >
> > Right, and that's why I'd be glad to have quickly something in the
> > kernel. More properties could be added later as there would be requests.
> 
> I'd agree if this was some kind of kernel internal stuff, but this is 
> creating ABI and we have to maintain it forever. Rushing this in without 
> proper discussion and consideration of the more complex use-cases is in my 
> opinion not a good idea.

Using a graph of port to describe the audio subsystem has been pushed
forwards by many people for a long time, as shown by the creation of
the document Documentation/devicetree/bindings/graph.txt.

Anyway, I am also glad to have this discussion.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
