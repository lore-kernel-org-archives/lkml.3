Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaEETQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:16:52 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:20255 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaEETQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:16:50 -0400
X-AuditID: cbfec37a-b7fd76d000006048-66-5367e3a1cb54
Message-id: <5367E39E.7090401@samsung.com>
Date: Mon, 05 May 2014 13:16:46 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Tejun Heo <tj@kernel.org>
Cc: gregkh@linuxfoundation.org, m.chehab@samsung.com, olebowle@gmx.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 1/4] drivers/base: add managed token devres interfaces
References: <cover.1398797954.git.shuah.kh@samsung.com>
 <6cb20ce23f540c883e60e6ce71302042b034c4aa.1398797955.git.shuah.kh@samsung.com>
 <20140501145337.GC31611@htj.dyndns.org>
In-reply-to: <20140501145337.GC31611@htj.dyndns.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.11]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t9hP92Fj9ODDW4fkbVoXryezeLyrjls
	Fj0btrJaTLxbb/Fr+VFGB1aPu/cXMnlsWtXJ5rF/7hp2j8+b5AJYorhsUlJzMstSi/TtErgy
	+t4sYi84I1XxbP1D1gbGGaJdjJwcEgImEgsmLGCEsMUkLtxbz9bFyMUhJLCMUeLrr5lMEE4v
	k8TWvnvMEM4mRomD06YygbTwCmhJPFvxlA3EZhFQlfj87QBYnE1AXeLz6x3sILaQgJxE05LV
	QM0cHKICERKPLwhBtApK/Jh8jwXEFhGQlbgy7SHYFcwCKxglvv/RAikXFvCS+P8tGG7tqg+3
	wUZyAl29dNpGqHpriZWTtkHZ8hKb17xlhlirLPHn8ikmkDkSAooSv/67T2AUmYVk8ywk3bOQ
	dC9gZF7FKFZanFxQnJSeWmGoV5yYW1yal66XnJ+7iRESJ1U7GO98tTnEKMDBqMTDK349PViI
	NbGsuDL3EKMEB7OSCO+3+0Ah3pTEyqrUovz4otKc1OJDjEwcnFINjLEaCj8mVKVqrhVVNHWW
	Y4+9YxfZ7jw/VULwGnfjo0e777N90LuV5Fvce2eSQ0L/zccXjmtb713657z8N/uc2JxH2j7P
	Z9/sr3tuIdSke+64dIrnAt8eq+IKx9RO5rLJzLNXr77Pm3xw51YHtRb7FWmzy2cqX05XuCaw
	9OxXd6m5EkKf+fZuUGIpzkg01GIuKk4EAJRSTPNxAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 05/01/2014 08:53 AM, Tejun Heo wrote:

>> +	if (!mutex_trylock(&tkn_ptr->lock))
>> +		return -EBUSY;
>
> How is this lock supposed to be used?  Have you tested it with lockdep
> enabled?  Does it ever get released by a task which is different from
> the one which locked it?  If the lock ownership is really about driver
> association rather than tasks, it might be necessary to nullify
> lockdep protection and add your own annotation to at least track that
> unlocking driver (identified how? maybe impossible?) actually owns the
> lock.
>

This lock is associated with a driver. Let me describe the use-case,
so you have more information to help me head in the right direction.

Media devices have more than one function and one or more functions
share a function without being aware that they are sharing it. For
instance, USB TV stick that supports both analog and digital TV, tuner
is shared by both these functions. When tuner is in use by analog,
digital function should not be allowed to touch it. This a longterm
lockout. So when an analog driver is using the tuner, if digital
driver tries to access the tuner, it should know as early as possible,
at the time user application requests tuning to a digital channel.

The tuner hardware is protected by a mutex, however the longer path
isn't protected. The path I am trying to protect is the between the
time digital driver gets the request from user-space and gets ready
to service it. It starts a kthread to handle the digital stream. Once
user changes channel and/or stops the stream, the kthread is terminated
and the tuner usage ends. The path that token hold is needed starts
right before kthread gets started and ends when kthread exits. This is
just an example, and analog use-case hold might start and end at times
that makes more sense for that path.

There is the audio stream as well. On some cases, snd-audio-usb handles
the audio part. Audio stream has to be active only when video stream is
active. So having a token construct at struct device level will have it
be associated with the common data structure that is available to all
drivers that provide full support for a media device.

I started testing with a device that has both analog, digital, and uses
snd-usb-audio instead of a media audio driver. I am hoping this will
help me refine this locking construct and approach.

You are right that there is a need for an owner field to indicate who
has the token. Since the path is very long, I didn't want to use just
the mutex and keep it tied up for long periods of time. That is the
reason why I added in_use field that marks it in-use or free. I hold
the mutex just to change the token status. This is what you are seeing
on the the following path:

+ if (tkn_ptr->in_use)
+		rc = -EBUSY;
+	else
+		tkn_ptr->in_use = true;


Hope this description helps you get a full picture of what I am trying
to solve. Maybe there is a different approach that would work better
than the one I am proposing.

This new device I am testing with now presents all the use-cases that 
need addressing. So I am hoping to refine the approach and make course
corrections as needed with this device.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
