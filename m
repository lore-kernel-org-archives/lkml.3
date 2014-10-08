Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbaJHAM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 20:12:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbaJHAMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 20:12:25 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bruce Allan <bruce.w.allan@intel.com>,
        John Griffin <john.griffin@intel.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH] crypto, qat, use generic numa functions
Date: Tue,  7 Oct 2014 20:12:09 -0400
Message-Id: <1412727129-14467-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing, the following panic was seen:

IP: [<ffffffff8115b8d7>] __alloc_pages_nodemask+0x97/0x420
PGD 0
Oops: 0000 [#1] SMP
Modules linked in: aesni_intel ptp lrw qat_dh895xcc(+) intel_qat pps_core i2c_algo_bit authenc gf128mul iTCO_wdt ioatdma glue_helper sb_edac i2c_i801 ablk_helper serio_raw iTCO_vendor_support pcspkr edac_core shpchp i2c_core cryptd dca lpc_ich mfd_core wmi xfs libcrc32c sd_mod crc_t10dif crct10dif_common ahci libahci libata dm_mirror dm_region_hash dm_log dm_mod
CPU: 0 PID: 1235 Comm: systemd-udevd Not tainted 3.10.0-165.el7.x86_64 #1
Hardware name: Intel Corporation SandyBridge Platform/To be filled by O.E.M., BIOS CCFRCLC0.019.1308201516 08/20/2013
task: ffff88006d068000 ti: ffff88006ca0c000 task.ti: ffff88006ca0c000
RIP: 0010:[<ffffffff8115b8d7>]  [<ffffffff8115b8d7>] __alloc_pages_nodemask+0x97/0x420
RSP: 0018:ffff88006ca0f928  EFLAGS: 00010246
RAX: 0000000000002000 RBX: 0000000000000000 RCX: ffff88006ca0ffd8
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 00000000002052d0
RBP: ffff88006ca0f9c8 R08: 0000000000000008 R09: 0000000000000002
R10: 0000000000000068 R11: ffffffffffffffc4 R12: 00000000002052d0
R13: 0000000000000000 R14: 0000000000000002 R15: 0000000000000000
FS:  00007f999a6f9880(0000) GS:ffff880076a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000002008 CR3: 000000006c916000 CR4: 00000000001407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Stack:
 ffff88007ac07700 ffff88006ca0f940 ffffffff811a43d9 ffff88006ca0fa00
 ffffffff811a4a0a ffff88007ac00e30 ffff88007ac00e10 ffff880076a17
 0000000000000000 ffff880000000002 0000000000002000 00000001000080d0
Call Trace:
 [<ffffffff811a43d9>] ? discard_slab+0x39/0x50
 [<ffffffff811a4a0a>] ? deactivate_slab+0x35a/0x3c0
 [<ffffffff811a3521>] new_slab+0x91/0x300
 [<ffffffff815ee9ed>] __slab_alloc+0x2bb/0x482
 [<ffffffff8101b923>] ? native_sched_clock+0x13/0x80
 [<ffffffff8101b999>] ? sched_clock+0x9/0x10
 [<ffffffffa01b8177>] ? adf_probe+0xb7/0x5a0 [qat_dh895xcc]
 [<ffffffff812cce6f>] ? idr_get_empty_slot+0x16f/0x3c0
 [<ffffffff812cce6f>] ? idr_get_empty_slot+0x16f/0x3c0
 [<ffffffff811a690b>] kmem_cache_alloc_node_trace+0x9b/0x220
 [<ffffffffa01b8177>] adf_probe+0xb7/0x5a0 [qat_dh895xcc]
 [<ffffffff81237bd2>] ? sysfs_addrm_finish+0x42/0xe0
 [<ffffffff812379b1>] ? __sysfs_add_one+0x61/0x100
 [<ffffffff812fee25>] local_pci_probe+0x45/0xa0
 [<ffffffff81300295>] ? pci_match_device+0xc5/0xd0
 [<ffffffff813003d9>] pci_device_probe+0xf9/0x150
 [<ffffffff813caee7>] driver_probe_device+0x87/0x390
 [<ffffffff813cb2c3>] __driver_attach+0x93/0xa0
 [<ffffffff813cb230>] ? __device_attach+0x40/0x40
 [<ffffffff813c8c73>] bus_for_each_dev+0x73/0xc0
 [<ffffffff813ca93e>] driver_attach+0x1e/0x20
 [<ffffffff813ca490>] bus_add_driver+0x200/0x2d0
 [<ffffffff813cb944>] driver_register+0x64/0xf0
 [<ffffffff812ffe95>] __pci_register_driver+0xa5/0xc0
 [<ffffffffa01be000>] ? 0xffffffffa01bdfff
 [<ffffffffa01be03a>] adfdrv_init+0x3a/0x1000 [qat_dh895xcc]
 [<ffffffff810020b8>] do_one_initcall+0xb8/0x230
 [<ffffffff810da32a>] load_module+0x131a/0x1b20
 [<ffffffff812ee3e0>] ? ddebug_proc_write+0xf0/0xf0
 [<ffffffff810d68c3>] ? copy_module_from_fd.isra.43+0x53/0x150
 [<ffffffff810dace6>] SyS_finit_module+0xa6/0xd0
 [<ffffffff81601a69>] system_call_fastpath+0x16/0x1b
Code: c1 eb 02 c1 e8 13 83 e3 02 83 e0 01 09 c3 44 23 25 cf 22 8a 00 48 c7 45 c0 00 00 00 00 41 f6 c4 10 0f 85 55 02 00 00 48 8b 45 b0 <48> 83 78 08 00 0f 84 a3 01 00 00 0f 1f 44 00 00 48 8b 45 b0 44

The method in which the qat code determines the numa node for memory
allocations is a bit clunky.  On 2 socket, single node systems it is
possible that adf_get_dev_node_id() returns node 1, even though node 1
doesn't exist.

This code transitions the qat code to the generic numa functions.
Changing adf_get_dev_node_id() to a simple call to dev_get_node() results
in a change to the adf_accel_dev struct as well.  In addition to that
change, qat_crypto_get_instance_node() must check for "any node" as a
valid numa_node value.

Cc: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Bruce Allan <bruce.w.allan@intel.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: John Griffin <john.griffin@intel.com>
Cc: qat-linux@intel.com
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h |    2 +-
 drivers/crypto/qat/qat_common/qat_algs.c          |    7 +------
 drivers/crypto/qat/qat_common/qat_crypto.c        |    4 +++-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c         |   19 ++-----------------
 4 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 9282381..025f52f 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -199,7 +199,7 @@ struct adf_accel_dev {
 	struct list_head list;
 	struct module *owner;
 	uint8_t accel_id;
-	uint8_t numa_node;
+	int numa_node;
 	struct adf_accel_pci accel_pci_dev;
 } __packed;
 #endif
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 59df488..d887074 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -127,11 +127,6 @@ struct qat_alg_session_ctx {
 	spinlock_t lock;	/* protects qat_alg_session_ctx struct */
 };
 
-static int get_current_node(void)
-{
-	return cpu_data(current_thread_info()->cpu).phys_proc_id;
-}
-
 static int qat_get_inter_state_size(enum icp_qat_hw_auth_algo qat_hash_alg)
 {
 	switch (qat_hash_alg) {
@@ -522,7 +517,7 @@ static int qat_alg_setkey(struct crypto_aead *tfm, const uint8_t *key,
 		       sizeof(struct icp_qat_fw_la_bulk_req));
 	} else {
 		/* new key */
-		int node = get_current_node();
+		int node = cpu_to_node(smp_processor_id());
 		struct qat_crypto_instance *inst =
 				qat_crypto_get_instance_node(node);
 		if (!inst) {
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 0d59bcb..c2260d8 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -109,7 +109,9 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 
 	list_for_each(itr, adf_devmgr_get_head()) {
 		accel_dev = list_entry(itr, struct adf_accel_dev, list);
-		if (accel_dev->numa_node == node && adf_dev_started(accel_dev))
+		if (((accel_dev->numa_node == NUMA_NO_NODE) ||
+		     (accel_dev->numa_node == node)) &&
+		    adf_dev_started(accel_dev))
 			break;
 		accel_dev = NULL;
 	}
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index 0d0435a..41bf86b 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -119,21 +119,6 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 	kfree(accel_dev);
 }
 
-static uint8_t adf_get_dev_node_id(struct pci_dev *pdev)
-{
-	unsigned int bus_per_cpu = 0;
-	struct cpuinfo_x86 *c = &cpu_data(num_online_cpus() - 1);
-
-	if (!c->phys_proc_id)
-		return 0;
-
-	bus_per_cpu = 256 / (c->phys_proc_id + 1);
-
-	if (bus_per_cpu != 0)
-		return pdev->bus->number / bus_per_cpu;
-	return 0;
-}
-
 static int qat_dev_start(struct adf_accel_dev *accel_dev)
 {
 	int cpus = num_online_cpus();
@@ -235,7 +220,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	void __iomem *pmisc_bar_addr = NULL;
 	char name[ADF_DEVICE_NAME_LENGTH];
 	unsigned int i, bar_nr;
-	uint8_t node;
+	int node;
 	int ret;
 
 	switch (ent->device) {
@@ -246,7 +231,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENODEV;
 	}
 
-	node = adf_get_dev_node_id(pdev);
+	node = dev_to_node(&pdev->dev);
 	accel_dev = kzalloc_node(sizeof(*accel_dev), GFP_KERNEL, node);
 	if (!accel_dev)
 		return -ENOMEM;
-- 
1.7.9.3

