Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab3CGR4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 12:56:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060Ab3CGRz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 12:55:59 -0500
Date: Thu, 7 Mar 2013 18:53:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, ibm-acpi@hmh.eng.br,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Artem Savkov <artem.savkov@gmail.com>
Subject: [PATCH 1/1] thinkpad-acpi: kill hotkey_thread_mutex
Message-ID: <20130307175359.GB15631@redhat.com>
References: <201303042055.38040.maciej.rutecki@gmail.com> <1362504883-9180-1-git-send-email-msb@chromium.org> <20130305174838.GA7276@redhat.com> <CACBanvqHRDsOQiMsQMw5_QDt1wFrb8_DRoiASSvqeA6XdFrwZQ@mail.gmail.com> <20130305180542.GA12738@redhat.com> <CACBanvr7XvXbFjphpRwKHHJKzVuA-s6sF-qkPiizBV3+uqzpJw@mail.gmail.com> <20130305232603.GA16045@khazad-dum.debian.net> <20130306154420.GA7697@redhat.com> <20130306233232.GA12645@khazad-dum.debian.net> <20130307175305.GA15631@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307175305.GA15631@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hotkey_kthread() does try_to_freeze() under hotkey_thread_mutex.

We can simply kill this mutex, hotkey_poll_stop_sync() does not need
to serialize with hotkey_kthread(). When kthread_stop() returns the
thread is already dead, it called do_exit()->complete_vfork_done().

Reported-by: Artem Savkov <artem.savkov@gmail.com>
Reported-by: Maciej Rutecki <maciej.rutecki@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- x/drivers/platform/x86/thinkpad_acpi.c
+++ x/drivers/platform/x86/thinkpad_acpi.c
@@ -1965,9 +1965,6 @@ struct tp_nvram_state {
 /* kthread for the hotkey poller */
 static struct task_struct *tpacpi_hotkey_task;
 
-/* Acquired while the poller kthread is running, use to sync start/stop */
-static struct mutex hotkey_thread_mutex;
-
 /*
  * Acquire mutex to write poller control variables as an
  * atomic block.
@@ -2463,8 +2460,6 @@ static int hotkey_kthread(void *data)
 	unsigned int poll_freq;
 	bool was_frozen;
 
-	mutex_lock(&hotkey_thread_mutex);
-
 	if (tpacpi_lifecycle == TPACPI_LIFE_EXITING)
 		goto exit;
 
@@ -2524,7 +2519,6 @@ static int hotkey_kthread(void *data)
 	}
 
 exit:
-	mutex_unlock(&hotkey_thread_mutex);
 	return 0;
 }
 
@@ -2534,9 +2528,6 @@ static void hotkey_poll_stop_sync(void)
 	if (tpacpi_hotkey_task) {
 		kthread_stop(tpacpi_hotkey_task);
 		tpacpi_hotkey_task = NULL;
-		mutex_lock(&hotkey_thread_mutex);
-		/* at this point, the thread did exit */
-		mutex_unlock(&hotkey_thread_mutex);
 	}
 }
 
@@ -3235,7 +3226,6 @@ static int __init hotkey_init(struct ibm
 	mutex_init(&hotkey_mutex);
 
 #ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
-	mutex_init(&hotkey_thread_mutex);
 	mutex_init(&hotkey_thread_data_mutex);
 #endif
 

