Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3J3Oih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:38:37 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:46739 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab3J3Oie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:38:34 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Madper Xie <cxie@redhat.com>, "tony.luck@intel.com" <tony.luck@intel.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "ccross@android.com" <ccross@android.com>,
        "anton@enomsg.org" <anton@enomsg.org>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bbboson@gmail.com" <bbboson@gmail.com>
Subject: RE: [PATCH 2/2] pstore: Differentiating names by adding count and
 timestamp
Thread-Topic: [PATCH 2/2] pstore: Differentiating names by adding count and
 timestamp
Thread-Index: AQHO1VTBz7UK19tnr0iaAQUmaI3oOJoNUGjw
Date: Wed, 30 Oct 2013 14:38:13 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D38B4@USINDEM103.corp.hds.com>
References: <1383126294-28793-1-git-send-email-cxie@redhat.com>
 <1383126294-28793-3-git-send-email-cxie@redhat.com>
In-Reply-To: <1383126294-28793-3-git-send-email-cxie@redhat.com>
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
 definitions=2013-10-30_05:2013-10-30,2013-10-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310300099
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Madper Xie [mailto:cxie@redhat.com]
> Sent: Wednesday, October 30, 2013 5:45 AM
> To: tony.luck@intel.com; keescook@chromium.org; ccross@android.com; anton@enomsg.org; Seiji Aguchi
> Cc: linux-efi@vger.kernel.org; linux-kernel@vger.kernel.org; bbboson@gmail.com; Madper Xie
> Subject: [PATCH 2/2] pstore: Differentiating names by adding count and timestamp
> 
> From: Madper Xie <bbboson@gmail.com>
> 
> pstore denominates dumped file as type-psname-id. it makes many file have
> the same name if there are many entries in backend have the same id.
> So adding count and timestamp to file name for differentiating.
> 
> Signed-off-by: Madper Xie <cxie@redhat.com>

It should be tested by other drivers as well..
But, looks good to me.
Acked-by: Seiji Aguchi <seiji.aguchi@hds.com>

> ---
>  fs/pstore/inode.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> index 0ae994c..36b502f 100644
> --- a/fs/pstore/inode.c
> +++ b/fs/pstore/inode.c
> @@ -285,7 +285,7 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
>  	int			rc = 0;
>  	char			name[PSTORE_NAMELEN];
>  	struct pstore_private	*private, *pos;
> -	unsigned long		flags;
> +	unsigned long		flags, timestamp;
> 
>  	spin_lock_irqsave(&allpstore_lock, flags);
>  	list_for_each_entry(pos, &allpstore, list) {
> @@ -316,35 +316,42 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
>  	private->count = count;
>  	private->psi = psi;
>  	memcpy(&private->time, &time, sizeof(struct timespec));
> +	timestamp = time.tv_sec;
> 
>  	switch (type) {
>  	case PSTORE_TYPE_DMESG:
> -		sprintf(name, "dmesg-%s-%lld%s", psname, id,
> -						compressed ? ".enc.z" : "");
> +		sprintf(name, "dmesg-%s-%lld-%d-%ld%s", psname, id, count,
> +			timestamp, compressed ? ".enc.z" : "");
>  		break;
>  	case PSTORE_TYPE_CONSOLE:
> -		sprintf(name, "console-%s", psname);
> +		sprintf(name, "console-%s-%d-%ld", psname, count, timestamp);
>  		break;
>  	case PSTORE_TYPE_FTRACE:
> -		sprintf(name, "ftrace-%s", psname);
> +		sprintf(name, "ftrace-%s-%d-%ld", psname, count, timestamp);
>  		break;
>  	case PSTORE_TYPE_MCE:
> -		sprintf(name, "mce-%s-%lld", psname, id);
> +		sprintf(name, "mce-%s-%lld-%d-%ld", psname, id, count,
> +			timestamp);
>  		break;
>  	case PSTORE_TYPE_PPC_RTAS:
> -		sprintf(name, "rtas-%s-%lld", psname, id);
> +		sprintf(name, "rtas-%s-%lld-%d-%ld", psname, id, count,
> +			timestamp);
>  		break;
>  	case PSTORE_TYPE_PPC_OF:
> -		sprintf(name, "powerpc-ofw-%s-%lld", psname, id);
> +		sprintf(name, "powerpc-ofw-%s-%lld-%d-%ld", psname, id, count,
> +			timestamp);
>  		break;
>  	case PSTORE_TYPE_PPC_COMMON:
> -		sprintf(name, "powerpc-common-%s-%lld", psname, id);
> +		sprintf(name, "powerpc-common-%s-%lld-%d-%ld", psname, id,
> +			count, timestamp);
>  		break;
>  	case PSTORE_TYPE_UNKNOWN:
> -		sprintf(name, "unknown-%s-%lld", psname, id);
> +		sprintf(name, "unknown-%s-%lld-%d-%ld", psname, id, count,
> +			timestamp);
>  		break;
>  	default:
> -		sprintf(name, "type%d-%s-%lld", type, psname, id);
> +		sprintf(name, "type%d-%s-%lld-%d-%ld", type, psname, id, count,
> +			timestamp);
>  		break;
>  	}
> 
> --
> 1.8.4.2

