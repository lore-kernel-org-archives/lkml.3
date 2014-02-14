Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaBNICT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:02:19 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:41212 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaBNICO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:02:14 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 33/52] scsi, bnx2i: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, Eddie Wai <eddie.wai@broadcom.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Ingo Molnar <mingo@kernel.org>, linux-scsi@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 14 Feb 2014 13:26:41 +0530
Message-ID: <20140214075641.22701.48573.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021408-5490-0000-0000-000004F303ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subsystems that want to register CPU hotplug callbacks, as well as perform
initialization for the CPUs that are already online, often do it as shown
below:

	get_online_cpus();

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	register_cpu_notifier(&foobar_cpu_notifier);

	put_online_cpus();

This is wrong, since it is prone to ABBA deadlocks involving the
cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
with CPU hotplug operations).

Instead, the correct and race-free way of performing the callback
registration is:

	cpu_notifier_register_begin();

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	/* Note the use of the double underscored version of the API */
	__register_cpu_notifier(&foobar_cpu_notifier);

	cpu_notifier_register_done();


Fix the bnx2i code in scsi by using this latter form of callback registration.

Cc: Eddie Wai <eddie.wai@broadcom.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/scsi/bnx2i/bnx2i_init.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 34c294b..80c03b4 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -537,11 +537,15 @@ static int __init bnx2i_mod_init(void)
 		p->iothread = NULL;
 	}
 
+	cpu_notifier_register_begin();
+
 	for_each_online_cpu(cpu)
 		bnx2i_percpu_thread_create(cpu);
 
 	/* Initialize per CPU interrupt thread */
-	register_hotcpu_notifier(&bnx2i_cpu_notifier);
+	__register_hotcpu_notifier(&bnx2i_cpu_notifier);
+
+	cpu_notifier_register_done();
 
 	return 0;
 
@@ -581,11 +585,15 @@ static void __exit bnx2i_mod_exit(void)
 	}
 	mutex_unlock(&bnx2i_dev_lock);
 
-	unregister_hotcpu_notifier(&bnx2i_cpu_notifier);
+	cpu_notifier_register_begin();
 
 	for_each_online_cpu(cpu)
 		bnx2i_percpu_thread_destroy(cpu);
 
+	__unregister_hotcpu_notifier(&bnx2i_cpu_notifier);
+
+	cpu_notifier_register_done();
+
 	iscsi_unregister_transport(&bnx2i_iscsi_transport);
 	cnic_unregister_driver(CNIC_ULP_ISCSI);
 }

