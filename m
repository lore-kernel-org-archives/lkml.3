Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaA2QES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 11:04:18 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:57727 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaA2QEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 11:04:16 -0500
Message-ID: <52E9267C.90403@6wind.com>
Date: Wed, 29 Jan 2014 17:04:12 +0100
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        stable <stable@vger.kernel.org>, Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 0/2] [BUG FIXES - 3.10.27] sit: More backports
References: <20140128205756.074448668@goodmis.org>	<52E8E025.2060803@6wind.com> <20140129075745.4227a2ed@gandalf.local.home>
In-Reply-To: <20140129075745.4227a2ed@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 29/01/2014 13:57, Steven Rostedt a écrit :
> On Wed, 29 Jan 2014 12:04:05 +0100
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
>
>> Le 28/01/2014 21:57, Steven Rostedt a écrit :
>>> At Red Hat we base our real-time kernel off of 3.10.27 and do lots of
>>> stress testing on that kernel. This has discovered some bugs that we
>>> can hit with the vanilla 3.10.27 kernel (no -rt patches applied).
>>>
>>> I sent out a bug fix that can cause a crash with the current 3.10.27
>>> when you add and then remove the sit module. That patch is obsoleted by
>>> these patches, as that patch was not enough.
>> Can you explain a bit more which problem remains after that patch?
>> I wonder if a problem remains also with ip6_tunnel.ko (net/ipv6/ip6_tunnel.c),
>> the same problem was spotted into this module.
>
> Hmm, OK it may only need the first version of the patch. It was one of
> those cases where it didn't fix the second bug, so we added the full
> patch as well. Then we found the second bug but never tried all the
> tests with the smaller version of the patch. I'll put back the first
> patch and then ask our QA to retest it with the older version and the
> other patch.
>
>>
>>>
>>> A previous patch that was backported:
>>>
>>>     Upstream commit 205983c43700ac3a81e7625273a3fa83cd2759b5
>>>     sit: allow to use rtnl ops on fb tunnel
>>>
>>> Had a depenency on commit 5e6700b3bf98 ("sit: add support of x-netns")
>>> which was not backported. The dependency was only on part of that
>>> commit which is what I backported.
>> I cannot comment directly the patch, it was an attachement, hence I put my
>
> It's not really an attachment. It was sent with quilt mail, which only
> makes it look like one. What mail client are you using? mutt, alpine,
> evolution, claws-mail, and thunderbird all show it as a normal patch.
> I do know that k9-mail on android makes it into an attachment.
Thunderbird. The patch was show as a normal aptch, but when I do "reply all", I
get an empty mail.

>
>> comments here.
>> In patch 0001-sit-Unregister-sit-devices-with-rtnl_link_ops.patch, I wonder how
>> 'if (dev_net(t->dev) != net)' can be wrong. If commit 5e6700b3bf98 ("sit: add
>> support of x-netns") has not been backported, this test is always true.
>
> Should it just be removed then? This has fixed our bugs, but perhaps it
> opened new ones we haven't detected yet. I can remove the if and
> unregister and see if it still works. Or perhaps calling unregister all
> the time isn't bad.
Ok, I've think a bit more to this problem. First, let's explain it.

rmmod sit
=> sit_cleanup()
   => rtnl_link_unregister()
     => __rtnl_kill_links()
       => for_each_netdev(net, dev) {
            if (dev->rtnl_link_ops == ops)
               ops->dellink(dev, &list_kill);
          }
  **at this point, the FB device is deleted (and all sit tunnels)**

   => unregister_pernet_device()
     => unregister_pernet_operations()
       => ops_exit_list()
         => sit_exit_net()
           => sit_destroy_tunnels()
              in this function, no tunnel is found
           unregister_netdevice_queue(sitn->fb_tunnel_dev, &list);
   ** second deletion, here is the bug **

Now, what happen on netns deletion with the previous patch? Only sit_exit_net()
will be called, hence with the previous patch, the fb device will not be
destroyed, netns will leak.

Your patch serie seems to be the good way to go (note that patch 1/2 does not
compile) but I think the fix is smaller because we don't have x-netns.

Here is my proposal, if you agree, I will send the same patch for ip6_tunnnel,
which have the netns leak.


 From d101450583c3a472a2a94904cfe13fd4e7d2f519 Mon Sep 17 00:00:00 2001
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Wed, 29 Jan 2014 16:40:30 +0100
Subject: [PATCH] sit: fix double free of fb_tunnel_dev on exit

This problem was fixed upstream by commit 9434266f2c64 ("sit: fix use after free
of fb_tunnel_dev").
The upstream patch depends on upstream commit 5e6700b3bf98 ("sit: add support of
x-netns"), which was not backported into 3.10 branch.

First, explain the problem: when the sit module is unloaded, sit_cleanup() is
called.
rmmod sit
=> sit_cleanup()
   => rtnl_link_unregister()
     => __rtnl_kill_links()
       => for_each_netdev(net, dev) {
         if (dev->rtnl_link_ops == ops)
         	ops->dellink(dev, &list_kill);
         }
At this point, the FB device is deleted (and all sit tunnels).
   => unregister_pernet_device()
     => unregister_pernet_operations()
       => ops_exit_list()
         => sit_exit_net()
           => sit_destroy_tunnels()
           In this function, no tunnel is found.
           => unregister_netdevice_queue(sitn->fb_tunnel_dev, &list);
We delete the FB device a second time here!

Because we cannot simply remove the second deletion (sit_exit_net() must remove
the FB device when a netns is deleted), we add an rtnl ops which delete all sit
device excepting the FB device and thus we can keep the explicit deletion in
sit_exit_net().

CC: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
  net/ipv6/sit.c | 10 ++++++++++
  1 file changed, 10 insertions(+)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 0491264b8bfc..620d326e8fdd 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1507,6 +1507,15 @@ static const struct nla_policy 
ipip6_policy[IFLA_IPTUN_MAX + 1] = {
  #endif
  };

+static void ipip6_dellink(struct net_device *dev, struct list_head *head)
+{
+	struct net *net = dev_net(dev);
+	struct sit_net *sitn = net_generic(net, sit_net_id);
+
+	if (dev != sitn->fb_tunnel_dev)
+		unregister_netdevice_queue(dev, head);
+}
+
  static struct rtnl_link_ops sit_link_ops __read_mostly = {
  	.kind		= "sit",
  	.maxtype	= IFLA_IPTUN_MAX,
@@ -1517,6 +1526,7 @@ static struct rtnl_link_ops sit_link_ops __read_mostly = {
  	.changelink	= ipip6_changelink,
  	.get_size	= ipip6_get_size,
  	.fill_info	= ipip6_fill_info,
+	.dellink	= ipip6_dellink,
  };

  static struct xfrm_tunnel sit_handler __read_mostly = {
-- 
1.8.4.1
