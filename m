Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbaHAUBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:01:46 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:36259 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaHAUBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:01:44 -0400
MIME-Version: 1.0
In-Reply-To: <CA+rthh_L1_9FoSg7HsjSjVkG_HQNCWLgzp3q1-jBrxt_FMOpdw@mail.gmail.com>
References: <1402866165-17408-1-git-send-email-minipli@googlemail.com>
	<CA+rthh-CYWjUCji4GXNeZV5CcLd3_DNaV9zFDc_DznYbyw6T+A@mail.gmail.com>
	<CAPM=9tyAmEQq9CZn9FFOxLbE7J9TMkTMu=XHEnzaRFBBByDyew@mail.gmail.com>
	<CA+rthh9w4Tj-b9m=jeCBcGP4E8X9ssVLGom=TmYT=9-4e_nmkw@mail.gmail.com>
	<CA+rthh_L1_9FoSg7HsjSjVkG_HQNCWLgzp3q1-jBrxt_FMOpdw@mail.gmail.com>
Date: Fri, 1 Aug 2014 22:01:43 +0200
Message-ID: <CA+rthh8NnsVsa+DFmqfagqGy9G0uPCjsZ7CWNVg1cu9yYYfXMw@mail.gmail.com>
Subject: Re: [PATCH] agp: remove read/write stubs
From: Mathias Krause <minipli@googlemail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: David Airlie <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 July 2014 21:50, Mathias Krause <minipli@googlemail.com> wrote:
> On 9 July 2014 08:52, Mathias Krause <minipli@googlemail.com> wrote:
>> On 9 July 2014 00:48, Dave Airlie <airlied@gmail.com> wrote:
>>> On 2 July 2014 16:15, Mathias Krause <minipli@googlemail.com> wrote:
>>>> On 15 June 2014 23:02, Mathias Krause <minipli@googlemail.com> wrote:
>>>>> The VFS layer handles those in the very same way, if unset. No need for
>>>>> additional stubs.
>>>>>
>>>>> Signed-off-by: Mathias Krause <minipli@googlemail.com>
>>>>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>>>>> ---
>>>>>  drivers/char/agp/frontend.c |   15 ---------------
>>>>>  1 file changed, 15 deletions(-)
>>>>>
>>>>> diff --git a/drivers/char/agp/frontend.c b/drivers/char/agp/frontend.c
>>>>> index b29703324e..09f17eb734 100644
>>>>> --- a/drivers/char/agp/frontend.c
>>>>> +++ b/drivers/char/agp/frontend.c
>>>>> @@ -710,19 +710,6 @@ static int agp_open(struct inode *inode, struct file *file)
>>>>>         return 0;
>>>>>  }
>>>>>
>>>>> -
>>>>> -static ssize_t agp_read(struct file *file, char __user *buf,
>>>>> -                       size_t count, loff_t * ppos)
>>>>> -{
>>>>> -       return -EINVAL;
>>>>> -}
>>>>> -
>>>>> -static ssize_t agp_write(struct file *file, const char __user *buf,
>>>>> -                        size_t count, loff_t * ppos)
>>>>> -{
>>>>> -       return -EINVAL;
>>>>> -}
>>>>> -
>>>>>  static int agpioc_info_wrap(struct agp_file_private *priv, void __user *arg)
>>>>>  {
>>>>>         struct agp_info userinfo;
>>>>> @@ -1047,8 +1034,6 @@ static const struct file_operations agp_fops =
>>>>>  {
>>>>>         .owner          = THIS_MODULE,
>>>>>         .llseek         = no_llseek,
>>>>> -       .read           = agp_read,
>>>>> -       .write          = agp_write,
>>>>>         .unlocked_ioctl = agp_ioctl,
>>>>>  #ifdef CONFIG_COMPAT
>>>>>         .compat_ioctl   = compat_agp_ioctl,
>>>>> --
>>>>> 1.7.10.4
>>>>>
>>>>
>>>> Ping. Any objections, comments? David?
>>>
>>> Are you sure VFS handles this the same way? can you point me where it
>>> checks ->read and returns -EINVAL, I'm probably just missing it in my
>>> quick look over fs/read_write.c
>>
>> The VFS code changed during the last merge window so the ->read and
>> ->write tests are no longer directly visible. The presence of a ->read
>> / ->write function is now remembered at open(2) time and stored in
>> ->f_mode as a flag.
>>
>> The corresponding commit for the VFS change is 7f7f25e82d "replace
>> checking for ->read/->aio_read presence with check in ->f_mode".
>> Despite its subject, it also handles ->write / ->aio_write. The flags
>> are set in fs/open:do_dentry_open():
>>
>>     if ((f->f_mode & FMODE_READ) &&
>>          likely(f->f_op->read || f->f_op->aio_read || f->f_op->read_iter))
>>         f->f_mode |= FMODE_CAN_READ;
>>     if ((f->f_mode & FMODE_WRITE) &&
>>          likely(f->f_op->write || f->f_op->aio_write || f->f_op->write_iter))
>>         f->f_mode |= FMODE_CAN_WRITE;
>>
>> With that change in mind, the redundancy of the agp_read() and
>> agp_write() functions can be seen for read(2) in vfs_read():
>>
>>     if (!(file->f_mode & FMODE_CAN_READ))
>>         return -EINVAL;
>>
>> ..and for write(2) in vfs_write():
>>
>>     if (!(file->f_mode & FMODE_CAN_WRITE))
>>         return -EINVAL;
>>
>> The other entry points (readv / writev / compat wrappers) have been
>> changed accordingly, so those handle a missing ->read / ->write
>> callback in the same way: returning -EINVAL.
>>
>> Regards,
>> Mathias
>
> Ping. Any more comments, David?

Ping, ping. David, did you had time to look at the patch again?

Regards,
Mathias
