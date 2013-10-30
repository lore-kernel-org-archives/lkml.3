Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab3J3VLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:11:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:65138 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab3J3VLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:11:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="314929548"
From: "Luck, Tony" <tony.luck@intel.com>
To: Madper Xie <cxie@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "ccross@android.com" <ccross@android.com>,
        "anton@enomsg.org" <anton@enomsg.org>,
        "seiji.aguchi@hds.com" <seiji.aguchi@hds.com>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bbboson@gmail.com" <bbboson@gmail.com>
Subject: RE: [PATCH 0/2] make all stored entries accessible.
Thread-Topic: [PATCH 0/2] make all stored entries accessible.
Thread-Index: AQHO1VTFeljrJQot5kSnramJnOjynpoNuMFg
Date: Wed, 30 Oct 2013 21:11:51 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D529D7@ORSMSX106.amr.corp.intel.com>
References: <1383126294-28793-1-git-send-email-cxie@redhat.com>
In-Reply-To: <1383126294-28793-1-git-send-email-cxie@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. checking type, id, psi, count and timespec when finding duplicate entries.
> 2. adding count and timestamp  for differentiating.

Ah - I was expecting that the backend driver would have a unique "id" for
each record stored ... but is seems that this isn't true for efivars.

I just tried this patch series out with the erst backend. It seems to work, but
I was confused for a while by the filenames that I see in the pstore filesystem. There is a "--"
in the name that I couldn't quite figure out:

-r--r--r-- 1 root root 17498 Oct 30 13:41 dmesg-erst-5940651313304961025--2129078373-1383165669
-r--r--r-- 1 root root 17511 Oct 30 13:41 dmesg-erst-5940651313304961026--2129078373-1383165669
-r--r--r-- 1 root root 17530 Oct 30 13:41 dmesg-erst-5940651313304961027--2129078373-1383165669
-r--r--r-- 1 root root 17492 Oct 30 13:41 dmesg-erst-5940651313304961028--2129078373-1383165669
-r--r--r-- 1 root root 17499 Oct 30 13:41 dmesg-erst-5940651313304961029--2129078373-1383165669
-r--r--r-- 1 root root 17512 Oct 30 13:41 dmesg-erst-5940651313304961030--2129078373-1383165669
-r--r--r-- 1 root root 17531 Oct 30 13:41 dmesg-erst-5940651313304961031--2129078373-1383165669
-r--r--r-- 1 root root 17488 Oct 30 13:44 dmesg-erst-5940652283967569921--2129078373-1383165895
-r--r--r-- 1 root root 17512 Oct 30 13:44 dmesg-erst-5940652283967569922--2129078373-1383165895
-r--r--r-- 1 root root 17512 Oct 30 13:44 dmesg-erst-5940652283967569923--2129078373-1383165895
-r--r--r-- 1 root root 17500 Oct 30 13:44 dmesg-erst-5940652283967569924--2129078373-1383165895
-r--r--r-- 1 root root 17536 Oct 30 13:44 dmesg-erst-5940652283967569925--2129078373-1383165895
-r--r--r-- 1 root root 17513 Oct 30 13:44 dmesg-erst-5940652283967569926--2129078373-1383165895
-r--r--r-- 1 root root 17513 Oct 30 13:44 dmesg-erst-5940652283967569927--2129078373-1383165895
-r--r--r-- 1 root root 17501 Oct 30 13:44 dmesg-erst-5940652283967569928--2129078373-1383165895

The filename came from:
+               sprintf(name, "dmesg-%s-%lld-%d-%ld%s", psname, id, count,
+                       timestamp, compressed ? ".enc.z" : "");

So I guess that "count" is  -2129078373 - which is some uninitialized junk from the stack frame
of pstore_get_records() for the "int count" variable ... the erst reader function doesn't touch it.

I'll add an initializer "int count = 0;" there when applying the patches.

-Tony
