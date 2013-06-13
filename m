Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab3FMEOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 00:14:09 -0400
Received: from nm28-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.229]:39861
	"EHLO nm28-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774Ab3FMEOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 00:14:06 -0400
X-Yahoo-Newman-Id: 40147.27212.bm@smtp103.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0PN5Vi8VM1mkcv.W6w0MMorDEOOcJ6agf8n6rcaZuwFnk5z
 dd9YD3hez9ASX3mSS_ikUvb2RJofQLzkt9x7T.xj_ViL20NlMjsrJvkdxKwu
 C7YcvFFllELrUqdPxdlYU3VMQdAbHmpyJ7KjqbqEwfUnyrdjpqu8I4tuy4fX
 ZcmfSjmtViYnNRhSJDbO03g5JJbLC.XeMcIzscPRp7KL3M7WxTWnkfTNM9Ta
 N5AugjO28rSlBhoToO3dTRM_dYTF9WuVhkeFsIZNGdQ5GgAyoN3UL7zVCY6K
 AMkNUmOOhlHhiLWCQexJIs3prgHw7fYyHbUMeB_hYl8KUO8aK5uOHQHiz7Un
 M2A4B2_cWXRTUT4I1_icvOAJi2TO3xM4Lc0tsSwMsvdmJviZELsUtIl_7ZQA
 SNP2QIMXRkJyNBDCf.Ph_HilOeTtiJfeH.uKtY9fd8YDzNPJeRUo1q9_USoX
 dq3QI1UqV3im6VYctbzY5lEUG6HES_akKLrd2DSFTSNWkPQCsK5344P.hT9v
 _IDI033c9zT1ynMTpbf7iPu7kH6SV8bFhz5M5PM7668zdo2H7jQQ-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.10.13] (casey@82.204.39.68 with plain)
        by smtp103.biz.mail.bf1.yahoo.com with SMTP; 12 Jun 2013 21:14:04 -0700 PDT
Message-ID: <51B9470E.7060107@schaufler-ca.com>
Date: Wed, 12 Jun 2013 21:14:06 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-security-module@vger.kernel.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFCv2] security: smack: add a hash table to quicken smk_find_entry()
References: <1370955313-3605-1-git-send-email-t.stanislaws@samsung.com> <1370955313-3605-2-git-send-email-t.stanislaws@samsung.com> <51B802EF.2080403@schaufler-ca.com> <51B87A3C.7050906@samsung.com>
In-Reply-To: <51B87A3C.7050906@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/2013 6:40 AM, Tomasz Stanislawski wrote:
> Hi Casey,
> Thank you for your review.
> Please refer to comments below.
>
> On 06/12/2013 07:11 AM, Casey Schaufler wrote:
>> On 6/11/2013 5:55 AM, Tomasz Stanislawski wrote:
>>> This patch adds a hash table to quicken searching of a smack label by its name.
>>>
>>> Basically, the patch improves performance of SMACK initialization.  Parsing of
>>> rules involves translation from a string to a smack_known (aka label) entity
>>> which is done in smk_find_entry().
>> There is one place where this is done, and that is in smk_import_entry().
>>
>> There is another place where labels are looked up, and that is in
>> smack_from_secattr(). Can you apply this enhancement there, too?
>>
> The overmentioned function contains following check:
>
>                         if (memcmp(sap->attr.mls.cat,
>                                  skp->smk_netlabel.attr.mls.cat,
>                                  SMK_CIPSOLEN) != 0)
>                                  continue;
>
> What does it mean?

The Smack label is encoded in the CIPSO categories in one
of two ways. When the label is imported (smk_import_entry())
the CIPSO encoding is generated and saved in the smack_known
entry for that label. When a packet is received the CIPSO
categories are not interpreted, instead it's a simple matter
of matching the saved category set in the label list.

> I expect that there was a reason not to use smk_find_entry()
> in smack_from_secattr().

Yes. While the dirty little secret is that for short labels
the CIPSO encoding is the Smack label, you can't count on the
bitwise representation matching because, well, networking code
is just like that.


> Do you want me to introduce a new hash table for searching
> skp->smk_netlabel.attr.mls.cat using up to SMK_CIPSOLEN character
> to produce a hash?

If we're going down the hashing path this would be an obvious
step to take. And we're always looking for ways to improve
network performance.

> If it is true then this change is rather orthogonal to the current patch
> and it can go to a separate patch.

I can go either way.

> Moreover, smack_from_secid() may need some hashing improvement.

Yes. The hash function is going to be pretty trivial. smack_from_secid
is a fortunately rare call.

