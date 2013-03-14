Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3CNWLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:11:44 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18852 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab3CNWLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:11:41 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: bp@alien.de
Cc: chegger@amazon.de, xen-devel@lists.xen.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com,
        stable@vger.kernel.org, boris.ostrovsky@oracle.com
Subject: [PATCH v2 1/2] x86/mce: Replace shared_bank array with is_shared_bank() helper
Date: Thu, 14 Mar 2013 17:10:40 -0400
Message-Id: <1363295441-1859-2-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363295441-1859-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1363295441-1859-1-git-send-email-boris.ostrovsky@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helper function instead of an array to report whether register
bank is shared. Currently only bank 4 (northbridge) is shared.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 1ac581f..654a155 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -58,11 +58,6 @@ static const char * const th_names[] = {
 };
 
 static DEFINE_PER_CPU(struct threshold_bank * [NR_BANKS], threshold_banks);
-
-static unsigned char shared_bank[NR_BANKS] = {
-	0, 0, 0, 0, 1
-};
-
 static DEFINE_PER_CPU(unsigned char, bank_map);	/* see which banks are on */
 
 static void amd_threshold_interrupt(void);
@@ -79,6 +74,12 @@ struct thresh_restart {
 	u16			old_limit;
 };
 
+static inline bool is_shared_bank(int bank)
+{
+	/* Bank 4 is for northbridge reporting is thus is shared */
+	return (bank == 4);
+}
+
 static const char * const bank4_names(struct threshold_block *b)
 {
 	switch (b->address) {
@@ -575,7 +576,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 	const char *name = th_names[bank];
 	int err = 0;
 
-	if (shared_bank[bank]) {
+	if (is_shared_bank(bank)) {
 		nb = node_to_amd_nb(amd_get_nb_id(cpu));
 
 		/* threshold descriptor already initialized on this node? */
@@ -609,7 +610,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
 
-	if (shared_bank[bank]) {
+	if (is_shared_bank(bank)) {
 		atomic_set(&b->cpus, 1);
 
 		/* nb is already initialized, see above */
@@ -691,7 +692,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 	if (!b->blocks)
 		goto free_out;
 
-	if (shared_bank[bank]) {
+	if (is_shared_bank(bank)) {
 		if (!atomic_dec_and_test(&b->cpus)) {
 			__threshold_remove_blocks(b);
 			per_cpu(threshold_banks, cpu)[bank] = NULL;
-- 
1.8.1.2

