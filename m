Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbbAWPTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:19:40 -0500
Received: from [198.137.202.10] ([198.137.202.10]:40081 "EHLO
	terminus.zytor.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbbAWPTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:19:36 -0500
Date: Fri, 23 Jan 2015 07:18:36 -0800
From: tip-bot for WANG Chao <tipbot@zytor.com>
Message-ID: <tip-7389882c81474d635a208726edb22938645ff9ad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, pure.logic@nexus-software.ie,
        matt.fleming@intel.com, chaowang@redhat.com, tglx@linutronix.de,
        santosh.shilimkar@ti.com, bp@suse.de, mingo@kernel.org
Reply-To: mingo@kernel.org, bp@suse.de, santosh.shilimkar@ti.com,
        tglx@linutronix.de, chaowang@redhat.com, matt.fleming@intel.com,
        hpa@zytor.com, pure.logic@nexus-software.ie,
        linux-kernel@vger.kernel.org
In-Reply-To: <1420628150-16872-1-git-send-email-chaowang@redhat.com>
References: <1420628150-16872-1-git-send-email-chaowang@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, setup: Let early_memremap()
  handle page alignment
Git-Commit-ID: 7389882c81474d635a208726edb22938645ff9ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7389882c81474d635a208726edb22938645ff9ad
Gitweb:     http://git.kernel.org/tip/7389882c81474d635a208726edb22938645ff9ad
Author:     WANG Chao <chaowang@redhat.com>
AuthorDate: Wed, 7 Jan 2015 18:55:48 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 23 Jan 2015 16:14:26 +0100

x86, setup: Let early_memremap() handle page alignment

early_memremap() takes care of page alignment and map size, so we can
just remap the required data size and get rid of the adjustments in
the setup code.

[tglx: Massaged changelog ]

Signed-off-by: WANG Chao <chaowang@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Link: http://lkml.kernel.org/r/1420628150-16872-1-git-send-email-chaowang@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/setup.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ab4734e..c4648ada 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -431,15 +431,13 @@ static void __init parse_setup_data(void)
 
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		u32 data_len, map_len, data_type;
+		u32 data_len, data_type;
 
-		map_len = max(PAGE_SIZE - (pa_data & ~PAGE_MASK),
-			      (u64)sizeof(struct setup_data));
-		data = early_memremap(pa_data, map_len);
+		data = early_memremap(pa_data, sizeof(*data));
 		data_len = data->len + sizeof(struct setup_data);
 		data_type = data->type;
 		pa_next = data->next;
-		early_iounmap(data, map_len);
+		early_iounmap(data, sizeof(*data));
 
 		switch (data_type) {
 		case SETUP_E820_EXT:
