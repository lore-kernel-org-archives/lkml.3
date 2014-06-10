Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaFJVh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:37:27 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50855 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302AbaFJVh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:37:26 -0400
Date: Tue, 10 Jun 2014 23:37:22 +0200
From: Florian Westphal <fw@strlen.de>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: =?iso-8859-15?Q?Egerv=E1ry?= Gergely <gergely@egervary.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, stable@kernel.org
Subject: Re: 3.4.92 MTU issues
Message-ID: <20140610213722.GE1970@breakpoint.cc>
References: <53975FF9.5070803@egervary.hu>
 <CAADnVQ+q3wFf=j0TY57d6Ux4GyGLr0bVCFHDgA45n9rXiEEzjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQ+q3wFf=j0TY57d6Ux4GyGLr0bVCFHDgA45n9rXiEEzjg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

[ Cc'ing stable team since its stable specific regression ]

> On Tue, Jun 10, 2014 at 12:43 PM, Egerváry Gergely <gergely@egervary.hu> wrote:
> > Hi,
> >
> > we have just upgraded our systems from 3.4.91 (longterm) to 3.4.92.
> > Since then we are experiencing dozens of MTU-related network timeout
> > issues. Reverting back to 3.4.91 fixes all of these problems.
> >
> > Both kernel versions are built from vanilla sources with the same
> > .config. These can be highly reproduced over VPN tunnels or even over
> > simple ethernet connections when using DNAT. (TCP port forward) It
> > looks like MTU path discovery is somehow affected.
> >
> > ICMP is not filtered in our network. (For testing, we flushed all
> > iptables rules, set all policies to ACCEPT, and problem still exists.)
> > We do not use any special sysctl settings. Was there any changes
> > related to packet forwarding or MTU discovery?

These were in earlier releases than 3.4.92.

> some combination of old kernel and backport of ("net: ipv4:
> ip_forward: fix inverted local_df test") ?
> just guessing

Excellent guess.  Yes, this is the culprit.

Quoting that patch changelog:

'This wasn't noticed earlier [..] because netfilter ip defrag did not set local_df
until couple of days ago.'

-stable lacks commit 895162b1101b3ea5db08ca6822ae9672717efec0, so
netfilter never sets ->local_df.  Thus all defragmented packets
that go over the mtu are refused to be forwarded.

Gergely, please either revert

commit bd91cb56f951a7b0da8c3098ea9cd56854ece66c
Author: Florian Westphal <fw@strlen.de>
net: ipv4: ip_forward: fix inverted local_df test
[ Upstream commit ca6c5d4ad216d5942ae544bbf02503041bd802aa ]

Or, alternatively, also apply upstream commit 895162b1101b3ea5db08ca6822ae9672717efec0
Author: Florian Westphal <fw@strlen.de>
Date:   Fri May 2 15:32:16 2014 +0200
netfilter: ipv4: defrag: set local_df flag on defragmented skb

on top of your 3.4.92 kernel.

(The latter might be a better option since it will also fix the
 long-standing issue where netfilter sends bogus frag-needed message
 under very rare circumstances).

Thanks for reporting, and sorry for not noticing during stable review
cycle 8-(
