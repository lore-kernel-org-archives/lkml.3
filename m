Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaC0Edz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 00:33:55 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10821 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaC0Edx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 00:33:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 26 Mar 2014 21:29:44 -0700
From: Songhee Baek <sbaek@nvidia.com>
To: Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
CC: Arun Shamanna Lakshmi <aruns@nvidia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 26 Mar 2014 21:33:51 -0700
Subject: RE: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
Thread-Topic: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
Thread-Index: Ac9JWVrQGgcG2ndITtu7gRxcPofFOgAG2v2g
Message-ID: <D6C615D3E4730340AE82D5BD856631C0A26CB31A6B@HQMAIL02.nvidia.com>
References: <1395792156-4178-1-git-send-email-aruns@nvidia.com>
 <53332CC7.6060800@metafoo.de> <20140327010852.GA30768@sirena.org.uk>
In-Reply-To: <20140327010852.GA30768@sirena.org.uk>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: alsa-devel-bounces@alsa-project.org [mailto:alsa-devel-bounces@alsa-
> project.org] On Behalf Of Mark Brown
> Sent: Wednesday, March 26, 2014 6:09 PM
> To: Lars-Peter Clausen
> Cc: Songhee Baek; Arun Shamanna Lakshmi; alsa-devel@alsa-project.org;
> swarren@wwwdotorg.org; tiwai@suse.de; lgirdwood@gmail.com; linux-
> kernel@vger.kernel.org
> Subject: Re: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
> 
> * PGP Signed by an unknown key
> 
> On Wed, Mar 26, 2014 at 08:38:47PM +0100, Lars-Peter Clausen wrote:
> > On 03/26/2014 01:02 AM, Arun Shamanna Lakshmi wrote:
> 
> > The way you describe this it seems to me that a value array for this
> > kind of mux would look like.
> 
> > 0x00000000, 0x00000000, 0x00000001
> > 0x00000000, 0x00000000, 0x00000002
> > 0x00000000, 0x00000000, 0x00000003
> > 0x00000000, 0x00000000, 0x00000004
> > 0x00000000, 0x00000000, 0x00000008
> 
> > That seems to be extremely tedious. If the MUX uses a one hot encoding
> > how about storing the index of the bit in the values array and use (1
> > << value) when writing the value to the register?
> 
> Or hide it behind utility macros at any rate; I've got this horrible feeling that as
> soon as we have this people will notice that they have more standard enums
> that are splatted over multiple registers (I think from memory I've seen them
> but they got fudged).
> 
> > [...]
> > >  /* enumerated kcontrol */
> > >  struct soc_enum {
> 
> > There doesn't actually be any code that is shared between normal enums
> > and wide enums. This patch doubles the size of the soc_enum struct,
> > how about having a separate struct for wide enums?
> 
> Or if they are going to share the same struct then they shouldn't be duplicating
> the code and instead keying off num_regs (which was my first thought earlier
> on when I saw the separate functions).  We definitely shouldn't be sharing the
> data without also sharing the code I think.
> 
> > >-	int reg;
> > >+	int reg[SOC_ENUM_MAX_REGS];
> > >  	unsigned char shift_l;
> > >  	unsigned char shift_r;
> > >  	unsigned int items;
> > >-	unsigned int mask;
> > >+	unsigned int mask[SOC_ENUM_MAX_REGS];
> 
> > If you make mask and reg pointers instead of arrays this should be
> > much more flexible and not be limited to 3 registers.
> 
> Right, which pushes towards not sharing.  Though with an arrayified mask the
> specification by shift syntax would get to be slightly obscure (is it relative to the
> enums or the registers?) so perhaps we don't want to do that at all if we've got
> specification by shift.  If we do that then we could get away with a variable
> length array at the end of the struct though I think that may be painful for the
> static declarations.  Someone would need to look to see what works

Making a separate soc_enum_wide is a better way compared to using soc_enum for this use case. If we add a separate soc_enum_wide, we need to update the following functions : 
	dapm_connect_mux,
	soc_dapm_mux_update_power
	snd_soc_dapm_mux_update_power
These functions are using texts field in soc_enum struct, I think that we can pass texts pointer instead of soc_enum struct pointer. I want to know whether it is Ok to do this.

> 
> * Unknown Key
> * 0x7EA229BD
