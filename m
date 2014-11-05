Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbaKEJRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:17:41 -0500
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:31558 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753495AbaKEJRi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:17:38 -0500
From: Shahed Shaikh <shahed.shaikh@qlogic.com>
To: Joe Stringer <joestringer@nicira.com>, netdev <netdev@vger.kernel.org>
CC: "sathya.perla@emulex.com" <sathya.perla@emulex.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "linux.nics@intel.com" <linux.nics@intel.com>,
        "amirv@mellanox.com" <amirv@mellanox.com>,
        Dept-GE Linux NIC Dev <Dept-GELinuxNICDev@qlogic.com>,
        "Tom Herbert (Partner - google)" <therbert@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 5/5] qlcnic: Implement ndo_gso_check()
Thread-Topic: [PATCH net 5/5] qlcnic: Implement ndo_gso_check()
Thread-Index: AQHP+HpQ5eyJBh8kxU2z21df5T0OlJxRuiug
Date: Wed, 5 Nov 2014 09:17:31 +0000
Message-ID: <262CB373A6D1F14F9B81E82F74F77D5A4709D060@avmb2.qlogic.org>
References: <1415138202-1197-1-git-send-email-joestringer@nicira.com>
 <1415138202-1197-6-git-send-email-joestringer@nicira.com>
In-Reply-To: <1415138202-1197-6-git-send-email-joestringer@nicira.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
disclaimer: bypass
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7612 signatures=670572
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1411050095
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Joe Stringer [mailto:joestringer@nicira.com]
> Sent: Wednesday, November 05, 2014 3:27 AM
> To: netdev
> Cc: sathya.perla@emulex.com; jeffrey.t.kirsher@intel.com;
> linux.nics@intel.com; amirv@mellanox.com; Shahed Shaikh; Dept-GE Linux
> NIC Dev; Tom Herbert (Partner - google); linux-kernel
> Subject: [PATCH net 5/5] qlcnic: Implement ndo_gso_check()
> 
> ndo_gso_check() was recently introduced to allow NICs to report the
> offloading support that they have on a per-skb basis. Add an implementation
> for this driver which checks for something that looks like VXLAN.
> 
> Implementation shamelessly stolen from Tom Herbert:
> http://thread.gmane.org/gmane.linux.network/332428/focus=333111
> 
> Signed-off-by: Joe Stringer <joestringer@nicira.com>
> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> index f5e29f7..6184f47 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> @@ -505,6 +505,17 @@ static void qlcnic_del_vxlan_port(struct net_device
> *netdev,  }  #endif
> 
> +static bool qlcnic_gso_check(struct sk_buff *skb, struct net_device
> +*dev) {
> +	if ((skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL) &&
> +	    (skb->inner_protocol_type != ENCAP_TYPE_ETHER ||
> +	     skb->inner_protocol != htons(ETH_P_TEB) ||
> +	     skb_inner_mac_header(skb) - skb_transport_header(skb) != 16))
> +		return false;
> +

Hi Joe,

Yes, qlcnic driver only supports VXLAN offload.
It would be good to put a comment about value 16 to make it more intuitive. 
e.g. 16 is the size of outer UDP header + VXLAN header.

Anyway, patch looks good to me.

Acked-by: Shahed Shaikh <shahed.shaikh@qlogic.com>

Thanks,
Shahed
