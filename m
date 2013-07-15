Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab3GOOJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:09:26 -0400
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:1635
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757219Ab3GOOIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:08:53 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1155h)
X-WSS-ID: 0MPZDYH-01-9LN-02
X-M-MSG: 
Message-ID: <51E40268.3030009@amd.com>
Date: Mon, 15 Jul 2013 09:08:40 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: <agordeev@redhat.com>, <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: AHCI: ahci Driver crash in ahci_host_activate
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran into a crash during booting with the latest 3.11.0-rc1.  After 
investigation, the crash was triggered by the patch below where the "pp" 
is NULL in some cases.

Suravee

commit b29900e62598cecd519c9ab2b8e4d03f8ebf702d
Author: Alexander Gordeev <agordeev@redhat.com>
Date:   Wed May 22 08:53:48 2013 +0900

     AHCI: Make distinct names for ports in /proc/interrupts

     Currently all interrupts assigned to AHCI ports show up in
     '/proc/interrupts' as 'ahci'. This fix adds port numbers as
     suffixes and hence makes the descriptions distinct.

     Reported-by: Jan Beulich <JBeulich@suse.com>
     Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
     Signed-off-by: Tejun Heo <tj@kernel.org>

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 251e57d..4d1c672 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1142,9 +1142,11 @@ int ahci_host_activate(struct ata_host *host, int 
irq, unsigned int n_msis)
                 return rc;

         for (i = 0; i < host->n_ports; i++) {
+               struct ahci_port_priv *pp = host->ports[i]->private_data;
+
                 rc = devm_request_threaded_irq(host->dev,
                         irq + i, ahci_hw_interrupt, ahci_thread_fn, 
IRQF_SHARED,
-                       dev_driver_string(host->dev), host->ports[i]);
+                       pp->irq_desc, host->ports[i]);
                 if (rc)
                         goto out_free_irqs;
         }

