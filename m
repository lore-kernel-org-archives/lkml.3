Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726AbaJ2LTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:19:19 -0400
Received: from lists.s-osg.org ([54.187.51.154]:42423 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932300AbaJ2LTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:19:17 -0400
Date: Wed, 29 Oct 2014 09:19:08 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        alsa-devel@alsa-project.org, Lars-Peter Clausen <lars@metafoo.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sander Eikelenboom <linux@eikelenboom.it>, prabhakar.csengg@gmail.com,
        Antti Palosaari <crope@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        "olebowle@gmx.com" <olebowle@gmx.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFCv1] Media Token API needs - Was: Re: [alsa-devel] [PATCH v2
 5/6] sound/usb: pcm changes to use media token api
Message-ID: <20141029091908.14c4856f@recife.lan>
In-Reply-To: <20141028220051.68a8ab6e@recife.lan>
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
	<cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com>
	<543FB374.8020604@metafoo.de>
	<543FC3CD.8050805@osg.samsung.com>
	<s5h38aow1ub.wl-tiwai@suse.de>
	<543FD1EC.5010206@osg.samsung.com>
	<s5hy4sgumjo.wl-tiwai@suse.de>
	<543FD892.6010209@osg.samsung.com>
	<s5htx34ul3w.wl-tiwai@suse.de>
	<54467EFB.7050800@xs4all.nl>
	<s5hbnp5z9uy.wl-tiwai@suse.de>
	<CAGoCfixD-zv1MMHUXLnjGV5KVB-DGdp2ZqZ0hUTR14UvLh-Gvw@mail.gmail.com>
	<544804F1.7090606@linux.intel.com>
	<20141025114115.292ff5d2@recife.lan>
	<s5hk33n8ccj.wl-tiwai@suse.de>
	<20141027105237.5f5ec7fd@recife.lan>
	<5450077F.70101@osg.samsung.com>
	<20141028214250.27f0c869@recife.lan>
	<20141028220051.68a8ab6e@recife.lan>
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 28 Oct 2014 22:00:51 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Tue, 28 Oct 2014 21:42:50 -0200
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
> 
> > Before starting with the description, this is the simplified diagram of
> > a media device (without IR, eeprom and other beasts):
> 
> As reference, a more complete diagram would be:

An even more complete (but still simplified) diagram is shown at:
	http://linuxtv.org/downloads/presentations/typical_hybrid_hardware.png

The dot lines represent the parts of the graph that are switched by
the tuner, DMA or input select.

Please notice that the DMA engines, together with the stuff needed to
control A/V switches is at one single chip. Changing the registers there
can affect the other streams, specially on most sophisticated devices like
cx231xx, where it even has a power management IP block that validades if
a device to be turned on/off won't exceed the maximum drain current of
500mA. That's basically why we need to do a temporary lock alsa, dvb, v4l
and IR drivers when doing certain changes.

Also, please notice that I2C buses that can be as slow as 10kbps 
are used to control for several devices, like:
	- the tuner
	- the Digital TV (DTV) demod
	- Analog and/or Video demod (sometimes embedded at the main chip)
	- DTV demux (sometimes embedded at the main chip)
	- The remote controller (sometimes embedded at the main chip)

For some devices, after powered on, or when certain parameters change, a
new firmware (and sometimes a hardware reset) is required. The firmware
size can be about 64KB or even bigger.

Also, the A/V switch it is actually two independent switches (or one
switch for video and one audio mux for audio) that needs to be changed 
together when the source changes.

Regards,
Mauro

For those curious enough or that are using mutt/pine this is the graph,
in text mode, manually adjusted to fit into 80 cols, and with a link
added by hand, as graph-easy failed to represent everything on this
graph:

                                              +------------------+
                                              |        IR        |
                                              +------------------+
                                                |
                                                |
                                                v
                                              +------------------+
                                              |  IR POLL or DMA  |
                                              +------------------+
                                                |
                                                |
                                                v
                                              +------------------+
                                              |  devnode input8  |
                                              +------------------+

                           ..................................................
                           :                                                :
                           :              +-------------+-----------+---------+
                           :              |  digital    |   tuner   | analog  |
                           :              +-------------+-----------+---------+
                           :                :
                           :                : DTV IF
                           :                : off on A/V
                           :                v
                           :              +------------------+
                           :              |    DTV demod     |
                           :              +------------------+
                           :                |
                           :                | MPEG-TS
                           :                | off on A/V
                           :                v
                           :              +------------------+
                           :              |      demux       |
                           :              +------------------+
                           :                |
                           :                | MPEG-TS
                           :                | off on A/V
                           :                v
                           :  +---------------+---------+-------------+
                           :  |    dvb        |   DMA   |    analog   | <----+
                           :  +---------------+---------+-------------+      |
                           :    :                          :                 |
                           :    : MPEG-TS     Video stream :    Video stream | 
                           :    : off on A/V    off on DTV :      off on DTV |
                           :    v                          v                 |
                           :  +------------------+       +----------------+  |
                ATV IF     :  |                  |       |                |  |
                off on DTV :  |   devnode dvr0   |       | devnode video0 |  |
          off on Composite :  |                  |       |                |  |
                           :  +------------------+       +----------------+  |
                           :                                                 |
                      +----+-------------------------------------------------+
                      |    v
+-------------+       |  +---------+------------+-----------+     +-----------+
| video demod | ------+  |  tuner  | A/V switch | composite | <-- | comp. src |
+-------------+          +---------+------------+-----------+     +-----------+
        ^                               :      :
        :                               :      : Audio IF
        .................................      : off on DTV
               Video IF                        v
               off on DTV                    +------------------+
                                             |   audio demod    |
                                             +------------------+
                                                |
                                                | Audio stream
                                                | off on DTV
                                                v
                                              +------------------+
                                              |    audio DMA     |
                                              +------------------+
                                                |
                                                | Audio stream
                                                | off on DTV
                                                v
                                              +------------------+
                                              | devnode pcmC1D0c |
                                              +------------------+

And this is the dot file to produce it:

digraph media_hardware {
  node [shape=record]
  DMA1[label = "<dvb> dvb | <dma> DMA | <video> analog"]
  DMA2[label = "audio DMA"]
  DMA3[label = "IR POLL or DMA"]
  tuner[label = "<digital> digital | <tuner> tuner | <analog> analog"]
  input[label = "<tuner> tuner | <switch> A/V switch | <composite> composite"]

  "composite src" -> input:composite

  DMA1:video -> "devnode video0" [style=dotted label="Video stream\noff on DTV"]
  DMA1:dvb -> "devnode dvr0" [style=dotted label="MPEG-TS\noff on A/V"]

  "demux" -> DMA1:dvb [label="MPEG-TS\noff on A/V"]
  "video demod" -> DMA1:video [label="Video stream\noff on DTV"]

  tuner:digital -> "DTV demod" [style=dotted label="DTV IF\noff on A/V"]
  "DTV demod" -> "demux" [label="MPEG-TS\noff on A/V"]
  tuner:analog -> input:tuner [style=dotted label="ATV IF\noff on DTV\noff on Composite"]

  input:switch -> "video demod" [style=dotted label="Video IF\noff on DTV"]
  input:switch -> "audio demod" [style=dotted label="Audio IF\noff on DTV"]

  "audio demod" -> DMA2  [label="Audio stream\noff on DTV"];
  DMA2 -> "devnode pcmC1D0c" [label="Audio stream\noff on DTV"];

  IR -> DMA3
  DMA3 -> "devnode input8"
}
