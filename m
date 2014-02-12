Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaBLAfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 19:35:17 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:56298 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaBLAfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 19:35:15 -0500
Date: Tue, 11 Feb 2014 16:35:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: qib_lookup_qpn() appears to leak pointer out of rcu_read_unlock()
Message-ID: <20140212003511.GA27242@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021200-1344-0000-0000-000005A3EE22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The qib_lookup_qpn() function does RCU pointer traversals within RCU
read-side critical sections as required, but the qp pointer is returned
from this function after it does rcu_read_unlock().  One of the callers,
qib_rcv_hdrerr(), dereferences this pointer upon return.

This appears to me to be a bug.  From what I can see, the structure
pointed to by qp could be freed immediately after the rcu_read_unlock(),
which would result in a SEGV when qib_rcv_hdrerr() does its later
spin_lock(&qp->r_lock).

So what am I missing here?

							Thanx, Paul

