Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3ILQXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:23:14 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:53545 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab3ILQXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:23:12 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>
CC: "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "ccross@android.com" <ccross@android.com>
Subject: RE: [PATCH v2] pstore: Adjust buffer size for compression for
 smaller registered buffers
Thread-Topic: [PATCH v2] pstore: Adjust buffer size for compression for
 smaller registered buffers
Thread-Index: AQHOr4RrBy3mHj0VHU2oPY07ldrW/ZnCSQ/w
Date: Thu, 12 Sep 2013 16:22:46 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443EC3AC9@USINDEM103.corp.hds.com>
References: <20130912064832.15340.52422.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130912064832.15340.52422.stgit@aruna-ThinkPad-T420>
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
 definitions=2013-09-12_06:2013-09-12,2013-09-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1309120081
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8CGNI7q013921

efivars works fine with this v2 patch.

Tested-by: Seiji Aguchi <seiji.aguchi@hds.com>

> -----Original Message-----
> From: Aruna Balakrishnaiah [mailto:aruna@linux.vnet.ibm.com]
> Sent: Thursday, September 12, 2013 2:51 AM
> To: linuxppc-dev@ozlabs.org; tony.luck@intel.com; Seiji Aguchi; linux-kernel@vger.kernel.org; keescook@chromium.org
> Cc: jkenisto@linux.vnet.ibm.com; mahesh@linux.vnet.ibm.com; cbouatmailru@gmail.com; ananth@in.ibm.com; ccross@android.com
> Subject: [PATCH v2] pstore: Adjust buffer size for compression for smaller registered buffers
> 
> When backends (ex: efivars) have smaller registered buffers, the big_oops_buf
> is quite too big for them as number of repeated occurences in the text captured
> will be less. Patch takes care of adjusting the buffer size based on the
> registered buffer size. cmpr values has been arrived after doing experiments with
> plain text for buffers of size 1k - 4k (Smaller the buffer size repeated occurence
> will be less) and with sample crash log for buffers ranging from 4k - 10k.
> 
> Reported-by: Seiji Aguchi <seiji.aguchi@hds.com>
> Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
> ---
> Changes from v1:
> 	Retain the cmpr = 45 for buffers ranging of size 4k - 10k. 45 seems to work.
> I added an additional headroom of 3%. Revert it back to 45.
> 
>  fs/pstore/platform.c |   23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index 4ffb7ab..57b4219 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -195,8 +195,29 @@ error:
>  static void allocate_buf_for_compression(void)
>  {
>  	size_t size;
> +	size_t cmpr;
> +
> +	switch (psinfo->bufsize) {
> +	/* buffer range for efivars */
> +	case 1000 ... 2000:
> +		cmpr = 56;
> +		break;
> +	case 2001 ... 3000:
> +		cmpr = 54;
> +		break;
> +	case 3001 ... 3999:
> +		cmpr = 52;
> +		break;
> +	/* buffer range for nvram, erst */
> +	case 4000 ... 10000:
> +		cmpr = 45;
> +		break;
> +	default:
> +		cmpr = 60;
> +		break;
> +	}
> 
> -	big_oops_buf_sz = (psinfo->bufsize * 100) / 45;
> +	big_oops_buf_sz = (psinfo->bufsize * 100) / cmpr;
>  	big_oops_buf = kmalloc(big_oops_buf_sz, GFP_KERNEL);
>  	if (big_oops_buf) {
>  		size = max(zlib_deflate_workspacesize(WINDOW_BITS, MEM_LEVEL),

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
