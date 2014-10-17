Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaJQOiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:38:54 -0400
Received: from smtp104.biz.mail.bf1.yahoo.com ([98.139.221.63]:28133 "EHLO
	smtp104.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723AbaJQOiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:38:52 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: MG75GB4VM1mHjMKHaYfgFDR3mYXMI0F1F_mzD_5_lw0Wx00
 SFynh6vk0Q4Y1fNFjUDVTl9NKy7I9wuVJ1FLSmjLEbrJNe_fVIwyWVBEy7S3
 kzOK1Qzpw1kS9yPGCg_.FUbhihmICs6wNWO9w5CjZIw3.UrtKAcYzzS3gwub
 sQfd8Qoqtcs4Gj91.61mvKD93vHo9o6qPWuYZUpaHvF7i5o53MnNjk1wt0hR
 BJGS4HbKiQ8wEkwQtSDZnouB.ZkwgbyAAaW__lB3ji2JqV6jbb0agHaBnzBI
 F.tOUEhpDkY5S9Xvmv88b5zdKGY6prpoYKJGrdMwXQyEcRpTGrCj7n6iJM_v
 FEGawcKBGiGyMrMGIyGOljXa.lEi1TOl4lkfJYPwrfHnI3sTkwtsYnhTBcBy
 ShbyXmk_2nyIVTpEIz5bmmExilWZpgFIG2wOFBFLHq8474IrOTjnQZmvkh7j
 MInYhRw53oU4kKP.MPA7rLRBh9deVSSdI3wW1y3vbxEGmHCCBUHsHvJuS9bo
 sjTmQhgHp.iBHKzja2zozwvwCHcfjBDvFzhzeq_fSTgFvqTGiPEujZoizRU3
 hq3ri77k_0ZES3CipTsq_DBxQqLn_OqTgDBq9_PzLRdiXZd5Wz1bCMakcvCz
 8cvGBCkkuD75O
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <544129FD.8060902@schaufler-ca.com>
Date: Fri, 17 Oct 2014 07:38:53 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rohit <rohit.kr@samsung.com>
CC: akpm@linux-foundation.org, james.l.morris@oracle.com, serge@hallyn.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpgs@samsung.com, pintu.k@samsung.com, vishnu.ps@samsung.com,
        iqbal.ams@samsung.com, ed.savinay@samsung.com, me.rohit@live.com,
        pintu_agarwal@yahoo.com, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v2] Security: smack: replace kzalloc with kmem_cache for
 inode_smack
References: <1413375041-29741-1-git-send-email-rohit.kr@samsung.com> <543FF121.7000502@schaufler-ca.com> <20141017171229.7c1a113e@rohitk-ubuntu.sisodomain.com>
In-Reply-To: <20141017171229.7c1a113e@rohitk-ubuntu.sisodomain.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2014 4:42 AM, Rohit wrote:
> On Thu, 16 Oct 2014 09:24:01 -0700
> Casey Schaufler <casey@schaufler-ca.com> wrote:
>
>> On 10/15/2014 5:10 AM, Rohit wrote:
>>> The patch use kmem_cache to allocate/free inode_smack since they are
>>> alloced in high volumes making it a perfect case for kmem_cache.
>>>
>>> As per analysis, 24 bytes of memory is wasted per allocation due
>>> to internal fragmentation. With kmem_cache, this can be avoided.
>> What impact does this have on performance? I am much more
>> concerned with speed than with small amount of memory.
>>
> I think there should not be any performance problem as such.
> However, please let me know how to check the performance in this case.

Any inode intensive benchmark would suffice. Even the classic
kernel build would do.

> As far as i know, kzalloc first finds the kmalloc_index corresponding to
> the size to get the kmem_cache_object and then calls kmem_cache_alloc
> with the kmalloc_index(kmem_cache object). Here, we create kmem_cache
> object specific for inode_smack and directly calls kmem_cache_alloc()
> which should give better performance as compared to kzalloc.

That would be my guess as well, but performance is tricky. Sometimes
things that "obviously" make performance better make it worse. There can
be unanticipated side effects.


> Please let me know your comments.

If you can run any sort of test that demonstrates this change
does not have performance impact, I'm fine with it. Smack is being
used in small devices, and both memory use and performance are critical
to the success of these devices. Of the two, performance is currently
more of an issue.

Thank you.

>>> Accounting of memory allocation is below :
>>>  total       slack            net      count-alloc/free
>>> caller Before (with kzalloc)
>>> 1919872      719952          1919872      29998/0
>>> new_inode_smack+0x14
>>>
>>> After (with kmem_cache)
>>> 1201680          0           1201680      30042/0
>>> new_inode_smack+0x18
>>>
>>> >From above data, we found that 719952 bytes(~700 KB) of memory is
>>> saved on allocation of 29998 smack inodes.
>>>
>>> Signed-off-by: Rohit <rohit.kr@samsung.com>
>>> ---
>>> Added static in kmem_cache object declaration noted by Andrew
>>> Morton <akpm@ linux-foundation.org> . Also updated commit message.
>>>  security/smack/smack_lsm.c |   13 ++++++++++---
>>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>>> index d515ec2..15d985c 100644
>>> --- a/security/smack/smack_lsm.c
>>> +++ b/security/smack/smack_lsm.c
>>> @@ -53,6 +53,7 @@
>>>  #define SMK_SENDING	2
>>>  
>>>  LIST_HEAD(smk_ipv6_port_list);
>>> +static struct kmem_cache *smack_inode_cache;
>>>  
>>>  #ifdef CONFIG_SECURITY_SMACK_BRINGUP
>>>  static void smk_bu_mode(int mode, char *s)
>>> @@ -240,7 +241,7 @@ struct inode_smack *new_inode_smack(struct
>>> smack_known *skp) {
>>>  	struct inode_smack *isp;
>>>  
>>> -	isp = kzalloc(sizeof(struct inode_smack), GFP_NOFS);
>>> +	isp = kmem_cache_zalloc(smack_inode_cache, GFP_NOFS);
>>>  	if (isp == NULL)
>>>  		return NULL;
>>>  
>>> @@ -767,7 +768,7 @@ static int smack_inode_alloc_security(struct
>>> inode *inode) */
>>>  static void smack_inode_free_security(struct inode *inode)
>>>  {
>>> -	kfree(inode->i_security);
>>> +	kmem_cache_free(smack_inode_cache, inode->i_security);
>>>  	inode->i_security = NULL;
>>>  }
>>>  
>>> @@ -4264,10 +4265,16 @@ static __init int smack_init(void)
>>>  	if (!security_module_enable(&smack_ops))
>>>  		return 0;
>>>  
>>> +	smack_inode_cache = KMEM_CACHE(inode_smack, 0);
>>> +	if (!smack_inode_cache)
>>> +		return -ENOMEM;
>>> +
>>>  	tsp = new_task_smack(&smack_known_floor,
>>> &smack_known_floor, GFP_KERNEL);
>>> -	if (tsp == NULL)
>>> +	if (tsp == NULL) {
>>> +		kmem_cache_destroy(smack_inode_cache);
>>>  		return -ENOMEM;
>>> +	}
>>>  
>>>  	printk(KERN_INFO "Smack:  Initializing.\n");
>>>  
> Thanks,
> Rohit
>

