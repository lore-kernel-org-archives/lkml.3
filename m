Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3FJVX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:23:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25723 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab3FJVX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:23:26 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=tLUlnkoJZcZI9ocdGARlSQ==:17 a=c11ml42nfjYA:10 a=wom5GMh1gUkA:10 a=2Mvv2snrxhsA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=hBqU3vQJAAAA:8 a=2fDNonidTOoA:10 a=omOdbC7AAAAA:8 a=fxJcL_dCAAAA:8 a=Ms-UuwhkBgPOIrQ0-J8A:9 a=CjuIK1q_8ugA:10 a=2eKvNQJKnqYA:10 a=tLUlnkoJZcZI9ocdGARlSQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 70.114.148.7
Date: Mon, 10 Jun 2013 16:24:37 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        eparis@redhat.com, linux-audit@redhat.com, ebiederm@xmission.com,
        davem@davemloft.net
Subject: Re: [PATCH RFC 00/48] Add namespace support for audit
Message-ID: <20130610212437.GA11940@austin.hallyn.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
 <519B3B4E.1070405@cn.fujitsu.com>
 <20130606215255.GA28978@tp>
 <20130606224710.GA30502@tp>
 <51B531CC.2020604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B531CC.2020604@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Gao feng (gaofeng@cn.fujitsu.com):
> On 06/07/2013 06:47 AM, Serge Hallyn wrote:
> > Quoting Serge Hallyn (serge.hallyn@ubuntu.com):
> >> Quoting Gao feng (gaofeng@cn.fujitsu.com):
> >>> On 05/07/2013 10:20 AM, Gao feng wrote:
> >>>> This patchset try to add namespace support for audit.
> >>>>
> >>>> I choose to assign audit to the user namespace.
> >>>> Right now,there are six kinds of namespaces, such as
> >>>> net, mount, ipc, pid, uts and user. the first five
> >>>> namespaces have special usage. the audit isn't suitable to
> >>>> belong to these five namespaces, so the user namespace
> >>>> may be the best choice.
> >>>>
> >>>> Through I decide to make audit related resources per user
> >>>> namespace, but audit uses netlink to communicate between kernel
> >>>> space and user space, and the netlink is a private resource
> >>>> of per net namespace. So we need the capability to allow the
> >>>> netlink sockets to communicate with each other in the same user
> >>>> namespace even they are in different net namespace. [PATCH 2/48]
> >>>> does this job, it adds a new function "compare" for per netlink
> >>>> table to compare two sockets. it means the netlink protocols can
> >>>> has its own compare fuction, For other protocols, two netlink
> >>>> sockets are different if they belong to the different net namespace.
> >>>> For audit protocol, two sockets can be the same even they in different
> >>>> net namespace,we use user namespace not net namespace to make the
> >>>> decision.
> >>>>
> >>>> There is one point that some people may dislike,in [PATCH 1/48],
> >>>> the kernel side audit netlink socket is created only when we create
> >>>> the first netns for the userns, and this userns will hold the netns
> >>>> until we destroy this userns.
> >>>>
> >>>> The other patches just make the audit related resources per
> >>>> user namespace.
> >>>>
> >>>> This patchset is sent as an RFC,any comments are welcome.
> >>
> >> Hi,
> >>
> >> thanks for sending this.  I think you need to ping the selinux folks
> >> for comment though.  It appears to me that, after this patchset, the
> >> kernel with CONFIG_USER_NS=y could not be LSPP-compliant, because
> >> the selinux-generated audit messages do not always go to init_user_ns.
> >>
> >> Additionally, the only type of namespacing selinux wants is where it
> >> is enforced by policy compiler and installer using typenames - i.e.
> >> 'container1.user_t' vs 'user_t'.  Selinux does not want user namespaces
> >> to affect selinux enforcement at all.  (at least last I knew, several
> >> years ago at a mini-summit, I believe this was from Stephen Smalley).
> > 
> > That sort of sounds like I'm distancing myself from that, which I
> > don't mean to do.  I agree with the decison:  MAC (selinux, apparmor
> > and smack) should not be confuddled by user namespaces.  (posix caps
> > are, as always, a bit different).
> 
> 
> Thanks for your comments!
> 
> Very useful information, it sounds reasonable.
> 
> Let's just drop those patches.
> 

Hi Gao,

proceeding then,

The netfilter related changes I think make sense.  They log to the userns
which owns the netns in question, which seems right.

However looking at Audit-tty-translate-audit_log_start-to-audit_log_sta.patch,
it appears to log to the userns of the task which is doing the operation.

Keeping in mind that an unprivileged user can create a new user namespace,
this doesn't seem right.

Also, you are introducing per-userns syscall filter.  It looks like I
can then create a new userns to escape my existing syscall filter, since
the filters up the user_ns parent chain are not being applied.  Is that
correct?

Did you have a particular rationale written out for what precisely you're
wanting to make per-userns?  That would be helpful in trying to figure
out which bits are appropriate.  Again I so far haven't seen a single
problem with the code itself, it's just a question of which bits we
actually want (and are safe).

-serge
