Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbbAJXT0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 18:19:26 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:40725 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbbAJXTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 18:19:25 -0500
Date: Sat, 10 Jan 2015 23:25:18 +0000
From: "Carlos R. Mafra" <crmafra@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
        "John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org
Subject: /proc/net/dev regression
Message-ID: <20150110232518.GA3212@linux-g29b.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I use a dockapp called 'wmnet' [1] to monitor the speed of
my internet connection and after the kernel v3.18 it does no
longer work properly (it still doesn't work in v3.19-rc3)

I bisected the problem and the culprit is this commit:

commit 6e094bd805a9b6ad2f5421125db8f604a166616c
Author: Rafał Miłecki <zajec5@gmail.com>
Date:   Fri Sep 5 00:18:48 2014 +0200

    bcma: move code for core registration into separate function
    
    This cleans code a bit and will us to register cores in other places as
    well. The only difference with this patch is using "core_index" for
    setting device name.
    
    
The problem is caused by the different name that my wireless connection
receives after this patch:

wlp3s0b1 (after the patch)
wlp3s0   (before the patch)

because it affects the display of information in the file /proc/net/dev.

Before the patch the fields are all aligned:

[mafra@linux-g29b:wmnet]$ cat net_dev_good.txt
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
    lo:   35916     332    0    0    0     0          0         0    35916     332    0    0    0     0       0          0
wlp3s0: 6406428    5794    0    0    0     0          0         0   426813    3778    0    0    0     0       0          0

but after the patch the fields are misaligned:

[mafra@linux-g29b:wmnet]$ cat net_dev_bad.txt
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
    lo:     600       8    0    0    0     0          0         0      600       8    0    0    0     0       0          0
wlp3s0b1: 9266848    7298    0    0    0     0          0         0   372229    4030    0    0    0     0       0          0

And for some reason this change confuses 'wmnet'. Reading the source code
of 'wmnet' I found that it reads the packets as follows,

	totalpackets_in = strtoul(&buffer[15], NULL, 10);

I am not sure if 'wmnet' could do this better (any suggestions?),
but the fact is that it was working before and now it is not.

Any help is greatly appreciated.

[1] wmnet can be found in http://repo.or.cz/w/dockapps.git
