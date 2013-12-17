Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3LQIHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:07:55 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:60599 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab3LQIHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:07:54 -0500
X-Greylist: delayed 1928 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Dec 2013 03:07:54 EST
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
To: Arnd Bergmann <arnd@arndb.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        Kumar Gala <galak@kernel.crashing.org>
Subject: commit e38c0a1f breaks powerpc boards with uli1575 chip
Date: Tue, 17 Dec 2013 11:35:37 +0400
User-Agent: KMail/1.9.9
Organization: RTsoft Software Development Center
Cc: linux-kernel@vger.kernel.org, Alexey Lugovskoy <lugovskoy@dev.rtsoft.ru>,
        Dmitry Krivoschekov <dkrivoschokov@dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201312171135.38576@blacky.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

While trying to make freescale p2020ds and  mpc8572ds boards working with mainline kernel, I faced that commit 
e38c0a1f (Handle #address-cells > 2 specially) breaks things with these boards.

Both these boards have uli1575 chip.
Corresponding part in device tree is something like

                uli1575@0 {
                        reg = <0x0 0x0 0x0 0x0 0x0>;
                        #size-cells = <2>;
                        #address-cells = <3>;
                        ranges = <0x2000000 0x0 0x80000000
                                  0x2000000 0x0 0x80000000
                                  0x0 0x20000000

                                  0x1000000 0x0 0x0
                                  0x1000000 0x0 0x0
                                  0x0 0x10000>;
                        isa@1e {
...

I.e. it has #address-cells = <3>


With commit e38c0a1f reverted, devices under uli1575 are registered correctly, e.g. for rtc

OF: ** translation for device /pcie@ffe09000/pcie@0/uli1575@0/isa@1e/rtc@70 **
OF: bus is isa (na=2, ns=1) on /pcie@ffe09000/pcie@0/uli1575@0/isa@1e
OF: translating address: 00000001 00000070
OF: parent bus is default (na=3, ns=2) on /pcie@ffe09000/pcie@0/uli1575@0
OF: walking ranges...
OF: ISA map, cp=0, s=1000, da=70
OF: parent translation for: 01000000 00000000 00000000
OF: with offset: 70
OF: one level translation: 00000000 00000000 00000070
OF: parent bus is pci (na=3, ns=2) on /pcie@ffe09000/pcie@0
OF: walking ranges...
OF: default map, cp=a0000000, s=20000000, da=70
OF: default map, cp=0, s=10000, da=70
OF: parent translation for: 01000000 00000000 00000000
OF: with offset: 70
OF: one level translation: 01000000 00000000 00000070
OF: parent bus is pci (na=3, ns=2) on /pcie@ffe09000
OF: walking ranges...
OF: PCI map, cp=0, s=10000, da=70
OF: parent translation for: 01000000 00000000 00000000
OF: with offset: 70
OF: one level translation: 01000000 00000000 00000070
OF: parent bus is default (na=2, ns=2) on /
OF: walking ranges...
OF: PCI map, cp=0, s=10000, da=70
OF: parent translation for: 00000000 ffc10000
OF: with offset: 70
OF: one level translation: 00000000 ffc10070
OF: reached root node

With commit e38c0a1f in place, address translation fails:

OF: ** translation for device /pcie@ffe09000/pcie@0/uli1575@0/isa@1e/rtc@70 **
OF: bus is isa (na=2, ns=1) on /pcie@ffe09000/pcie@0/uli1575@0/isa@1e
OF: translating address: 00000001 00000070
OF: parent bus is default (na=3, ns=2) on /pcie@ffe09000/pcie@0/uli1575@0
OF: walking ranges...
OF: ISA map, cp=0, s=1000, da=70
OF: parent translation for: 01000000 00000000 00000000
OF: with offset: 70
OF: one level translation: 00000000 00000000 00000070
OF: parent bus is pci (na=3, ns=2) on /pcie@ffe09000/pcie@0
OF: walking ranges...
OF: default map, cp=a0000000, s=20000000, da=70
OF: default map, cp=0, s=10000, da=70
OF: not found !

Either e38c0a1f should be reverted, or uli1575 (and perhaps other similar devices) have to be described in device 
trees differently.

Could someone please comment on this?
