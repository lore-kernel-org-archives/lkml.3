Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaEEUAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:00:06 -0400
Received: from mail.siteground.com ([67.19.240.234]:52295 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaEEUAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:00:05 -0400
Message-ID: <5367EDB6.3010408@1h.com>
Date: Mon, 05 May 2014 22:59:50 +0300
From: Marian Marinov <mm@1h.com>
Organization: 1H Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr@hp.com>
CC: akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] IPC initialize shmmax and shmall from the current value
 not the default
References: <5365723D.7030303@1h.com> <1399161216.2573.9.camel@buesod1.americas.hpqcorp.net> <536621D4.60002@colorfullife.com>
In-Reply-To: <536621D4.60002@colorfullife.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mail.siteground.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 1h.com
X-Get-Message-Sender-Via: mail.siteground.com: none
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2014 02:17 PM, Manfred Spraul wrote:
> Hi Marian,
>
> Note: The limits will soon be increased to (nearly) ULONG_MAX.
> I.e.: If you propose the patch because you are running into issues with a too small SEMMAX after an
> unshare(CLONE_NEWIPC), then this will be fixed soon.
>
>
> On 05/04/2014 01:53 AM, Davidlohr Bueso wrote:
>> On Sun, 2014-05-04 at 01:48 +0300, Marian Marinov wrote:
>>> When we are creating new IPC namespace that should be cloned from the current namespace it is a good idea to copy the
>>> values of the current shmmax and shmall to the new namespace.
> The idea sounds reasonable:
> If an admin has reduced the limits, then the reduction should also apply after a unshare(CLONE_NEWIPC).
>
> But:
> Your patch doesn't use the current shmmax, it uses the shmmax from init_ipc_ns.
> Would it be possible to use the current values?

In my tests it worked exactly as expected.
Here is an example:

[root@sp2 ~]# sysctl -a|grep shmmax
kernel.shmmax = 68719476736
[root@sp2 ~]# lxc-attach -n cent_plain
[root@localhost ~]# sysctl -a|grep shmmax
kernel.shmmax = 68719476736
[root@localhost ~]# halt
[root@sp2 ~]# sysctl -a|grep shmmax
kernel.shmmax = 68719476736
[root@sp2 ~]# sysctl kernel.shmmax=34359738368
kernel.shmmax = 34359738368
[root@sp2 ~]# lxc-start -n cent_plain -d
[root@sp2 ~]# lxc-attach -n cent_plain
[root@localhost ~]# sysctl -a|grep shmmax
kernel.shmmax = 34359738368
[root@localhost ~]#

So it seams to work as expected :)

It works because wen you setup a new shmmax limit it is actually the limit in the init_ipc_ns.
So when we are creating a new ipc_ns its ok to copy the values from init_ipc_ns.

-Marian

>
>> Why is this a good idea?
>>
>> This would break userspace that relies on the current behavior.
>> Furthermore we've recently changed the default value of both these
>> limits to be as large as you can get, thus deprecating them. I don't
>> like the idea of this being replaced by namespaces.
> Davidlohr: We are not deprecating them, we make the default huge.
> The limits should stay as usable as they were.
>
> With regards to breaking user space, I must think about it a bit more.
> Right now, each new namespace starts with SEMMAX=32MB, i.e. an often unusable default.
>
> --
>      Manfred
>


-- 
Marian Marinov
Founder & CEO of 1H Ltd.
Jabber/GTalk: hackman@jabber.org
ICQ: 7556201
Mobile: +359 886 660 270
