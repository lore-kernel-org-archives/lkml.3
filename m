Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab3JaOgC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 10:36:02 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:55081 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab3JaOgA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:36:00 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Madper Xie <bbboson@gmail.com>, "Luck, Tony" <tony.luck@intel.com>
CC: Madper Xie <cxie@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "ccross@android.com" <ccross@android.com>,
        "anton@enomsg.org" <anton@enomsg.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/2] make all stored entries accessible.
Thread-Topic: [PATCH 0/2] make all stored entries accessible.
Thread-Index: AQHO1VS/gENfXKMKsEu0OLLoqy46ppoOAbKA///bNICAAFq+AIAAK32AgAB7i2A=
Date: Thu, 31 Oct 2013 14:35:33 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D4D01@USINDEM103.corp.hds.com>
References: <1383126294-28793-1-git-send-email-cxie@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F31D529D7@ORSMSX106.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D4476@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F31D52E99@ORSMSX106.amr.corp.intel.com>
 <87d2mm6t64.fsf@gmail.com>
In-Reply-To: <87d2mm6t64.fsf@gmail.com>
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
 definitions=2013-10-31_05:2013-10-31,2013-10-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310310103
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> 1. combine timestamp, count and part into "id".
>    for now, in efi-pstore.c, *id = part. and we could simply change it
>    to unique one. F.E. *id = (timestamp * 100 + part) * 100 + count.

My opinion close to 1.
But, the "*id" should not be the complex one like (timestamp * 100 + part) * 100 + count.
Rather, it should be a simple sequential number beginning with 1.

 - Remove "id" member from pstore_read_info struct.
 -  Introduce a global sequential counter like "static u64 efi_pstore_read_count" (or add the member to pstore_info structure?)
 - Initialize to "1" in efi_pstore_open().
 - Increment it in efi_pstore_read().

If we can do it, we don't need to touch a code of pstore filesystem and can avoid regressions of
other backend drivers.

Seiji

> -----Original Message-----
> From: linux-efi-owner@vger.kernel.org [mailto:linux-efi-owner@vger.kernel.org] On Behalf Of Madper Xie
> Sent: Wednesday, October 30, 2013 11:01 PM
> To: Luck, Tony
> Cc: Seiji Aguchi; Madper Xie; keescook@chromium.org; ccross@android.com; anton@enomsg.org; linux-efi@vger.kernel.org; linux-
> kernel@vger.kernel.org; bbboson@gmail.com
> Subject: Re: [PATCH 0/2] make all stored entries accessible.
> 
> 
> tony.luck@intel.com writes:
> 
> >> So, do you mean efivars should fix to use the "id" in a proper way?
> >
> > It would avoid the need for all these tests, and additions to the filename to guarantee
> > uniqueness.
> >
> > Not sure what options efivars has to create a unique, persistent "id" for each
> > record.  It's a fundamental part of how ERST works (though the unique ID is just
> > based around a timestamp).
> >
> Okay, maybe there are three options here:
> 1. combine timestamp, count and part into "id".
>    for now, in efi-pstore.c, *id = part. and we could simply change it
>    to unique one. F.E. *id = (timestamp * 100 + part) * 100 + count.
> 2. change the id's type. let id become a string.
>    so every backend could write anything to id. then it will become a
>    part of filename in pstore filesystem. (but we need fix all backends
>    since we modified api.)
> 3. apply the patches I have sent... even if the filename will be ugly
>    and gory...
> Which one do you prefer?
> >> I acked Madper's patch 2/2 earlier today, but when I look at your test result, I'm not sure if
> >> it is reasonable for users to make multiple numbers visible to the file name.
> >>
> >>> -r--r--r-- 1 root root 17499 Oct 30 13:41 dmesg-erst-5940651313304961029--2129078373-1383165669
> >
> > after I added the "count = 0" initialization the filename gets a tiny bit less
> > scary:
> >
> > -r--r--r-- 1 root root 17499 Oct 30 13:41 dmesg-erst-5940651313304961029-0-1383165669
> >
> > -Tony
> 
> 
> --
> Best,
> Madper Xie.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
