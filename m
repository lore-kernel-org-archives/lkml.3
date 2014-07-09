Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbaGILcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:32:46 -0400
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:39303 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750739AbaGILco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:32:44 -0400
From: Manish Chopra <manish.chopra@qlogic.com>
To: ethan zhao <ethan.zhao@oracle.com>, David Miller <davem@davemloft.net>
CC: "balbi@ti.com" <balbi@ti.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "sriharsha.devdas@oracle.com" <sriharsha.devdas@oracle.com>,
        "ethan.kernel@gmail.com" <ethan.kernel@gmail.com>,
        vaughan <vaughan.cao@oracle.com>
Subject: RE: [PATCH NET-NEXT V2] netxen: fix ethtool rx_dropped information
 in ethtool get_ethtool_stats()
Thread-Topic: [PATCH NET-NEXT V2] netxen: fix ethtool rx_dropped information
 in ethtool get_ethtool_stats()
Thread-Index: AQHPmx9Vm4puBbR4oE+QXNxHoJGruJuXkReQ
Date: Wed, 9 Jul 2014 11:32:38 +0000
Message-ID: <31AFFC7280259C4184970ABA9AFE8B93E074D13E@avmb3.qlogic.org>
References: <1404827830-22990-1-git-send-email-ethan.zhao@oracle.com>
 <53BCABD3.3050207@oracle.com>
In-Reply-To: <53BCABD3.3050207@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7493 signatures=670477
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1407090145
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s69BWrvh029333

>-----Original Message-----
>From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
>On Behalf Of ethan zhao
>Sent: Wednesday, July 09, 2014 8:11 AM
>To: David Miller
>Cc: balbi@ti.com; netdev; linux-kernel; sriharsha.devdas@oracle.com;
>ethan.kernel@gmail.com; vaughan
>Subject: Re: [PATCH NET-NEXT V2] netxen: fix ethtool rx_dropped information in
>ethtool get_ethtool_stats()
>
>David,
>
>    Please help to review and confirm this patch.
>
>Thanks,
>Ethan
>
>On 2014/7/8 21:57, Ethan Zhao wrote:
>> netxen driver has implemented netxen_nic_get_ethtool_stats()
>> interface, but it doesn't collect stats.rxdropped in driver, so we
>> will get different rx_dropped statistic information while using ifconfig and
>ethtool.
>> this patch fills stats.rxdropped field with data from net core with
>> dev_get_stats() just as ixgbe driver did for some of its stats.
>>
>> V2: only fix the stats.rxdropped field.
>>
>> Tested with last netxen 4.0.82
>> Compiled with net-next branch 3.16-rc2
>>
>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>> Tested-by: Sriharsha Yadagudde <sriharsha.devdas@oracle.com>
>> ---
>>   .../ethernet/qlogic/netxen/netxen_nic_ethtool.c    |   34 +++++++++++++++++-
>--
>>   1 files changed, 29 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
>> b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
>> index 4ca2c19..49e6a1b 100644
>> --- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
>> +++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
>> @@ -33,22 +33,30 @@
>>   #include "netxen_nic.h"
>>   #include "netxen_nic_hw.h"
>>
>> +enum {NETDEV_STATS, NETXEN_STATS};
>> +
>>   struct netxen_nic_stats {
>>   	char stat_string[ETH_GSTRING_LEN];
>> +	int type;
>>   	int sizeof_stat;
>>   	int stat_offset;
>>   };
>>
>> -#define NETXEN_NIC_STAT(m) sizeof(((struct netxen_adapter *)0)->m), \
>> +#define NETXEN_NIC_STAT(m)	NETXEN_STATS, \
>> +			sizeof(((struct netxen_adapter *)0)->m), \
>>   			offsetof(struct netxen_adapter, m)
>>
>> +#define NETXEN_NETDEV_STAT(m)	NETDEV_STATS, \
>> +			sizeof(((struct rtnl_link_stats64 *)0)->m), \
>> +			offsetof(struct rtnl_link_stats64, m)
>> +
>>   #define NETXEN_NIC_PORT_WINDOW 0x10000
>>   #define NETXEN_NIC_INVALID_DATA 0xDEADBEEF
>>
>>   static const struct netxen_nic_stats netxen_nic_gstrings_stats[] = {
>>   	{"xmit_called", NETXEN_NIC_STAT(stats.xmitcalled)},
>>   	{"xmit_finished", NETXEN_NIC_STAT(stats.xmitfinished)},
>> -	{"rx_dropped", NETXEN_NIC_STAT(stats.rxdropped)},
>> +	{"rx_dropped", NETXEN_NETDEV_STAT(rx_dropped)},
>>   	{"tx_dropped", NETXEN_NIC_STAT(stats.txdropped)},
>>   	{"csummed", NETXEN_NIC_STAT(stats.csummed)},
>>   	{"rx_pkts", NETXEN_NIC_STAT(stats.rx_pkts)}, @@ -679,11 +687,27 @@
>> netxen_nic_get_ethtool_stats(struct net_device *dev,
>>   {
>>   	struct netxen_adapter *adapter = netdev_priv(dev);
>>   	int index;
>> +	struct rtnl_link_stats64 temp;
>> +	const struct rtnl_link_stats64 *net_stats;
>> +	char *p = NULL;
>>
>> +	net_stats = dev_get_stats(dev, &temp);
>>   	for (index = 0; index < NETXEN_NIC_STATS_LEN; index++) {
>> -		char *p =
>> -		    (char *)adapter +
>> -		    netxen_nic_gstrings_stats[index].stat_offset;
>> +
>> +		switch (netxen_nic_gstrings_stats[index].type) {
>> +		case NETDEV_STATS:
>> +			p = (char *)net_stats +
>> +				netxen_nic_gstrings_stats[index].stat_offset;
>> +			break;
>> +		case NETXEN_STATS:
>> +			p = (char *)adapter +
>> +				netxen_nic_gstrings_stats[index].stat_offset;
>> +			break;
>> +		default:
>> +			data[index] = 0;
>> +			continue;
>> +		}
>> +
>>   		data[index] =
>>   		    (netxen_nic_gstrings_stats[index].sizeof_stat ==
>>   		     sizeof(u64)) ? *(u64 *) p : *(u32 *) p;

Ethan, I can't download this patch as I donâ€™t see it in netdev patchwork. Just looking at the diff I think there is style issue with macro definition of NETXEN_NIC_STAT and NETXEN_NETDEV_STAT.
Enclose macro definition in parentheses as they are containing complex values.

Send this patch targeted for net instead of net-next being a bug fix. Please also run checkpatch.pl to correct any style warning/errors in the patch.

Thanks!!  

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
