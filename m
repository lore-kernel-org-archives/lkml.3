Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3LTDLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 22:11:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab3LTDLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 22:11:21 -0500
Message-ID: <1387509074.2919.36.camel@localhost>
Subject: Re: [PATCH] audit: listen in all network namespaces
From: Eric Paris <eparis@redhat.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        Steve Grubb <sgrubb@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>
Date: Thu, 19 Dec 2013 22:11:14 -0500
In-Reply-To: <52B3AF8F.5040607@cn.fujitsu.com>
References: <1374006760-7687-1-git-send-email-rgb@redhat.com>
		 <52B26F1A.9070308@cn.fujitsu.com>
	 <1387478422.29366.33.camel@flatline.rdu.redhat.com>
	 <52B3AF8F.5040607@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-20 at 10:46 +0800, Gao feng wrote:
> On 12/20/2013 02:40 AM, Eric Paris wrote:
> > On Thu, 2013-12-19 at 11:59 +0800, Gao feng wrote:
> >> On 07/17/2013 04:32 AM, Richard Guy Briggs wrote:

> >> we have to store audit_sock
> >> into auditns(auditns will be passed to kauditd_send_skb),
> >> this will cause auditns have to get a reference of netns.
> >> and for some reason(netfilter audit target), netns will
> >> get reference of auditns too. this is terrible...
> > 
> > I'm not sure I agree/understand this entirely...
> > 
> 
> Yes, the audit_sock is created and destroyed by net namespace,
> so if auditns wants to use audit_sock, it must prevent netns
> from being destroyed. so auditns has to get reference of netns.

Namespace == mind blown.  Ok, so:

 auditd in audit_ns2 and net_ns2. <--- ONLY process in net_ns2
 some process in audit_ns2 and net_ns3

Lets assume that auditd is killed improperly/dies.  Because the last
process in net_ns2 is gone net_ns2 is invalid/freed.

Today in the kernel the way we detect auditd is gone is by using the
socket and getting ECONNREFUSSED.  So here you think that audit_ns2
should hold a reference on net_ns2, to make sure that socket is always
valid.

I instead propose that we could run all audit_ns and reset the audit_pid
in that namespace and the audit_sock in the namespace to 0/null inside
audit_net_exit.  Since obviously if the net_ns disappeared, the auditd
which was running in any audit namespace in that net_ns isn't running
any more.  We didn't need to hold a reference on the net_ns.  We just
have to clear the skb_queue, reset the audit_pid to 0, and reset the
socket to NULL...

Maybe the one magic socket is the right answer.  I'm not arguing against
your solution.  I'm really trying to understand why we are going that
way...

> and in some case, netns will get reference of auditns too. this
> is complex than making audit_sock global and getting rid of this
> reference.

This I haven't even started to try to wrap my head around...

