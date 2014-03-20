Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716AbaCTT0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:26:10 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:35678 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaCTT0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:26:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
Date: Thu, 20 Mar 2014 20:27:55 +0100
Message-ID: <22904541.tzCZUcGtJB@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140320181820.GY7528@n2100.arm.linux.org.uk>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> <2161777.L3ZZmhyfM4@avalon> <20140320181820.GY7528@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Thursday 20 March 2014 18:18:20 Russell King - ARM Linux wrote:
> On Thu, Mar 20, 2014 at 07:16:29PM +0100, Laurent Pinchart wrote:
> > On Thursday 20 March 2014 17:54:31 Grant Likely wrote:
> > > On Wed, 12 Mar 2014 10:25:56 +0000, Russell King - ARM Linux wrote:
> > > > On Mon, Mar 10, 2014 at 02:52:53PM +0100, Laurent Pinchart wrote:
> > > > > In theory unidirectional links in DT are indeed enough. However,
> > > > > let's not forget the following.
> > > > > 
> > > > > - There's no such thing as single start points for graphs. Sure, in
> > > > > some simple cases the graph will have a single start point, but
> > > > > that's not a generic rule. For instance the camera graphs
> > > > > http://ideasonboard.org/media/omap3isp.ps and
> > > > > http://ideasonboard.org/media/eyecam.ps have two camera sensors, and
> > > > > thus two starting points from a data flow point of view.
> > > > 
> > > > I think we need to stop thinking of a graph linked in terms of data
> > > > flow - that's really not useful.
> > > > 
> > > > Consider a display subsystem.  The CRTC is the primary interface for
> > > > the CPU - this is the "most interesting" interface, it's the interface
> > > > which provides access to the picture to be displayed for the CPU. 
> > > > Other interfaces are secondary to that purpose - reading the I2C DDC
> > > > bus for the display information is all secondary to the primary
> > > > purpose of displaying a picture.
> > > > 
> > > > For a capture subsystem, the primary interface for the CPU is the
> > > > frame grabber (whether it be an already encoded frame or not.)  The
> > > > sensor devices are all secondary to that.
> > > > 
> > > > So, the primary software interface in each case is where the data for
> > > > the primary purpose is transferred.  This is the point at which these
> > > > graphs should commence since this is where we would normally start
> > > > enumeration of the secondary interfaces.
> > > > 
> > > > V4L2 even provides interfaces for this: you open the capture device,
> > > > which then allows you to enumerate the capture device's inputs, and
> > > > this in turn allows you to enumerate their properties.  You don't open
> > > > a particular sensor and work back up the tree.
> > > > 
> > > > I believe trying to do this according to the flow of data is just
> > > > wrong. You should always describe things from the primary device for
> > > > the CPU towards the peripheral devices and never the opposite
> > > > direction.
> > > 
> > > Agreed.
> > 
> > Absolutely not agreed. The whole concept of CPU towards peripherals only
> > makes sense for very simple devices and breaks as soon as the hardware
> > gets more complex. There's no such thing as CPU towards peripherals when
> > peripherals communicate directly.
> > 
> > Please consider use cases more complex than just a display controller and
> > an encoder, and you'll realize how messy not being able to parse the
> > whole graph at once will become. Let's try to improve things, not to make
> > sure to prevent support for future devices.
> 
> That's odd, I did.
> 
> Please draw some (ascii) diagrams of the situations you're saying this
> won't work for, because at the moment all I'm seeing is some vague
> hand-waving rather than anything factual that I can relate to.  Help
> us to actually _see_ the problem you have with this approach so we can
> understand it.

I've broken the diagram into pieces as it won't fit in 80 columns. Ports named 
by a capital letter enclosed in parentheses are connected together. 

