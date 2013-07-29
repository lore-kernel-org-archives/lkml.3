Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab3G2RlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:41:16 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51420 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab3G2RlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:41:15 -0400
Message-ID: <51F6A933.4050301@linux.vnet.ibm.com>
Date: Mon, 29 Jul 2013 10:41:07 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 2/5] rbtree: add rbtree_postorder_for_each_entry_safe()
 helper
References: <1374873223-25557-1-git-send-email-cody@linux.vnet.ibm.com> <1374873223-25557-3-git-send-email-cody@linux.vnet.ibm.com> <20130729150624.GB4381@variantweb.net>
In-Reply-To: <20130729150624.GB4381@variantweb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072917-7182-0000-0000-000007E54FF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 08:06 AM, Seth Jennings wrote:
> On Fri, Jul 26, 2013 at 02:13:40PM -0700, Cody P Schafer wrote:
>> Because deletion (of the entire tree) is a relatively common use of the
>> rbtree_postorder iteration, and because doing it safely means fiddling
>> with temporary storage, provide a helper to simplify postorder rbtree
>> iteration.
>>
>> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
>> ---
>>   include/linux/rbtree.h | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
>> index 2879e96..64ab98b 100644
>> --- a/include/linux/rbtree.h
>> +++ b/include/linux/rbtree.h
>> @@ -85,4 +85,21 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
>>   	*rb_link = node;
>>   }
>>
>> +/**
>> + * rbtree_postorder_for_each_entry_safe - iterate over rb_root in post order of
>> + * given type safe against removal of rb_node entry
>> + *
>> + * @pos:	the 'type *' to use as a loop cursor.
>> + * @n:		another 'type *' to use as temporary storage
>> + * @root:	'rb_root *' of the rbtree.
>> + * @field:	the name of the rb_node field within 'type'.
>> + */
>> +#define rbtree_postorder_for_each_entry_safe(pos, n, root, field) \
>> +	for (pos = rb_entry(rb_first_postorder(root), typeof(*pos), field),\
>> +	      n = rb_entry(rb_next_postorder(&pos->field), \
>> +		      typeof(*pos), field); \
>> +	     &pos->field; \
>> +	     pos = n, \
>> +	      n = rb_entry(rb_next_postorder(&pos->field), typeof(*pos), field))
>
> One too many spaces.  Also mix of tabs and spaces is weird, but
> checkpatch doesn't complain so...
>
> Seth

The extra space is to set off ';' vs ',' in the macro. And I did that 
instead of a tab to avoid wrapping. I've adjusted them (in the next 
version) to use the same style as list.h's list_for_each*() macros. 
Which results in more wrapping :( .

>
>> +
>>   #endif	/* _LINUX_RBTREE_H */
>> --
>> 1.8.3.4
>>

