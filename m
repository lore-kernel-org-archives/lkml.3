Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab3HMQq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:46:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41906 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab3HMQq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:46:28 -0400
Message-ID: <520A62E2.6000309@codeaurora.org>
Date: Tue, 13 Aug 2013 09:46:26 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / QoS: Fix workqueue deadlock when using pm_qos_update_request_timeout()
References: <1375992837-1673-1-git-send-email-sboyd@codeaurora.org> <20130813164315.GB32719@htj.dyndns.org>
In-Reply-To: <20130813164315.GB32719@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/13 09:43, Tejun Heo wrote:
> Hello, Stephen.
>
> On Thu, Aug 08, 2013 at 01:13:57PM -0700, Stephen Boyd wrote:
>> pm_qos_update_request_timeout() updates a qos and then schedules
>> a delayed work item to bring the qos back down to the default
>> after the timeout. When the work item runs, pm_qos_work_fn() will
>> call pm_qos_update_request() and deadlock because it tries to
>> cancel itself via cancel_delayed_work_sync(). Future callers of
>> that qos will also hang waiting to cancel the work that is
>> canceling itself. Before ed1ac6e (PM: don't use
>> [delayed_]work_pending(), 2013-01-11) this didn't happen because
>> the work function wouldn't try to cancel itself.
> I see.  That must have been racy tho.  If the work item execution
> races someone else queuing the work item, the same deadlock could
> happen, right?

Yes you're right. It was always racy.

>
>> Let's just do the little bit of pm_qos_update_request() here so
>> that we don't deadlock.
>>
>> Cc: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  kernel/power/qos.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/power/qos.c b/kernel/power/qos.c
>> index 06fe285..d52d314 100644
>> --- a/kernel/power/qos.c
>> +++ b/kernel/power/qos.c
>> @@ -308,7 +308,11 @@ static void pm_qos_work_fn(struct work_struct *work)
>>  						  struct pm_qos_request,
>>  						  work);
>>  
>> -	pm_qos_update_request(req, PM_QOS_DEFAULT_VALUE);
>> +	if (PM_QOS_DEFAULT_VALUE != req->node.prio)
>> +		pm_qos_update_target(
>> +				pm_qos_array[req->pm_qos_class]->constraints,
>> +				&req->node, PM_QOS_UPDATE_REQ,
>> +				PM_QOS_DEFAULT_VALUE);
> Maybe it'd be cleaner to add a param or internal variant of
> pm_qos_update_request()?

Maybe, but I was trying to make a minimal fix here.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

