Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135Ab3K2FF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 00:05:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52928 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3K2FF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 00:05:57 -0500
Date: Thu, 28 Nov 2013 23:05:49 -0600
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: containers@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        gaofeng@cn.fujitsu.com, David Miller <davem@davemloft.net>,
        Li Zefan <lizefan@huawei.com>, Huang Qiang <h.huangqiang@huawei.com>,
        Wengmeiling <wengmeiling.weng@huawei.com>
Subject: Re: Q: use vlan in container
Message-ID: <20131129050549.GB8830@sergelap>
References: <5296E003.80804@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5296E003.80804@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Libo Chen (clbchenlibo.chen@huawei.com):
> Hello LXC experts,
> 
> 	I meet a problem. When using vlan as network device in suse11 system container,
> I can not use halt to stop this container. It hung on "eth0 is still used from interfaces eth0" in cycle.
> 
> The config file:
> 
> lxc.network.type = vlan
> lxc.network.flags = up
> lxc.network.link = eth0
> lxc.network.name = eth0
> lxc.network.vlan.id = 1301
> lxc.network.ipv4 = 128.5.131.100/24
> 
> 
> The reason is in the shell command /sbin/ifdown, see below:
> 
> ######################################################################
> # Shut down depending interfaces
> #
> # Check if there are interfaces which depend on this interface. If yes these
> # have to be shut down first.
> # For example these might be bonding or vlan interfaces. Note that we don't
> # catch all types of depending interfaces currently. See function
> # 'get_depending_ifaces' in file 'functions' for details.
> #
> test "$SCRIPTNAME" = ifdown && DEP_IFACES=`get_depending_ifaces $INTERFACE`
> if [ "$?" = 0 -a "$NODEPS" != yes ] ; then
>         message "`printf "    %-9s is still used from interfaces %s" \
>                          $INTERFACE "$DEP_IFACES"`"
>         for DI in $DEP_IFACES; do

Should the proper fix be to fix this script so that it doesn't call
ifdown recursively if $DI = $INTERFACE ?

>                 ifdown $DI -o $OPTIONS
>         done
> 
>         message "`printf "    %-9s now going down itself" $INTERFACE`"
>         # check if iface is (still) avaliable
>         # [bonding master may go down itself
>         #  while the last slave gets removed]
>         if ! is_iface_available $INTERFACE; then
>                 exit $R_SUCCESS
>         fi
> fi
> 
> 
> $DEP_IFACES is also eth0 in this scene, so ifdown will call ifdown again and again.
> 
> if we set lxc.network.name = eth1, it will be ok, so can we add a judgment to make
> lxc.network.link and lxc.network.name are not equal in lxc-start command.
> 
> simple implement like:
> 
> 	if [ lxc.network.type == vlan ] ; then
> 		if [ lxc.network.link == lxc.network.name ] ; then
> 			return false
> 		fi
> 	fi
> 
> 
> Is it reasonable?  or any other way to achieve this?
> 
> 
> 
