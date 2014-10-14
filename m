Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbaJNMqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:46:02 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:57220 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbaJNMqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:46:00 -0400
Date: Tue, 14 Oct 2014 13:44:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia: don't bale on invalid card headers
Message-ID: <20141014134447.1cae04c5@www.etchedpixels.co.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no requirement a PCMCIA card has valid CIS data or even a CIS.
The MTD layer correctly handles this but the core PCMCIA code erroneously
refuses to accept the card and prevents the MTD driver from working in
this case.

Tested with an Apple Newton 1MB SRAM card.

Signed-off-by: Alan Cox <alan@linux.intel.com>

diff -u --new-file --recursive --exclude-from ac/.gitignore next/drivers/pcmcia/ds.c ac/drivers/pcmcia/ds.c
--- next/drivers/pcmcia/ds.c	2013-10-28 11:40:29.721315588 +0000
+++ ac/drivers/pcmcia/ds.c	2014-10-14 13:43:35.431774459 +0100
@@ -635,7 +635,6 @@
 	ret = pccard_validate_cis(s, &no_chains);
 	if (ret || !no_chains) {
 		dev_dbg(&s->dev, "invalid CIS or invalid resources\n");
-		return -ENODEV;
 	}
 
 	if (!pccard_read_tuple(s, BIND_FN_ALL, CISTPL_LONGLINK_MFC, &mfc))
