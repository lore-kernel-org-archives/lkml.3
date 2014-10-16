Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaJPOjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 10:39:39 -0400
Received: from lists.s-osg.org ([54.187.51.154]:40941 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbaJPOj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:39:28 -0400
Message-ID: <543FD89E.70106@osg.samsung.com>
Date: Thu, 16 Oct 2014 08:39:26 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: m.chehab@samsung.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, crope@iki.fi, olebowle@gmx.com,
        dheitmueller@kernellabs.com, hverkuil@xs4all.nl, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        perex@perex.cz, prabhakar.csengg@gmail.com, tim.gardner@canonical.com,
        linux@eikelenboom.it, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] media: add media token device resource framework
References: <cover.1413246370.git.shuahkh@osg.samsung.com> <c8bae1d475b1086302fcb83bc463ec01437c3f95.1413246372.git.shuahkh@osg.samsung.com> <s5h8ukhw9eu.wl-tiwai@suse.de> <543F1708.1040303@osg.samsung.com> <s5h4mv4w1wc.wl-tiwai@suse.de>
In-Reply-To: <s5h4mv4w1wc.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2014 08:00 AM, Takashi Iwai wrote:
> At Wed, 15 Oct 2014 18:53:28 -0600,
> Shuah Khan wrote:
>>
>> On 10/15/2014 11:05 AM, Takashi Iwai wrote:
>>
>>>> +#if defined(CONFIG_MEDIA_SUPPORT)
>>>> +extern int media_tknres_create(struct device *dev);
>>>> +extern int media_tknres_destroy(struct device *dev);
>>>> +
>>>> +extern int media_get_tuner_tkn(struct device *dev);
>>>> +extern int media_put_tuner_tkn(struct device *dev);
>>>> +
>>>> +extern int media_get_audio_tkn(struct device *dev);
>>>> +extern int media_put_audio_tkn(struct device *dev);
>>>
>>> The words "tknres" and "tkn" (especially latter) look ugly and not
>>> clear to me.  IMO, it should be "token".
>>
>> No problem. I can change that to media_token_create/destroy()
>> and expand token in other functions.
>>
>>>> +struct media_tkn {
>>>> +	spinlock_t lock;
>>>> +	unsigned int owner;	/* owner task pid */
>>>> +	unsigned int tgid;	/* owner task gid */
>>>> +	struct task_struct *task;
>>>> +};
>>>> +
>>>> +struct media_tknres {
>>>> +	struct media_tkn tuner;
>>>> +	struct media_tkn audio;
>>>> +};
>>>
>>> Why do you need to have both tuner and audio tokens?  If I understand
>>> correctly, no matter whether it's tuner or audio, if it's being used,
>>> the open must fail, right?
>>
>> As it evolved during development, it turns out at the moment I don't
>> have any use-cases that require holding audio and tuner separately.
>> It probably could be collapsed into just a media token. I have to
>> think about this some.
>>
>>>> +
>>>> +static int __media_get_tkn(struct media_tkn *tkn, char *tkn_str)
>>>> +{
>>>> +	int rc = 0;
>>>> +	unsigned tpid;
>>>> +	unsigned tgid;
>>>> +
>>>> +	spin_lock(&tkn->lock);
>>>
>>> You should use spin_lock_irqsave() here and in all other places.
>>> The trigger callback in usb-audio, for example, may be called in irq
>>> context.
>>
>> ok. Good point, will change that.
>>
>>>
>>>> +
>>>> +	tpid = task_pid_nr(current);
>>>> +	tgid = task_tgid_nr(current);
>>>> +
>>>> +	/* allow task in the same group id to release */
>>>
>>> IMO, it's not "release" but "steal"...  But what happens if the stolen
>>> owner calls put?  Then it'll be released although the stealing owner
>>> still thinks it's being held.
>>
>> Yeah it could be called a steal. :) Essentially tgid happens to be
>> the real owner. I am overwriting the pid with current pid when
>> tgid is same.
>>
>> media dvb and v4l apps start two or more threads that all share the
>> tgid and subsequent token gets should be allowed based on the tgid.
>>
>> Scenario 1:
>>
>> Please note that there are 3 device files in question and media
>> token resource is the lock for all. Hence the changes to v4l-core,
>> dvb-core, and snd-usb-audio to hold the token for exclusive access
>> when the task or tgid don't match.
>>
>> program starts:
>> - first thread opens device file in R/W mode - open gets the token
>>   or thread makes ioctls calls that clearly indicates intent to
>>   change tuner settings
>> - creates one thread for audio
>> - creates another for video or continues video function
>> - video thread does a close and re-opens the device file
>>
>>   In this case when thread tries to close, token put fails unless
>>   tasks with same tgid are allowed to release.
>>   ( I ran into this one of the media applications and it is a valid
>>     case to handle, thread can close the file and should be able to
>>     open again without running into token busy case )
>>
>> - or continue to just use the device file
>> - audio thread does snd_pcm_capture ops - trigger start
>>
>> program exits:
>> - video thread closes the device file
>> - audio thread does snd_pcm_capture ops - trigger stop
>>
>> This got me thinking about the scenario when an application
>> does a fork() as opposed to create a thread. I have to think
>> about this and see how I can address that.
>>
>>>
>>>> +	if (tkn->task && ((tkn->task != current) && (tkn->tgid != tgid))) {
>>>
>>> Shouldn't the second "&&" be "||" instead?
>>> And too many parentheses there.
>>
>> Right - this is my bad. The comment right above this conditional
>> is a give away that, at some point I did a copy and paste from
>> _put to _get and only changed the first task null check.
>> I am yelling at myself at the moment.
>>
>>>
>>>> +			rc = -EBUSY;
>>>
>>> Wrong indentation.
>>
>> Yes. Will fix that.
>>
>>>
>>> I have a feeling that the whole thing can be a bit more simplified in
>>> the end...
>>>
>>
>> Any ideas to simplify are welcome.
> 
> There are a few points to make things more consistent and simplified,
> IMO.  First of all, the whole concept can be more generalized.  It's
> not necessarily only for media and audio.  Rather we can make it a
> generic dev_token.  Then it'll become more convincing to land into
> lib/*.

Right. At the moment this is very media specific.

> 
> The media-specific handling is only about the pid and gid checks.
> This can be implemented as a callback that is passed at creating a
> token, for example.  This will reduce the core code in lib/*.
> 
> Also, get and put should handle a proper refcount.  The point I
> mentioned in my previous post is the possible unbalance, and you'll
> see unexpected unlock in the scenario.  In addition, with use of kref,
> the lock can be removed.

Yes. kref would eliminate the need for locks and potential for
unbalanced scenario.

> 
> So, essentially the lib code would be just a devres_alloc() for an
> object with kref, and dev_token_get() will take a kref with the
> exclusion check.
> 

I considered callback for media specific handling to make this token
construct generic. Talked myself out of it with the idea to get this
working for media use-case first and then extend it to be generic.

With this patch set covering media cases including non-media driver,
I think I am confident that the approach itself works to address the
issues and I don't mind pursuing a generic approach you are suggesting.
The current work isn't that far off and I can get the generic working
without many changes.

Thanks again for talking through the problem and ideas.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
