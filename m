Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaIIUYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:24:34 -0400
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:19536
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752438AbaIIUYb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:24:31 -0400
From: Anish Bhatt <anish@chelsio.com>
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "mchan@broadcom.com" <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: RE: randconfig build error with next-20140909, in
 drivers/net/ethernet/broadcom/cnic.c
Thread-Topic: randconfig build error with next-20140909, in
 drivers/net/ethernet/broadcom/cnic.c
Thread-Index: AQHPzDvJUu4bLmC2JEOt957Ln3rhrpv5OvG1
Date: Tue, 9 Sep 2014 20:24:21 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D88E0BFB@nice.asicdesigners.com>
References: <CA+r1ZhhZynUKSeZnya67z9sph4+tpjO4E7jLZKc0EG4azxFdYA@mail.gmail.com>
In-Reply-To: <CA+r1ZhhZynUKSeZnya67z9sph4+tpjO4E7jLZKc0EG4azxFdYA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.164.225]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is caused by c99d667e8527  ("cnic : Cleanup CONFIG_IPV6 & VLAN check")

So I'm not really sure what the fix for this is. CNIC will properly only support 
[m] or [n] when IPV6 is compiled as a module, but if you set SCSI_BNX2X_FCOE or 
SCSI_BNX2_ISCSI to be in built, there is a 'select CNIC' that forces CNIC to be 
inbuilt, even though this is not supported by Kconfig. I was under the 
assumption that select will not forcibly change m to inbuilt (or perhaps I'm 
missing some syntax suboption ?)

This is still fixable in SCSI_BNX2_ISCSI using the same logic used in the above 
mentioned commit, but not so in SCSI_BNX2X_FCOE where it causes a recursive 
dependency error (thought it is fixing the issue nevertheless), and none of the 
 other solutions I tried seemed to work either.

Looking at previous code, the earlier approach used to just disable ipv6 code 
in such a situation.
-Anish

________________________________________
From: Jim Davis [jim.epost@gmail.com]
Sent: Tuesday, September 09, 2014 7:38 AM
To: Stephen Rothwell; linux-next; linux-kernel; Anish Bhatt; mchan@broadcom.com; David S. Miller; netdev
Subject: randconfig build error with next-20140909, in drivers/net/ethernet/broadcom/cnic.c

Building with the attached random configuration file,

drivers/built-in.o: In function `cnic_get_v6_route':
cnic.c:(.text+0x3a4168): undefined reference to `ip6_route_output'
make: *** [vmlinux] Error 1
