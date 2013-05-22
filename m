Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab3EVNWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:22:06 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:44492 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753739Ab3EVNWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:22:04 -0400
Message-ID: <519CC676.2010905@hurleysoftware.com>
Date: Wed, 22 May 2013 09:21:58 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: stephan.gatzka@gmail.com
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, Tejun Heo <tj@kernel.org>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: function call fw_iso_resource_mange(..) (core-iso.c) does not
 return
References: <8ac7ca3200325ddf85ba57aa6d000f70@gatzka.org> <519BA6AC.1080600@hurleysoftware.com> <20130521231847.GA6985@mtj.dyndns.org> <20130522094840.472b263e@stein> <51145028d1c880d68e0a88d863faa71c@gatzka.org> <20130522145808.1ec7bea7@stein> <b41fcb8e7f7deafe8f8f4c708daf81d4@gatzka.org>
In-Reply-To: <b41fcb8e7f7deafe8f8f4c708daf81d4@gatzka.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 09:06 AM, Stephan Gatzka wrote:
>> Solution 2 --- Perform interdependent works in different queue instances.
>> (Keep the WQ_MEM_RECLAIM flag set at those workqueues that have to take
>> work which is necessary for progress of memory reclaim.  If this and only
>> this solution is employed for an SBP-2 initiator, we need two if not more
>> WQ_MEM_RECLAIM workqueue instances.)
>
> I would go for this solution. I have no problems with lots of workqueues around, because there is only a relatively small structure required for each workqueue.

Now that we more fully understand the cause, this would be my choice as
well (despite my earlier advocacy for the return to tasklets).

Although we do need to carefully review the other work items (bm_work,br_work)
to ensure that there aren't unwanted dependencies with those as well.

Also, wqs that are WQ_MEM_RECLAIM aren't free as each wq will have a
dedicated rescue thread.

[The other advantage with tasklets is the reduced latency but I do
understand the advantages of the RT characteristics of worklets.]

Regards,
Peter Hurley

>
>>
>> Solution 3 --- Remove the dependency between worklets:
>>
>>     Solution 3a --- Remove the lower-level worklet altogether.
>>     E.g. reimplement the lower-level worklet as a tasklet.
>
> No, I like the workqueue context. :)
>
>
>>     Solution 3b --- Remove the higher-level worklet's dependency.
>>     E.g. reimplement the higher-level worklet such that it is woken by
>>     a timer and then aborts or reschedules ( = lets the lower-level
>>     worklet bubble up in the queue).
>
> This looks more difficult to me and not so easy to test.
>
> Stephan

