Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbaKSXNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:13:05 -0500
Received: from mail-bn1on0147.outbound.protection.outlook.com ([157.56.110.147]:14924
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755849AbaKSXND convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:13:03 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH v2 1/2] Tools: hv: vssdaemon: report freeze errors
Thread-Topic: [PATCH v2 1/2] Tools: hv: vssdaemon: report freeze errors
Thread-Index: AQHP/QSXmC5vQj/BgE2XOkatyKGZIZxooquA
Date: Wed, 19 Nov 2014 23:12:57 +0000
Message-ID: <BN1PR0301MB0707937F69B155C862F028FFA0890@BN1PR0301MB0707.namprd03.prod.outlook.com>
References: <1415637422-27880-1-git-send-email-vkuznets@redhat.com>
 <1415637422-27880-2-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1415637422-27880-2-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0706;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0706;
x-forefront-prvs: 04004D94E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(377454003)(13464003)(199003)(189002)(86362001)(19580395003)(575784001)(19580405001)(97736003)(92566001)(92726001)(1511001)(21056001)(20776003)(86612001)(64706001)(122556002)(120916001)(2561002)(99396003)(101416001)(87936001)(33656002)(2656002)(95666004)(99286002)(105586002)(106116001)(76576001)(107046002)(106356001)(77156002)(77096003)(62966003)(40100003)(31966008)(2421001)(4396001)(76176999)(54206007)(74316001)(50986999)(54606007)(54356999)(46102003)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0706;H:BN1PR0301MB0707.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0628;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Monday, November 10, 2014 8:37 AM
> To: KY Srinivasan; Haiyang Zhang; Greg Kroah-Hartman
> Cc: devel@linuxdriverproject.org; linux-kernel@vger.kernel.org; Dexuan Cui
> Subject: [PATCH v2 1/2] Tools: hv: vssdaemon: report freeze errors
> 
> When ioctl(fd, FIFREEZE, 0) results in an error we cannot report it to syslog
> instantly since that can cause write to a frozen disk.
> However, the name of the filesystem which caused the error and errno are
> valuable and we would like to get a nice human-readable message in the log.
> Save errno before calling vss_operate(VSS_OP_THAW) and report the error
> right after.
> 
> Unfortunately, FITHAW errors cannot be reported the same way as we need
> to finish thawing all filesystems before calling syslog().
> 
> We should also avoid calling endmntent() for the second time in case we
> encountered an error during freezing of '/' as it usually results in SEGSEGV.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

> ---
>  tools/hv/hv_vss_daemon.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c index
> b720d8f..ee44f0d 100644
> --- a/tools/hv/hv_vss_daemon.c
> +++ b/tools/hv/hv_vss_daemon.c
> @@ -82,7 +82,7 @@ static int vss_operate(int operation)
>  	FILE *mounts;
>  	struct mntent *ent;
>  	unsigned int cmd;
> -	int error = 0, root_seen = 0;
> +	int error = 0, root_seen = 0, save_errno = 0;
> 
>  	switch (operation) {
>  	case VSS_OP_FREEZE:
> @@ -114,7 +114,6 @@ static int vss_operate(int operation)
>  		if (error && operation == VSS_OP_FREEZE)
>  			goto err;
>  	}
> -	endmntent(mounts);
> 
>  	if (root_seen) {
>  		error |= vss_do_freeze("/", cmd);
> @@ -122,10 +121,19 @@ static int vss_operate(int operation)
>  			goto err;
>  	}
> 
> -	return error;
> +	goto out;
>  err:
> -	endmntent(mounts);
> +	save_errno = errno;
>  	vss_operate(VSS_OP_THAW);
> +	/* Call syslog after we thaw all filesystems */
> +	if (ent)
> +		syslog(LOG_ERR, "FREEZE of %s failed; error:%d %s",
> +		       ent->mnt_dir, save_errno, strerror(save_errno));
> +	else
> +		syslog(LOG_ERR, "FREEZE of / failed; error:%d %s",
> save_errno,
> +		       strerror(save_errno));
> +out:
> +	endmntent(mounts);
>  	return error;
>  }
> 
> --
> 1.9.3

