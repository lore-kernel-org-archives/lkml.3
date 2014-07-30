Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaG3B44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:56:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbaG3BuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:50:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tyrel Datwyler <tyreld@linux.vnet.ibm.com>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.15 17/37] powerpc/pseries: dynamically added OF nodes need to call of_node_init
Date: Tue, 29 Jul 2014 18:48:53 -0700
Message-Id: <20140730014828.510035939@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014827.565626091@linuxfoundation.org>
References: <20140730014827.565626091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

commit 97a9a7179aad701ab676e6f29eb90766a1acfde2 upstream.

Commit 75b57ecf9 refactored device tree nodes to use kobjects such that they
can be exposed via /sysfs. A secondary commit 0829f6d1f furthered this rework
by moving the kobect initialization logic out of of_node_add into its own
of_node_init function. The inital commit removed the existing kref_init calls
in the pseries dlpar code with the assumption kobject initialization would
occur in of_node_add. The second commit had the side effect of triggering a
BUG_ON during DLPAR, migration and suspend/resume operations as a result of
dynamically added nodes being uninitialized.

This patch fixes this by adding of_node_init calls in place of the previously
removed kref_init calls.

Fixes: 0829f6d1f69e ("of: device_node kobject lifecycle fixes")
Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Acked-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Acked-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/dlpar.c    |    1 +
 arch/powerpc/platforms/pseries/reconfig.c |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -86,6 +86,7 @@ static struct device_node *dlpar_parse_c
 	}
 
 	of_node_set_flag(dn, OF_DYNAMIC);
+	of_node_init(dn);
 
 	return dn;
 }
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -69,6 +69,7 @@ static int pSeries_reconfig_add_node(con
 
 	np->properties = proplist;
 	of_node_set_flag(np, OF_DYNAMIC);
+	of_node_init(np);
 
 	np->parent = derive_parent(path);
 	if (IS_ERR(np->parent)) {


