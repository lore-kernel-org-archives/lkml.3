Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3ITUzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:55:39 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:57848
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754208Ab3ITUzg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:55:36 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zzbb2dI98dI9371I936eI1432I4015I853kzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de097h186068h8275dhz2fh2a8h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
Message-ID: <1379710523.21515.4.camel@atx-linux-37>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
From: Alan Tull <atull@altera.com>
To: Michal Simek <monstr@monstr.eu>
CC: Pavel Machek <pavel@denx.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Date: Fri, 20 Sep 2013 15:55:23 -0500
In-Reply-To: <523AD9C5.8060006@monstr.eu>
References: <cover.1379519753.git.michal.simek@xilinx.com>
	 <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
	 <20130918191517.GQ19937@titan.lakedaemon.net>
	 <20130918203247.GA11181@obsidianresearch.com>
	 <1379539063.31417.23.camel@atx-linux-37>
	 <20130919100833.GC19346@amd.pavel.ucw.cz> <523AD9C5.8060006@monstr.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-19 at 13:02 +0200, Michal Simek wrote:
> On 09/19/2013 12:08 PM, Pavel Machek wrote:
> > Hi!
> > 
> >> The firmware approach is interesting.  It might be less flexible
> >> compared with my original code (see link to git below) that this is
> > 
> > On the other hand... that's the interface world wants, right? To most
> > users, fpga bitstream is just a firmware.
> 
> It is one nice way how to get data from one place to another and
> it is easy to handle. Using different methods is also possible.
> 
> >> Is there some way a per-device userspace helper can be added that can
> >> handle adding the headers?  Such that different fpga types get different
> >> helpers?
> > 
> > https://www.kernel.org/doc/Documentation/firmware_class/README
> > 
> >  4), userspace:
> >      - hotplug: cat appropriate_firmware_image > \
> >        		    			       /sys/class/firmware/xxx/data
> > 
> > I assume udev's firmware.sh could be modified to add headers.
> > 
> > But... if same bitstream is expected to work across multiple FPGAs (is
> > it?) maybe kernel should hide that difference and provide headers
> > itself.
> 
> There could be a configuration where you want to load one bitstream
> to more fpgas with the same type. I can imagine this system and use cases.
> 
> Thanks,
> Michal
> 
> 
Hi Michael,

I have ported the altera fpga manager driver to work with your version
of the fpga manager framework.  It works fine if I use the
firmware_class.c's built-in support to load the firmware, but not with a
userspace helper.

I see my helper script get called, but I don't see 'loading' and 'data'
show up under /sys.  I have CONFIG_FW_LOADER_USER_HELPER=y enabled and
have done enough printf debugging to see that there was no failure in
creating the attributes as far as firmware_class.c is concerned.

More details:
I'm taking cues from Documentation/firmware_class here.
This is with the 3.11 kernel.
I have CONFIG_FW_LOADER_USER_HELPER=y enabled.
I have this udev rule:
SUBSYSTEM=="firmware", ACTION=="add", RUN+="/lib/udev/hotplug-script"
My hotplug-script is linux/Documentation/firmware_class/hotplug-script

What I am seeing when I request 'image.rbf' is that my hotplug-script
gets run with this DEVPATH set:
DEVPATH == /devices/soc.0/ff706000.fpgamgr/fpga/fpga0/image.rbf

I added debug to my hotplug-script and it could not find 'loading' or
'data' appearing under /sys anywhere when it got called.  According to
the firmware_class/README, these should appear under
/sys/class/firmware.  However according to the
firmware_class/hotplug-script, they should be under /sys/$DEVPATH.

When I look at firmware_class.c, that code wants these attributes
to show up under the firmware class.  Again, with printf debugging,
I don't see firmware_class.c being unhappy until it decides it has
timed out (which happens quickly).

I was wondering what behavior you were seeing with userspace helpers.

Alan



