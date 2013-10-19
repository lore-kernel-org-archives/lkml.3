Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3JSQKq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 12:10:46 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64645 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3JSQKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 12:10:45 -0400
MIME-Version: 1.0
In-Reply-To: <5262641C.5050406@gmail.com>
References: <hverkuil@xs4all.nl> <1381736489-27852-1-git-send-email-ricardo.ribalda@gmail.com>
 <526256F5.1060404@gmail.com> <CAPybu_0NxSS2CyPL7sv0NOn8_1HcPPBsWyqV6Hi2=b7oRezKYQ@mail.gmail.com>
 <5262641C.5050406@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Sat, 19 Oct 2013 18:10:24 +0200
Message-ID: <CAPybu_3o7rRcTpa7yeDMYUQKoDjKQC=y==D04ynOajo8tT5qsg@mail.gmail.com>
Subject: Re: [PATCH] videobuf2: Add missing lock held on vb2_fop_relase
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sylwester

I have just posted a new version. Please take a look to it, it should
fix your issue.

I havent tried it in hw because I am out of the office.

Regards!

On Sat, Oct 19, 2013 at 12:51 PM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 10/19/2013 12:22 PM, Ricardo Ribalda Delgado wrote:
>>
>> On Sat, Oct 19, 2013 at 11:55 AM, Sylwester Nawrocki
>> <sylvester.nawrocki@gmail.com>  wrote:
>>>
>>> >  On 10/14/2013 09:41 AM, Ricardo Ribalda Delgado wrote:
>>>
>>>> >>
>>>> >>  vb2_fop_relase does not held the lock although it is modifying the
>>>> >>  queue->owner field.
>>>
>>> >  [...]
>>>>
>>>> >>  diff --git a/drivers/media/v4l2-core/videobuf2-core.c
>>>> >>  b/drivers/media/v4l2-core/videobuf2-core.c
>>>> >>  index 9fc4bab..3a961ee 100644
>>>> >>  --- a/drivers/media/v4l2-core/videobuf2-core.c
>>>> >>  +++ b/drivers/media/v4l2-core/videobuf2-core.c
>>>> >>  @@ -2588,8 +2588,15 @@ int vb2_fop_release(struct file *file)
>>>> >>           struct video_device *vdev = video_devdata(file);
>>>> >>
>>>> >>           if (file->private_data == vdev->queue->owner) {
>>>> >>  +               struct mutex *lock;
>>>> >>  +
>>>> >>  +               lock = vdev->queue->lock ? vdev->queue->lock :
>>>> >> vdev->lock;
>>>> >>  +               if (lock)
>>>> >>  +                       mutex_lock(lock);
>>>> >>                   vb2_queue_release(vdev->queue);
>>>> >>                   vdev->queue->owner = NULL;
>>>> >>  +               if (lock)
>>>> >>  +                       mutex_unlock(lock);
>>>> >>           }
>>>> >>           return v4l2_fh_release(file);
>>>> >>     }
>>>
>>> >
>>> >
>>> >  It seems you didn't inspect all users of vb2_fop_release(). There are
>>> > 3
>>> >  drivers
>>> >  that don't assign vb2_fop_release() to struct v4l2_file_operations
>>> > directly
>>> >  but
>>> >  instead call it from within its own release() handler. Two of them do
>>> > call
>>> >  vb2_fop_release() with the video queue lock already held.
>>> >
>>> >  $ git grep -n vb2_fop_rel -- drivers/media/
>>> >
>>> >  drivers/media/platform/exynos4-is/fimc-capture.c:552:   ret =
>>> >  vb2_fop_release(file);
>>> >  drivers/media/platform/exynos4-is/fimc-lite.c:549:
>>> > vb2_fop_release(file);
>>> >
>>
>>
>> Very good catch, thanks!
>>
>>> >  A rather ugly solution would be to open code the vb2_fop_release()
>>> > function
>>> >  in those driver, like in below patch (untested). Unless there are
>>> > better
>>> >  proposals I would queue the patch as below together with the $subject
>>> > patch
>>> >  upstream.
>>
>>
>> IMHO this will lead to the same type of mistakes in the future.
>>
>>   What about creating a function __vb2_fop_release that does exactly
>> the same as the original function but with an extra parameter bool
>> lock_held
>>
>> vb2_fop_release will be a wrapper for that funtion with lock_held== false
>
>
> Hmm, the parameter would be telling whether the lock is already held ?
> Perhaps
> we should inverse its meaning and it should indicate whether
> vb2_fop_release()
> should be taking the lock internally ? It seems to me more straightforward.
>
>
>> drivers that overload the fop_release and need to hold the lock will
>> call the __ function with lock_held= true
>>
>> What do you think?
>
>
> I was also considering this, it's probably better. I'm not sure about
> exporting
> functions prefixed with __ though. And the locking becomes less clear with
> such
> functions proliferation.
>
> Anyway, I'm in general personally OK with having an additional version like:
>
> __vb2_fop_release(struct file *filp, bool lock);
>
>
> Regards,
> Sylwester



-- 
Ricardo Ribalda
