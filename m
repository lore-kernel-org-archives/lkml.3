Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030208AbaGAVwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:52:40 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:10873 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbaGAVrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:47:43 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 41/50] mars: add new file drivers/block/mars/mars_light/light_net.c
Date: Tue,  1 Jul 2014 23:47:21 +0200
Message-Id: <1404251250-22992-42-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 drivers/block/mars/mars_light/light_net.c | 99 +++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)
 create mode 100644 drivers/block/mars/mars_light/light_net.c

diff --git a/drivers/block/mars/mars_light/light_net.c b/drivers/block/mars/mars_light/light_net.c
new file mode 100644
index 0000000..170e51b
--- /dev/null
+++ b/drivers/block/mars/mars_light/light_net.c
@@ -0,0 +1,99 @@
+/*  (c) 2011 Thomas Schoebel-Theuer / 1&1 Internet AG */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
+
+#include <linux/mars_light/light_strategy.h>
+#include <linux/xio_net.h>
+
+static
+char *_xio_translate_hostname(const char *name)
+{
+	struct mars_global *global = mars_global;
+	char *res = brick_strdup(name);
+	struct mars_dent *test;
+	char *tmp;
+
+	if (unlikely(!global))
+		goto done;
+
+	for (tmp = res; *tmp; tmp++) {
+		if (*tmp == ':') {
+			*tmp = '\0';
+			break;
+		}
+	}
+
+	tmp = path_make("/mars/ips/ip-%s", res);
+	if (unlikely(!tmp))
+		goto done;
+
+	test = mars_find_dent(global, tmp);
+	if (test && test->link_val) {
+		XIO_DBG("'%s' => '%s'\n", tmp, test->link_val);
+		brick_string_free(res);
+		res = brick_strdup(test->link_val);
+	} else {
+		XIO_DBG("no translation for '%s'\n", tmp);
+	}
+	brick_string_free(tmp);
+
+done:
+	return res;
+}
+
+int xio_send_dent_list(struct xio_socket *sock, struct list_head *anchor)
+{
+	struct list_head *tmp;
+	struct mars_dent *dent;
+	int status = 0;
+
+	for (tmp = anchor->next; tmp != anchor; tmp = tmp->next) {
+		dent = container_of(tmp, struct mars_dent, dent_link);
+		status = xio_send_struct(sock, dent, mars_dent_meta);
+		if (status < 0)
+			break;
+	}
+	if (status >= 0) { /*  send EOR */
+		status = xio_send_struct(sock, NULL, mars_dent_meta);
+	}
+	return status;
+}
+EXPORT_SYMBOL_GPL(xio_send_dent_list);
+
+int xio_recv_dent_list(struct xio_socket *sock, struct list_head *anchor)
+{
+	int status;
+
+	for (;;) {
+		struct mars_dent *dent = brick_zmem_alloc(sizeof(struct mars_dent));
+
+		INIT_LIST_HEAD(&dent->dent_link);
+		INIT_LIST_HEAD(&dent->brick_list);
+
+		status = xio_recv_struct(sock, dent, mars_dent_meta);
+		if (status <= 0) {
+			xio_free_dent(dent);
+			goto done;
+		}
+		list_add_tail(&dent->dent_link, anchor);
+	}
+done:
+	return status;
+}
+EXPORT_SYMBOL_GPL(xio_recv_dent_list);
+
+/***************** module init stuff ************************/
+
+int __init init_sy_net(void)
+{
+	XIO_INF("init_sy_net()\n");
+	xio_translate_hostname = _xio_translate_hostname;
+	return 0;
+}
+
+void exit_sy_net(void)
+{
+	XIO_INF("exit_sy_net()\n");
+}
-- 
2.0.0

