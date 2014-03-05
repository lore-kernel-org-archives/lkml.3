Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbaCEDvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:51:39 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33070 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbaCEDvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:51:37 -0500
MIME-Version: 1.0
In-Reply-To: <53169123.4020909@lougher.demon.co.uk>
References: <20140228230017.GE14970@merlin.infradead.org> <20140303145137.70819698@tukaani.org>
 <CAGVrzcZ7KU-m9s9KgoigK+WdSqeqwEmm=_pY6qF=ep2vFp6WUg@mail.gmail.com>
 <20140304202038.03b36109@tukaani.org> <53169123.4020909@lougher.demon.co.uk>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 4 Mar 2014 19:50:56 -0800
Message-ID: <CAGVrzcYQ44fYA0kpRC84Qfe7v0vPGy+euWLfs8xF0XEMnsFmGA@mail.gmail.com>
Subject: Re: [PATCH] xz: make XZ_DEC_BCJ filters non-optional
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Lasse Collin <lasse.collin@tukaani.org>,
        Kyle McMartin <kyle@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-04 18:51 GMT-08:00 Phillip Lougher <phillip@lougher.demon.co.uk>:
> On 04/03/14 18:20, Lasse Collin wrote:
>> On 2014-03-03 Florian Fainelli wrote:
>>> 2014-03-03 4:51 GMT-08:00 Lasse Collin <lasse.collin@tukaani.org>:
>>>> The second version enables the BCJ filter only for the current arch
>>>> by default if CONFIG_EXPERT; without CONFIG_EXPERT all filters are
>>>> forced on:
>>>
>>> I like this version better because it still provides you with accurate
>>> defaults (i.e: enable only th X86 BCJ filter decoder where it makes
>>> sense by default) and still provides enough flexibility.
>>
>> I understand your viewpoint, but different people probably consider
>> different options as "accurate defaults". The current behavior certainly
>> isn't very accurate; otherwise Kyle McMartin wouldn't have had a reason
>> to send a patch. The patch you prefer would give both of you the
>> defaults you want *if* embedded devs always use CONFIG_EXPERT and
>> non-embedded people never do. If a non-embedded dev uses CONFIG_EXPERT,
>> then Kyle's problem can reappear.
>>
>
> CONFIG_EMBEDDED was renamed CONFIG_EXPERT a couple of years
> ago because it was being used by more than embedded people.  As
> such I'd be wary adding an option which relied on the original
> meaning.
>
> http://lwn.net/Articles/421304/
>
>
>> I still think it is clearest to enable all by default and allow
>> deselecting filters if CONFIG_EXPERT. That way the default selection
>> doesn't change behind anyone's back when CONFIG_EXPERT is selected.
>> I guess embedded devs go through the config carefully looking for
>> things to deselect anyway, but maybe it was easy to miss these options
>> just like some desktop users have missed them now.
>>
>> I'd like to make the defaults such that minimum number of people get
>> annoyed in the long term. There will always be people who will need to
>> change the options (otherwise options wouldn't be needed). At the same
>> time this is so very tiny issue that I don't expect many people to care
>> at all.
>>
>> I'll submit some patch this week but I'll wait for more opinions for a
>> day or two. Thanks.
>>
>
> As Kyle should know Redhat hit this problem with Squashfs a while back,
> and it was I who identified the config changes as the culprit
> (BTW Kyle you should have CC'd me on the patch as a courtesy).
> The bug is only viewable by Redhat employees (disclaimer, I'm
> also a Redhat employee), and so I'll say no more.
>
> But speaking as the Squashfs author, the lack of BCJ support for
> an architecture creates a subtle failure mode in Squashfs, this is
> because not all blocks in a Squashfs filesystem get compressed
> with a BCJ filter.  At compression time each block is compressed
> without any BCJ filter, and then with the BCJ filter(s) selected on
> the command line, and the best compression for *that* block is
> chosen.  What this means is kernels without a particular
> BCJ filter can still read the Squashfs metadata (mount, ls etc.) and
> read many of the files, it is only some files that mysteriously
> fail with decompression error.  As such this will be (and has been)
> invariably treated as a bug in Squashfs.
>
> Moreover, without expert knowledge of Squashfs, and the config
> options, most people will not have a clue how to fix the issue.
>
> This is why I prefer the first option, which is to reinstate
> the enabling of all filters by default, and then to allow people
> to remove the filters they don't want.
>
> BTW there is a potential additional fix for Squashfs that will
> make its handling of (lack of) BCJ filters more intelligent
> at mount time, but this of course only addresses Squashfs,
> and it relies on an additional call into XZ being added.  The
> BCJ filters specified at filesystem creation are stored in the
> compression options part of the superblock, and are known at
> mount time.  Squashfs should check that these filters are
> supported by the kernel and refuse to mount it otherwise.  This
> has not been done because AFAIK there is no way to query XZ to
> determine which BCJ filters are supported (beyond passing it a
> test stream which is too messy).
>
> If this call was added, I would be happy to add a patch to Squashfs
> to do this.

I am okay with enabling all filters by default as long as there is a
knob to allow turning achitecture specific BCJ filters off, as it
barely makes sense for embedded systems to have a BCJ filter
implementation for anything but the architecture you are running on.

It does make sense for a desktop use-case like what Kyle describes in
his initial patch. What you describes sounds like there is room for
improvements though instead of silently failing...

Thanks
-- 
Florian
