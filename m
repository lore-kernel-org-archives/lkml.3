Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3JaXXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 19:23:23 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:60940 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3JaXXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 19:23:21 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>, Madper Xie <bbboson@gmail.com>
CC: Madper Xie <cxie@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "ccross@android.com" <ccross@android.com>,
        "anton@enomsg.org" <anton@enomsg.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/2] make all stored entries accessible.
Thread-Topic: [PATCH 0/2] make all stored entries accessible.
Thread-Index: AQHO1VS/gENfXKMKsEu0OLLoqy46ppoOAbKA///bNICAAFq+AIAAK32AgAB7i2CAAKdxgP//vung
Date: Thu, 31 Oct 2013 23:22:55 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DBBA3@USINDEM103.corp.hds.com>
References: <1383126294-28793-1-git-send-email-cxie@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F31D529D7@ORSMSX106.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D4476@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F31D52E99@ORSMSX106.amr.corp.intel.com>
 <87d2mm6t64.fsf@gmail.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D4D01@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F31D53A1F@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D53A1F@ORSMSX106.amr.corp.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-31_08:2013-10-31,2013-10-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310310220
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I also like option 1 ... but I think the "id" should be a persistent value for
> a given saved record.  So some func(timestamp, part, count) would be a
> good idea.  If we try using "sequential" numbers - and don't manage to
> clear out /sys/fs/pstore each time - then we may have the same "dmesg"
> file show up with different names on each boot.
> 
> Right now I have a simple script to save & clear ... not much more
> complex than:
> 
> 	cd /sys/fs/pstore
> 	cp * /var/log/save-pstore
> 	rm *
> 
> This depends on not re-using filenames (otherwise new files in pstore
> might overwrite older saved files in my /var/log/save-pstore area).

I see.. It is a persuasive use case.

(1) I agree that some func(timestamp, part, count) would be  good idea.
      This might work, although an overflow will happen some time...
      sprintf(id_str, "%lld%d%d", timestamp, part, count)
      simple_str_to_ull(id_str, &id, base)
 
(2) There is a GetNextHighMonotonicCount() runtime service in EFI specification
       to get a persistent number across the reboot, but I'm not sure if it is safe to use it..
      Also,  it would be good if we can create the id by ourselves, rather than using firmware.

 (3) Also, (it might not be good idea),  if a pstore filesystem expects all backend drivers
       to use the persistent id, the pstore should provide it by itself.
       (by using time stamp counter or something like that.)

       As I looked into the ramoops's code. It seems to use a non-persistent sequential counter,by initializing
       read_cnt to "0" in ramoops_pstore_open(), and incrementing it in ramoops_pstore_read().
       It doesn't seem to be the pstore's expectation. 
       And when someone introduces a new driver, they may misunderstand how to create the id as well..

As above, there are mutiple ideas, but (1) is reasonable to me.    
 
Seiji




