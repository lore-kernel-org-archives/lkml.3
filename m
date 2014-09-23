Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbaIWUqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:46:24 -0400
Received: from lists.s-osg.org ([54.187.51.154]:37278 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaIWUqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:46:22 -0400
Message-ID: <5421DC1A.4030509@osg.samsung.com>
Date: Tue, 23 Sep 2014 14:46:18 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sakari.ailus@linux.intel.com, ramakrmu@cisco.com,
        Devin Heitmueller <dheitmueller@kernellabs.co>, olebowle@gmx.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 2/5] media: v4l2-core changes to use media tuner token
 api
References: <cover.1411397045.git.shuahkh@osg.samsung.com> <b83cf780636a80aec53e3b7e8f101645049e94f3.1411397045.git.shuahkh@osg.samsung.com> <CAGoCfizUWx-RrRbtuv7ctTqZskmDPK-w9bRTnEwjwn6oJ=V48g@mail.gmail.com> <54208A03.2010101@osg.samsung.com> <CAGoCfix8BH0coq2q-ndvBvDHGJ6f28mVE0CzAnMZYgCaPg+yrw@mail.gmail.com>
In-Reply-To: <CAGoCfix8BH0coq2q-ndvBvDHGJ6f28mVE0CzAnMZYgCaPg+yrw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Devin/Mauro/Hans,

Summarizing the discussion on v4l to keep others on this
thread in the loop. Please see below:

Hans! Could you please take a look and see if it raises
any red flags for you.

On 09/23/2014 08:17 AM, Devin Heitmueller wrote:

> 
> We can always start with coarse locking on open/close, and do finer
> grained locking down the road if needed - or simply change the
> currently undefined behavior in the spec to say that you have to close
> the device handle before attempting to open the other side of the
> device.
> 

I share the same concerns about fine grain locking approach that
requires changes to various v4l2 ioctls to hold the token. My
concern with the current approach is that we won't be able to find
all the v4l paths to secure. During my testing, it is clear that
several applications don't seem to check ioctls return codes and
even if one of the ioctls returns -EBUSY, applications keep calling
other ioctls instead of exiting with device busy condition.

Compared to the current approach, holding lock in open and releasing
it in close is cleaner with predictable failure conditions. It is lot
easier to maintain. In addition, this approach keeps it same as the
dvb core token hold approach as outlined below.

dvb on the other hand is easier with its clean entry and exit points.
In the case of dvb, the lock is held when the device is opened in
read/write mode before dvb front-end thread gets started and released
when thread exits.

I discussed this a couple of times in the past during development
for this current patch series. The concern has been that a number of
currently supported use-cases will break with the simpler approach
to lock when v4l device is opened and unlock when it is closed.

As we discussed this morning and agreed on giving the simpler
approach a try first keeping the finer grain locking option
open for revisit. This would be acceptable provided the token
code is tested on existing apps, including mythtv, kradio,
gnome-radio.

In addition to releasing the token at device close, release the token
if an app decides to use S_PRIORITY to release the streaming ownership
e. g. V4L2_PRIORITY_BACKGROUND

Devin recommended testing on devices that have an encoder to cover
the cases where there are multiple /dev/videoX nodes tied to the
same tuner.

Please check if I captured it correctly. I can get started on the
simpler approach and see where it takes us. I have to change the
v4l2 and driver v4l2 patches. dvb and the rest can stay the same.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
