Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3LTCsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 21:48:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:9925 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab3LTCsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 21:48:21 -0500
X-IronPort-AV: E=Sophos;i="4.95,517,1384272000"; 
   d="scan'208";a="9294941"
Message-ID: <52B3AF8F.5040607@cn.fujitsu.com>
Date: Fri, 20 Dec 2013 10:46:39 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        Steve Grubb <sgrubb@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] audit: listen in all network namespaces
References: <1374006760-7687-1-git-send-email-rgb@redhat.com>	 <52B26F1A.9070308@cn.fujitsu.com> <1387478422.29366.33.camel@flatline.rdu.redhat.com>
In-Reply-To: <1387478422.29366.33.camel@flatline.rdu.redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 10:45:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 10:47:44,
	Serialize complete at 2013/12/20 10:47:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 02:40 AM, Eric Paris wrote:
> On Thu, 2013-12-19 at 11:59 +0800, Gao feng wrote:
>> On 07/17/2013 04:32 AM, Richard Guy Briggs wrote:
>>> Convert audit from only listening in init_net to use register_pernet_subsys()
>>> to dynamically manage the netlink socket list.
>>>
>>> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
>>> ---
>>
>> I think it's the time for us to discuss if we should revert this
>> commit, since this one prevent me from continuing to achieve
>> audit namespace.
>>
>>
>> The major problem is in kaudit_send_skb, we have no idea which
>> audit sock the skb should send to.
> 
> right, we have problems here no matter what...
> 
> If we stick with the current approach you will need to know socket +
> portid.  With your approach one only needs to know portid.  Since these
> are can both be part of the audit_ns structure I don't see a huge
> difference...
> 
>> we have to store audit_sock
>> into auditns(auditns will be passed to kauditd_send_skb),
>> this will cause auditns have to get a reference of netns.
>> and for some reason(netfilter audit target), netns will
>> get reference of auditns too. this is terrible...
> 
> I'm not sure I agree/understand this entirely...
> 

Yes, the audit_sock is created and destroyed by net namespace,
so if auditns wants to use audit_sock, it must prevent netns
from being destroyed. so auditns has to get reference of netns.

and in some case, netns will get reference of auditns too. this
is complex than making audit_sock global and getting rid of this
reference.

