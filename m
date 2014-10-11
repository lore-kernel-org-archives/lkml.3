Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaJKIgf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 04:36:35 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:45155 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaJKIgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 04:36:32 -0400
Date: Sat, 11 Oct 2014 10:36:27 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Graf <tgraf@suug.ch>, Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ursula Braun <braunu@de.ibm.com>
Subject: [bisected] e341694e3eb5 netlink_lookup() rcu conversion causes
 latencies
Message-ID: <20141011083627.GB5074@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101108-0017-0000-0000-00000168AA3F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

it just came to my attention that commit e341694e3eb5
"netlink: Convert netlink_lookup() to use RCU protected hash table"
causes network latencies for me on s390.

The testcase is quite simple and 100% reproducible on s390:

Simply login via ssh to a remote system which has the above mentioned
patch applied. Any action like pressing return now has significant
latencies. Or in other words, working via such a connection becomes
a pain ;)

I haven't debugged it, however I assume the problem is that a) the
commit introduces a synchronize_net() call und b) s390 kernels
usually get compiled with CONFIG_HZ_100 while most other architectures
use CONFIG_HZ_1000.
If I change the kernel config to CONFIG_HZ_1000 the problem goes away,
however I don't consider this a fix...

Another reason why this hasn't been observed on x86 may or may not be
that we haven't implemented CONFIG_HAVE_CONTEXT_TRACKING on s390 (yet).
But that's just guessing...

