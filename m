Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbaJXOpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:45:08 -0400
Received: from lists.s-osg.org ([54.187.51.154]:41966 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296AbaJXOpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:45:04 -0400
Message-ID: <544A65DE.40108@osg.samsung.com>
Date: Fri, 24 Oct 2014 08:44:46 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: alsa-devel@alsa-project.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Antti Palosaari <crope@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        "olebowle@gmx.com" <olebowle@gmx.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v2 5/6] sound/usb: pcm changes to use media
 token api
References: <cover.1413246370.git.shuahkh@osg.samsung.com> <cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com> <543FB374.8020604@metafoo.de> <543FC3CD.8050805@osg.samsung.com> <s5h38aow1ub.wl-tiwai@suse.de> <543FD1EC.5010206@osg.samsung.com> <s5hy4sgumjo.wl-tiwai@suse.de> <543FD892.6010209@osg.samsung.com> <s5htx34ul3w.wl-tiwai@suse.de> <54467EFB.7050800@xs4all.nl> <s5hbnp5z9uy.wl-tiwai@suse.de> <CAGoCfixD-zv1MMHUXLnjGV5KVB-DGdp2ZqZ0hUTR14UvLh-Gvw@mail.gmail.com> <544804F1.7090606@linux.intel.com> <CAGoCfiyQVY6Ss2qcp3aQijq3cP3BAM8X4yaCXRtx63dNNm-QKA@mail.gmail.com>
In-Reply-To: <CAGoCfiyQVY6Ss2qcp3aQijq3cP3BAM8X4yaCXRtx63dNNm-QKA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 01:45 PM, Devin Heitmueller wrote:
>> this seems like a feature, not a bug. PulseAudio starts streaming before
>> clients push any data and likewise keeps sources active even after for some
>> time after clients stop recording. Closing VLC in your example doesn't
>> immediately close the ALSA device. look for module-suspend-on-idle in your
>> default.pa config file.
> 
> The ALSA userland emulation in PulseAudio is supposed to faithfully emulate
> the behavior of the ALSA kernel ABI... except when it doesn't, then it's not
> a bug but rather a feature.  :-)
> 
>> I also agree that the open/close of the alsa device is the only way to
>> control exclusion.
> 
> I was also a proponent that we should have fairly coarse locking done
> at open/close for the various device nodes (ALSA/V4L/DVB).  The challenge here
> is that we have a large installed based of existing applications that
> rely on kernel
> behavior that isn't formally specified in any specification.  Hence
> we're forced to try
> to come up with a solution that minimizes the risk of ABI breakage.
> 
> If we were doing this from scratch then we could lay down some hard/fast rules
> about things apps aren't supposed to do and how apps are supposed to respond
> to those exception cases.  Unfortunately we don't have that luxury here.
> 

Sounds like we don't have a clear direction on open/close or capture
start/stop. What I am hearing is open/close isn't acceptable for
media maintainers and capture trigger start/stop isn't acceptable
to sound maintainers. :) Fork in the road, which way do we go?

Implementation wise, supporting capture trigger start/stop approach
will be harder to maintain in longterm. It adds more variables to
the mix. Applications open sounds device from the main thread and
then create a new thread to handle streams. I can see that based
on the token hold requests that come in. So the token hold logic
will have to take that into account, leading into potential
unbalanced lock/unlock scenarios. It is not impossible to solve,
that's what I did in this patch series, but it does get complex.

What I am looking for is some consensus on let's go with an approach
and try. Doesn't matter which way we go, and how much testing I do,
I am bound to miss something and this work needs to soak for a bit in
the media experimental branch.

thanks,
-- Shuah



-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
