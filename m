Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab3BKVsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 16:48:47 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:39392 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674Ab3BKVsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 16:48:46 -0500
Date: Mon, 11 Feb 2013 13:48:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>
cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [patch for-3.8] fs, dlm: fix build error when EXPERIMENTAL is
 disabled
Message-ID: <alpine.DEB.2.02.1302111344140.14071@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_IP_SCTP relies on being able to select things like CONFIG_CRC32C to 
build.  Thus, nothing should be selecting CONFIG_IP_SCTP that does not 
meet its requirements.

For example, if CONFIG_EXPERIMENTAL is disabled and CONFIG_DLM is enabled, 
the build fails at link time:

	net/built-in.o: In function `sctp_crc32c':
	include/net/sctp/checksum.h:51: undefined reference to `crc32c'
	include/net/sctp/checksum.h:51: undefined reference to `crc32c'
	include/net/sctp/checksum.h:51: undefined reference to `crc32c'
	include/net/sctp/checksum.h:51: undefined reference to `crc32c'
	include/net/sctp/checksum.h:51: undefined reference to `crc32c'
	net/built-in.o:include/net/sctp/checksum.h:51: more undefined references to `crc32c' follow

Fix this by making CONFIG_DLM depend on CONFIG_EXPERIMENTAL so that 
CONFIG_IP_SCTP properly builds.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/dlm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dlm/Kconfig b/fs/dlm/Kconfig
--- a/fs/dlm/Kconfig
+++ b/fs/dlm/Kconfig
@@ -2,6 +2,7 @@ menuconfig DLM
 	tristate "Distributed Lock Manager (DLM)"
 	depends on INET
 	depends on SYSFS && CONFIGFS_FS && (IPV6 || IPV6=n)
+	depends on EXPERIMENTAL
 	select IP_SCTP
 	help
 	A general purpose distributed lock manager for kernel or userspace
