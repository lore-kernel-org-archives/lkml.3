Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422755AbaDPQVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:21:25 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:52736 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422648AbaDPQVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:21:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140416152326.GG1257@htj.dyndns.org>
References: <1395937212-4103-1-git-send-email-laijs@cn.fujitsu.com>
	<5335661E.7030408@cn.fujitsu.com>
	<20140415164752.GC30990@htj.dyndns.org>
	<534DDBFC.9060803@cn.fujitsu.com>
	<20140416152326.GG1257@htj.dyndns.org>
Date: Thu, 17 Apr 2014 00:21:21 +0800
X-Google-Sender-Auth: LLej1_IFCjBhSXeO1obwnYVSmH0
Message-ID: <CACvQF532wtmegbNixch2zTGDmYoGoB4TFTHikw3dTNQPo7Gg2w@mail.gmail.com>
Subject: Re: [PATCH V2] workqueue: fix possible race condition when rescuer VS pwq-release
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 11:23 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Lai.
>
> On Wed, Apr 16, 2014 at 09:25:16AM +0800, Lai Jiangshan wrote:
>> 1) Our aim is to protect unbound pwq, not percpu pwq which can't be be protected by get_pwq().
>> 2) get_pwq() will make reviewers confused/surprised, destroy_workqueue() may destroy percpu pwqs
>>    with ref > 1. At least we need to add more comments explain this behavior. Origin comments:
>>               /*
>>                * The base ref is never dropped on per-cpu pwqs.  Directly
>>                * free the pwqs and wq.
>>                */

Hi, Tejun

OK. It is better to use get_pwq(). I will also change the above comments to:

  The base ref and the possible ref from rerscuer(stopped) are never
dropped on per-cpu pwqs.
  Directly free the pwqs and wq.

The reason I quickly dropped V1 and wrote the V2 is that I saw this comment.
"The base ref" is precise after I used get_pwq() in V1.

Or to avoid to change to this comments.
I can also move the following code down to the bottom of the rescuer_thread().

if (kthread_should_stop()) {
__set_current_state(TASK_RUNNING);
rescuer->task->flags &= ~PF_WQ_WORKER;
return 0;
}

(I reply this email on browser, never mind the syntax).
Maybe the second choice are better.

Any think?

Thanks,
Lai.

>
> You can just comment "pwqs might go away at any time, pin it until
> rescuer is done with it" and that's actually the better way to do it.
> percpu wq's not supporting attribute changes may change in the future.
> What the code path wants is pinning down the pwq no matter where it
> came from.  There's no point in distinguishing unbound and per-cpu
> here.
>
>> 3) get_unbound_pwq() self document.
>
> Not really.  If the name is get_pwq_if_unbound(), maybe.  Functions
> which take args and become noop depending on the argument aren't
> generally good ideas.  There are specific cases that they are suitable
> but this is just gratuituous.
>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
