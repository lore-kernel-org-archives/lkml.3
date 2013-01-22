Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab3AVXbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:31:11 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:58731 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab3AVXbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:31:09 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Huang, Ying (ying.huang@intel.com)" <ying.huang@intel.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "robert.moore@intel.com" <robert.moore@intel.com>,
        "trenn@suse.de" <trenn@suse.de>,
        "myron.stowe@redhat.com" <myron.stowe@redhat.com>
Subject: ERST: how to avoid a dynamic memory allocation in panic case
Thread-Topic: ERST: how to avoid a dynamic memory allocation in panic case
Thread-Index: Ac349nJDZpYrCzzbTuW1wPMkV8nEDQ==
Date: Tue, 22 Jan 2013 23:30:08 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A51F3D@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-01-22_10:2013-01-22,2013-01-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=11 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1301220243
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Issue]

Current erst driver is kicked in panic case.
On the other hand, a dynamic memory allocation seems to run in it
with a following code path.

erst_writer -> erst_write -> __erst_write_to_storage -> many of apei_exec_run -> 
ctx->ins_table[entry->instruction].run()

which are functions defined in erst_ins_type table i.e:

apei_exec_read_register -> apei_read -> acpi_os_read_memory64 -> acpi_os_ioremap -> ioremap_cache

which possibly involve IOMMU allocator.

I may cause a failure of  an erst driver if the panic happens in an interrupt context.

[Idea]

If we can remove ioremap_cache() from acpi_os_read_memory() as follows,
It is easy to fix this issue.
But I'm not sure if it is feasible because I can't see the reason of tying acpi_os_ioremap()  from a git log...

Any comment?

<snip>
@@ -918,10 +918,7 @@ acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
 	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
 	if (!virt_addr) {
 		rcu_read_unlock();
-		virt_addr = acpi_os_ioremap(phys_addr, size);
-		if (!virt_addr)
-			return AE_BAD_ADDRESS;
-		unmap = true;
+		return AE_BAD_ADDRESS;
 	}
 
 	if (!value)
<snip>

Seiji
