Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbaGRAwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 20:52:33 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:44199 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaGRAwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 20:52:32 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: KY Srinivasan <kys@microsoft.com>, Jens Axboe <axboe@kernel.dk>,
        "James Bottomley" <jbottomley@parallels.com>,
        "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>,
        "Christoph Hellwig (hch@infradead.org)" <hch@infradead.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Thread-Topic: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT
 from the basic I/O timeout
Thread-Index: AQHPgAqrrlGx/1kfQ0SPzg5EQKxH1pthLVSAgAADsICAAh1LgIAAFoiAgADx34CAAAl2AIAACGQAgBY20ACAKpUsgIAAA6+g
Date: Fri, 18 Jul 2014 00:51:06 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958BAC6DC@G9W0745.americas.hpqcorp.net>
References: <1401899623-24194-1-git-send-email-kys@microsoft.com>
 <1401901323.17510.23.camel@dabdike>
 <d61f4b87a72544e4b0c1e1872a76f97b@BY2PR03MB299.namprd03.prod.outlook.com>
 <53911A35.7010805@cs.wisc.edu>
 <d9854e6ff97f4b0087dbe835a2a57c8f@BY2PR03MB299.namprd03.prod.outlook.com>
 <5391F801.4010107@cs.wisc.edu>
 <1402077167.2207.89.camel@dabdike.int.hansenpartnership.com>
 <539206FA.1020001@kernel.dk>
 <5b926a0a9f264edda91c7c2ab0acb7d1@BY2PR03MB299.namprd03.prod.outlook.com>
 <13807d2cc8744ae1bc374f20d8f9caec@BY2PR0301MB0711.namprd03.prod.outlook.com>
In-Reply-To: <13807d2cc8744ae1bc374f20d8f9caec@BY2PR0301MB0711.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In sd_sync_cache:
	rq->timeout *= SD_FLUSH_TIMEOUT_MULTIPLIER;

Regardless of the baseline for the multiplication, a magic 
number of 2 is too arbitrary.  That might work for an
individual drive, but could be far too short for a RAID
controller that runs into worst case error handling for
the drives to which it is flushing (e.g., if its cache
is volatile and the drives all have recoverable errors
during writes).  That time goes up with a bigger cache and 
with more fragmented write data in the cache requiring
more individual WRITE commands.

A better value would be the Recommended Command Timeout field 
value reported in the REPORT SUPPORTED OPERATION CODES command,
if reported by the device server.  That is supposed to account
for the worst case.

For cases where that is not reported, exposing the multiplier
in sysfs would let the timeout for simple devices be set to
smaller values than complex devices.

Also, in both sd_setup_flush_cmnd and sd_sync_cache:
      cmd->cmnd[0] = SYNCHRONIZE_CACHE;
      cmd->cmd_len = 10;

SYNCHRONIZE CACHE (16) should be favored over SYNCHRONIZE 
CACHE (10) unless SYNCHRONIZE CACHE (10) is not supported.

---
Rob Elliott    HP Server Storage



