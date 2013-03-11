Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab3CKIMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:12:12 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:34388 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab3CKIMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:12:09 -0400
MIME-Version: 1.0
In-Reply-To: <CADZ9YHgcsTg4OGt7dRbhNAqDHWCAHNrAwJMpRjG2poStE+H-eA@mail.gmail.com>
References: <20130307132819.GA31162@localhost>
	<87sj47t97s.fsf@xmission.com>
	<CADZ9YHhbvu8WYUMdDtpvkrZmLCD87fQ0Y0AcXdBaQB53=uPYYw@mail.gmail.com>
	<87d2v9q3sk.fsf@xmission.com>
	<CADZ9YHhPq7aWwmyBoEt+CsGnKfKTeZN1bCT-LtwtJxUaHGwJ=g@mail.gmail.com>
	<877glhkm6b.fsf@xmission.com>
	<CADZ9YHgcsTg4OGt7dRbhNAqDHWCAHNrAwJMpRjG2poStE+H-eA@mail.gmail.com>
Date: Mon, 11 Mar 2013 14:12:08 +0600
Message-ID: <CADZ9YHiQXZ7=CxkW-b99FZvEQSirWB=wGHKwo6b2Y+Se+6wKAg@mail.gmail.com>
Subject: Re: [nsproxy] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000024
From: Rakib Mullick <rakib.mullick@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 9, 2013 at 10:48 PM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On Sat, Mar 9, 2013 at 2:33 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Rakib Mullick <rakib.mullick@gmail.com> writes:
>>
>>> On Fri, Mar 8, 2013 at 10:01 PM, Eric W. Biederman
>>> <ebiederm@xmission.com> wrote:
>>>>
>>>> When a new task is created one of two things needs to happen.
>>>> A) A reference count needs to be added to the current nsproxy.
>>>> B) B a new nsproxy needs to be created.
>>>>
>>>> The way that code works today is far from a shiny example of totally
>>>> clear code but it is not incorrect.
>>>>
>>>> By moving get_nsproxy down below the first return 0, you removed taking
>>>> the reference count in the one case it is important.
>>>>
>>>> Arguably we should apply the patch below for clarity, and I just might
>>>> queue it up for 3.10.
>>>>
>>> This one is much more cleaner. One thing regarding this patch, can we
>>> check the namespace related flags at copy_namespace() call time at
>>> copy_process(), also get_nsproxy()? I think this will reduce some
>>> extra function call overhead and as you've mentioned get_nsproxy() is
>>> needed at every process creation.
>>
>> If you can write a benchmark that can tell the difference, and the code
>> continues to be readable.  It would be worth making the change.
>>
>> My gut says you are proposing an optimization that won't have
>> a measurable impact.
>>
> Yes, it'll be hard to measure these sorts of optimization, though I'll
> try and will tell you if the impact is measurable :).
>
Well, it's quite certain that - the changes I've proposed that don't
have much noticable impact. From this tiny
changes we can't expect too much impact. The tinyest possible impact
could be on at every task creation path by
reducing some latency. So, to find it out I took the help of ftrace -
I used it's function_graph option with set_graph_function set to
do_fork.

So currently, at every task creation copy_namespaces() gets called and
it costs some like below (few snippet from ftrace log):

 3)   0.025 us    |        try_module_get();
 3) ! 887.805 us  |      } /* dup_mm */
 3)   0.278 us    |      copy_namespaces(); <------
 3)   0.094 us    |      copy_thread();

 3)   0.264 us    |      copy_namespaces(); <-----
 3)   0.091 us    |      copy_thread();

 3)   0.306 us    |      copy_namespaces();  <-----
 3)   0.086 us    |      copy_thread();

etc. copy_namespaces() just returns here.

On the otherhand, when namespace related flags are moved to
kernel/fork.c::copy_process(), copy_namespaces() never gets called
until flags are set.

So, this is what I did manage to get. If you're not convinced, then
you can drop it. But, we can't expect much than this for this simple
changes.

Thanks,
Rakib.
