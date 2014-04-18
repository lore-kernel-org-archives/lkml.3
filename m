Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaDRRNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:13:47 -0400
Received: from www.meduna.org ([92.240.244.38]:40839 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbaDRRNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:13:42 -0400
Message-ID: <53515D38.4090400@meduna.org>
Date: Fri, 18 Apr 2014 19:13:28 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Fabio Estevam <fabio.estevam@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Jim Baxter <jim_baxter@mentor.com>,
        Duan Fugang-B38611 <B38611@freescale.com>,
        Frank Li <Frank.Li@freescale.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: Freescale FEC i.MX28 restart problem
References: <53511079.2020206@meduna.org>	<CAOMZO5CyFaP2phreKYdwUUB0RcpAhomDzm1QhAjCYtH09yYfQQ@mail.gmail.com> <CAOMZO5DAixbrO1Zhvm60gevdCbKVgSP652vS7QYZS+XSfbPLdQ@mail.gmail.com>
In-Reply-To: <CAOMZO5DAixbrO1Zhvm60gevdCbKVgSP652vS7QYZS+XSfbPLdQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2014-04-18 19:13:33
X-Connected-IP: 95.105.163.217:61917
X-Message-Linecount: 76
X-Body-Linecount: 56
X-Message-Size: 3223
X-Body-Size: 2184
X-Received-Count: 1
X-Recipient-Count: 9
X-Local-Recipient-Count: 9
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.04.2014 15:05, Fabio Estevam wrote:

>> Could you try the latest Russell's FEC patches available at?
>> http://ftp.arm.linux.org.uk/cgit/linux-arm.git/log/?h=fec-testing
> 
> In particular this one could help with your "MDIO timeout" issue:
> http://ftp.arm.linux.org.uk/cgit/linux-arm.git/commit/?h=fec-testing&id=ec1fac3de70b16c69d3edc9f223e91d56b1915de

Thanks for the heads-up, I was not aware that there is a larger
refactoring going on.

I did just copy the whole fec driver from that branch into
my environment (the isolated patch does not apply as it needs
the previous work) and yes, it seems to help. I'll give it
a bit more testing and I will report if there are still
some issues.

However, in my opinion the FEC_ENET_EBERR handling should be also
added (if only to print a big fat error), as if this happens
for whatever reason, the controller is now dead until reboot.

I had a problem where the MDIO communication was needed before
the controller has interrupts enabled - I am not quite sure whether
it is always the case or was caused by my unrelated patch.
I need to specify the PHY in the device tree as my hardware
uses weird MDIO address to FEC port assignment. The only change
in the logic is that in the fec_enet_mii_probe an of_phy_connect
is used instead of phy_connect and I think they both end in the
same code, but maybe I have overlooked something.

I just added a hack to poll for the MII transaction completion
and it started to work:


--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1356,6 +1357,14 @@ static unsigned long fec_enet_mdio_op(struct fec_enet_pri
        time_left = wait_for_completion_timeout(&fep->mdio_done,
                        usecs_to_jiffies(FEC_MII_TIMEOUT));

+       if (time_left == 0) {
+               u32 int_events = readl(fep->hwp + FEC_IEVENT);
+               if (int_events & FEC_ENET_MII) {
+                       writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
+                       time_left = 1;
+               }
+       }
+
        mutex_unlock(&fep->mutex);

        return time_left;


Many thanks
-- 
                                          Stano
