Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab3LRVJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:09:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab3LRVJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:09:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.4 23/31] dm bufio: initialize read-only module parameters
Date: Wed, 18 Dec 2013 13:08:31 -0800
Message-Id: <20131218210523.441140055@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218210522.790152625@linuxfoundation.org>
References: <20131218210522.790152625@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 4cb57ab4a2e61978f3a9b7d4f53988f30d61c27f upstream.

Some module parameters in dm-bufio are read-only. These parameters
inform the user about memory consumption. They are not supposed to be
changed by the user.

However, despite being read-only, these parameters can be set on
modprobe or insmod command line, for example:
modprobe dm-bufio current_allocated_bytes=12345

The kernel doesn't expect that these variables can be non-zero at module
initialization and if the user sets them, it results in BUG.

This patch initializes the variables in the module init routine, so that
user-supplied values are ignored.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-bufio.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1642,6 +1642,11 @@ static int __init dm_bufio_init(void)
 {
 	__u64 mem;
 
+	dm_bufio_allocated_kmem_cache = 0;
+	dm_bufio_allocated_get_free_pages = 0;
+	dm_bufio_allocated_vmalloc = 0;
+	dm_bufio_current_allocated = 0;
+
 	memset(&dm_bufio_caches, 0, sizeof dm_bufio_caches);
 	memset(&dm_bufio_cache_names, 0, sizeof dm_bufio_cache_names);
 


