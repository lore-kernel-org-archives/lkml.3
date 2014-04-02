Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbaDBCLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 22:11:54 -0400
Received: from mail-pb0-f73.google.com ([209.85.160.73]:43473 "EHLO
	mail-pb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaDBCLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 22:11:52 -0400
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net> <20140331170546.3b3e72f0.akpm@linux-foundation.org> <1396371699.25314.11.camel@buesod1.americas.hpqcorp.net> <CAHGf_=qsf6vN5k=-PLraG8Q_uU1pofoBDktjVH1N92o76xPadQ@mail.gmail.com> <1396377083.25314.17.camel@buesod1.americas.hpqcorp.net> <CAHGf_=rLLBDr5ptLMvFD-M+TPQSnK3EP=7R+27K8or84rY-KLA@mail.gmail.com> <1396386062.25314.24.camel@buesod1.americas.hpqcorp.net> <CAHGf_=rhXrBQSmDBJJ-vPxBbhjJ91Fh2iWe1cf_UQd-tCfpb2w@mail.gmail.com> <20140401142947.927642a408d84df27d581e36@linux-foundation.org> <CAHGf_=p70rLOYwP2OgtK+2b+41=GwMA9R=rZYBqRr1w_O5UnKA@mail.gmail.com> <20140401144801.603c288674ab8f417b42a043@linux-foundation.org> <CAHGf_=r5AUu6yvJgOzwYDghBo6iT2q+nNumpvqwer+igcfChrA@mail.gmail.co> <xr937g78k06y.fsf@gthelen.mtv.corp.google.com> <533B6EC0.10303@jp.fujitsu.com>
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Greg Thelen <gthelen@google.com>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
In-reply-to: <533B6EC0.10303@jp.fujitsu.com>
Date: Tue, 01 Apr 2014 19:11:51 -0700
Message-ID: <xr9361msjx94.fsf@gthelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, Apr 01 2014, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

>> On Tue, Apr 01 2014, Davidlohr Bueso <davidlohr@hp.com> wrote:
>> 
>>> On Tue, 2014-04-01 at 19:56 -0400, KOSAKI Motohiro wrote:
>>>>>>> Ah-hah, that's interesting info.
>>>>>>>
>>>>>>> Let's make the default 64GB?
>>>>>>
>>>>>> 64GB is infinity at that time, but it no longer near infinity today. I like
>>>>>> very large or total memory proportional number.
>>>>>
>>>>> So I still like 0 for unlimited. Nice, clean and much easier to look at
>>>>> than ULONG_MAX. And since we cannot disable shm through SHMMIN, I really
>>>>> don't see any disadvantages, as opposed to some other arbitrary value.
>>>>> Furthermore it wouldn't break userspace: any existing sysctl would
>>>>> continue to work, and if not set, the user never has to worry about this
>>>>> tunable again.
>>>>>
>>>>> Please let me know if you all agree with this...
>>>>
>>>> Surething. Why not. :)
>>>
>>> *sigh* actually, the plot thickens a bit with SHMALL (total size of shm
>>> segments system wide, in pages). Currently by default:
>>>
>>> #define SHMALL (SHMMAX/getpagesize()*(SHMMNI/16))
>>>
>>> This deals with physical memory, at least admins are recommended to set
>>> it to some large percentage of ram / pagesize. So I think that if we
>>> loose control over the default value, users can potentially DoS the
>>> system, or at least cause excessive swapping if not manually set, but
>>> then again the same goes for anon mem... so do we care?
>> 
> (2014/04/02 10:08), Greg Thelen wrote:
>> 
>> At least when there's an egregious anon leak the oom killer has the
>> power to free the memory by killing until the memory is unreferenced.
>> This isn't true for shm or tmpfs.  So shm is more effective than anon at
>> crushing a machine.
>
> Hm..sysctl.kernel.shm_rmid_forced won't work with oom-killer ?
>
> http://www.openwall.com/lists/kernel-hardening/2011/07/26/7
>
> I like to handle this kind of issue under memcg but hmm..tmpfs's limit is half
> of memory at default.

Ah, yes. I forgot about shm_rmid_forced.  Thanks.  It would give the oom
killer ability to cleanup shm (as it does with anon) when
shm_rmid_forced=1.
