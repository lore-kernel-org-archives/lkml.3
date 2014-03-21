Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966011AbaCUAJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:09:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965874AbaCUAJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.10 44/85] ACPI / resources: ignore invalid ACPI device resources
Date: Thu, 20 Mar 2014 17:09:47 -0700
Message-Id: <20140321000604.996736946@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit b355cee88e3b1a193f0e9a81db810f6f83ad728b upstream.

ACPI table may export resource entry with 0 length.
But the current code interprets this kind of resource in a wrong way.
It will create a resource structure with
res->end = acpi_resource->start + acpi_resource->len - 1;

This patch fixes a problem on my machine that a platform device fails
to be created because one of its ACPI IO resource entry (start = 0,
end = 0, length = 0) is translated into a generic resource with
start = 0, end = 0xffffffff.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/resource.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -77,18 +77,24 @@ bool acpi_dev_resource_memory(struct acp
 	switch (ares->type) {
 	case ACPI_RESOURCE_TYPE_MEMORY24:
 		memory24 = &ares->data.memory24;
+		if (!memory24->address_length)
+			return false;
 		acpi_dev_get_memresource(res, memory24->minimum,
 					 memory24->address_length,
 					 memory24->write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_MEMORY32:
 		memory32 = &ares->data.memory32;
+		if (!memory32->address_length)
+			return false;
 		acpi_dev_get_memresource(res, memory32->minimum,
 					 memory32->address_length,
 					 memory32->write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
 		fixed_memory32 = &ares->data.fixed_memory32;
+		if (!fixed_memory32->address_length)
+			return false;
 		acpi_dev_get_memresource(res, fixed_memory32->address,
 					 fixed_memory32->address_length,
 					 fixed_memory32->write_protect);
@@ -144,12 +150,16 @@ bool acpi_dev_resource_io(struct acpi_re
 	switch (ares->type) {
 	case ACPI_RESOURCE_TYPE_IO:
 		io = &ares->data.io;
+		if (!io->address_length)
+			return false;
 		acpi_dev_get_ioresource(res, io->minimum,
 					io->address_length,
 					io->io_decode);
 		break;
 	case ACPI_RESOURCE_TYPE_FIXED_IO:
 		fixed_io = &ares->data.fixed_io;
+		if (!fixed_io->address_length)
+			return false;
 		acpi_dev_get_ioresource(res, fixed_io->address,
 					fixed_io->address_length,
 					ACPI_DECODE_10);


