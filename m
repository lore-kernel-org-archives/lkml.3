Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab3IQBr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 21:47:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab3IQBr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 21:47:26 -0400
From: Veaceslav Falico <vfalico@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Veaceslav Falico <vfalico@redhat.com>
Subject: [PATCH 0/3] msi: fix kobject/sysfs removal from msi_list
Date: Tue, 17 Sep 2013 03:47:41 +0200
Message-Id: <1379382464-7920-1-git-send-email-vfalico@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, while removing msi_list's ->kobj, we just do kobject_put() on it
and after that free the entry itself. However, kobject_put() doesn't
guarantee that the kobject itself is freed - it can be used by someone else
and thus, when we'll free the entry, we'll free the kobject too - leading
to bugs in the other users (or when we'll finally release it).

Also, in some cases we might fail to register the kobjects, but we forget
to remove pdev->msi_kset, and this can lead to errors if we try to
re-register it - cause we already have that kset initialized.

Fix both issues by moving msi_kset/kobject deinitialization code completely
to free_msi_irqs(), which is called every time we fail and need to roll
back (and on the proper device irqs deinit). Also, move kfree-ing of the
msi_list entry to kobject->release (msi_kobj_release()), so that the entry
containing kobject will only be delisted in free_msi_irqs(), and free only
when there are no other users of its kobject.

CC: Bjorn Helgaas <bhelgaas@google.com>
CC: linux-pci@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Veaceslav Falico <vfalico@redhat.com>

---
 drivers/pci/msi.c | 38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)
