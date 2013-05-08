Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab3EHQis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:38:48 -0400
Received: from smtpx.feld.cvut.cz ([147.32.192.33]:36019 "EHLO
	smtpx.feld.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab3EHQir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:38:47 -0400
X-Greylist: delayed 626 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 May 2013 12:38:47 EDT
Date: Wed, 08 May 2013 18:28:14 +0200
Message-ID: <20130508182814.Horde.hakqXtmsOi7FNBjwBV1zlw1@wimap.feld.cvut.cz>
From: strnape1@fel.cvut.cz
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr, mmarek@suse.cz,
        julia.lawall@lip6.fr
Subject: [PATCH] scripts: Coccinelle script for pci_free_consistent()
User-Agent: Internet Messaging Program (IMP) H5 (6.0.4)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Created coccinelle script for reporting missing pci_free_consistent() calls.

Signed-off-by: Petr Strnad <strnape1@fel.cvut.cz>
---
/// Find missing pci_free_consistent for every pci_alloc_consistent.
///
// Confidence: Moderate
// Copyright: (C) 2013 Petr Strnad.  GPLv2.
// URL: http://coccinelle.lip6.fr/
// Keywords: pci_free_consistent, pci_alloc_consistent
// Options: --no-includes --include-headers

virtual report
virtual org

@search@
local idexpression id;
expression x,y,z,e;
position p1,p2;
type T;
@@

id = pci_alloc_consistent@p1(x,y,&z)
... when != e = id
if (id == NULL || ...) { ... return ...; }
... when != pci_free_consistent(x,y,id,z)
     when != if (id) { ... pci_free_consistent(x,y,id,z) ... }
     when != if (y) { ... pci_free_consistent(x,y,id,z) ... }
     when != e = (T)id
     when exists
(
return 0;
|
return 1;
|
return id;
|
return@p2 ...;
)

@script:python depends on report@
p1 << search.p1;
p2 << search.p2;
@@

msg = "ERROR: missing pci_free_consistent; pci_alloc_consistent on  
line %s and return without freeing on line %s" % (p1[0].line,p2[0].line)
coccilib.report.print_report(p2[0],msg)

@script:python depends on org@
p1 << search.p1;
p2 << search.p2;
@@

msg = "ERROR: missing pci_free_consistent; pci_alloc_consistent on  
line %s and return without freeing on line %s" % (p1[0].line,p2[0].line)
cocci.print_main(msg,p1)
cocci.print_secs("",p2)

