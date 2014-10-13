Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbaJMC3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:29:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbaJMC3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:29:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Xishi Qiu <qiuxishi@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3.16 54/55] driver/base/node: remove unnecessary kfree of node struct from unregister_one_node
Date: Mon, 13 Oct 2014 04:25:08 +0200
Message-Id: <20141013022446.316047719@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022443.729870634@linuxfoundation.org>
References: <20141013022443.729870634@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

commit 33ead538f642a33b1d658782a5d14a40b5014d1f upstream.

Commit 92d585ef067d ("numa: fix NULL pointer access and memory
leak in unregister_one_node()") added kfree() of node struct in
unregister_one_node(). But node struct is freed by node_device_release()
which is called in  unregister_node(). So by adding the kfree(),
node struct is freed two times.

While hot removing memory, the commit leads the following BUG_ON():

  kernel BUG at mm/slub.c:3346!
  invalid opcode: 0000 [#1] SMP
  [...]
  Call Trace:
   [...] unregister_one_node
   [...] try_offline_node
   [...] remove_memory
   [...] acpi_memory_device_remove
   [...] acpi_bus_trim
   [...] acpi_bus_trim
   [...] acpi_device_hotplug
   [...] acpi_hotplug_work_fn
   [...] process_one_work
   [...] worker_thread
   [...] ? rescuer_thread
   [...] kthread
   [...] ? kthread_create_on_node
   [...] ret_from_fork
   [...] ? kthread_create_on_node

This patch removes unnecessary kfree() from unregister_one_node().

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Fixes: 92d585ef067d "numa: fix NULL pointer access and memory leak in unregister_one_node()"
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/node.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -603,7 +603,6 @@ void unregister_one_node(int nid)
 		return;
 
 	unregister_node(node_devices[nid]);
-	kfree(node_devices[nid]);
 	node_devices[nid] = NULL;
 }
 


