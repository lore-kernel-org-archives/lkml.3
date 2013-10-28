Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab3J1Pqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:46:48 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:55002 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab3J1Pqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:46:46 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Madper Xie <cxie@redhat.com>, Tony Luck <tony.luck@gmail.com>,
        "Anton Vorontsov" <cbou@mail.ru>, Colin Cross <ccross@google.com>,
        Kees Cook <kees@outflux.net>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Differentiating names by adding a timestamp.
Thread-Topic: [PATCH] Differentiating names by adding a timestamp.
Thread-Index: AQHO0+DIWiwO2ULpUE6Js5xbzLmGmZoKQEmA
Date: Mon, 28 Oct 2013 15:46:01 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D0EFB@USINDEM103.corp.hds.com>
References: <87li1dv8by.fsf@redhat.com>
In-Reply-To: <87li1dv8by.fsf@redhat.com>
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
 definitions=2013-10-28_01:2013-10-28,2013-10-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310280112
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To distinguish all events more precisely, "count" is needed to add to the name.
Please see the commit below.
755d4fe46529018ae45bc7c86df682de45ace764

Seiji

> -----Original Message-----
> From: Madper Xie [mailto:cxie@redhat.com]
> Sent: Monday, October 28, 2013 9:22 AM
> To: Tony Luck; Seiji Aguchi; Anton Vorontsov; Colin Cross; Kees Cook
> Cc: linux-efi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] Differentiating names by adding a timestamp.
> 
> 
> pstore denominate dumped file as type-psname-id. it makes many file have
> the same name if there are many entries in backend have the same id.
> So adding a timestamp to file name.
> 
> Signed-off-by: Madper Xie <cxie@redhat.com>
> ---
>  fs/pstore/inode.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> index 1282384..bf6ed3a 100644
> --- a/fs/pstore/inode.c
> +++ b/fs/pstore/inode.c
> @@ -315,32 +315,38 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
> 
>  	switch (type) {
>  	case PSTORE_TYPE_DMESG:
> -		sprintf(name, "dmesg-%s-%lld%s", psname, id,
> -						compressed ? ".enc.z" : "");
> +		sprintf(name, "dmesg-%s-%lld-%lld%s", psname, id,
> +			timespec_to_ns(&time), compressed ? ".enc.z" : "");
>  		break;
>  	case PSTORE_TYPE_CONSOLE:
> -		sprintf(name, "console-%s", psname);
> +		sprintf(name, "console-%s-%lld", psname, timespec_to_ns(&time));
>  		break;
>  	case PSTORE_TYPE_FTRACE:
> -		sprintf(name, "ftrace-%s", psname);
> +		sprintf(name, "ftrace-%s-%lld", psname, timespec_to_ns(&time));
>  		break;
>  	case PSTORE_TYPE_MCE:
> -		sprintf(name, "mce-%s-%lld", psname, id);
> +		sprintf(name, "mce-%s-%lld-%lld", psname, id,
> +			timespec_to_ns(&time));
>  		break;
>  	case PSTORE_TYPE_PPC_RTAS:
> -		sprintf(name, "rtas-%s-%lld", psname, id);
> +		sprintf(name, "rtas-%s-%lld-%lld", psname, id,
> +			timespec_to_ns(&time));
>  		break;
>  	case PSTORE_TYPE_PPC_OF:
> -		sprintf(name, "powerpc-ofw-%s-%lld", psname, id);
> +		sprintf(name, "powerpc-ofw-%s-%lld-%lld", psname, id,
> +			timespec_to_ns(&time));
>  		break;
>  	case PSTORE_TYPE_PPC_COMMON:
> -		sprintf(name, "powerpc-common-%s-%lld", psname, id);
> +		sprintf(name, "powerpc-common-%s-%lld-%lld", psname, id,
> +			timespec_to_ns(&time));
>  		break;
>  	case PSTORE_TYPE_UNKNOWN:
> -		sprintf(name, "unknown-%s-%lld", psname, id);
> +		sprintf(name, "unknown-%s-%lld-%lld", psname, id,
> +			timespec_to_ns(&time));
>  		break;
>  	default:
> -		sprintf(name, "type%d-%s-%lld", type, psname, id);
> +		sprintf(name, "type%d-%s-%lld-%lld", type, psname, id,
> +			timespec_to_ns(&time));
>  		break;
>  	}
> 
> --
> 1.8.4.1
