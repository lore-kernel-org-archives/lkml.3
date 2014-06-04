Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbaFEALO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:11:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbaFDXWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Chojnowski <frirajder@gmail.com>,
        Andy Grover <agrover@redhat.com>, Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 175/228] target: Allow non-supporting backends to set pi_prot_type to 0
Date: Wed,  4 Jun 2014 16:23:24 -0700
Message-Id: <20140604232353.640136740@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Grover <agrover@redhat.com>

commit 448ba904160f9d8f69217c28a1692cee5afbff88 upstream.

Userspace tools assume if a value is read from configfs, it is valid
and will not cause an error if the same value is written back. The only
valid value for pi_prot_type for backends not supporting DIF is 0, so allow
this particular value to be set without returning an error.

Reported-by: Krzysztof Chojnowski <frirajder@gmail.com>
Signed-off-by: Andy Grover <agrover@redhat.com>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_device.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -936,6 +936,10 @@ int se_dev_set_pi_prot_type(struct se_de
 		return 0;
 	}
 	if (!dev->transport->init_prot || !dev->transport->free_prot) {
+		/* 0 is only allowed value for non-supporting backends */
+		if (flag == 0)
+			return 0;
+
 		pr_err("DIF protection not supported by backend: %s\n",
 		       dev->transport->name);
 		return -ENOSYS;


