Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab3LCXmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:42:46 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43926 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3LCXmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:42:38 -0500
Date: Tue, 3 Dec 2013 23:42:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Leigh Brown <leigh@solinno.co.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Nicolas Schichan <nschichan@freebox.fr>,
        Jason Cooper <jason@lakedaemon.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Fainelli <florian@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Spurious timeouts in mvmdio
Message-ID: <20131203234209.GW16735@n2100.arm.linux.org.uk>
References: <529CA42A.3040504@freebox.fr> <20131203122346.GD29282@titan.lakedaemon.net> <20131203124033.GT16735@n2100.arm.linux.org.uk> <abe249f5cba5c267e2c536bd62c57908@doppler.thel33t.co.uk> <529E5F03.8040607@gmail.com> <8d65780eb7bfe49bb0734a09f05f70a6@doppler.thel33t.co.uk> <529E66A4.4050000@gmail.com> <ae69666fd3b61411d7bbd9ac993cec13@doppler.thel33t.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae69666fd3b61411d7bbd9ac993cec13@doppler.thel33t.co.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 11:38:23PM +0000, Leigh Brown wrote:
> On 2013-12-03 23:17, Sebastian Hesselbarth wrote:
>> If you want to ensure timeout > 2, why not then just use:
>>
>> - 	unsigned long timeout = usecs_to_jiffies(MVMDIO_SMI_TIMEOUT);
>> + 	unsigned long timeout = 1 + usecs_to_jiffies(MVMDIO_SMI_TIMEOUT);
>
> This will make it correct when using interrupts but it will make the  
> loop wait one jiffie longer than it should when polling.

Alternatively, code it like this instead.

 drivers/net/ethernet/marvell/mvmdio.c |   32 +++++++++++++++-----------------
 1 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index 7354960b583b..a6f59831fc5b 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -76,31 +76,29 @@ static int orion_mdio_wait_ready(struct mii_bus *bus)
 {
 	struct orion_mdio_dev *dev = bus->priv;
 	unsigned long timeout = usecs_to_jiffies(MVMDIO_SMI_TIMEOUT);
-	unsigned long end = jiffies + timeout;
-	int timedout = 0;
 
-	while (1) {
-	        if (orion_mdio_smi_is_done(dev))
+	if (dev->err_interrupt > 0) {
+		if (wait_event_timeout(dev->smi_busy_wait,
+				       orion_mdio_smi_is_done(dev),
+				       1 + timeout))
 			return 0;
-	        else if (timedout)
-			break;
+	} else {
+		unsigned long end = jiffies + timeout;
 
-	        if (dev->err_interrupt <= 0) {
-			usleep_range(MVMDIO_SMI_POLL_INTERVAL_MIN,
-				     MVMDIO_SMI_POLL_INTERVAL_MAX);
+		while (1) {
+	        	if (orion_mdio_smi_is_done(dev))
+				return 0;
 
 			if (time_is_before_jiffies(end))
-				++timedout;
-	        } else {
-			wait_event_timeout(dev->smi_busy_wait,
-				           orion_mdio_smi_is_done(dev),
-				           timeout);
-
-			++timedout;
-	        }
+				break;
+
+			usleep_range(MVMDIO_SMI_POLL_INTERVAL_MIN,
+				     MVMDIO_SMI_POLL_INTERVAL_MAX);
+		}
 	}
 
 	dev_err(bus->parent, "Timeout: SMI busy for too long\n");
+
 	return  -ETIMEDOUT;
 }
 
