Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbaDPWbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 18:31:25 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:10449 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751390AbaDPWbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 18:31:24 -0400
X-IronPort-AV: E=Sophos;i="4.97,875,1389715200"; 
   d="scan'208";a="29363206"
Message-ID: <534F059C.9020905@cn.fujitsu.com>
Date: Thu, 17 Apr 2014 06:35:08 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] workqueue: fix possible race condition when rescuer
 VS pwq-release
References: <1395937212-4103-1-git-send-email-laijs@cn.fujitsu.com> <5335661E.7030408@cn.fujitsu.com> <20140415164752.GC30990@htj.dyndns.org> <534DDBFC.9060803@cn.fujitsu.com> <20140416152326.GG1257@htj.dyndns.org> <CACvQF532wtmegbNixch2zTGDmYoGoB4TFTHikw3dTNQPo7Gg2w@mail.gmail.com> <20140416165052.GK1257@htj.dyndns.org>
In-Reply-To: <20140416165052.GK1257@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 12:50 AM, Tejun Heo wrote:
> Hello, Lai.
> 
> On Thu, Apr 17, 2014 at 12:21:21AM +0800, Lai Jiangshan wrote:
>> OK. It is better to use get_pwq(). I will also change the above comments to:
>>
>>   The base ref and the possible ref from rerscuer(stopped) are never
>> dropped on per-cpu pwqs.
>>   Directly free the pwqs and wq.
> 
> Hmmm, why does that matter?  The base ref is the business of
> create/destroy path and as long as base ref is never put other refs
> just don't matter.
> 
>> The reason I quickly dropped V1 and wrote the V2 is that I saw this comment.
>> "The base ref" is precise after I used get_pwq() in V1.
>>
>> Or to avoid to change to this comments.
>> I can also move the following code down to the bottom of the rescuer_thread().
>>
>> if (kthread_should_stop()) {
>> __set_current_state(TASK_RUNNING);
>> rescuer->task->flags &= ~PF_WQ_WORKER;
>> return 0;
>> }
>>
>> (I reply this email on browser, never mind the syntax).
>> Maybe the second choice are better.
> 
> Hmmm... yeah, regardlesss of the above, it's a bit nasty that rescuer
> may exit with non-empty mayday list.
> 

+		 * The wq->maydays list maybe still have some pwqs linked,
+		 * but it is safe to free them all together since the rescuer
+		 * is stopped.

I just comment it without fix. It has no harm before, but it harms after I added a get_pwq().
Sorry.
Lai
