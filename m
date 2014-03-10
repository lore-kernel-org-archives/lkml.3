Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbaCJUmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:42:35 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39472 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbaCJUmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:42:31 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 48/52] profile: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rjw@rjwysocki.net,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pm@vger.kernel.org, linuxppc-dev@ozlabs.org,
        srivatsa.bhat@linux.vnet.ibm.com, Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2014 02:12:08 +0530
Message-ID: <20140310204207.10746.84822.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
References: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031020-0260-0000-0000-000004832C60
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


Fix the profile code by using this latter form of callback registration.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/profile.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index 6631e1e..4c0cb95 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -591,18 +591,28 @@ out_cleanup:
 int __ref create_proc_profile(void) /* false positive from hotcpu_notifier */
 {
 	struct proc_dir_entry *entry;
+	int err = 0;
 
 	if (!prof_on)
 		return 0;
-	if (create_hash_tables())
-		return -ENOMEM;
+
+	cpu_notifier_register_begin();
+
+	if (create_hash_tables()) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	entry = proc_create("profile", S_IWUSR | S_IRUGO,
 			    NULL, &proc_profile_operations);
 	if (!entry)
-		return 0;
+		goto out;
 	proc_set_size(entry, (1 + prof_len) * sizeof(atomic_t));
-	hotcpu_notifier(profile_cpu_callback, 0);
-	return 0;
+	__hotcpu_notifier(profile_cpu_callback, 0);
+
+out:
+	cpu_notifier_register_done();
+	return err;
 }
 module_init(create_proc_profile);
 #endif /* CONFIG_PROC_FS */

