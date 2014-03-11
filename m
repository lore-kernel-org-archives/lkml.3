Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbaCKRmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:42:55 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:55961 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbaCKRmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:42:53 -0400
Subject: [PATCH 2/5] resources: Set type in __request_region()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 11 Mar 2014 11:42:49 -0600
Message-ID: <20140311174249.23084.66300.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140311173556.23084.57635.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140311173556.23084.57635.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't set the type (I/O, memory, etc.) of resources added by
__request_region(), which leads to confusing messages like this:

    address space collision: [io  0x1000-0x107f] conflicts with ACPI CPU throttle [??? 0x00001010-0x00001015 flags 0x80000000]

Set the type of a new resource added by __request_region() (used by
request_region() and request_mem_region()) to the type of its parent.  This
makes the resource tree internally consistent and fixes messages like the
above, where the ACPI CPU throttle resource really is an I/O port region,
but request_region() didn't fill in the type, so %pR didn't know how to
print it.

Sample dmesg showing the issue at the link below.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=71611
Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 kernel/resource.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index a8344dda7049..ae1f742c860c 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -945,8 +945,8 @@ struct resource * __request_region(struct resource *parent,
 	res->name = name;
 	res->start = start;
 	res->end = start + n - 1;
-	res->flags = IORESOURCE_BUSY;
-	res->flags |= flags;
+	res->flags = parent->flags;
+	res->flags |= IORESOURCE_BUSY | flags;
 
 	write_lock(&resource_lock);
 

