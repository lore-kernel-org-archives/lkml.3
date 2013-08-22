Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab3HVXIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 19:08:23 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:56812 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3HVXIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 19:08:22 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>
CC: "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "ccross@android.com" <ccross@android.com>
Subject: RE: [RFC PATCH v2 04/11] pstore: Add compression support to pstore
Thread-Topic: [RFC PATCH v2 04/11] pstore: Add compression support to pstore
Thread-Index: AQHOmoMcsKHK3fNXLUCcb5sKdMjJG5mhyInA
Date: Thu, 22 Aug 2013 23:07:57 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443E8F0D7@USINDEM103.corp.hds.com>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
 <20130816131805.3338.68767.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130816131805.3338.68767.stgit@aruna-ThinkPad-T420>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-08-22_09:2013-08-22,2013-08-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1308220171
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7MN8TkE002212



>   * callback from kmsg_dump. (s2,l2) has the most recently
>   * written bytes, older bytes are in (s1,l1). Save as much
> @@ -148,23 +243,56 @@ static void pstore_dump(struct kmsg_dumper *dumper,
>  		char *dst;
>  		unsigned long size;
>  		int hsize;
> +		int zipped_len = -1;
>  		size_t len;
> -		bool compressed = false;
> +		bool compressed;
> +		size_t total_len;
> 
> -		dst = psinfo->buf;
> -		hsize = sprintf(dst, "%s#%d Part%d\n", why, oopscount, part);
> -		size = psinfo->bufsize - hsize;
> -		dst += hsize;
> +		if (big_oops_buf) {
> +			dst = big_oops_buf;
> +			hsize = sprintf(dst, "%s#%d Part%d\n", why,
> +							oopscount, part);
> +			size = big_oops_buf_sz - hsize;
> 
> -		if (!kmsg_dump_get_buffer(dumper, true, dst, size, &len))
> -			break;
> +			if (!kmsg_dump_get_buffer(dumper, true, dst + hsize,
> +								size, &len))
> +				break;
> +
> +			zipped_len = pstore_compress(dst, psinfo->buf,
> +						hsize + len, psinfo->bufsize);
> +
> +			if (zipped_len > 0) {
> +				compressed = true;
> +				total_len = zipped_len;
> +			} else {
> +				pr_err("pstore: compression failed for Part %d"
> +					" returned %d\n", part, zipped_len);
> +				pr_err("pstore: Capture uncompressed"
> +					" oops/panic report of Part %d\n", part);

Why did you add these messages in pstore_dump()?
In my test case, they are not needed....

<snip>
# cat dmesg-efi-1
Panic#2 Part1
<4>[  383.209057] RBP: ffff88006f551e80 R08: 0000000000000002 R09: 0000000000000000
<4>[  383.209057] R10: 0000000000000382 R11: 0000000000000000 R12: 0000000000000063
<4>[  383.209057] R13: 0000000000000286 R14: 000000000000000f R15: 0000000000000000
<4>[  383.209057] FS:  00007f53317cc740(0000) GS:ffff88007c400000(0000) knlGS:0000000000000000
<4>[  383.209057] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[  383.209057] CR2: 0000000000000000 CR3: 0000000078a73000 CR4: 00000000000006f0
<4>[  383.209057] Stack:
<4>[  383.209057]  ffff88006f551eb8 ffffffff813d40a2 0000000000000002 00007f53317db000
<4>[  383.209057]  ffff88006f551f50 0000000000000002 0000000000000000 ffff88006f551ed8
<4>[  383.209057]  ffffffff813d45aa 00007f53317db000 ffff88003f8c2b00 ffff88006f551ef8
<4>[  383.209057] Call Trace:
<4>[  383.209057]  [<ffffffff813d40a2>] __handle_sysrq+0xa2/0x170
<4>[  383.209057]  [<ffffffff813d45aa>] write_sysrq_trigger+0x4a/0x50
<4>[  383.209057]  [<ffffffff8121981d>] proc_reg_write+0x3d/0x80
<4>[  383.209057]  [<ffffffff811aeb20>] vfs_write+0xc0/0x1f0
<4>[  383.209057]  [<ffffffff811af59c>] SyS_write+0x4c/0xa0
<4>[  383.209057]  [<ffffffff8168be82>] system_call_fastpath+0x16/0x1b
<4>[  383.209057] Code: ef e8 ff f7 ff ff eb d8 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f 1f 44 00 00 55 c7 05 cc f3 c9 00 01 00 00 00 48 89 e5 0f ae f8 <c6> 04 25 00 00 00 00 01 5d c3 0f 1f 44 00 00 55 31 c0 c7 05 5e 
<1>[  383.209057] RIP  [<ffffffff813d3946>] sysrq_handle_crash+0x16/0x20
<4>[  383.209057]  RSP <ffff88006f551e80>
<4>[  383.209057] CR2: 0000000000000000
<4>[  383.209057] ---[ end trace 04a1cddad37b4b33 ]---
<3>[  383.209057] pstore: compression failed for Part 2 returned -5
<3>[  383.209057] pstore: Capture uncompressed oops/panic report of Part 2
<3>[  383.209057] pstore: compression failed for Part 5 returned -5
<3>[  383.209057] pstore: Capture uncompressed oops/panic report of Part 5
<3>[  383.209057] pstore: compression failed for Part 12 returned -5
<3>[  383.209057] pstore: Capture uncompressed oops/panic report of Part 12
<0>[  383.209057] Kernel panic - not syncing: Fatal exception
<3>[  383.209057] drm_kms_helper: panic occurred, switching back to text console
<snip>


In efi-pstore case, after rebooting a system,
we are able to know which entry failed to compress with 'C' or 'D' as below.

#ls /sys/firmware/efi/vars/ |grep dump
dump-type0-10-1-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-10-2-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-11-1-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-1-1-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-11-2-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-12-1-1377204734-D-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-1-2-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-12-2-1377204734-D-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-13-1-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-13-2-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-2-1-1377204734-D-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-2-2-1377204734-D-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-3-1-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-3-2-1377204734-D-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-4-1-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-4-2-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-5-1-1377204734-D-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-5-2-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-6-1-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-6-2-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-7-1-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-7-2-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-8-1-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-8-2-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-9-1-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-9-2-1377204734-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0

Seiji
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
