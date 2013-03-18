Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3CRRuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 13:50:16 -0400
Received: from nm19.access.bullet.mail.mud.yahoo.com ([66.94.237.220]:45580
	"EHLO nm19.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657Ab3CRRuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 13:50:14 -0400
X-Yahoo-Newman-Id: 733743.12208.bm@smtp104.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: WJAefY0VM1mZqyKB1a60hneFTT40n_aMXfJ3xLqa71nj8u2
 gLkiw4ig9JQtiGZD7Kimx_73VoOqkUaXHidn9Wh7yTkumRvzKwiN286lRph.
 V350hf1u6MgICIjNg582qZD5R8y1FewjKsY.Uo6uOX0VovDHXE6tuIP4bTrl
 LyMqzzDFiRBNNx2.Wy0vqeQmh0FNdFmtIOH6JUfD.0KJKyUEt1C0DMTtfDwo
 UOQKq7s2HcNJbSdVQraPW3iwu2QSXLTJEz4IMSsTQLM6W6V0tOrSgOwn5kPf
 7eDuyJjo3BCV3FNjqSzp.U0vHIc1SviM56OMYmykYJtLgk9ETzcm9sF2YsDX
 GQ1fM2mQl7KWlYzdJzsDhAQontq7qRHIOs2KSO71IlC47_vXdFbQBooObL42
 GDSvWrCPoZLTrB1UtxAZAR.6t4JhVaysIJzQX22BI9QuFD6XndO0j5x0s07i
 RYR9S
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@50.131.111.212 with plain)
        by smtp104.biz.mail.bf1.yahoo.com with SMTP; 18 Mar 2013 10:50:12 -0700 PDT
Message-ID: <514753DC.4030609@schaufler-ca.com>
Date: Mon, 18 Mar 2013 10:50:21 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@intel.com,
        akpm@linux-foundation.org, ebiederm@xmission.com,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 3/4] capability: Create a new capability CAP_SIGNED
References: <1363379758-10071-1-git-send-email-vgoyal@redhat.com> <1363379758-10071-4-git-send-email-vgoyal@redhat.com> <51438EDB.3050300@schaufler-ca.com> <20130318170552.GG20743@redhat.com>
In-Reply-To: <20130318170552.GG20743@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/18/2013 10:05 AM, Vivek Goyal wrote:
> On Fri, Mar 15, 2013 at 02:12:59PM -0700, Casey Schaufler wrote:
>> On 3/15/2013 1:35 PM, Vivek Goyal wrote:
>>> Create a new capability CAP_SIGNED which can be given to signed executables.
>> This would drive anyone who is trying to use
>> capabilities as the privilege mechanism it is
>> intended to be absolutely crazy.
> Will calling it CAP_SIGNED_SERVICES help. I intend to use it as
> capability (and not just as a flag for task attribute).

No, the name is not the issue.

> I think primary difference here is that this capability is controlled
> by kernel and only validly signed processes get it.

Applications are allowed to manipulate their capability sets
in well defined ways. The behavior of file based capabilities
is also explicitly defined. The behavior you are proposing would
violate both of these mechanisms. 

>> Capabilities aren't just random attribute bits. They
>> indicate that a task has permission to violate a
>> system policy (e.g. change the mode bits of a file
>> the user doesn't own). Think about how this will
>> interact with programs using file based capabilities.
> It is a separate capability. I am not sure why it would
> interfere with other capabilities or functionality out there.

The behavior of capabilities is uniform. You can't have one
capability that behaves differently from the others. If a
file is unsigned but has CAP_SIGNED in the file capability
set what do you expect to happen? Do you want a signed
application to be able to drop and raise the fact that it
is signed?

I expect that you don't want your attribute that indicates
that the binary was signed to behave the same way that
capabilities do. Like I said, capabilities are not just
attribute bits. You need a different kind of process attribute
to indicate that the binary was signed.

When (if ever) we have multiple LSM support you might consider
doing this as a small LSM. Until then, you're going to need a
different way to express the signature attribute.


>
> Thanks
> Vivek
>
>>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>>> ---
>>>  include/uapi/linux/capability.h |   12 +++++++++++-
>>>  kernel/cred.c                   |    7 +++++++
>>>  security/commoncap.c            |    2 ++
>>>  3 files changed, 20 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
>>> index ba478fa..1bbe671 100644
>>> --- a/include/uapi/linux/capability.h
>>> +++ b/include/uapi/linux/capability.h
>>> @@ -343,7 +343,17 @@ struct vfs_cap_data {
>>>  
>>>  #define CAP_BLOCK_SUSPEND    36
>>>  
>>> -#define CAP_LAST_CAP         CAP_BLOCK_SUSPEND
>>> +/*
>>> + * Allow certain kernel services with secureboot enabled. One of such
>>> + * service is sys_kexec() which can be invoked by process only if it
>>> + * has CAP_SIGNED capability (with secureboot enabled).
>>> + *
>>> + * This capability is given by kernel automatically if executable
>>> + * file is validly signed.
>>> + */
>>> +#define CAP_SIGNED    37
>>> +
>>> +#define CAP_LAST_CAP         CAP_SIGNED
>>>  
>>>  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
>>>  
>>> diff --git a/kernel/cred.c b/kernel/cred.c
>>> index e0573a4..f554d1b 100644
>>> --- a/kernel/cred.c
>>> +++ b/kernel/cred.c
>>> @@ -555,6 +555,12 @@ void revert_creds(const struct cred *old)
>>>  }
>>>  EXPORT_SYMBOL(revert_creds);
>>>  
>>> +static void remove_cap_signed_init_cred(void)
>>> +{
>>> +	cap_lower((&init_cred)->cap_bset, CAP_SIGNED);
>>> +	cap_lower((&init_cred)->cap_permitted, CAP_SIGNED);
>>> +}
>>> +
>>>  /*
>>>   * initialise the credentials stuff
>>>   */
>>> @@ -563,6 +569,7 @@ void __init cred_init(void)
>>>  	/* allocate a slab in which we can store credentials */
>>>  	cred_jar = kmem_cache_create("cred_jar", sizeof(struct cred),
>>>  				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
>>> +	remove_cap_signed_init_cred();
>>>  }
>>>  
>>>  /**
>>> diff --git a/security/commoncap.c b/security/commoncap.c
>>> index c44b6fe..4190eb9 100644
>>> --- a/security/commoncap.c
>>> +++ b/security/commoncap.c
>>> @@ -272,6 +272,8 @@ int cap_capset(struct cred *new,
>>>  	new->cap_effective   = *effective;
>>>  	new->cap_inheritable = *inheritable;
>>>  	new->cap_permitted   = *permitted;
>>> +	if (cap_raised(old->cap_effective, CAP_SIGNED))
>>> +		cap_raise(new->cap_effective, CAP_SIGNED);
>>>  	return 0;
>>>  }
>>>  

