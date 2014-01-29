Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaA2M5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 07:57:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:51145 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751888AbaA2M5s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 07:57:48 -0500
Date: Wed, 29 Jan 2014 07:57:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: nicolas.dichtel@6wind.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        stable <stable@vger.kernel.org>, Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 0/2] [BUG FIXES - 3.10.27] sit: More backports
Message-ID: <20140129075745.4227a2ed@gandalf.local.home>
In-Reply-To: <52E8E025.2060803@6wind.com>
References: <20140128205756.074448668@goodmis.org>
	<52E8E025.2060803@6wind.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jan 2014 12:04:05 +0100
Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:

> Le 28/01/2014 21:57, Steven Rostedt a écrit :
> > At Red Hat we base our real-time kernel off of 3.10.27 and do lots of
> > stress testing on that kernel. This has discovered some bugs that we
> > can hit with the vanilla 3.10.27 kernel (no -rt patches applied).
> >
> > I sent out a bug fix that can cause a crash with the current 3.10.27
> > when you add and then remove the sit module. That patch is obsoleted by
> > these patches, as that patch was not enough.
> Can you explain a bit more which problem remains after that patch?
> I wonder if a problem remains also with ip6_tunnel.ko (net/ipv6/ip6_tunnel.c),
> the same problem was spotted into this module.

Hmm, OK it may only need the first version of the patch. It was one of
those cases where it didn't fix the second bug, so we added the full
patch as well. Then we found the second bug but never tried all the
tests with the smaller version of the patch. I'll put back the first
patch and then ask our QA to retest it with the older version and the
other patch.

> 
> >
> > A previous patch that was backported:
> >
> >    Upstream commit 205983c43700ac3a81e7625273a3fa83cd2759b5
> >    sit: allow to use rtnl ops on fb tunnel
> >
> > Had a depenency on commit 5e6700b3bf98 ("sit: add support of x-netns")
> > which was not backported. The dependency was only on part of that
> > commit which is what I backported.
> I cannot comment directly the patch, it was an attachement, hence I put my

It's not really an attachment. It was sent with quilt mail, which only
makes it look like one. What mail client are you using? mutt, alpine,
evolution, claws-mail, and thunderbird all show it as a normal patch.
I do know that k9-mail on android makes it into an attachment.

> comments here.
> In patch 0001-sit-Unregister-sit-devices-with-rtnl_link_ops.patch, I wonder how
> 'if (dev_net(t->dev) != net)' can be wrong. If commit 5e6700b3bf98 ("sit: add
> support of x-netns") has not been backported, this test is always true.

Should it just be removed then? This has fixed our bugs, but perhaps it
opened new ones we haven't detected yet. I can remove the if and
unregister and see if it still works. Or perhaps calling unregister all
the time isn't bad.

-- Steve


> 
> >
> > The other upstream commit 9434266f2c645d4fcf62a03a8e36ad8075e37943
> > sit: fix use after free of fb_tunnel_dev
> >
> > fixes another bug we encountered, it also fixes the 3.10.27 bug
> > where removing the sit module cause the crash. This is the patch
> > that obsoletes my previous patch.
> >
> > -- Steve
> >
> >
> > Steven Rostedt (Red Hat) (1):
> >        sit: Unregister sit devices with rtnl_link_ops
> >
> > Willem de Bruijn (1):
> >        sit: fix use after free of fb_tunnel_dev
> >
> > ----
> >   net/ipv6/sit.c | 30 +++++++++++++++++++++++++-----
> >   1 file changed, 25 insertions(+), 5 deletions(-)
> >

