Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab3LSSkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:40:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab3LSSkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:40:32 -0500
Message-ID: <1387478422.29366.33.camel@flatline.rdu.redhat.com>
Subject: Re: [PATCH] audit: listen in all network namespaces
From: Eric Paris <eparis@redhat.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        Steve Grubb <sgrubb@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>
Date: Thu, 19 Dec 2013 13:40:22 -0500
In-Reply-To: <52B26F1A.9070308@cn.fujitsu.com>
References: <1374006760-7687-1-git-send-email-rgb@redhat.com>
	 <52B26F1A.9070308@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 11:59 +0800, Gao feng wrote:
> On 07/17/2013 04:32 AM, Richard Guy Briggs wrote:
> > Convert audit from only listening in init_net to use register_pernet_subsys()
> > to dynamically manage the netlink socket list.
> > 
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> 
> I think it's the time for us to discuss if we should revert this
> commit, since this one prevent me from continuing to achieve
> audit namespace.
> 
> 
> The major problem is in kaudit_send_skb, we have no idea which
> audit sock the skb should send to.

right, we have problems here no matter what...

If we stick with the current approach you will need to know socket +
portid.  With your approach one only needs to know portid.  Since these
are can both be part of the audit_ns structure I don't see a huge
difference...

> we have to store audit_sock
> into auditns(auditns will be passed to kauditd_send_skb),
> this will cause auditns have to get a reference of netns.
> and for some reason(netfilter audit target), netns will
> get reference of auditns too. this is terrible...

I'm not sure I agree/understand this entirely...

> So why not we revert this one, and use a very simple one to
> replace it? the below patch will save us from the refer to
> each other case, achieve the same effect.
> 
> what's your opinion?

Help me go all the way back to the beginning.  What's our end goal here
again?

When thinking about this I realized we have another problem that I don't
think we've considered.  Which makes me lean away from the single
socket/kauditd  :(

I we have one socket and one kauditd ANY auditd can completely freeze
the audit system.  Which seems problematic, especially if there isn't
equal levels of trust between the different namespaces...  If one auditd
gets hung (intentionally or not) the kernel will never send another
audit message....

Makes me think we really need a kauditd thread per namespace, possibly
an skb queue per namespace.  At which point an audit socket per
namespace makes a lot of sense too....

