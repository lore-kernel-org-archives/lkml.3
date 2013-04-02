Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918Ab3DBCOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 22:14:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53760 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759418Ab3DBCOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 22:14:48 -0400
X-IronPort-AV: E=Sophos;i="4.87,390,1363104000"; 
   d="scan'208";a="6986530"
Message-ID: <515A3FBD.3080509@cn.fujitsu.com>
Date: Tue, 02 Apr 2013 10:17:33 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 tj/for-3.10] workqueue: add wq->freezing and remove
 POOL_FREEZING
References: <1364660955-5217-1-git-send-email-laijs@cn.fujitsu.com> <20130401184402.GA31435@htj.dyndns.org>
In-Reply-To: <20130401184402.GA31435@htj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/02 10:13:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/02 10:13:49,
	Serialize complete at 2013/04/02 10:13:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 02:44 AM, Tejun Heo wrote:
> On Sun, Mar 31, 2013 at 12:29:14AM +0800, Lai Jiangshan wrote:
>> freezing is nothing related to pools, but POOL_FREEZING adds a connection,
>> and causes freeze_workqueues_begin() and thaw_workqueues() complicated.
>>
>> Since freezing is workqueue instance attribute, so we introduce wq->freezing
>> instead and remove POOL_FREEZING.
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>>  kernel/workqueue.c |   33 +++++++--------------------------
>>  1 files changed, 7 insertions(+), 26 deletions(-)
>>
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index 04a8b98..6b7e5a4 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -66,7 +66,6 @@ enum {
>>  	 */
>>  	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
>>  	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
>> -	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
>>  
>>  	/* worker flags */
>>  	WORKER_STARTED		= 1 << 0,	/* started */
>> @@ -241,6 +240,7 @@ struct workqueue_struct {
>>  
>>  	int			nr_drainers;	/* WQ: drain in progress */
>>  	int			saved_max_active; /* WQ: saved pwq max_active */
>> +	bool			freezing;	/* WQ: the wq is freezing */
> 
> Why not use another internal flag?  There already are __WQ_DRAINING
> and __WQ_ORDERED.  Can't we just add __WQ_FREEZING?
> 
> Thanks.
> 



->flags is hot and almost read-only(except __WQ_DRAINING).
__WQ_DRAINING bit is accessed for every queue_work(), so we add it to hot ->flags.

__WQ_ORDERED is read-only.

->freezing is cold and non-read-only.
I don't think we need to add __WQ_FREEZING to ->flags.

Thanks,
Lai

