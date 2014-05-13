Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaEMRen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 13:34:43 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:53293 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaEMReg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 13:34:36 -0400
Message-ID: <537257A9.3070504@gmail.com>
Date: Tue, 13 May 2014 19:34:33 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
CC: mtk.manpages@gmail.com, Eric Paris <eparis@redhat.com>,
        Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v2] fanotify: check file flags passed in fanotify_init
References: <1399921336-6433-1-git-send-email-xypron.glpk@gmx.de> <CAKgNAkjd=faKp8-QroLHXDOk00tKYxvAzm0xZV4PjYLNO+3_Ew@mail.gmail.com> <5372535B.5030503@gmx.de>
In-Reply-To: <5372535B.5030503@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 07:16 PM, Heinrich Schuchardt wrote:
> On 13.05.2014 10:25, Michael Kerrisk (man-pages) wrote:
>> Hello Heinrich
>>
>> On Mon, May 12, 2014 at 9:02 PM, Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
>>> Without this patch fanotify_init does not validate the value passed in
>>> event_f_flags.
>>>
>>> When a fanotify event is read from the fanotify file descriptor a new file
>>> descriptor is created where file.f_flags = event_f_flags.
>>>
>>> Internal and external open flags are stored together in field f_flags of
>>> struct file. Hence, an application might create file descriptors with
>>> internal flags like FMODE_EXEC, FMODE_NOCMTIME set.
>>>
>>> Jan Kara and Eric Paris both aggreed that this is a bug and the value of
>>> event_f_flags should be checked:
>>> https://lkml.org/lkml/2014/4/29/522
>>> https://lkml.org/lkml/2014/4/29/539
>>>
>>> This updated patch version considers the comments by Michael Kerrisk in
>>> https://lkml.org/lkml/2014/5/4/10
>>>
>>> With the patch the value of event_f_flags is checked.
>>> When specifying an invalid value error EINVAL is returned.
>>>
>>> Internal flags are disallowed.
>>>
>>> File creation flags are disallowed:
>>> O_CREAT, O_DIRECTORY, O_EXCL, O_NOCTTY, O_NOFOLLOW, O_TRUNC, and O_TTY_INIT.
>>>
>>> Flags which do not make sense with fanotify are disallowed:
>>> __O_TMPFILE, O_PATH, FASYNC, and O_DIRECT.
>>>
>>> This leaves us with the following allowed values:
>>>
>>> O_RDONLY, O_WRONLY, O_RDWR are basic functionality. The are stored in the
>>> bits given by O_ACCMODE.
>>>
>>> O_APPEND is working as expected. The value might be useful in a logging
>>> application which appends the current status each time the log is opened.
>>>
>>> O_LARGEFILE is needed for files exceeding 4GB on 32bit systems.
>>>
>>> O_NONBLOCK may be useful when monitoring slow devices like tapes.
>>>
>>> O_NDELAY is equal to O_NONBLOCK except for platform parisc.
>>> To avoid code breaking on parisc either both flags should be
>>> allowed or none. The patch allows both.
>>>
>>> __O_SYNC and O_DSYNC may be used to avoid data loss on power disruption.
>>>
>>> O_NOATIME may be useful to reduce disk activity.
>>>
>>> O_CLOEXEC may be useful, if separate processes shall be used to scan files.
>>>
>>> Once this patch is accepted, the fanotify_init.2 manpage has to be updated.
>>>
>>> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
>>> ---
>>>   fs/notify/fanotify/fanotify_user.c | 25 +++++++++++++++++++++++++
>>>   1 file changed, 25 insertions(+)
>>>
>>> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
>>> index d42220f..31b0de2 100644
>>> --- a/fs/notify/fanotify/fanotify_user.c
>>> +++ b/fs/notify/fanotify/fanotify_user.c
>>> @@ -25,6 +25,19 @@
>>>   #define FANOTIFY_DEFAULT_MAX_MARKS     8192
>>>   #define FANOTIFY_DEFAULT_MAX_LISTENERS 128
>>>
>>> +/*
>>> + * All flags that may be specified in parameter event_f_flags of fanotify_init.
>>> + *
>>> + * Internal and external open flags are stored together in field f_flags of
>>> + * struct file. Only external open flags shall be allowed in event_f_flags.
>>> + * Internal flags like FMODE_NONOTIFY, FMODE_EXEC, FMODE_NOCMTIME shall be
>>> + * excluded.
>>> + */
>>> +#define        FANOTIFY_INIT_ALL_EVENT_F_BITS                          ( \
>>> +               O_ACCMODE       | O_APPEND      | O_NONBLOCK    | \
>>> +               __O_SYNC        | O_DSYNC       | O_CLOEXEC     | \
>>> +               O_LARGEFILE     | O_NOATIME     )
>>> +
>>>   extern const struct fsnotify_ops fanotify_fsnotify_ops;
>>
>> The above looks okay to me, but I'd be happier seeing an Ack from Jan or Eric.
>>
>>>   static struct kmem_cache *fanotify_mark_cache __read_mostly;
>>> @@ -669,6 +682,18 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
>>>          if (flags & ~FAN_ALL_INIT_FLAGS)
>>>                  return -EINVAL;
>>>
>>> +       if (event_f_flags & ~FANOTIFY_INIT_ALL_EVENT_F_BITS)
>>> +               return -EINVAL;
>>> +
>>> +       switch (event_f_flags & O_ACCMODE) {
>>> +       case O_RDONLY:
>>> +       case O_RDWR:
>>> +       case O_WRONLY:
>>> +               break;
>>> +       default:
>>> +               return -EINVAL;
>>> +       }
>>> +
>>
>> The 'switch' could just be replaced by:
>>
>> if ((event_f_flags & O_ACCMODE) == 3)
>>          return -EINVAL;
>>
>> (But I'm not sure if some might prefer the idiom you have used.)
>>
>> Cheers,
>>
>> Michael
> 
> Using explicit numbers makes the code hard to read and analyze.
> I do not intend to participate in the Obfuscated C Code Contest.

I agree that using explicit numbers is odd, but '3" in this
context does have a special meaning (see open(2)), and it struck
me as a more efficient way of doing the check. But, if others
are fine with what you've written, I have no real problem with it.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
