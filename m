Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaKJTvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:51:37 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33943 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751316AbaKJTvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:51:36 -0500
Date: Mon, 10 Nov 2014 19:51:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>, Liam Girdwood <lgirdwood@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ASoC: Remove 'const' from the device_node pointers
Message-ID: <20141110195122.GY4042@n2100.arm.linux.org.uk>
References: <cover.1415562021.git.moinejf@free.fr>
 <d5d74f6993e9f2392008a27a2938c58d47dc8062.1415562021.git.moinejf@free.fr>
 <20141110193704.GL3815@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110193704.GL3815@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 07:37:04PM +0000, Mark Brown wrote:
> On Sun, Nov 09, 2014 at 08:33:45PM +0100, Jean-Francois Moine wrote:
> 
> > index 7ba7130..405f967 100644
> > --- a/include/sound/soc.h
> > +++ b/include/sound/soc.h
> > @@ -886,7 +886,7 @@ struct snd_soc_platform_driver {
> >  
> >  struct snd_soc_dai_link_component {
> >  	const char *name;
> > -	const struct device_node *of_node;
> > +	struct device_node *of_node;
> >  	const char *dai_name;
> >  };
> >  
> 
> The changelog talked about of_node_put() but I'm not seeing anything in
> the code which calls that except snd_soc_of_get_dai_name()?  Everything
> else just does comparisons of the pointer AFIACT from a quick scan
> through.

I think it comes from these files (from a previous patch from Jean
adding a load of inappropriate const's to places where they do not
belong):

 sound/soc/generic/simple-card.c       | 7 ++-----
 sound/soc/samsung/odroidx2_max98090.c | 4 ++--
 sound/soc/ux500/mop500.c              | 6 ++----

That patch was trying to do this to those three files:

-               np = (struct device_node *) dai_link->cpu_of_node;
-               of_node_put(np);
-               np = (struct device_node *) dai_link->codec_of_node;
-               of_node_put(np);
+               of_node_put(dai_link->cpu_of_node);
+               of_node_put(dai_link->codec_of_node);
...
-       of_node_put((struct device_node *)odroidx2_dai[0].cpu_of_node);
-       of_node_put((struct device_node *)odroidx2_dai[0].codec_of_node);
+       of_node_put(odroidx2_dai[0].cpu_of_node);
+       of_node_put(odroidx2_dai[0].codec_of_node);
...
                if (mop500_dai_links[i].cpu_of_node)
-                       of_node_put((struct device_node *)
-                               mop500_dai_links[i].cpu_of_node);
+                       of_node_put(mop500_dai_links[i].cpu_of_node);
                if (mop500_dai_links[i].codec_of_node)
-                       of_node_put((struct device_node *)
-                               mop500_dai_links[i].codec_of_node);
+                       of_node_put(mop500_dai_links[i].codec_of_node);

having made of_node_put() take a const pointer.  Since of_node_put()
ultimately modifies the data pointed to by that pointer, making its
argument "const" is incorrect.

Moreover, Jean's latest patch is absolutely the right thing to do.
Had he quoted me fully, then the reason would become clear.

struct device_node is a ref-counted structure.  That means if you
store a reference to it, you should "get" it, and you should "put"
it once you've done.  The act of "put"ing the pointed-to structure
involves writing to that structure, so it is totally unappropriate
to store a device_node structure as a const pointer.  It forces you
to have to cast it back to a non-const pointer at various points
in time to use various OF function calls.

So, what you have is a pointer that you would /like/ to be const, but
ultimately you violate its const-ness at some point in time when you
need to call of_node_put() on it.  So it isn't really const at all.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
