Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3ARNaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 08:30:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35205 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3ARNaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 08:30:11 -0500
Date: Fri, 18 Jan 2013 16:29:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [bug report] f2fs: off by one in garbage collection functions
Message-ID: <20130118132949.GA5708@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jaegeuk Kim,

The patch 7bc0900347e0: "f2fs: add garbage collection functions" from 
Nov 2, 2012, has an off-by-one bug.

   429  block_t start_bidx_of_node(unsigned int node_ofs)
   430  {
   431          unsigned int indirect_blks = 2 * NIDS_PER_BLOCK + 4;
   432          unsigned int bidx;
   433  
   434          if (node_ofs == 0)
   435                  return 0;
   436  
   437          if (node_ofs <= 2) {
   438                  bidx = node_ofs - 1;
   439          } else if (node_ofs <= indirect_blks) {
   440                  int dec = (node_ofs - 4) / (NIDS_PER_BLOCK + 1);

If node_ofs == 3 here then (node_ofs - 4) is a very high positive
number.  We divide by 1019 and we get another still very high number but
not so high that it is negative when cast as an int.

   441                  bidx = node_ofs - 2 - dec;

It means that bidx is much higher than intended here (4290752413).

I thought maybe there is an off by one somewhere.  Perhaps the 4 should
be a 3.

   442          } else {
   443                  int dec = (node_ofs - indirect_blks - 3) / (NIDS_PER_BLOCK + 1);
   444                  bidx = node_ofs - 5 - dec;
   445          }
   446          return bidx * ADDRS_PER_BLOCK + ADDRS_PER_INODE;
   447  }

regards,
dan carpenter

