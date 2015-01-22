Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbbAVPAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:00:19 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:51024 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbbAVPAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:00:16 -0500
MIME-Version: 1.0
In-Reply-To: <CA+V-a8uzfcyhO0vA2Jxg8YJYrHtk_b0skhN4kGCwO81X9yF--w@mail.gmail.com>
References: <cover.1421115389.git.shuahkh@osg.samsung.com>
	<9642c73eb38234cd69059c4a64bfde5205d637c2.1421115389.git.shuahkh@osg.samsung.com>
	<CA+V-a8uzfcyhO0vA2Jxg8YJYrHtk_b0skhN4kGCwO81X9yF--w@mail.gmail.com>
Date: Thu, 22 Jan 2015 10:00:16 -0500
Message-ID: <CAGoCfiw4Sehjk0_7KWo3tQZabn1w8nVM+8WTgY2sSkL0FSZWOQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] media: au0828 - convert to use videobuf2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        laurent pinchart <laurent.pinchart@ideasonboard.com>,
        ttmesterr <ttmesterr@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -       fh->type = type;
>> -       fh->dev = dev;
>> -       v4l2_fh_init(&fh->fh, vdev);
>> -       filp->private_data = fh;
>> +       dprintk(1,
>> +               "%s called std_set %d dev_state %d stream users %d users %d\n",
>> +               __func__, dev->std_set_in_tuner_core, dev->dev_state,
>> +               dev->streaming_users, dev->users);
>>
>> -       if (mutex_lock_interruptible(&dev->lock)) {
>> -               kfree(fh);
>> +       if (mutex_lock_interruptible(&dev->lock))
>>                 return -ERESTARTSYS;
>> +
>> +       ret = v4l2_fh_open(filp);
>> +       if (ret) {
>> +               au0828_isocdbg("%s: v4l2_fh_open() returned error %d\n",
>> +                               __func__, ret);
>> +               mutex_unlock(&dev->lock);
>> +               return ret;
>>         }
>> +
>>         if (dev->users == 0) {
>
> you can use v4l2_fh_is_singular_file() and get rid of users member ?

That won't work because the underlying resources are shared between
/dev/videoX and /dev/vbiX device nodes.  Hence if you were to move to
v4l2_fh_is_singular_file(), the video device would get opened, the
stream would get reset, the VBI device would get opened, and that
would cause the analog stream to get enabled/reset *again*.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
