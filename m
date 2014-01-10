Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbaAJQ6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:58:53 -0500
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:60256 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbaAJQ6u convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:58:50 -0500
From: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
To: Joe Perches <joe@perches.com>
CC: Dept-Eng Linux Driver <Linux-Driver@qlogic.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] qlcnic: Convert vmalloc/memset to kcalloc
Thread-Topic: [PATCH net-next] qlcnic: Convert vmalloc/memset to kcalloc
Thread-Index: AQHPDQX4KC+gHBvYCEerlVsxtB0qg5p+MGQA
Date: Fri, 10 Jan 2014 16:58:45 +0000
Message-ID: <BECD8E8A1B550B48A1BF97C13991F60E46CF4795@avmb2.qlogic.org>
References: <1389249745.24222.20.camel@joe-AO722>
In-Reply-To: <1389249745.24222.20.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ECFD097A845AE543A4A0CA0836D51133@qlogic.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7313 signatures=668874
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1401100105
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/8/14 10:42 PM, "Joe Perches" <joe@perches.com> wrote:

>vmalloc is a limited resource.  Don't use it unnecessarily.
>
>It seems this allocation should work with kcalloc.
>
>Remove unnecessary memset(,0,) of buf as it's completely
>overwritten as the previously only unset field in
>struct qlcnic_pci_func_cfg is now set to 0.
>
>Use kfree instead of vfree.
>Use ETH_ALEN instead of 6.
>
>Signed-off-by: Joe Perches <joe@perches.com>
>---
> drivers/net/ethernet/qlogic/qlcnic/qlcnic.h       |  2 +-
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c | 16 ++++++----------
> 2 files changed, 7 insertions(+), 11 deletions(-)

Acked-by: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>

>
>diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
>b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
>index 35d4876..8d7aa4c 100644
>--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
>+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
>@@ -1267,7 +1267,7 @@ struct qlcnic_pci_func_cfg {
> 	u16	port_num;
> 	u8	pci_func;
> 	u8	func_state;
>-	u8	def_mac_addr[6];
>+	u8	def_mac_addr[ETH_ALEN];
> };
> 
> struct qlcnic_npar_func_cfg {
>diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
>b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
>index b529667..c9b704d 100644
>--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
>+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
>@@ -6,7 +6,6 @@
>  */
> 
> #include <linux/slab.h>
>-#include <linux/vmalloc.h>
> #include <linux/interrupt.h>
> 
> #include "qlcnic.h"
>@@ -927,38 +926,35 @@ static ssize_t qlcnic_sysfs_read_pci_config(struct
>file *file,
> 	u32 pci_func_count = qlcnic_get_pci_func_count(adapter);
> 	struct qlcnic_pci_func_cfg *pci_cfg;
> 	struct qlcnic_pci_info *pci_info;
>-	size_t pci_info_sz, pci_cfg_sz;
>+	size_t pci_cfg_sz;
> 	int i, ret;
> 
> 	pci_cfg_sz = pci_func_count * sizeof(*pci_cfg);
> 	if (size != pci_cfg_sz)
> 		return QL_STATUS_INVALID_PARAM;
> 
>-	pci_info_sz = pci_func_count * sizeof(*pci_info);
>-	pci_info = vmalloc(pci_info_sz);
>+	pci_info = kcalloc(pci_func_count, sizeof(*pci_info), GFP_KERNEL);
> 	if (!pci_info)
> 		return -ENOMEM;
> 
>-	memset(pci_info, 0, pci_info_sz);
>-	memset(buf, 0, pci_cfg_sz);
>-	pci_cfg = (struct qlcnic_pci_func_cfg *)buf;
>-
> 	ret = qlcnic_get_pci_info(adapter, pci_info);
> 	if (ret) {
>-		vfree(pci_info);
>+		kfree(pci_info);
> 		return ret;
> 	}
> 
>+	pci_cfg = (struct qlcnic_pci_func_cfg *)buf;
> 	for (i = 0; i < pci_func_count; i++) {
> 		pci_cfg[i].pci_func = pci_info[i].id;
> 		pci_cfg[i].func_type = pci_info[i].type;
>+		pci_cfg[i].func_state = 0;
> 		pci_cfg[i].port_num = pci_info[i].default_port;
> 		pci_cfg[i].min_bw = pci_info[i].tx_min_bw;
> 		pci_cfg[i].max_bw = pci_info[i].tx_max_bw;
> 		memcpy(&pci_cfg[i].def_mac_addr, &pci_info[i].mac, ETH_ALEN);
> 	}
> 
>-	vfree(pci_info);
>+	kfree(pci_info);
> 	return size;
> }

Thanks,
Jiten

