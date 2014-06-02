Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbaFBOkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:40:33 -0400
Received: from canardo.mork.no ([148.122.252.1]:50825 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026AbaFBOkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:40:31 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Michal Privoznik <mprivozn@redhat.com>, davem@davemloft.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net-sysfs: Report link speed as signed integer
Organization: m
References: <06d53256e3bf2d0deedb16249082200500da3ee6.1401718809.git.mprivozn@redhat.com>
	<20140602143557.GA2925@minipsycho.orion>
Date: Mon, 02 Jun 2014 16:40:20 +0200
In-Reply-To: <20140602143557.GA2925@minipsycho.orion> (Jiri Pirko's message of
	"Mon, 2 Jun 2014 16:35:57 +0200")
Message-ID: <87egz72x4b.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Pirko <jiri@resnulli.us> writes:
> Mon, Jun 02, 2014 at 04:25:15PM CEST, mprivozn@redhat.com wrote:
>>The link speed is available at /sys/class/net/$nic/speed.
>>However, the speed is printed in unsigned integer format. This
>>makes userspace applications read an incorrect value (which
>>moreover changes through several architectures) while in fact
>>'-1' should be reported.
>>
>>Before the change:
>>  # cat /sys/class/net/eth0/speed
>>  4294967295
>>
>>After the change:
>>  # cat /sys/class/net/eth0/speed
>>  -1
>>
>>Signed-off-by: Michal Privoznik <mprivozn@redhat.com>
>>---
>> net/core/net-sysfs.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>>diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
>>index 1cac29e..99afdea 100644
>>--- a/net/core/net-sysfs.c
>>+++ b/net/core/net-sysfs.c
>>@@ -173,7 +173,7 @@ static ssize_t speed_show(struct device *dev,
>> 	if (netif_running(netdev)) {
>> 		struct ethtool_cmd cmd;
>> 		if (!__ethtool_get_settings(netdev, &cmd))
>>-			ret = sprintf(buf, fmt_udec, ethtool_cmd_speed(&cmd));
>>+			ret = sprintf(buf, fmt_dec, ethtool_cmd_speed(&cmd));
>
> I wonder why this should be signed. What -1 means? What driver reports
> this?

I believe many drivers will do this when the speed is unknown, e.g
because the link is down.  For example:

bjorn@nemi:~$ grep . /sys/class/net/eth0/speed
4294967295
bjorn@nemi:~$ ls -l /sys/class/net/eth0/device/driver
lrwxrwxrwx 1 root root 0 Jun  2 10:48 /sys/class/net/eth0/device/driver -> ../../../bus/pci/drivers/e1000e
bjorn@nemi:~$ ethtool eth0
Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full 
                                100baseT/Half 100baseT/Full 
                                1000baseT/Full 
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Advertised link modes:  10baseT/Half 10baseT/Full 
                                100baseT/Half 100baseT/Full 
                                1000baseT/Full 
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Speed: Unknown!
        Duplex: Unknown! (255)
        Port: Twisted Pair
        PHYAD: 2
        Transceiver: internal
        Auto-negotiation: on
        MDI-X: Unknown
Cannot get wake-on-lan settings: Operation not permitted
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: no



Bjørn
