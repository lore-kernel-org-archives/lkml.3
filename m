Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbaJ2ABF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 20:01:05 -0400
Received: from lists.s-osg.org ([54.187.51.154]:42360 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbaJ2ABC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 20:01:02 -0400
Date: Tue, 28 Oct 2014 22:00:51 -0200
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
Message-ID: <20141028220051.68a8ab6e@recife.lan>
In-Reply-To: <20141028214250.27f0c869@recife.lan>
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
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 28 Oct 2014 21:42:50 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Before starting with the description, this is the simplified diagram of
> a media device (without IR, eeprom and other beasts):

As reference, a more complete diagram would be:



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

                             +------------------------------------+
                             v                                    |
                           +----------------+          +-------+-------------------+-----------+
                           |  demod_video   |  +-----> | tuner |     A/V switch    | composite |
                           +----------------+  |       +-------+-------------------+-----------+
                             |                 |                  |
                             |                 |                  |
                             v                 |                  v
     +--------------+-----+-----------------+  |                +------------------+
  +- |     dvb      | DMA |      analog     |  |                |   demod_audio    |
  |  +--------------+-----+-----------------+  |                +------------------+
  |    ^                     |                 |                  |
  |    +---------------+     |                 |                  |
  |                    |     v                 |                  v
  |  +--------------+  |   +----------------+  |                +------------------+
  +> | devnode dvr0 |  |   | devnode video0 |  |                |    audio DMA     |
     +--------------+  |   +----------------+  |                +------------------+
                       |                       |                  |
                       |                       |                  |
                       |                       |                  v
                       |                       |                +------------------+
                       |                       |                | devnode pcmC1D0c |
                       |                       |                +------------------+
                       |                       |
                       |                       |
                       |                       |
                       |                     +--------+--------+-------------------+
                       |                     | analog |  tuner |      digital      |
                       |                     +--------+--------+-------------------+
                       |                                          |
                       |                                          |
                       |                                          v
                       |                                        +------------------+
                       +--------------------------------------- |  digital_demux   |
                                                                +------------------+

Regards,
Mauro

-

Dot file for the above diagram:

digraph media_hardware {
  node [shape=record]
  DMA1[label = "<dvb> dvb | <dma> DMA | <video> analog"]
  DMA2[label = "audio DMA"]
  DMA3[label = "IR POLL or DMA"]
  tuner[label = "<analog> analog | <tuner> tuner | <digital> digital"]
  input[label = "<tuner> tuner | <switch> A/V switch | <composite> composite"]

  DMA1:video -> "devnode video0"
  DMA1:dvb -> "devnode dvr0"

  "digital_demux" -> DMA1:dvb
  demod_video -> DMA1:video

  tuner:digital -> "digital_demux"
  tuner:analog -> input:tuner

  input:switch -> demod_video
  input:switch -> demod_audio

  demod_audio -> DMA2
  DMA2 -> "devnode pcmC1D0c"

  IR -> DMA3
  DMA3 -> "devnode input8"
}
