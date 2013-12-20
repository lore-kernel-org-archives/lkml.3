Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3LTDpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 22:45:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:38266 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab3LTDpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 22:45:03 -0500
X-IronPort-AV: E=Sophos;i="4.95,517,1384272000"; 
   d="scan'208";a="9295356"
Message-ID: <52B3BD74.7040204@cn.fujitsu.com>
Date: Fri, 20 Dec 2013 11:45:56 +0800
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
References: <1374006760-7687-1-git-send-email-rgb@redhat.com>		 <52B26F1A.9070308@cn.fujitsu.com>	 <1387478422.29366.33.camel@flatline.rdu.redhat.com>	 <52B3AF8F.5040607@cn.fujitsu.com> <1387509074.2919.36.camel@localhost>
In-Reply-To: <1387509074.2919.36.camel@localhost>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 11:44:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 11:44:28,
	Serialize complete at 2013/12/20 11:44:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 11:11 AM, Eric Paris wrote:
> On Fri, 2013-12-20 at 10:46 +0800, Gao feng wrote:
>> On 12/20/2013 02:40 AM, Eric Paris wrote:
>>> On Thu, 2013-12-19 at 11:59 +0800, Gao feng wrote:
>>>> On 07/17/2013 04:32 AM, Richard Guy Briggs wrote:
> 
>>>> we have to store audit_sock
>>>> into auditns(auditns will be passed to kauditd_send_skb),
>>>> this will cause auditns have to get a reference of netns.
>>>> and for some reason(netfilter audit target), netns will
>>>> get reference of auditns too. this is terrible...
>>>
>>> I'm not sure I agree/understand this entirely...
>>>
>>
>> Yes, the audit_sock is created and destroyed by net namespace,
>> so if auditns wants to use audit_sock, it must prevent netns
>> from being destroyed. so auditns has to get reference of netns.
> 
> Namespace == mind blown.  Ok, so:
> 
>  auditd in audit_ns2 and net_ns2. <--- ONLY process in net_ns2
>  some process in audit_ns2 and net_ns3
> 
> Lets assume that auditd is killed improperly/dies.  Because the last
> process in net_ns2 is gone net_ns2 is invalid/freed.
> 
> Today in the kernel the way we detect auditd is gone is by using the
> socket and getting ECONNREFUSSED.  So here you think that audit_ns2
> should hold a reference on net_ns2, to make sure that socket is always
> valid.
> 
> I instead propose that we could run all audit_ns and reset the audit_pid
> in that namespace and the audit_sock in the namespace to 0/null inside
> audit_net_exit.  Since obviously if the net_ns disappeared, the auditd
> which was running in any audit namespace in that net_ns isn't running
> any more.  We didn't need to hold a reference on the net_ns.  We just
> have to clear the skb_queue, reset the audit_pid to 0, and reset the
> socket to NULL...

multi auditns can share the same netns. it happens if you unshare
auditns. if you want to reset audit_sock to null inside audit_net_exit,
you have to maintain a list in netns, this list contains the auditnss
whose audit_sock is created in this netns. so you can foreach this
list and reset the audit socks of audit nss.

Above is unsharing auditns, consider unsharing netns. auditd is running
in auditns1 and netns1, and then who-know-why the auditd call unshare(CLONE_NEWNET)
to change it's netns from netns1 to new netns2. so the netns1 is released
and auditns->audit_sock being reset to NULL. the auditd cannot receive
the audit log. auditd will in chaos, "I'm still alive, why kernel think
I'm die?"

So maybe you will say, we can reset the audit_sock of netns2 to auditns.
ok, this is a way. but how can we decide if we should reset the auditns->audit_sock?
when we create the new netns, the old netns is still alive, so the auditns->audit_sock
is still valid in that time.

I don't know if there are some other problems we should consider.
it is too complex..

> 
> Maybe the one magic socket is the right answer.  I'm not arguing against
> your solution.  I'm really trying to understand why we are going that
> way...
> 

That's why we should discuss :)

