Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3FFHy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:54:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:12447 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab3FFHyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:54:54 -0400
X-IronPort-AV: E=Sophos;i="4.87,813,1363104000"; 
   d="scan'208";a="7477245"
Message-ID: <51B03FB0.80306@cn.fujitsu.com>
Date: Thu, 06 Jun 2013 15:52:16 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Namjae Jeon <linkinjeon@gmail.com>
CC: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: Re: [PATCH 1/2] f2fs: add remount_fs callback support
References: <1370071212-7715-1-git-send-email-linkinjeon@gmail.com> <51AD698F.3020305@cn.fujitsu.com> <CAKYAXd_jFuG00-HWQREKieXdqBGEAs+W0imvYZjCpGAH5S4H9A@mail.gmail.com>
In-Reply-To: <CAKYAXd_jFuG00-HWQREKieXdqBGEAs+W0imvYZjCpGAH5S4H9A@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/06 15:53:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/06 15:53:10,
	Serialize complete at 2013/06/06 15:53:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namjae,

On 06/05/2013 12:34 PM, Namjae Jeon wrote:

> 2013/6/4 Gu Zheng <guz.fnst@cn.fujitsu.com>:
>> On 06/01/2013 03:20 PM, Namjae Jeon wrote:
>>
>>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>>
>>> Add the f2fs_remount function call which will be used
>>> during the filesystem remounting. This function
>>> will help us to change the mount options specific to
>>> f2fs.
>>>
>>> Also modify the f2fs background_gc mount option, which
>>> will allow the user to dynamically trun on/off the
>>> garbage collection in f2fs based on the background_gc
>>> value. If background_gc=0, Garbage collection will
>>> be turned off & if background_gc=1, Garbage collection
>>> will be truned on.
>>
>>
>> Hi Namjae,
> Hi. Gu.
> 
>>   I think splitting these two changes into single ones seems better.
>> Refer to the inline comments.
> I don't think so. Mount option background_gc is changed to make
> remount_fs working in the correct way.

Yes, I know. Maybe you somewhat misread my words. 
Though remount_fs is dependent on changing background_gc option, but the change of background_gc option
and the adding remount_fs support are two different changes.
In order to make each patch simple and clear, maybe you need to split into single ones,
such as:
[PATCH 1/3] f2fs: Modify the f2fs background_gc mount option
[PATCH 2/3] f2fs: add remount_fs callback support
[PATCH 3/3] f2fs: reorganise the function get_victim_by_default

Just a personal suggestion, if you think it is worthless, please ignore it.:)


> 
>>
>> Thanks,
>> Gu
>>
>>
>> Though simply option show is enough, but I think the "background_gc=on/off" is more friendly.
> Yes, Agree. I will update.
> 
>>
>>> +
>>> +     /**
>>> +      * We stop the GC thread if FS is mounted as RO
>>> +      * or if background_gc = 0 is passed in mount
>>> +      * option. Also sync the filesystem.
>>> +      */
>>> +     if ((*flags & MS_RDONLY) || !test_opt(sbi, BG_GC)) {
>>
>>
>> Another condition: The old mount is not RO.
> I don't think that it is needed. I think current condition check can
> be covered about all cases.
> Am I missing something ?

Maybe. If the old mount is RO, so does the remount. It still can pass the judgement here, right?
Though the following stop_gc_thread() and f2fs_sync_fs() can handle this case well, but this
is unnecessary and needless. If we add additional judgement of whether old mount is not RO can avoid this.

Thanks,
Gu

> 
>>
>>> +             stop_gc_thread(sbi);
>>> +             f2fs_sync_fs(sb, 1);
>>> +     } else if (test_opt(sbi, BG_GC) && !sbi->gc_thread) {
>>> +             err = start_gc_thread(sbi);
>>> +             if (err)
>>> +                     goto restore_opts;
>>> +     }
>>> +
>>> +     /* Update the POSIXACL Flag */
>>> +      sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
>>> +             (test_opt(sbi, POSIX_ACL) ? MS_POSIXACL : 0);
>>
>>
>> Maybe you forget to update the flags with MS_RDONLY or ~MS_RDONLY, if the flags changed.
> No, we don't need to check this flags. sb-s_flags will be updated by
> MS_REMOUNT of vfs.(do_remount_sb)
> 
>>
>>> +     return 0;
>>> +
>>> +restore_opts:
>>> +     sb->s_flags = old_sb_flags;
>>
>>
>> There is no need to restore sb->s_flags, parse_options() did not change it.
>> no need to store the old sb->s_flags too.
> Yes, right, I will update.
> 
>>
>>>
>>> -     /* After POR, we can run background GC thread */
>>> -     err = start_gc_thread(sbi);
>>> -     if (err)
>>> -             goto fail;
>>> +     /* After POR, we can run background GC thread.*/
>>> +     if (!(sb->s_flags & MS_RDONLY)) {
>>> +             /**
>>> +              * If filesystem is mounted as read-only then
>>> +              * do not start the gc_thread.
>>> +              */
>>
>> It seems that the comment here is against with the logic.
> hum.. Okay, I will update comment to avoid some confusion.
> 
> Thanks for review :)
> I will post v2 patch including your opinion soon.
> 


