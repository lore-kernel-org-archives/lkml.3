Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761779Ab3IDBpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:45:16 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:59887 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761538Ab3IDBpO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:45:14 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
CC: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "ccross@android.com" <ccross@android.com>
Subject: RE: [RFC PATCH v2 04/11] pstore: Add compression support to pstore
Thread-Topic: [RFC PATCH v2 04/11] pstore: Add compression support to pstore
Thread-Index: AQHOmoMcsKHK3fNXLUCcb5sKdMjJG5mhyInAgABg8gCABq6lAIAMBsAQ
Date: Wed, 4 Sep 2013 01:44:57 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443E9E24D@USINDEM103.corp.hds.com>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
 <20130816131805.3338.68767.stgit@aruna-ThinkPad-T420>
 <A5ED84D3BB3A384992CBB9C77DEDA4D443E8F0D7@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F31CC7AC0@ORSMSX106.amr.corp.intel.com>
 <521C36F4.8030607@linux.vnet.ibm.com>
In-Reply-To: <521C36F4.8030607@linux.vnet.ibm.com>
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
 definitions=2013-09-04_01:2013-09-04,2013-09-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1309030092
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aruna,

Sorry for the late response.

> Seiji,
> 
> Could you let us know the efivars buffer size with which the pstore is
> registered when
> the failure occurred.

I looked into the issue today.

I added some debug message just before pstore_compress().
As you can see below, the buffer size is a fixed value(1024).
Therefore, the size doesn't seem to be related to the failure directly.

Also, in the failure case, zlib_deflate() returns Z_OK and stream.avail_out is zero.
So, I thought big_oops_buf_sz is too big in my environment.
And then, I tuned  big_oops_buf_sz to (psinfo->bufsize * 100) / 53.

At the same time, while looking into this issue, I had two concerns about current cording.

1) In pstore_decompress(), why not use zlib_inflateInit2() instead of zlib_inflateInit()?
     If you use zlib_deflateInit2()  for specifying window_bit at compressing time, 
     zlib_inflateInit2() seems to be appropriate for decompressing.
     (Please see a comment about inflateInit2() in include/linux/zlib.h and source code of crypto/deflate.c)

2) As looking at crypto/deflate.c, stream->workspace is kzalloced at the beginning of 
   compressing/decompressing time.
    So, in pstore case,  stream.workspace must be initialized to 0 with memset() in pstore_compress()/decompress().

I did three things above, tuning big_oops_buf_sz, using zlib_inflateInit2() and initializing stream.workspace , in my environment.
As a result, compressions/decmpressions of all entries succeeded with efivars driver.

<snip>
Panic#2 Part1
<4>[   75.665020]  [<ffffffff811af59c>] SyS_write+0x4c/0xa0
<4>[   75.665020]  [<ffffffff8168be82>] system_call_fastpath+0x16/0x1b
<4>[   75.665020] Code: ef e8 ff f7 ff ff eb d8 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f 1f 44 00 00 55 c7 05 cc f3 c9 00 01 00 00 00 48 89 e5 0f ae f8 <c6> 04 25 00 00 00 00 01 5d c3 0f 1f 44 00 00 55 31 c0 c7 05 5e 
<1>[   75.665020] RIP  [<ffffffff813d3946>] sysrq_handle_crash+0x16/0x20
<4>[   75.665020]  RSP <ffff88007852de80>
<4>[   75.665020] CR2: 0000000000000000
<4>[   75.665020] ---[ end trace 97bb4a1f8d3fe7b2 ]---
<3>[   75.665020] pstore_dump hsize=13 len=2155 big_oops_buf_sz=2275 psinfo->bufsize=1024
<3>[   75.665020] pstore_dump hsize=13 len=2246 big_oops_buf_sz=2275 psinfo->bufsize=1024
<3>[   75.665020] pstore: compression failed for Part 2 returned -5
<3>[   75.665020] pstore: Capture uncompressed oops/panic report of Part 2
<3>[   75.665020] pstore_dump hsize=13 len=2239 big_oops_buf_sz=2275 psinfo->bufsize=1024
<3>[   75.665020] pstore_dump hsize=13 len=2231 big_oops_buf_sz=2275 psinfo->bufsize=1024
<3>[   75.665020] pstore_dump hsize=13 len=2185 big_oops_buf_sz=2275 psinfo->bufsize=1024
<3>[   75.665020] pstore: compression failed for Part 5 returned -5
<3>[   75.665020] pstore: Capture uncompressed oops/panic report of Part 5
<3>[   75.665020] pstore_dump hsize=13 len=2234 big_oops_buf_sz=2275 psinfo->bufsize=1024
<3>[   75.665020] pstore_dump hsize=13 len=2208 big_oops_buf_sz=2275 psinfo->bufsize=1024
<3>[   75.665020] pstore_dump hsize=13 len=2218 big_oops_buf_sz=2275 psinfo->bufsize=1024
<3>[   75.665020] pstore_dump hsize=13 len=2222 big_oops_buf_sz=2275 psinfo->bufsize=1024
<3>[   75.665020] pstore: compression failed for Part 9 returned -5
<3>[   75.665020] pstore: Capture uncompressed oops/panic report of Part 9
<3>[   75.665020] pstore_dump hsize=14 len=2256 big_oops_buf_sz=2275 psinfo->bufsize=1024
<3>[   75.665020] pstore_dump hsize=14 len=2219 big_oops_buf_sz=2275 psinfo->bufsize=1024
<3>[   75.665020] pstore_dump hsize=14 len=2226 big_oops_buf_sz=2275 psinfo->bufsize=1024
<0>[   75.665020] Kernel panic - not syncing: Fatal exception
<3>[   75.665020] drm_kms_helper: panic occurred, switching back to text console
<snip>

Seiji
