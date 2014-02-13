Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaBMTC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:02:27 -0500
Received: from smtprelay0036.hostedemail.com ([216.40.44.36]:46807 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750861AbaBMTCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:02:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:2:41:69:355:379:541:599:800:960:966:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1606:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3872:3874:4117:4250:4321:4385:4419:5007:6119:7652:7903:8957:9010:9040:10004:10848:11026:11232:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12660:12679:12683:12740:13972:21063,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nose70_1484cbae61332
X-Filterd-Recvd-Size: 6717
Message-ID: <1392318137.2214.69.camel@joe-AO722>
Subject: Re: ip_set: protocol %u message -- useful?
From: Joe Perches <joe@perches.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Cong Wang <cwang@twopensource.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Ilia Mirkin <imirkin@alum.mit.edu>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vitaly Lavrov <lve@guap.ru>
Date: Thu, 13 Feb 2014 11:02:17 -0800
In-Reply-To: <20140213184254.GF14175@macbook.localnet>
References: <CAKb7UvhsLi2Sv4SWA2nVTgoFV8dzrY=3R1-SUk9D-aa0VdizSA@mail.gmail.com>
	 <alpine.DEB.2.10.1402131117120.16734@blackhole.kfki.hu>
	 <CAHA+R7MeEEfqz-7RhCUjsoWPx_BKHVXFV3Y32xjf0B1WwjNdRQ@mail.gmail.com>
	 <20140213184254.GF14175@macbook.localnet>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-13 at 18:42 +0000, Patrick McHardy wrote:
> On Thu, Feb 13, 2014 at 10:32:45AM -0800, Cong Wang wrote:
> > On Thu, Feb 13, 2014 at 2:30 AM, Jozsef Kadlecsik
> > <kadlec@blackhole.kfki.hu> wrote:
> > > On Thu, 13 Feb 2014, Ilia Mirkin wrote:
> > >> messages in my dmesg. This might be because of some local
> > >> configuration changes I've made, or perhaps a kernel upgrade. Either
> > >> way, it appears this message has been a pr_notice since the original
> > >> code added it in a7b4f989a62 ("netfilter: ipset: IP set core
> > >> support").
> > >>
> > >> Does this message provide a lot of value? Or could it be made into a pr_debug?
> > >
> > > That's a report message on the protocol version used by the ipset
> > > subsystem. There was (and possibly will be) multiple protocols, so it
> > > helps to catch basic userpsace/kernelspace communication issues.
> > 
> > But still it doesn't deserve a pr_notice()... pr_info() should be enough.
> 
> Maybe printing "using protocol version X" will make it appear less like
> a debugging message referring to packet contents or something similar.

Maybe making all the ip_set messages be prefixed with "ip_set: "
would help too.

Add pr_fmt
Remove embedded ip_set prefixes
Convert pr_warning to pr_warn
Realign arguments

---
 net/netfilter/ipset/ip_set_core.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index de770ec..1d4396f 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -9,6 +9,8 @@
 
 /* Kernel module for IP set management */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -101,7 +103,7 @@ load_settype(const char *name)
 	nfnl_unlock(NFNL_SUBSYS_IPSET);
 	pr_debug("try to load ip_set_%s\n", name);
 	if (request_module("ip_set_%s", name) < 0) {
-		pr_warning("Can't find ip_set type %s\n", name);
+		pr_warn("Can't find type %s\n", name);
 		nfnl_lock(NFNL_SUBSYS_IPSET);
 		return false;
 	}
@@ -195,25 +197,24 @@ ip_set_type_register(struct ip_set_type *type)
 	int ret = 0;
 
 	if (type->protocol != IPSET_PROTOCOL) {
-		pr_warning("ip_set type %s, family %s, revision %u:%u uses "
-			   "wrong protocol version %u (want %u)\n",
-			   type->name, family_name(type->family),
-			   type->revision_min, type->revision_max,
-			   type->protocol, IPSET_PROTOCOL);
+		pr_warn("type %s, family %s, revision %u:%u uses wrong protocol version %u (want %u)\n",
+			type->name, family_name(type->family),
+			type->revision_min, type->revision_max,
+			type->protocol, IPSET_PROTOCOL);
 		return -EINVAL;
 	}
 
 	ip_set_type_lock();
 	if (find_set_type(type->name, type->family, type->revision_min)) {
 		/* Duplicate! */
-		pr_warning("ip_set type %s, family %s with revision min %u "
-			   "already registered!\n", type->name,
-			   family_name(type->family), type->revision_min);
+		pr_warn("type %s, family %s with revision min %u already registered!\n",
+			type->name, family_name(type->family),
+			type->revision_min);
 		ret = -EINVAL;
 		goto unlock;
 	}
 	list_add_rcu(&type->list, &ip_set_type_list);
-	pr_debug("type %s, family %s, revision %u:%u registered.\n",
+	pr_debug("type %s, family %s, revision %u:%u registered\n",
 		 type->name, family_name(type->family),
 		 type->revision_min, type->revision_max);
 unlock:
@@ -228,13 +229,13 @@ ip_set_type_unregister(struct ip_set_type *type)
 {
 	ip_set_type_lock();
 	if (!find_set_type(type->name, type->family, type->revision_min)) {
-		pr_warning("ip_set type %s, family %s with revision min %u "
-			   "not registered\n", type->name,
-			   family_name(type->family), type->revision_min);
+		pr_warn("type %s, family %s with revision min %u not registered\n",
+			type->name, family_name(type->family),
+			type->revision_min);
 		goto unlock;
 	}
 	list_del_rcu(&type->list);
-	pr_debug("type %s, family %s with revision min %u unregistered.\n",
+	pr_debug("type %s, family %s with revision min %u unregistered\n",
 		 type->name, family_name(type->family), type->revision_min);
 unlock:
 	ip_set_type_unlock();
@@ -269,8 +270,8 @@ EXPORT_SYMBOL_GPL(ip_set_alloc);
 void
 ip_set_free(void *members)
 {
-	pr_debug("%p: free with %s\n", members,
-		 is_vmalloc_addr(members) ? "vfree" : "kfree");
+	pr_debug("%p: free with %s\n",
+		 members, is_vmalloc_addr(members) ? "vfree" : "kfree");
 	if (is_vmalloc_addr(members))
 		vfree(members);
 	else
@@ -1945,7 +1946,7 @@ ip_set_net_init(struct net *net)
 		return -ENOMEM;
 	inst->is_deleted = 0;
 	rcu_assign_pointer(inst->ip_set_list, list);
-	pr_notice("ip_set: protocol %u\n", IPSET_PROTOCOL);
+	pr_notice("protocol %u\n", IPSET_PROTOCOL);
 	return 0;
 }
 
@@ -1980,7 +1981,7 @@ ip_set_init(void)
 {
 	int ret = nfnetlink_subsys_register(&ip_set_netlink_subsys);
 	if (ret != 0) {
-		pr_err("ip_set: cannot register with nfnetlink.\n");
+		pr_err("cannot register with nfnetlink\n");
 		return ret;
 	}
 	ret = nf_register_sockopt(&so_set);
@@ -1991,7 +1992,7 @@ ip_set_init(void)
 	}
 	ret = register_pernet_subsys(&ip_set_net_ops);
 	if (ret) {
-		pr_err("ip_set: cannot register pernet_subsys.\n");
+		pr_err("cannot register pernet_subsys\n");
 		nf_unregister_sockopt(&so_set);
 		nfnetlink_subsys_unregister(&ip_set_netlink_subsys);
 		return ret;


