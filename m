Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab3FLNkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 09:40:20 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10378 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab3FLNkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 09:40:17 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-8e-51b87a3ec8af
Message-id: <51B87A3C.7050906@samsung.com>
Date: Wed, 12 Jun 2013 15:40:12 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
MIME-version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2] security: smack: add a hash table to quicken
 smk_find_entry()
References: <1370955313-3605-1-git-send-email-t.stanislaws@samsung.com>
 <1370955313-3605-2-git-send-email-t.stanislaws@samsung.com>
 <51B802EF.2080403@schaufler-ca.com>
In-reply-to: <51B802EF.2080403@schaufler-ca.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xa7p2VTsCDdbMErW4t+0Xm8XZpjfs
	Fpd3zWGz+NDziM1i7ZG77BZvJ61gdmDz6NuyitHj6P5FbB6fN8kFMEdx2aSk5mSWpRbp2yVw
	ZSz9s4y14INmxcPuRuYGxk6FLkZODgkBE4m1E36xQthiEhfurWfrYuTiEBJYyijxZ+9VVgjn
	M6PEpOUf2LsYOTh4BbQkfq3XAmlgEVCV+LV5NxOIzQY06NiSz4wgJaICERJNp8tAwrwCghI/
	Jt9jAbFFBHQk9u15zg4ykllgMqPE97N9YL3CAiESr5vuskDsWs0o8eRaK9hFnAIGEm+2z2EG
	sZmBuve3TmODsOUlNq95yzyBUWAWkiWzkJTNQlK2gJF5FaNoamlyQXFSeq6hXnFibnFpXrpe
	cn7uJkZIIH/Zwbj4mNUhRgEORiUe3gNm2wOFWBPLiitzDzFKcDArifAmxu8IFOJNSaysSi3K
	jy8qzUktPsTIxMEp1cCouds5iTeWOeaJuuSj3Q+di2ZaXFm2MlX7kvr/6EPxf69u5Bbtd/Dx
	/Ca0rI+v2WDbR+5pL7ZkbQm7ya5vsSnlSsHF5YdWlred2XJ64vQfnhUKElKq83TMfXVd9si1
	LGV6Hf5m//3U3xMzdoo/+PnNW+1M89sL7NILnX1MgnZVBRi03ty84WycEktxRqKhFnNRcSIA
	oIo0e0ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Casey,
Thank you for your review.
Please refer to comments below.

On 06/12/2013 07:11 AM, Casey Schaufler wrote:
> On 6/11/2013 5:55 AM, Tomasz Stanislawski wrote:
>> This patch adds a hash table to quicken searching of a smack label by its name.
>>
>> Basically, the patch improves performance of SMACK initialization.  Parsing of
>> rules involves translation from a string to a smack_known (aka label) entity
>> which is done in smk_find_entry().
> 
> There is one place where this is done, and that is in smk_import_entry().
> 
> There is another place where labels are looked up, and that is in
> smack_from_secattr(). Can you apply this enhancement there, too?
> 

The overmentioned function contains following check:

                        if (memcmp(sap->attr.mls.cat,
                                 skp->smk_netlabel.attr.mls.cat,
                                 SMK_CIPSOLEN) != 0)
                                 continue;

What does it mean?
I expect that there was a reason not to use smk_find_entry()
in smack_from_secattr().

Do you want me to introduce a new hash table for searching
skp->smk_netlabel.attr.mls.cat using up to SMK_CIPSOLEN character
to produce a hash?

If it is true then this change is rather orthogonal to the current patch
and it can go to a separate patch.

Moreover, smack_from_secid() may need some hashing improvement.

>>
>> The current implementation of the function iterates over a global list of
>> smack_known resulting in O(N) complexity for smk_find_entry().  The total
>> complexity of SMACK initialization becomes O(rules * labels).  Therefore it
>> scales quadratically with a complexity of a system.
>>
>> Applying the patch reduced the complexity of smk_find_entry() to O(1) as long
>> as number of label is in hundreds. If the number of labels is increased please
>> update SMACK_HASH_SLOTS constant defined in security/smack/smack.h. Introducing
>> the configuration of this constant with Kconfig or cmdline might be a good
>> idea.
>>
>> The size of the hash table was adjusted experimentally.  The rule set used by
>> TIZEN contains circa 17K rules for 500 labels.  The table above contains
>> results of SMACK initialization using 'time smackctl apply' bash command.
>> The 'Ref' is a kernel without this patch applied. The consecutive values
>> refers to value of SMACK_HASH_SLOTS.  Every measurement was repeated three
>> times to reduce noise.
>>
>>      |  Ref  |   1   |   2   |   4   |   8   |   16  |   32  |   64  |  128  |  256  |  512
>> --------------------------------------------------------------------------------------------
>> Run1 | 1.156 | 1.096 | 0.883 | 0.764 | 0.692 | 0.667 | 0.649 | 0.633 | 0.634 | 0.629 | 0.620
>> Run2 | 1.156 | 1.111 | 0.885 | 0.764 | 0.694 | 0.661 | 0.649 | 0.651 | 0.634 | 0.638 | 0.623
>> Run3 | 1.160 | 1.107 | 0.886 | 0.764 | 0.694 | 0.671 | 0.661 | 0.638 | 0.631 | 0.624 | 0.638
>> AVG  | 1.157 | 1.105 | 0.885 | 0.764 | 0.693 | 0.666 | 0.653 | 0.641 | 0.633 | 0.630 | 0.627
> 
>                  4%      20%     14%     9%      4%      2%      2%      1%      <1%
> 
> 
> You get 4% by going to the hlist. The improvement is trivial after 16 slots.
> If you have 500 labels and 128 slots that's an average of 4 labels per slot.
> That's an awfully big hash table for so few labels and so little performance
> gain over what you get with 16 slots. Plus, 500 labels is a huge number of
> labels. Most Smack systems should be using far fewer than that. 
> 

Ok. 16 slots might be considered as 'good-enough'.

However, the cost of a single slot is a hash table is only 4 bytes (on ARM).
For example, using 64 slots instead of 16 costs only 4 * (64 - 16) = 196 bytes.
It is a very small value in comparison to other structures used in SMACK.
For example, sizeof(struct smack_rule) == 20. Notice that 32 bytes are consumed
due to kmalloc alignment policy (refer to include/linux/kmalloc_sizes.h).
So the cost is equal to the cost of 6 additional rules.

The performance gain is 4% (for 64 slots compared to 16 slots).
The gain (expressed in percents) will be larger if IO issues in smackctl get resolved.
The additional memory cost for TIZEN case (not including smack_known and other objects) is:
196 / (17k rules * 32 bytes/rule) * 100% = 0.03%

I think that 4% speed for 0.03% memory is a very good trade-off.
Especially as it makes system more resistant if a number of labels somehow
get increased.

Anyway, if you consider 16 to be the best value then 16 is the best value.

Are there any other issues to be fixed in the patch?
Do you think that commit log is a good place for measurement results.
Maybe cover-letter would be a better place?

Regards,
Tomasz Stanislawski

>>
>> Surprisingly, a single hlist is slightly faster than a double-linked list.
>> The speed-up saturates near 64 slots.  Therefore I chose value 128 to provide
>> some margin if more labels were used.
>> It looks that IO becomes a new bottleneck.
>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> ---
>>  security/smack/smack.h        |    5 +++++
>>  security/smack/smack_access.c |   30 +++++++++++++++++++++++++++---
>>  security/smack/smack_lsm.c    |   12 ++++++------
>>  3 files changed, 38 insertions(+), 9 deletions(-)
>>

