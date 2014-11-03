Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaKCDIu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 22:08:50 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:9140 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbaKCDIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 22:08:44 -0500
Message-ID: <5456F1A6.7010601@huawei.com>
Date: Mon, 3 Nov 2014 11:08:22 +0800
From: hujianyang <hujianyang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>
CC: <dedekind1@gmail.com>, <ezequiel.garcia@free-electrons.com>,
        "Richard Weinberger" <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <linux-arm-msm@vger.kernel.org>,
        "Brian Norris" <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH V5] mtd: ubi: Extend UBI layer debug/messaging capabilities
References: <1413824221-31235-1-git-send-email-tlinder@codeaurora.org> <5449C870.7060509@huawei.com> <54566692.10504@codeaurora.org>
In-Reply-To: <54566692.10504@codeaurora.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.144]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tanya,

On 2014/11/3 1:14, Tanya Brokhman wrote:
>>
>> This patch add 'struct ubi_device *' for 3 functions. We can get 'ubi_device' from
>> 'ubi_volume'. So I think it's because when we call these functions, the '->ubi'
>> pointer of 'ubi_volume' is not initialized, am I right? This patch use 'vol->ubi'
>> to indicate a 'struct ubi_device *' pointer in some places, I think you are sure
>> of using them.
>>
> 
> 1. for validate_vid_hdr() we don;t have a ubi_volume yet since its part of the attach process so we need struct ubi_device
> 2. for get_exclusive() - you're right. Will fetch dev number from the volume
> 3. for check_av() - you're right. fixed
> 

I'm not sure if 'ubi_volume->ubi' is initialized when we call some kinds of
ubi_err() to print error messages. The reference to a null pointer, we perform
'ubi->ubi_num' in ubi_err(), may crash the kernel. So you should be careful
of these situations not only in above cases but also in other places in your
patch.

>>
>> We have the parameter 'ubi_num' for log in some functions like 'ubi_attach_mtd_dev'
>> before. This patch remove 'ubi_num' in upper changes but keep it in other changes.
>> Do we have a discussed rule to deal with this situation? It's not a big problem~
> 
> I removed it because it made no sense printing it twice:
> "ubi-0: attached mtd-0 (...) to ubi0"?
> so I shortned the message:
> "ubi-0: attched mtd..."
> All the info is still there....
> Same for other messages that printed ubi number.
> 

Could we remove some the 'ubi_num'? I think there are no need to print it
twice in other places, like:

@@ -921,7 +923,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,

 		/* Make sure ubi_num is not busy */
 		if (ubi_devices[ubi_num]) {
-			ubi_err("ubi%d already exists", ubi_num);
+			ubi_err(ubi, "ubi%d already exists", ubi_num);
 			return -EEXIST;
 		}
 	}

and

@@ -970,7 +974,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	mutex_init(&ubi->fm_mutex);
 	init_rwsem(&ubi->fm_sem);

-	ubi_msg("attaching mtd%d to ubi%d", mtd->index, ubi_num);
+	ubi_msg(ubi, "attaching mtd%d to ubi%d", mtd->index, ubi_num);


>>> @@ -1415,8 +1418,9 @@ int ubi_self_check_all_ff(struct ubi_device *ubi, int pnum, int offset, int len)
>>>       return 0;
>>>
>>>   fail:
>>> -    ubi_err("self-check failed for PEB %d", pnum);
>>> -    ubi_msg("hex dump of the %d-%d region", offset, offset + len);
>>> +    ubi_err(ubi, "self-check failed for PEB %d", pnum);
>>> +    ubi_msg(ubi, "hex dump of the %d-%d region",
>>> +         offset, offset + len);
>>>       print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1, buf, len, 1);
>>>       err = -EINVAL;
>>>   error:
>>
>> Artem, I know you have tried to align the message code in different lines, maybe
>> you can check if you lose this one.
>>
> 
> hmmm... not sure I understand what is wrong here....
> 

Turn

+    ubi_msg(ubi, "hex dump of the %d-%d region",
+         offset, offset + len);

to

+    ubi_msg(ubi, "hex dump of the %d-%d region",
+            offset, offset + len);

Maybe like this. The next line aligns to the message in first line, not a big problem.
By the way, I use space in this example, it's wrong. Tab is right.


Thanks!

Hu


