Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbaIVUnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:43:52 -0400
Received: from lists.s-osg.org ([54.187.51.154]:37104 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbaIVUnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:43:50 -0400
Message-ID: <54208A03.2010101@osg.samsung.com>
Date: Mon, 22 Sep 2014 14:43:47 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>,
        m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
        gregkh@linuxfoundation.org, sakari.ailus@linux.intel.com,
        ramakrmu@cisco.com, dheitmueller@kernellabs.co, olebowle@gmx.com,
        akpm@linux-foundation.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 2/5] media: v4l2-core changes to use media tuner token
 api
References: <cover.1411397045.git.shuahkh@osg.samsung.com> <b83cf780636a80aec53e3b7e8f101645049e94f3.1411397045.git.shuahkh@osg.samsung.com> <CAGoCfizUWx-RrRbtuv7ctTqZskmDPK-w9bRTnEwjwn6oJ=V48g@mail.gmail.com>
In-Reply-To: <CAGoCfizUWx-RrRbtuv7ctTqZskmDPK-w9bRTnEwjwn6oJ=V48g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Devin,

On 09/22/2014 01:21 PM, Devin Heitmueller wrote:
> Hi Shuah,
> 
> What about G_INPUT and G_TUNER?  Consider the following use case, which is
> entirely legal in the V4L2 API:

Did you mean G_INPUT and G_STD here? I didn't see G_TUNER mentioned
below in the use-case.

I didn't know this use-case, I did notice ENUM_INPUT getting called
in a loop during testing. I think I didn't run into this because I
changed the au0828: vidioc_g_tuner to hold the lock as it does a tuner
init and messes up the tuner when it is in use by dvb. But, that doesn't
cover this use-case for other drivers. So I need to make more changes
to cover it. Thanks for pointing this out.

> 
> 1.  Program opens /dev/video0
> 2.  Program calls G_INPUT/G_STD and sees that the appropriate input and
> standard are already set, since all devices have a default input at
> initialization
> 3.  Program never calls S_INPUT, S_STD, or S_TUNER
> 4.  Program goes into a loop calling ENUM_INPUT, waiting until it returns
> the input as having signal lock
> 5.  When signal lock is seen, program calls STREAMON.

I am missing vb2 streamon change to hold the tuner in this patch set.
Without that change vb2 work isn't complete. Unfortunately I don't
have hybrid hardware that uses a vb2 driver.

> 
> In the above case, you would be actively using the au8522 video decoder but
> not holding the lock, so thr DVB device can be opened and screw everything
> up.  Likewise if the DVB device were in use and such a program were run, it
> wouls break.
> 

I think this use-case will be covered with changes to vb2 streamon
to check and hold tuner. I am thinking it might not be necessary to
change g_tuner, g_std, g_input and enum_input at v4l2-core level.
Does that sounds right??

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