>
>>> The current implementation of the function iterates over a global list of
>>> smack_known resulting in O(N) complexity for smk_find_entry().  The total
>>> complexity of SMACK initialization becomes O(rules * labels).  Therefore it
>>> scales quadratically with a complexity of a system.
>>>
>>> Applying the patch reduced the complexity of smk_find_entry() to O(1) as long
>>> as number of label is in hundreds. If the number of labels is increased please
>>> update SMACK_HASH_SLOTS constant defined in security/smack/smack.h. Introducing
>>> the configuration of this constant with Kconfig or cmdline might be a good
>>> idea.
>>>
>>> The size of the hash table was adjusted experimentally.  The rule set used by
>>> TIZEN contains circa 17K rules for 500 labels.  The table above contains
>>> results of SMACK initialization using 'time smackctl apply' bash command.
>>> The 'Ref' is a kernel without this patch applied. The consecutive values
>>> refers to value of SMACK_HASH_SLOTS.  Every measurement was repeated three
>>> times to reduce noise.
>>>
>>>      |  Ref  |   1   |   2   |   4   |   8   |   16  |   32  |   64  |  128  |  256  |  512
>>> --------------------------------------------------------------------------------------------
>>> Run1 | 1.156 | 1.096 | 0.883 | 0.764 | 0.692 | 0.667 | 0.649 | 0.633 | 0.634 | 0.629 | 0.620
>>> Run2 | 1.156 | 1.111 | 0.885 | 0.764 | 0.694 | 0.661 | 0.649 | 0.651 | 0.634 | 0.638 | 0.623
>>> Run3 | 1.160 | 1.107 | 0.886 | 0.764 | 0.694 | 0.671 | 0.661 | 0.638 | 0.631 | 0.624 | 0.638
>>> AVG  | 1.157 | 1.105 | 0.885 | 0.764 | 0.693 | 0.666 | 0.653 | 0.641 | 0.633 | 0.630 | 0.627
>>                  4%      20%     14%     9%      4%      2%      2%      1%      <1%
>>
>>
>> You get 4% by going to the hlist. The improvement is trivial after 16 slots.
>> If you have 500 labels and 128 slots that's an average of 4 labels per slot.
>> That's an awfully big hash table for so few labels and so little performance
>> gain over what you get with 16 slots. Plus, 500 labels is a huge number of
>> labels. Most Smack systems should be using far fewer than that. 
>>
> Ok. 16 slots might be considered as 'good-enough'.
>
> However, the cost of a single slot is a hash table is only 4 bytes (on ARM).
> For example, using 64 slots instead of 16 costs only 4 * (64 - 16) = 196 bytes.
> It is a very small value in comparison to other structures used in SMACK.
> For example, sizeof(struct smack_rule) == 20. Notice that 32 bytes are consumed
> due to kmalloc alignment policy (refer to include/linux/kmalloc_sizes.h).
> So the cost is equal to the cost of 6 additional rules.
>
> The performance gain is 4% (for 64 slots compared to 16 slots).

Which is still only 20 milliseconds, once, at boot time.

> The gain (expressed in percents) will be larger if IO issues in smackctl get resolved.
> The additional memory cost for TIZEN case (not including smack_known and other objects) is:
> 196 / (17k rules * 32 bytes/rule) * 100% = 0.03%

But that memory is in use forever. 

> I think that 4% speed for 0.03% memory is a very good trade-off.
> Especially as it makes system more resistant if a number of labels somehow
> get increased.

The number of labels is already larger than it ought to be. We have
work to do on that.

> Anyway, if you consider 16 to be the best value then 16 is the best value.
>
> Are there any other issues to be fixed in the patch?

I don't see any right now, but of course something could come up
during my testing.

> Do you think that commit log is a good place for measurement results.
> Maybe cover-letter would be a better place?

Commit log is fine. It never hurts to record why something
seems like a good idea.

>
> Regards,
> Tomasz Stanislawski
>
>>> Surprisingly, a single hlist is slightly faster than a double-linked list.
>>> The speed-up saturates near 64 slots.  Therefore I chose value 128 to provide
>>> some margin if more labels were used.
>>> It looks that IO becomes a new bottleneck.
>>>
>>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>>> ---
>>>  security/smack/smack.h        |    5 +++++
>>>  security/smack/smack_access.c |   30 +++++++++++++++++++++++++++---
>>>  security/smack/smack_lsm.c    |   12 ++++++------
>>>  3 files changed, 38 insertions(+), 9 deletions(-)
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

