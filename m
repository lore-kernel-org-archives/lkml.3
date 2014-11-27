Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbaK0QI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:08:27 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbaK0QIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:08:25 -0500
Message-ID: <54774C71.50807@nod.at>
Date: Thu, 27 Nov 2014 17:08:17 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] UBI: Fastmap: Ensure that all fastmap work is done
 upon WL shutdown
References: <1416835236-25185-1-git-send-email-richard@nod.at>	 <1416835236-25185-4-git-send-email-richard@nod.at> <1417102739.5858.112.camel@sauron.fi.intel.com>
In-Reply-To: <1417102739.5858.112.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.11.2014 um 16:38 schrieb Artem Bityutskiy:
> On Mon, 2014-11-24 at 14:20 +0100, Richard Weinberger wrote:
>> ...otherwise the deferred work might run after datastructures
>> got freed and corrupt memory.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  drivers/mtd/ubi/wl.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
>> index 7f135df..cb2e571 100644
>> --- a/drivers/mtd/ubi/wl.c
>> +++ b/drivers/mtd/ubi/wl.c
>> @@ -2041,6 +2041,9 @@ static void protection_queue_destroy(struct ubi_device *ubi)
>>  void ubi_wl_close(struct ubi_device *ubi)
>>  {
>>  	dbg_wl("close the WL sub-system");
>> +#ifdef CONFIG_MTD_UBI_FASTMAP
>> +	flush_work(&ubi->fm_work);
>> +#endif
> 
> If you are using the work infrastructure implemented in wl.c, then
> fastmap work should be no different to any other work. And we do flush
> all works in 'shutdown_work()'. The fastmap work should be flushed there
> too.
> 
> I think we discussed this already - there should be one single queue of
> works, managed by the same set of functions, all flushed in the same
> place, one-by-one...
> 
> Obviously, there is some misunderstanding. This looks like lack of
> separation and misuse of layering. I am missing explanations why I am
> wrong...

So you want me to use the UBI WL background thread for the scheduled fastmap work?
I didn't do it that way because you said more than once that fastmap is fastmap and
WL is WL. Therefore I've separated it.

Thanks,
//richard
