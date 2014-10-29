Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbaJ2JRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:17:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:15087 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbaJ2JRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:17:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,808,1406617200"; 
   d="scan'208";a="598204753"
Message-ID: <5450B0B8.2060804@linux.intel.com>
Date: Wed, 29 Oct 2014 11:17:44 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:33.0) Gecko/20100101 SeaMonkey/2.30
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>, m.chehab@samsung.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, crope@iki.fi,
        olebowle@gmx.com, dheitmueller@kernellabs.com, hverkuil@xs4all.nl,
        ramakrmu@cisco.com, laurent.pinchart@ideasonboard.com, perex@perex.cz,
        tiwai@suse.de, prabhakar.csengg@gmail.com, tim.gardner@canonical.com,
        linux@eikelenboom.it
CC: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] media token resource framework
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1413246370.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah and others,

Shuah Khan wrote:
> Add media token device resource framework to allow sharing
> resources such as tuner, dma, audio etc. across media drivers
> and non-media sound drivers that control media hardware. The
> Media token resource is created at the main struct device that
> is common to all drivers that claim various pieces of the main
> media device, which allows them to find the resource using the
> main struct device. As an example, digital, analog, and
> snd-usb-audio drivers can use the media token resource API
> using the main struct device for the interface the media device
> is attached to.
>
> This patch series consists of media token resource framework
> and changes to use it in dvb-core, v4l2-core, au0828 driver,
> and snd-usb-audio driver.
>
> With these changes dvb and v4l2 can share the tuner without
> disrupting each other. Used tvtime, xawtv, kaffeine, and vlc,
> vlc audio capture option, arecord/aplay during development to
> identify v4l2 vb2 and vb1 ioctls and file operations that
> disrupt the digital stream and would require changes to check
> tuner ownership prior to changing the tuner configuration.
> vb2 changes are made in the v4l2-core and vb1 changes are made
> in the au0828 driver to encourage porting drivers to vb2 to
> advantage of the new media token resource framework with changes
> in the core.

I know this comes quite late after the first patch series has been sent, 
but I'd like to ask if you have you considered a different approach: 
rather than implementing something entirely new, the Media controller 
can almost do this already. It models the physical layout of the device, 
instead of creating special use case specific Media entity like 
constructs for tuner and audio. Also the Media token framework does not 
appear to be as a perfect match for the Media controller framework which 
is also planned to be used by DVB already:

<URL:http://linuxtv.org/news.php?entry=2014-10-21.mchehab>; look for "3) 
DVB API improvements". There have been ALSA MC patches as well but I'm 
not aware of the status of those at the moment.

The tokens appear much like media entities of specific kind to me.

Currently, media entities may only be entities bound to a given 
subsystem, but I don't think it has to (or perhaps even may) stay that way.

In case of the Media controller, mutual exclusion of different users is 
currently performed by adding the entities to a pipeline and 
incrementing the streaming count once streaming is enabled --- on 
different interfaces streaming may mean a different thing.

The Media controller interface does not handle serialising potential 
users that may wish to configure the device. If that's needed then we'll 
need to think how to add it.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
