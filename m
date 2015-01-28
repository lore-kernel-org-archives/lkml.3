Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbbA2BOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:14:44 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:51090 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbbA2BOm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:14:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v8 0/4] net: Add Keystone NetCP ethernet driver support
Date: Wed, 28 Jan 2015 22:03:09 +0100
Message-ID: <20343006.1NmdQEM9nn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54C94A0D.9050505@ti.com>
References: <1421367007-19744-1-git-send-email-m-karicheri2@ti.com> <54C92878.3030207@ti.com> <54C94A0D.9050505@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:o3BBv4W+lbJoIFeWcHZp+CZKd5sYRK7+qQLlfY2bSs9/319dPwk
 mgkXno7RMqkBP2M4u8kM8pOPlaOLowrvyIxBJlsWbAc+QTqX29XnsAI9+WE6AXKzBXcsQVr
 Um96rnSp+510CAfQRYSFBxbNFeRRObZt6VWLldvN9Zo1Alg2LZcGBWsgzZNOFaJJTiodVms
 7bbtBbBWeQv0lEYdONi/Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2015 15:43:57 Murali Karicheri wrote:
> > this. Hope I am on the right track.
> 
> Reproduced this. Following errors seen when building the modules.
> 
>    LD [M]  drivers/net/ethernet/ti/keystone_netcp.o
> drivers/net/ethernet/ti/netcp_ethss.o: In function `init_module':
> netcp_ethss.c:(.init.text+0x0): multiple definition of `init_module'
> drivers/net/ethernet/ti/netcp_core.o:netcp_core.c:(.init.text+0x0): 
> first defined here
> drivers/net/ethernet/ti/netcp_ethss.o: In function `cleanup_module':
> netcp_ethss.c:(.exit.text+0x0): multiple definition of `cleanup_module'
> drivers/net/ethernet/ti/netcp_core.o:netcp_core.c:(.exit.text+0x0): 
> first defined here
> make[4]: *** [drivers/net/ethernet/ti/keystone_netcp.o] Error 1
>
> BTW, I had to disable cpsw_ale.c to get to build keystone NetCP. I am 
> assuming someone from TI is addressing this.
> 
> drivers/net/ethernet/ti/cpsw_ale.c: In function ‘cpsw_ale_start’:
> drivers/net/ethernet/ti/cpsw_ale.c:759:2: error: ‘KBUILD_MODNAME’ 
> undeclared (first use in this function)
> drivers/net/ethernet/ti/cpsw_ale.c:759:2: note: each undeclared 
> identifier is reported only once for each function it appears in

I think both problems are nontrivial to fix. The first one is obviously
that there are multiple init_module functions in one module. You have
to either split the driver into multiple loadable modules with at most
one init_module/cleanup_module pair each, or call one of the functions
from the other one in the right order.

The second problem is where I got stuck myself: cpsw_ale.c (also cpts.c)
is getting linked into both modules, which is not allowed: It is
impossible for the kernel to compile these if one driver is a module
and the other one is not, and any use of KBUILD_MODNAME fails because
it is unclear what the modname is if the file is compiled once to
be linked into two drivers.

	Arnd
