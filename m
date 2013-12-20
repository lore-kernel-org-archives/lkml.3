Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab3LTBe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 20:34:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:44829 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756516Ab3LTBe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 20:34:56 -0500
X-IronPort-AV: E=Sophos;i="4.95,516,1384272000"; 
   d="scan'208";a="9294465"
Message-ID: <52B39EF3.5020202@cn.fujitsu.com>
Date: Fri, 20 Dec 2013 09:35:47 +0800
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
 2013/12/20 09:34:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 09:34:22,
	Serialize complete at 2013/12/20 09:34:22
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

My brain must be destroyed, I need to think about if auditns
should get reference of netns. it's not clear to me now. :(
but I intend to think you are right.

>> So why not we revert this one, and use a very simple one to
>> replace it? the below patch will save us from the refer to
>> each other case, achieve the same effect.
>>
>> what's your opinion?
> 
> Help me go all the way back to the beginning.  What's our end goal here
> again?
> 
> When thinking about this I realized we have another problem that I don't
> think we've considered.  Which makes me lean away from the single
> socket/kauditd  :(
> 
> I we have one socket and one kauditd ANY auditd can completely freeze
> the audit system.  Which seems problematic, especially if there isn't
> equal levels of trust between the different namespaces...  If one auditd
> gets hung (intentionally or not) the kernel will never send another
> audit message....
> 
> Makes me think we really need a kauditd thread per namespace, possibly
> an skb queue per namespace.  At which point an audit socket per
> namespace makes a lot of sense too....
> 

You are right, and My prototype supports per kauditd/auditd/sbk queue per
audit namespace. one auditd freeze in one auditns will not affect audit
subsystem in another auditns.

Thanks!
