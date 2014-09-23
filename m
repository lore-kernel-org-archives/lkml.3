Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbaIWCk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:40:57 -0400
Received: from mail.kernel.org ([198.145.19.201]:38585 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbaIWCkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:40:52 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Stephen Hurd <shurd@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 39/45] 8250_pci: fix warnings in backport of Broadcom TruManage support
Date: Tue, 23 Sep 2014 10:31:41 +0800
Message-Id: <1411439507-30391-39-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 7400ce7ee9595432b2a1402b6ffcac9faf38d9ae (v3.4.92-76-g7400ce7ee959)
was a backport of commit ebebd49a8eab5e9aa1b1f8f1614ccc3c2120f886 upstream
("8250/16?50: Add support for Broadcom TruManage redirected serial port")

However, in the context of 3.4.x kernels, the pci setup code was
expecting a struct uart_port and not a struct uart_8250_port, leading to
the following concerning warnings:

drivers/tty/serial/8250/8250_pci.c: In function ‘pci_brcm_trumanage_setup’:
drivers/tty/serial/8250/8250_pci.c:1086:2: warning: passing argument 3 of ‘pci_default_setup’ from incompatible pointer type [enabled by default]
  int ret = pci_default_setup(priv, board, port, idx);
  ^
drivers/tty/serial/8250/8250_pci.c:1036:1: note: expected ‘struct uart_port *’ but argument is of type ‘struct uart_8250_port *’
 pci_default_setup(struct serial_private *priv,
 ^
drivers/tty/serial/8250/8250_pci.c: At top level:
drivers/tty/serial/8250/8250_pci.c:1746:3: warning: initialization from incompatible pointer type [enabled by default]
   .setup  = pci_brcm_trumanage_setup,
   ^
drivers/tty/serial/8250/8250_pci.c:1746:3: warning: (near initialization for ‘pci_serial_quirks[56].setup’) [enabled by default]

I'd also expect the initialization to not function correctly, and
perhaps dereference random garbage due to this.  Since the uart_port
is a field within the uart_8250_port, the adaptation to fix these
warnings is a straightforward removal of a layer of indirection.

Cc: Stephen Hurd <shurd@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/tty/serial/8250/8250_pci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index c48cf89..d53f396 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1080,12 +1080,12 @@ pci_omegapci_setup(struct serial_private *priv,
 static int
 pci_brcm_trumanage_setup(struct serial_private *priv,
 			 const struct pciserial_board *board,
-			 struct uart_8250_port *port, int idx)
+			 struct uart_port *port, int idx)
 {
 	int ret = pci_default_setup(priv, board, port, idx);
 
-	port->port.type = PORT_BRCM_TRUMANAGE;
-	port->port.flags = (port->port.flags | UPF_FIXED_PORT | UPF_FIXED_TYPE);
+	port->type = PORT_BRCM_TRUMANAGE;
+	port->flags = (port->flags | UPF_FIXED_PORT | UPF_FIXED_TYPE);
 	return ret;
 }
 
-- 
1.7.9.5

