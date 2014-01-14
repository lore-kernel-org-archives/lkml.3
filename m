Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaANL6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:58:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbaANL6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:58:37 -0500
Date: Tue, 14 Jan 2014 12:55:20 +0100
From: Veaceslav Falico <vfalico@redhat.com>
To: Ying Xue <ying.xue@windriver.com>
Cc: davem@davemloft.net, john.r.fastabend@intel.com,
        stephen@networkplumber.org, antonio@meshcoding.com,
        dmitry.tarnyagin@lockless.no, socketcan@hartkopp.net,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 02/10] bonding: use __dev_get_by_name instead of
 dev_get_by_name to find interface
Message-ID: <20140114115520.GH4132@redhat.com>
References: <1389685269-18600-1-git-send-email-ying.xue@windriver.com>
 <1389685269-18600-3-git-send-email-ying.xue@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1389685269-18600-3-git-send-email-ying.xue@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 03:41:01PM +0800, Ying Xue wrote:
>The following call chain indicates that bond_do_ioctl() is protected
>under rtnl_lock. If we use __dev_get_by_name() instead of
>dev_get_by_name() to find interface handler in it, this would
>help us avoid to change reference counter of interface once.
>
>dev_ioctl()
>  rtnl_lock()
>  dev_ifsioc()
>    bond_do_ioctl()
>  rtnl_unlock()
>
>Additionally we also change the coding style in bond_do_ioctl(),
>letting it more readable for us.
>
>Cc: Jay Vosburgh <fubar@us.ibm.com>
>Cc: Veaceslav Falico <vfalico@redhat.com>

Acked-by: Veaceslav Falico <vfalico@redhat.com>

>Signed-off-by: Ying Xue <ying.xue@windriver.com>
>---
> drivers/net/bonding/bond_main.c |   49 ++++++++++++++++++---------------------
> 1 file changed, 23 insertions(+), 26 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index e06c445..a69afbf 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -3213,37 +3213,34 @@ static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd
> 	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
> 		return -EPERM;
>
>-	slave_dev = dev_get_by_name(net, ifr->ifr_slave);
>+	slave_dev = __dev_get_by_name(net, ifr->ifr_slave);
>
> 	pr_debug("slave_dev=%p:\n", slave_dev);
>
> 	if (!slave_dev)
>-		res = -ENODEV;
>-	else {
>-		pr_debug("slave_dev->name=%s:\n", slave_dev->name);
>-		switch (cmd) {
>-		case BOND_ENSLAVE_OLD:
>-		case SIOCBONDENSLAVE:
>-			res = bond_enslave(bond_dev, slave_dev);
>-			break;
>-		case BOND_RELEASE_OLD:
>-		case SIOCBONDRELEASE:
>-			res = bond_release(bond_dev, slave_dev);
>-			break;
>-		case BOND_SETHWADDR_OLD:
>-		case SIOCBONDSETHWADDR:
>-			bond_set_dev_addr(bond_dev, slave_dev);
>-			res = 0;
>-			break;
>-		case BOND_CHANGE_ACTIVE_OLD:
>-		case SIOCBONDCHANGEACTIVE:
>-			res = bond_option_active_slave_set(bond, slave_dev);
>-			break;
>-		default:
>-			res = -EOPNOTSUPP;
>-		}
>+		return -ENODEV;
>
>-		dev_put(slave_dev);
>+	pr_debug("slave_dev->name=%s:\n", slave_dev->name);
>+	switch (cmd) {
>+	case BOND_ENSLAVE_OLD:
>+	case SIOCBONDENSLAVE:
>+		res = bond_enslave(bond_dev, slave_dev);
>+		break;
>+	case BOND_RELEASE_OLD:
>+	case SIOCBONDRELEASE:
>+		res = bond_release(bond_dev, slave_dev);
>+		break;
>+	case BOND_SETHWADDR_OLD:
>+	case SIOCBONDSETHWADDR:
>+		bond_set_dev_addr(bond_dev, slave_dev);
>+		res = 0;
>+		break;
>+	case BOND_CHANGE_ACTIVE_OLD:
>+	case SIOCBONDCHANGEACTIVE:
>+		res = bond_option_active_slave_set(bond, slave_dev);
>+		break;
>+	default:
>+		res = -EOPNOTSUPP;
> 	}
>
> 	return res;
>-- 
>1.7.9.5
>