Let's start with the on-board input paths, with an HDMI input connector and a 
camera sensor.

 ,-----------.      ,----------.
 | HDMI      |      | ADV7611  |
 | Connector | ---> | HDMI     | ---> (A)
 |           |      | Decoder  |
 `-----------'      `----------'

 ,-----------.
 | AR0331    |
 | Camera    | ---> (B)
 | Sensor    |
 `-----------'

We then get to the SoC.

      |
      |    ,-----------.      ,------------.
      |    | BT.656    |      | Test       |
(A) -[0]-> | Decoder   | ---> | Pattern    | ---> (C)
      |    |           |      | Generator  |
      |    `-----------'      `------------'
      |
      |    ,-----------.      ,------------.      ,------------.
      |    | CSI-2     |      |            |      | Test       |
(B) -[1]-> | Receiver  | ---> | Processing | ---> | Pattern    |  ---> (D)
      |    |           |  `   |            |      | Generator  |
      |    `-----------'  |   `------------'      `------------'
      |                   |   ,------------.
      |                   |   |            |      ,-----.
      | --SOC--           `-> | Statistics | ---> | DMA |
      |                       |            |      `-----'
      |                       `------------'

The blocks named Processing is made of

      ,------------.      ,------------.      ,-------------.
      | Faulty     |      | Bayer      |      | White       |
 ---> | Pixels     | ---> | to RGB     | ---> | Balance     | ---.
      | Correction |      | Conversion |      | Correction  |    |
      `------------'      `------------'      `-------------'    |
                                                                 |
 ,---------------------------------------------------------------'
 |
 |    ,------------.      ,------------.      ,-------------.
 |    | Gamma      |      | RGB to YUV |      | Image       |
 `--> | Correction | ---> | Conversion | ---> | Enhancement | --->
      |            |      |            |      |             |
      `------------'      `------------'      `-------------'

The two flows then go through a crossbar switch.

                                ,--------.
                                |        |      ,-----.
           ,-----------.     -> | Scaler | ---> | DMA |
           |           |   ,'   |        |      `-----'
           |     ,----[2] -     `--------'
 (C) ---> [0]---'      |
           |   `,-----[3] ----> (E)
 (D) ---> [1]--'       |
           |    `-----[4] -
           |           |   `--> (F)
           `-----------'

One of the video streams went to memory through DMA. The second one enters the 
compositor through a scaler, with two additional streams coming from memory.

                  ,------------.       ,--------------.
     ,-----.      | RGB to YUV |       |              |
     | DMA | ---> | Conversion | ---> [0]             |
     `-----'      |            |       |              |
                  `------------'       |              |
                  ,--------.           |              |
     ,-----.      |        |           |  Compositor  |
     | DMA | ---> | Scaler | -------> [1]            [3] ---> (G)
     `-----'      |        |           |              |
                  `--------'           |              |
                  ,--------.           |              |
                  |        |           |              |
     (E) -------> | Scaler | -------> [2]             |
                  |        |           |              |
                  `--------'           `--------------'

The remaining video capture stream and the video display stream exit the SoC 
and are output to HDMI connectors through HDMI encoders.

          |
          |    ,---------.      ,-----------.
          |    | ADV7511 |      | HDMI      |
    (G) -[2]-> | HDMI    | ---> | Output    |
          |    | Encoder |      | Connector |
          |    `---------'      `-----------'
          |
          |    ,---------.      ,-----------.
          |    | ADV7511 |      | HDMI      |
    (F) -[3]-> | HDMI    | ---> | Output    |
          |    | Encoder |      | Connector |
  --SOC-- |    `---------'      `-----------'
          |

Every block in this diagram (including the DMA engines) corresponds to a 
device instance and has a device node in the device tree.

Note how the same RGB to YUV conversion and scaler blocks are used in both 
capture and display pipelines, how the capture and display pipelines are 
merged at the hardware level, and how the same HDMI encoder is used for one 
video output that comes from the display device (G) and one video output that 
comes straight from the capture device (F).

I wish this was an example I made up instead of real hardware I need to 
support.

-- 
Regards,

Laurent Pinchart
